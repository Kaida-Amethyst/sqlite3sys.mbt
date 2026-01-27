# SQLite3 MoonBit 接口设计白皮书

**版本**: 1.0
**状态**: 提案 (Proposal)
**目标读者**: MoonBit 库开发者, SQLite 集成工程师

---

## 1. 概述 (Overview)

本文档详细描述了 MoonBit 语言的 SQLite3 绑定库的设计规范。本设计旨在提供一个**生产级**、**内存安全**且**符合 MoonBit 惯用风格**的高级接口。

### 1.1 设计哲学

1. **零手动内存管理 (Zero Manual Memory Management)** : 利用 MoonBit 的 `Finalizer` 机制，确保数据库连接和预编译语句在不再使用时自动释放，杜绝 C 堆内存泄露。
2. **强类型 (Strong Typing)** : 通过 `SqlValue` 枚举屏蔽 SQLite 的动态类型，提供安全的类型转换。
3. **错误显式化 (Explicit Errors)** : 使用 MoonBit 的 Error Handling 机制 (`raise`) 清晰地报告 SQL 错误和 API 误用。
4. **零开销抽象 (Zero-Cost Abstraction)** : 在保证安全的前提下，尽量减少不必要的内存拷贝和对象分配。

### 1.2 需要明确的工程语义 (Operational Semantics)

为保证实现一致性，本文档显式规定以下语义：错误来源、Statement 生命周期、Cursor/Row 有效性、事务与并发边界、参数绑定内存模型。

---

## 2. 架构设计 (Architecture)

系统分为三层：

1. **用户层 (User Layer)** : 用户编写的 MoonBit 代码，操作 `Connection` 和 `Statement` 对象。
2. **抽象层 (Abstraction Layer)** : MoonBit 编写的高级库 (`sqlite3.mbt`)。负责类型转换、错误检查和对象生命周期管理。
3. **本地层 (Native Layer)** : C 语言编写的胶水代码 (`wrap.c`) 和 FFI 定义 (`capi.mbt`)。负责直接与 `libsqlite3` 交互，并利用 `moonbit_make_external_object` 桥接 GC。

### 2.1 生命周期管理 (Lifecycle Management)

这是本设计的核心。为了防止资源泄露，我们将使用 MoonBit 的外部对象机制 (External Object with Finalizer)。

- **Connection**: 对应 C 端的 `struct mb_conn`。当 MoonBit 的 `Connection` 对象引用计数为 0 时，GC 调用 C 端的 `mb_conn_dtor`，执行 `sqlite3_close_v2`。
- **Statement**: 对应 C 端的 `struct mb_stmt`。当 MoonBit 的 `Statement` 对象引用计数为 0 时，GC 调用 C 端的 `mb_stmt_dtor`，执行 `sqlite3_finalize`。

### 2.2 线程与并发模型 (Threading & Concurrency)

- 默认假设：单个 `Connection` **非线程安全**，不允许在多个线程/并发任务中同时使用。
- 如需并发访问，请由用户在上层实现互斥或使用连接池。
- 本库不强制锁，但应在文档中明确该限制，避免隐式数据竞争。

---

## 3. 本地层规范 (Native Layer Specification)

需要在 `wrap.c` 中实现的辅助结构和函数。

### 3.1 结构体定义

```c
// 包装 SQLite 连接句柄
struct mb_conn {
    sqlite3 *db;
    // 可以在此添加其他元数据，如是否已关闭的标记，防止 double-close
    int is_closed;
};

// 包装 SQLite 预编译语句句柄
struct mb_stmt {
    sqlite3_stmt *stmt;
    // 强引用 Connection 对象，确保 Statement 存活期间 Connection 不被关闭？
    // 注意：在 MoonBit 侧通过 struct 字段持有引用即可，C 侧只需关注 stmt 指针。
    // 但为了安全，可以在 C 侧也保留对 mb_conn 的某种引用，或者完全依赖 MoonBit 侧的生命周期。
    // 简化设计：依赖 MoonBit 侧 Statement struct 持有 Connection 字段来保证顺序。
    int is_finalized;
};
```

