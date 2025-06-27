///| 测试SQLite基础操作
test "SQLite open and close" {
  // 测试内存数据库连接
  let db = { val: @sqlite3sys.Sqlite3::init() }
  let result = @sqlite3sys.sqlite3_open(
    @sqlite3sys.CStr::from_string(":memory:"),
    db,
  )

  // 检查连接是否成功
  assert_true(result == @sqlite3sys.SQLITE_OK)
  assert_false(@sqlite3sys.Sqlite3::is_nullptr(db.val))

  // 关闭数据库
  let close_result = @sqlite3sys.sqlite3_close(db.val)
  assert_true(close_result == @sqlite3sys.SQLITE_OK)
}

///| 测试SQL执行
test "simple sql execution" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  let result = @sqlite3sys.sqlite3_open(
    @sqlite3sys.CStr::from_string(":memory:"),
    db,
  )
  assert_true(result == @sqlite3sys.SQLITE_OK)

  // 创建表
  let create_sql = @sqlite3sys.CStr::from_string(
    "CREATE TABLE test (id INTEGER PRIMARY KEY, name TEXT)",
  )
  let exec_result = @sqlite3sys.sqlite3_exec(
    db.val,
    create_sql,
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  )
  assert_true(exec_result == @sqlite3sys.SQLITE_OK)

  // Insert data
  let insert_sql = @sqlite3sys.CStr::from_string(
    "INSERT INTO test (name) VALUES ('Hello')",
  )
  let insert_result = @sqlite3sys.sqlite3_exec(
    db.val,
    insert_sql,
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  )
  assert_true(insert_result == @sqlite3sys.SQLITE_OK)

  // check changes
  let changes = @sqlite3sys.sqlite3_changes(db.val)
  assert_true(changes == 1)
  @sqlite3sys.sqlite3_close(db.val) |> ignore
}

///| Test prepared statements
test "prepared statements" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  @sqlite3sys.sqlite3_open(@sqlite3sys.CStr::from_string(":memory:"), db)
  |> ignore

  // create a table
  let create_sql = @sqlite3sys.CStr::from_string(
    "CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
  )
  @sqlite3sys.sqlite3_exec(
    db.val,
    create_sql,
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  )
  |> ignore

  // 准备插入语句
  let stmt = { val: @sqlite3sys.Sqlite3_stmt::init() }
  let prepare_sql = @sqlite3sys.CStr::from_string(
    "INSERT INTO users (name, age) VALUES (?, ?)",
  )
  let prepare_result = @sqlite3sys.sqlite3_prepare_v2(
    db.val,
    prepare_sql,
    -1,
    stmt,
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  )
  assert_true(prepare_result == @sqlite3sys.SQLITE_OK)
  assert_false(@sqlite3sys.Sqlite3_stmt::is_nullptr(stmt.val))

  // bind text
  let bind_name = @sqlite3sys.sqlite3_bind_text(
    stmt.val,
    1,
    @sqlite3sys.CStr::from_string("Alice"),
    -1,
    fn(_ptr) {  },
  )
  assert_true(bind_name == @sqlite3sys.SQLITE_OK)
  let bind_age = @sqlite3sys.sqlite3_bind_int(stmt.val, 2, 25)
  assert_true(bind_age == @sqlite3sys.SQLITE_OK)

  // 执行语句
  let step_result = @sqlite3sys.sqlite3_step(stmt.val)
  assert_true(step_result == @sqlite3sys.SQLITE_DONE)

  // 清理
  @sqlite3sys.sqlite3_finalize(stmt.val) |> ignore
  @sqlite3sys.sqlite3_close(db.val) |> ignore
}

///| 
test "querying data" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  @sqlite3sys.sqlite3_open(@sqlite3sys.CStr::from_string(":memory:"), db)
  |> ignore

  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string(
      "CREATE TABLE numbers (id INTEGER, value REAL, text TEXT)",
    ),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  )
  |> ignore
  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string("INSERT INTO numbers VALUES (1, 3.14, 'pi')"),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  )
  |> ignore

  let stmt = { val: @sqlite3sys.Sqlite3_stmt::init() }
  @sqlite3sys.sqlite3_prepare_v2(
    db.val,
    @sqlite3sys.CStr::from_string(
      "SELECT id, value, text FROM numbers WHERE id = 1",
    ),
    -1,
    stmt,
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  )
  |> ignore
  let step_result = @sqlite3sys.sqlite3_step(stmt.val)
  assert_true(step_result == @sqlite3sys.SQLITE_ROW)

  // check column count
  let column_count = @sqlite3sys.sqlite3_column_count(stmt.val)
  assert_true(column_count == 3)

  // obtain column values
  let id = @sqlite3sys.sqlite3_column_int(stmt.val, 0)
  assert_true(id == 1)
  let value = @sqlite3sys.sqlite3_column_double(stmt.val, 1)
  assert_true(value == 3.14)
  let text_cstr = @sqlite3sys.sqlite3_column_text(stmt.val, 2)
  let text = @sqlite3sys.CStr::convert_to_moonbit_string(text_cstr)
  assert_true(text == "pi")

  // check column types
  let type0 = @sqlite3sys.sqlite3_column_type(stmt.val, 0)
  assert_true(type0 == @sqlite3sys.SQLITE_INTEGER)
  let type1 = @sqlite3sys.sqlite3_column_type(stmt.val, 1)
  assert_true(type1 == @sqlite3sys.SQLITE_FLOAT)
  let type2 = @sqlite3sys.sqlite3_column_type(stmt.val, 2)
  assert_true(type2 == @sqlite3sys.SQLITE3_TEXT)

  // close
  @sqlite3sys.sqlite3_finalize(stmt.val) |> ignore
  @sqlite3sys.sqlite3_close(db.val) |> ignore
}