### 3.2 析构函数 (Destructors)

```c
void mb_conn_dtor(void *ptr) {
    struct mb_conn *self = (struct mb_conn *)ptr;
    if (self->db && !self->is_closed) {
        // 使用 v2 版本以处理未 finalize 的 stmt
        sqlite3_close_v2(self->db); 
        self->db = NULL;
        self->is_closed = 1;
    }
}

void mb_stmt_dtor(void *ptr) {
    struct mb_stmt *self = (struct mb_stmt *)ptr;
    if (self->stmt && !self->is_finalized) {
        sqlite3_finalize(self->stmt);
        self->stmt = NULL;
        self->is_finalized = 1;
    }
}
```

### 3.3 构造辅助函数 (Constructors)

这些函数通过 `moonbit_make_external_object` 创建对象并返回给 MoonBit。

```c
// 返回 void* (即 MoonBit 的 Connection)
void *mb_open_helper(const char *filename, int *out_error_code) {
    sqlite3 *db;
    int rc = sqlite3_open(filename, &db);
    if (rc != SQLITE_OK) {
        *out_error_code = rc;
        // 即使失败，sqlite3_open 也可能返回一个非空的 db 句柄用于获取错误信息
        // 我们选择在此处直接关闭它并返回 NULL，或者返回一个标记错误的 wrapper
        if (db) sqlite3_close(db);
        return NULL; 
    }
    
    struct mb_conn *wrapper = (struct mb_conn *)moonbit_make_external_object(mb_conn_dtor, sizeof(struct mb_conn));
    wrapper->db = db;
    wrapper->is_closed = 0;
    return wrapper;
}

void *mb_prepare_helper(void *conn_ptr, const char *sql, int *out_error_code) {
    struct mb_conn *conn = (struct mb_conn *)conn_ptr;
    if (conn->is_closed) {
        *out_error_code = SQLITE_MISUSE;
        return NULL;
    }

    sqlite3_stmt *stmt;
    int rc = sqlite3_prepare_v2(conn->db, sql, -1, &stmt, NULL);
    if (rc != SQLITE_OK) {
        *out_error_code = rc;
        return NULL;
    }

    struct mb_stmt *wrapper = (struct mb_stmt *)moonbit_make_external_object(mb_stmt_dtor, sizeof(struct mb_stmt));
    wrapper->stmt = stmt;
    wrapper->is_finalized = 0;
    return wrapper;
}
```

---

## 4. MoonBit 核心类型设计

### 4.1 错误处理 (`SqlError`)

所有可能失败的操作都使用 MoonBit 的 `raise` 机制。

```moonbit
pub suberror SqlError {
    // 来自 SQLite 的错误代码和消息
    SqliteError(Int, String)
    // 逻辑错误：如对已关闭的连接进行操作
    Misuse(String)
    // 类型不匹配：如尝试将 Blob 读取为 Integer
    TypeMismatch(expected~: String, actual~: String)
}
```

#### 错误来源与消息选择 (Error Message Source)

- **Connection 级错误**：使用 `sqlite3_errmsg(db)` 获取消息。
- **Statement 级错误**：使用 `sqlite3_errmsg(sqlite3_db_handle(stmt))` 获取消息。
- **sqlite3_open 失败**：若获得 `db` 句柄，则先读取 `sqlite3_errmsg(db)` 作为消息，再关闭并报错。
- **Misuse**：由 MoonBit 层主动生成，不依赖 SQLite 错误码。

### 4.2 数据类型 (`SqlValue`)

```moonbit
pub enum SqlValue {
    Null
    Integer(Int64)
    Real(Double)
    Text(String)
    Blob(Bytes)
}

// 辅助方法：判断类型
pub fn is_null(self: SqlValue) -> Bool
pub fn as_int(self: SqlValue) -> Int64?
// ... 其他转换方法
```

#### 参数绑定与类型读取 (Binding & Column Mapping)

- 绑定规则：
  - `Null` -> `sqlite3_bind_null`
  - `Integer` -> `sqlite3_bind_int64`
  - `Real` -> `sqlite3_bind_double`
  - `Text` -> `sqlite3_bind_text` (建议 `SQLITE_TRANSIENT`)
  - `Blob` -> `sqlite3_bind_blob` (建议 `SQLITE_TRANSIENT`)
- 读取规则：
  - `sqlite3_column_type` 为 `SQLITE_INTEGER` -> `Integer`
  - `SQLITE_FLOAT` -> `Real`
  - `SQLITE_TEXT` -> `Text`
  - `SQLITE_BLOB` -> `Blob`
  - `SQLITE_NULL` -> `Null`
- **内存所有权**：统一使用 `SQLITE_TRANSIENT`，避免依赖 MoonBit 对象生命周期。

---

## 5. 接口详细规范 (API Specification)

### 5.1 Connection

```moonbit
// 这是一个外部类型，对应 C 端的 void* (指向 struct mb_conn 的封装对象)
type Connection 

// 构造函数
pub fn open(path: String) -> Connection raise SqlError
pub fn open_in_memory() -> Connection raise SqlError

// 方法
impl Connection {
    // 显式关闭。
    // 实现细节：调用 C 端函数将 is_closed 置为 1，并调用 sqlite3_close_v2。
    // 如果再次调用，检查 is_closed 标记，直接返回或报错。
    pub fn close(self: Connection) -> Unit raise SqlError

    pub fn execute(self: Connection, sql: String, params: Array[SqlValue]) -> Unit raise SqlError
    
    // 返回 Statement 对象
    pub fn prepare(self: Connection, sql: String) -> Statement raise SqlError
    
    pub fn last_insert_rowid(self: Connection) -> Int64
    pub fn changes(self: Connection) -> Int
    pub fn get_autocommit(self: Connection) -> Bool
    
    // 事务控制
    // 注意：SQLite 默认自动提交。显式事务需手动执行 BEGIN/COMMIT 或使用此帮助函数
    pub fn transaction[T](self: Connection, f: () -> T raise SqlError) -> T raise SqlError
}
```

#### Connection 关闭语义 (Close Semantics)

- 若存在未 finalize 的 Statement：
  - 允许 `sqlite3_close_v2` 关闭并延迟释放，但应明确 Statement 仍可继续工作直至 finalize；
  - 或选择直接报错 `Misuse`。必须在文档中固定其一。
- 建议 V1 采用：**允许 close_v2 并延迟释放**，简化资源管理；并在 Statement.finalize 后确保最终释放。

### 5.2 Statement

```moonbit
// 外部类型，对应 C 端的 void* (指向 struct mb_stmt 的封装对象)
type StatementHandle 

// MoonBit 侧的包装结构，为了持有 Connection 的引用，防止 Connection 在 Statement 存活时被 GC
pub struct Statement {
    priv handle: StatementHandle
    priv conn: Connection // 关键：保持 Connection 的强引用
}

impl Statement {
    // 绑定参数并执行，不返回结果行（用于 INSERT/UPDATE）
    pub fn execute(self: Statement, params: Array[SqlValue]) -> Unit raise SqlError
    
    // 绑定参数并执行，返回游标（用于 SELECT）
    pub fn query(self: Statement, params: Array[SqlValue]) -> Cursor raise SqlError
    
    // 重置语句，以便重新绑定参数
    pub fn reset(self: Statement) -> Unit raise SqlError
    
    // 显式释放。虽然 GC 会兜底，但在循环中推荐调用。
    pub fn finalize(self: Statement) -> Unit raise SqlError
    
    // 获取绑定参数数量
    pub fn bind_parameter_count(self: Statement) -> Int
}
```

#### Statement 生命周期语义 (Lifecycle Semantics)