///|
test "error handling" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  @sqlite3sys.sqlite3_open(@sqlite3sys.CStr::from_string(":memory:"), db)
  |> ignore

  // execute a bad SQL statement
  let bad_sql = @sqlite3sys.CStr::from_string("INVALID SQL STATEMENT")
  let result = @sqlite3sys.sqlite3_exec(
    db.val,
    bad_sql,
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  )

  // should return an error
  assert_false(result == @sqlite3sys.SQLITE_OK)

  // obtain error code
  let errcode = @sqlite3sys.sqlite3_errcode(db.val)
  assert_true(errcode == @sqlite3sys.SQLITE_ERROR)

  // obtain error message
  let errmsg_cstr = @sqlite3sys.sqlite3_errmsg(db.val)
  let errmsg = @sqlite3sys.CStr::convert_to_moonbit_string(errmsg_cstr)
  assert_false(errmsg.is_empty())
  @sqlite3sys.sqlite3_close(db.val) |> ignore
}

///|
test "handling different data types" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  @sqlite3sys.sqlite3_open(@sqlite3sys.CStr::from_string(":memory:"), db)
  |> ignore

  // create a table with various data types
  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string(
      "CREATE TABLE types_test (int_col INTEGER, real_col REAL, text_col TEXT, blob_col BLOB)",
    ),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  )
  |> ignore

  // prepare an insert statement
  let stmt = { val: @sqlite3sys.Sqlite3_stmt::init() }
  @sqlite3sys.sqlite3_prepare_v2(
    db.val,
    @sqlite3sys.CStr::from_string("INSERT INTO types_test VALUES (?, ?, ?, ?)"),
    -1,
    stmt,
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  )
  |> ignore

  // bind values of different types
  @sqlite3sys.sqlite3_bind_int64(stmt.val, 1, 42L) |> ignore
  @sqlite3sys.sqlite3_bind_double(stmt.val, 2, 3.14159) |> ignore
  @sqlite3sys.sqlite3_bind_text(
    stmt.val,
    3,
    @sqlite3sys.CStr::from_string("Hello SQLite"),
    -1,
    fn(_ptr) {  },
  )
  |> ignore
  @sqlite3sys.sqlite3_bind_null(stmt.val, 4) |> ignore

  // execute the statement
  assert_true(@sqlite3sys.sqlite3_step(stmt.val) == @sqlite3sys.SQLITE_DONE)
  @sqlite3sys.sqlite3_finalize(stmt.val) |> ignore

  // query the data back
  let select_stmt = { val: @sqlite3sys.Sqlite3_stmt::init() }
  @sqlite3sys.sqlite3_prepare_v2(
    db.val,
    @sqlite3sys.CStr::from_string("SELECT * FROM types_test"),
    -1,
    select_stmt,
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  )
  |> ignore
  assert_true(
    @sqlite3sys.sqlite3_step(select_stmt.val) == @sqlite3sys.SQLITE_ROW,
  )

  // verify the values
  let int_val = @sqlite3sys.sqlite3_column_int64(select_stmt.val, 0)
  assert_true(int_val == 42L)
  let real_val = @sqlite3sys.sqlite3_column_double(select_stmt.val, 1)
  assert_true(real_val == 3.14159)
  let text_cstr = @sqlite3sys.sqlite3_column_text(select_stmt.val, 2)
  let text_val = @sqlite3sys.CStr::convert_to_moonbit_string(text_cstr)
  assert_true(text_val == "Hello SQLite")

  // check the null value
  let null_type = @sqlite3sys.sqlite3_column_type(select_stmt.val, 3)
  assert_true(null_type == @sqlite3sys.SQLITE_NULL)
  @sqlite3sys.sqlite3_finalize(select_stmt.val) |> ignore
  @sqlite3sys.sqlite3_close(db.val) |> ignore
}