- `finalize` 后，所有方法必须抛出 `Misuse`。
- `execute/query` 会在绑定前调用 `sqlite3_reset` 与 `sqlite3_clear_bindings`，保证幂等执行。
- `reset` 仅重置执行状态，不清理绑定值；如需清理，使用 `sqlite3_clear_bindings`。
- `Statement` 通过强引用 `Connection` 保证连接存活。

### 5.3 Cursor & Row

`Cursor` 是对 `Statement` 的轻量级封装，维护迭代状态。`Row` 是对当前结果行的视图。

```moonbit
pub struct Cursor {
    priv stmt: Statement
}

pub struct Row {
    priv stmt: Statement
}

impl Cursor {
    // 推进到下一行。
    // 返回 Some(Row) 表示有数据。
    // 返回 None 表示迭代结束 (SQLITE_DONE)。
    pub fn next(self: Cursor) -> Row? raise SqlError
    
    // 关闭游标（实际上是重置 Statement，使其可被再次复用）
    pub fn close(self: Cursor) -> Unit raise SqlError
}

impl Row {
    // 基于 0 的索引
    pub fn get(self: Row, idx: Int) -> SqlValue raise SqlError
    
    // 强类型获取（性能更好，如果不匹配则报错）
    pub fn get_int(self: Row, idx: Int) -> Int64 raise SqlError
    pub fn get_double(self: Row, idx: Int) -> Double raise SqlError
    pub fn get_string(self: Row, idx: Int) -> String raise SqlError
    pub fn get_blob(self: Row, idx: Int) -> Bytes raise SqlError
    
    pub fn column_count(self: Row) -> Int
    pub fn column_name(self: Row, idx: Int) -> String
}
```

#### Cursor/Row 有效性约束 (Row Validity)

- `Row` 是对当前结果行的**视图**，下一次 `Cursor.next` 调用后，上一行的 `Row` 失效。
- 如果 `Statement` 被 `reset` 或 `finalize`，所有现存 `Row` 与 `Cursor` 均失效并抛 `Misuse`。
- `column_name` 和 `column_count` 在 `finalize` 后必须抛 `Misuse`。

---

## 6. 用户自定义函数 (UDF) 设计

为了支持 SLT 测试，我们需要 `create_scalar_function`。

**挑战**: C API 接受函数指针，而 MoonBit 的闭包 (Closure) 包含了环境 (Context)。
**方案**:
由于目前的 FFI 限制，我们可能无法直接将带捕获的 MoonBit闭包传递给 `sqlite3_create_function` 的 `xFunc`。
**V1 简化实现**:
支持 `(Array[SqlValue]) -> SqlValue` 类型的纯函数。
在 C 端，我们需要一个通用的 `trampoline` 函数。

```c
// wrap.c

// 假设我们能在 C 端存储 MoonBit 的函数引用对象 (callback_ref)
void mb_udf_trampoline(sqlite3_context *ctx, int argc, sqlite3_value **argv) {
    void *callback_ref = sqlite3_user_data(ctx);
    // 这里需要 MoonBit 运行时提供的能力来调用 callback_ref
    // 目前这部分可能需要特定的 FFI 支持：
    // extern "C" fn call_moonbit_func(ref: AnyType, args: ...)
}
```

**替代方案 (如果 FFI 暂不支持反向调用闭包)** :
仅在 MoonBit 侧硬编码几个用于 SLT 的标准辅助函数 (如 `md5_mock`)，并在 C 侧静态注册它们。这足以跑通测试，但这牺牲了通用性。
**最终建议**: 在 V1 阶段，如果无法通用地传递闭包，先硬编码支持 SLT 所需的函数。

### 6.1 V1 可落地策略 (Implementation Strategy)

- **V1**：仅注册若干固定名字的内建函数用于 SLT（例如 `md5_mock` 等）。
- **V2**：如果 MoonBit 运行时提供安全可行的回调调用机制，再开放 `create_scalar_function`。
- 显式定义参数转换：`sqlite3_value` -> `SqlValue`，返回值使用 `sqlite3_result_*` 映射。

---

## 7. 生产级验证清单 (Production Checklist)

在发布前必须验证：

1. **Memory Leak Test**: 在无限循环中 `open`, `prepare`, `execute` (抛出异常), `close`。监控进程内存占用，确保无明显增长。
2. **File Descriptor Leak Test**: 类似内存测试，监控 `lsof` 或 `fd` 数量。
3. **Error Propagation**: 验证 SQLite 的所有错误码都能正确映射并抛出，特别是 `SQLITE_BUSY` (锁冲突) 和 `SQLITE_CONSTRAINT` (约束违反)。
4. **Unicode Support**: 验证中文路径数据库打开、中文字符串存取。
5. **Blob Handling**: 验证二进制数据 (包含 `\0`) 的正确存取。
6. **64-bit Integer**: 验证 `Int64` 的边界值存取。

---

## 8. 可选但推荐的扩展 (Optional Extensions)

这些功能不是 V1 必须，但能显著提升工程可用性：

1. `execute_batch(sql: String)`：使用 `sqlite3_exec` 执行多语句脚本。
2. `query_row` / `query_value`：常见单行/单值查询快捷接口。
3. `bind_named`：支持 `:name` 参数，提高可维护性。
4. `busy_timeout` 与 `busy_handler`：用于锁冲突时的生产级行为控制。

---

## 9. 示例代码 (Examples)

以下示例用于帮助工程实现与用户理解，演示常见用法与语义边界。

### 示例 1：打开内存库并执行建表

```moonbit
fn main() -> Unit raise SqlError {
  let conn = open_in_memory()
  conn.execute(
    "CREATE TABLE t(id INTEGER PRIMARY KEY, name TEXT)",
    []
  )
  conn.close()
}
```

### 示例 2：插入数据并读取 last_insert_rowid

```moonbit
fn main() -> Unit raise SqlError {
  let conn = open("example.db")
  conn.execute(
    "INSERT INTO t(name) VALUES (?)",
    [Text("alice")]
  )
  let id = conn.last_insert_rowid()
  println("last id: \{id}")
  conn.close()
}
```

### 示例 3：使用 prepare + execute 复用语句

```moonbit
fn main() -> Unit raise SqlError {
  let conn = open("example.db")
  let stmt = conn.prepare("INSERT INTO t(name) VALUES (?)")

  stmt.execute([Text("bob")])
  stmt.execute([Text("carol")])
  stmt.finalize()
  conn.close()
}
```

### 示例 4：查询并逐行读取

```moonbit
fn main() -> Unit raise SqlError {
  let conn = open("example.db")
  let stmt = conn.prepare("SELECT id, name FROM t WHERE id >= ?")
  let cursor = stmt.query([Integer(1)])
  loop cursor {
    c => match c.next() {
      Some(row) => {
        let id = row.get_int(0)
        let name = row.get_string(1)
        println("\{id}: \{name}")
        continue c
      }
      None => {
        c.close()
      }
    }
  }
  stmt.finalize()
  conn.close()
}
```

### 示例 5：事务封装，失败自动回滚

```moonbit
fn main() -> Unit raise SqlError {
  let conn = open("example.db")
  let res = conn.transaction(fn () -> Unit raise SqlError {
    conn.execute("INSERT INTO t(name) VALUES (?)", [Text("tx-1")])
    conn.execute("INSERT INTO t(name) VALUES (?)", [Text("tx-2")])
  })
  _ = res
  conn.close()
}
```

### 示例 6：SqlValue 类型安全读取与匹配

```moonbit
fn main() -> Unit raise SqlError {
  let conn = open("example.db")
  let stmt = conn.prepare("SELECT name FROM t WHERE id = ?")
  let cursor = stmt.query([Integer(1)])
  match cursor.next() {
    Some(row) => {
      match row.get(0) {
        Text(s) => println(s)
        other => raise Misuse("unexpected type: \{other}")
      }
    }
    None => ()
  }
  cursor.close()
  stmt.finalize()
  conn.close()
}
```

---
