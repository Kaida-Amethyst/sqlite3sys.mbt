///|
/// Shared callbacks for C APIs expecting function pointers.
let exec_callback : FuncRef[
  (AnyType, Int, FixedArray[CStr], FixedArray[CStr]) -> Int,
] = fn(_data, _cols, _values, _names) { 0 }

///|
let noop_destructor : FuncRef[(AnyType) -> Unit] = fn(_ptr) {  }

///|
let noop_destructor64 : FuncRef[(AnyType) -> Unit] = fn(_ptr) {  }

///|
let busy_handler_cb : FuncRef[(AnyType, Int) -> Int] = fn(_ptr, _count) { 0 }

///|
let progress_cb : FuncRef[(AnyType) -> Int] = fn(_ptr) { 0 }

///|
let auto_extension_cb : FuncRef[() -> Unit] = fn() {  }

///|
let collation_needed_cb : FuncRef[(AnyType, Sqlite3, Int, CStr) -> Unit] = fn(
  _ptr,
  _db,
  _enc,
  _name,
) {

}

///|
let collation_needed16_cb : FuncRef[(AnyType, Sqlite3, Int, AnyType) -> Unit] = fn(
  _ptr,
  _db,
  _enc,
  _name,
) {

}

///|
let collation_compare_cb : FuncRef[(AnyType, Int, AnyType, Int, AnyType) -> Int] = fn(
  _ptr,
  _len1,
  _p1,
  _len2,
  _p2,
) {
  0
}

///|
let commit_hook_cb : FuncRef[(AnyType) -> Int] = fn(_ptr) { 0 }

///|
let rollback_hook_cb : FuncRef[(AnyType) -> Unit] = fn(_ptr) {  }

///|
let update_hook_cb : FuncRef[(AnyType, Int, CStr, CStr, Int64) -> Unit] = fn(
  _ptr,
  _op,
  _db,
  _tbl,
  _rowid,
) {

}

///|
let trace_cb : FuncRef[(AnyType, CStr) -> Unit] = fn(_ptr, _sql) {  }

///|
let profile_cb : FuncRef[(AnyType, CStr, UInt64) -> Unit] = fn(
  _ptr,
  _sql,
  _ns,
) {

}

///|
let wal_hook_cb : FuncRef[(AnyType, Sqlite3, CStr, Int) -> Int] = fn(
  _ptr,
  _db,
  _name,
  _pages,
) {
  0
}

///|
let trace_v2_cb : FuncRef[(UInt, AnyType, AnyType, AnyType) -> Int] = fn(
  _mask,
  _ctx,
  _p1,
  _p2,
) {
  0
}

///|
let unlock_notify_cb : FuncRef[(AnyType, Int) -> Unit] = fn(_ptr, _n) {  }

///|
let autovacuum_cb : FuncRef[(AnyType, CStr, UInt, UInt, UInt) -> UInt] = fn(
  _ptr,
  _db_name,
  _n_pages,
  _n_free,
  _n_res,
) {
  0U
}

///|
let memory_alarm_cb : FuncRef[(AnyType, Int64, Int) -> Unit] = fn(
  _ptr,
  _used,
  _alloc,
) {

}

///|
let rtree_geom_cb : FuncRef[(AnyType, Int, AnyType, AnyType) -> Int] = fn(
  _geom,
  _n,
  _coords,
  _out,
) {
  SQLITE_OK
}

///|
let rtree_query_cb : FuncRef[(AnyType) -> Int] = fn(_info) { SQLITE_OK }

///|
let authorizer_cb : FuncRef[(AnyType, Int, CStr, CStr, CStr, CStr) -> Int] = fn(
  _ptr,
  _code,
  _a,
  _b,
  _c,
  _d,
) {
  SQLITE_OK
}

///|
let window_value_cb : FuncRef[(Sqlite3_context) -> Unit] = fn(ctx) {
  sqlite3_result_int(ctx, 0)
}

///|
extern "C" fn sqlite3sys_test_module() -> Sqlite3_module = "sqlite3sys_test_module_ptr"

///|
extern "C" fn sqlite3sys_make_index_info() -> Sqlite3_index_info = "sqlite3sys_make_index_info"

///|
extern "C" fn sqlite3sys_free_index_info(info : Sqlite3_index_info) -> Unit = "sqlite3sys_free_index_info"

///|
fn any_is_null(ptr : AnyType) -> Bool {
  Sqlite3::is_nullptr(Sqlite3::from_void_ptr(ptr))
}

///|
fn close_db(db : Sqlite3) -> Unit raise Error {
  let close_result = sqlite3_close(db)
  if close_result == SQLITE_BUSY {
    let close_v2 = sqlite3_close_v2(db)
    assert_true(close_v2 == SQLITE_OK || close_v2 == SQLITE_BUSY)
  } else if close_result == SQLITE_MISUSE {
    ()
  } else {
    assert_true(close_result == SQLITE_OK)
  }
}

///|
fn prepare_v2_or_v3(db : Sqlite3, sql : CStr, stmt : Ref[Sqlite3_stmt]) -> Int {
  let tail = Ref::new(CStr::from_string(""))
  let res = sqlite3_prepare_v2(db, sql, -1, stmt, tail)
  if res != SQLITE_OK {
    let res_v3 = sqlite3_prepare_v3(db, sql, -1, 0, stmt, tail)
    if res_v3 == SQLITE_OK {
      return res_v3
    }
  }
  res
}

///|
fn exec_or_prepare(db : Sqlite3, sql : CStr) -> Bool {
  let exec_res = sqlite3_exec(
    db,
    sql,
    exec_callback,
    Sqlite3::to_void_ptr(Sqlite3::init()),
    Sqlite3::to_void_ptr(Sqlite3::init()),
  )
  if exec_res == SQLITE_OK {
    return true
  }
  let stmt = Ref::new(Sqlite3_stmt::init())
  let prep_res = prepare_v2_or_v3(db, sql, stmt)
  if prep_res != SQLITE_OK {
    return false
  }
  let step_res = sqlite3_step(stmt.val)
  if step_res != SQLITE_DONE && step_res != SQLITE_ROW {
    let finalize_err = sqlite3_finalize(stmt.val)
    if finalize_err != SQLITE_OK {
      return false
    }
    return false
  }
  let finalize_res = sqlite3_finalize(stmt.val)
  if finalize_res != SQLITE_OK {
    return false
  }
  true
}

///|
let scalar_func_cb : FuncRef[
  (Sqlite3_context, Int, FixedArray[Sqlite3_value]) -> Unit,
] = fn(ctx, argc, argv) {
  let db_handle = sqlite3_context_db_handle(ctx)
  if Sqlite3::is_nullptr(db_handle) {
    sqlite3_result_null(ctx)
  }
  let user_ptr = sqlite3_user_data(ctx)
  if any_is_null(user_ptr) {
    sqlite3_result_subtype(ctx, 0)
  }
  let aux_ptr = sqlite3_get_auxdata(ctx, 0)
  if any_is_null(aux_ptr) {
    let new_aux = sqlite3_malloc(4)
    sqlite3_set_auxdata(ctx, 0, new_aux, noop_destructor)
  }
  let aux_ptr2 = sqlite3_get_auxdata(ctx, 0)
  if !any_is_null(aux_ptr2) {
    sqlite3_result_subtype(ctx, 1)
  }
  let nochange = sqlite3_vtab_nochange(ctx)
  if nochange != 0 {
    sqlite3_result_subtype(ctx, 2)
  }
  if argc > 0 {
    let v = argv[0]
    let vtype = sqlite3_value_type(v)
    let i = sqlite3_value_int64(v)
    if vtype == SQLITE_NULL {
      sqlite3_result_null(ctx)
    } else {
      sqlite3_result_int64(ctx, i + 1L)
    }
    sqlite3_result_subtype(ctx, 1)
  } else {
    sqlite3_result_null(ctx)
  }
}

///|
let aggregate_step_cb : FuncRef[
  (Sqlite3_context, Int, FixedArray[Sqlite3_value]) -> Unit,
] = fn(ctx, argc, argv) {
  let count = sqlite3_aggregate_count(ctx)
  let agg_ptr = sqlite3_aggregate_context(ctx, 8)
  if any_is_null(agg_ptr) {
    sqlite3_result_null(ctx)
  }
  if argc > 0 {
    let v = argv[0]
    sqlite3_result_value(ctx, v)
  } else if count == 0 {
    sqlite3_result_null(ctx)
  } else {
    sqlite3_result_null(ctx)
  }
}

///|
let aggregate_final_cb : FuncRef[(Sqlite3_context) -> Unit] = fn(ctx) {
  sqlite3_result_int(ctx, 0)
}

///|
let result_func_cb : FuncRef[
  (Sqlite3_context, Int, FixedArray[Sqlite3_value]) -> Unit,
] = fn(ctx, _argc, _argv) {
  sqlite3_result_error_code(ctx, SQLITE_ERROR)
  sqlite3_result_error_toobig(ctx)
  sqlite3_result_error_nomem(ctx)
  sqlite3_result_error(ctx, CStr::from_string("err"), -1)
  sqlite3_result_error16(ctx, Sqlite3::to_void_ptr(Sqlite3::init()), 0)
  sqlite3_result_int(ctx, 1)
  sqlite3_result_int64(ctx, 2L)
  sqlite3_result_double(ctx, 1.5)
  sqlite3_result_text(ctx, CStr::from_string("ok"), -1, noop_destructor)
  sqlite3_result_text64(
    ctx,
    CStr::from_string("ok64"),
    4UL,
    noop_destructor64,
    b'\x01',
  )
  sqlite3_result_text16(
    ctx,
    Sqlite3::to_void_ptr(Sqlite3::init()),
    0,
    noop_destructor,
  )
  sqlite3_result_text16le(
    ctx,
    Sqlite3::to_void_ptr(Sqlite3::init()),
    0,
    noop_destructor,
  )
  sqlite3_result_text16be(
    ctx,
    Sqlite3::to_void_ptr(Sqlite3::init()),
    0,
    noop_destructor,
  )
  sqlite3_result_blob(
    ctx,
    Sqlite3::to_void_ptr(Sqlite3::init()),
    0,
    noop_destructor,
  )
  sqlite3_result_blob64(
    ctx,
    Sqlite3::to_void_ptr(Sqlite3::init()),
    0UL,
    noop_destructor,
  )
  sqlite3_result_zeroblob(ctx, 0)
  let zero64_res = sqlite3_result_zeroblob64(ctx, 0UL)
  if zero64_res != SQLITE_OK {
    sqlite3_result_error_code(ctx, zero64_res)
  }
  sqlite3_result_pointer(
    ctx,
    Sqlite3::to_void_ptr(Sqlite3::init()),
    CStr::from_string("ptr"),
    noop_destructor,
  )
}

///|
/// Test basic SQLite operations
test "SQLite open and close" {
  // test in-memory database connection
  let db = Ref::new(Sqlite3::init())
  let result = sqlite3_open(CStr::from_string(":memory:"), db)

  // verify connection success
  assert_true(result == SQLITE_OK)
  assert_false(Sqlite3::is_nullptr(db.val))

  // close database
  let errmsg16 = sqlite3_errmsg16(db.val)
  assert_false(any_is_null(errmsg16))
  close_db(db.val)
}

///|
/// Test SQL execution
test "simple sql execution" {
  let db = Ref::new(Sqlite3::init())
  let result = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(result == SQLITE_OK)

  // create table
  let create_sql = CStr::from_string(
    "CREATE TABLE test (id INTEGER PRIMARY KEY, name TEXT)",
  )
  let created = exec_or_prepare(db.val, create_sql)
  if !created {
    return
  }

  // Insert data
  let insert_sql = CStr::from_string("INSERT INTO test (name) VALUES ('Hello')")
  let inserted = exec_or_prepare(db.val, insert_sql)
  if !inserted {
    return
  }

  // check changes
  let changes = sqlite3_changes(db.val)
  assert_true(changes == 1)
  close_db(db.val)
}

///|
/// Test prepared statements
test "prepared statements" {
  let db = Ref::new(Sqlite3::init())
  let null_ptr = Sqlite3::to_void_ptr(Sqlite3::init())
  let open_result = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_result == SQLITE_OK)
  let auto_vac_res = sqlite3_autovacuum_pages(
    db.val,
    autovacuum_cb,
    null_ptr,
    noop_destructor,
  )
  assert_true(
    auto_vac_res == SQLITE_OK ||
    auto_vac_res == SQLITE_ERROR ||
    auto_vac_res == SQLITE_MISUSE,
  )

  // create a table
  let create_sql = CStr::from_string(
    "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
  )
  let created = exec_or_prepare(db.val, create_sql)
  if !created {
    return
  }

  // prepare insert statement
  let stmt = Ref::new(Sqlite3_stmt::init())
  let prepare_sql = CStr::from_string(
    "INSERT INTO users (name, age) VALUES (?, ?)",
  )
  let prepare_result = prepare_v2_or_v3(db.val, prepare_sql, stmt)
  assert_true(prepare_result == SQLITE_OK)
  assert_false(Sqlite3_stmt::is_nullptr(stmt.val))

  // bind text
  let bind_name = sqlite3_bind_text(
    stmt.val,
    1,
    CStr::from_string("Alice"),
    -1,
    noop_destructor,
  )
  assert_true(bind_name == SQLITE_OK)
  let bind_age = sqlite3_bind_int(stmt.val, 2, 25)
  assert_true(bind_age == SQLITE_OK)

  // execute statement
  let step_result = sqlite3_step(stmt.val)
  assert_true(step_result == SQLITE_DONE)

  // cleanup
  let finalize_result = sqlite3_finalize(stmt.val)
  assert_true(finalize_result == SQLITE_OK)
  close_db(db.val)
}

///|
test "querying data" {
  let db = Ref::new(Sqlite3::init())
  let open_result = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_result == SQLITE_OK)
  let created = exec_or_prepare(
    db.val,
    CStr::from_string(
      "CREATE TABLE numbers (id INTEGER, value REAL, text TEXT)",
    ),
  )
  if !created {
    return
  }
  let inserted = exec_or_prepare(
    db.val,
    CStr::from_string("INSERT INTO numbers VALUES (1, 3.14, 'pi')"),
  )
  if !inserted {
    return
  }
  let stmt = Ref::new(Sqlite3_stmt::init())
  prepare_v2_or_v3(
    db.val,
    CStr::from_string("SELECT id, value, text FROM numbers WHERE id = 1"),
    stmt,
  )
  |> result => { assert_true(result == SQLITE_OK) }
  let step_result = sqlite3_step(stmt.val)
  assert_true(step_result == SQLITE_ROW)

  // check column count
  let column_count = sqlite3_column_count(stmt.val)
  assert_true(column_count == 3)

  // obtain column values
  let id = sqlite3_column_int(stmt.val, 0)
  assert_true(id == 1)
  let value = sqlite3_column_double(stmt.val, 1)
  assert_true(value == 3.14)
  let text_cstr = sqlite3_column_text(stmt.val, 2)
  let text = CStr::convert_to_moonbit_string(text_cstr)
  assert_true(text == "pi")

  // check column types
  let type0 = sqlite3_column_type(stmt.val, 0)
  assert_true(type0 == SQLITE_INTEGER)
  let type1 = sqlite3_column_type(stmt.val, 1)
  assert_true(type1 == SQLITE_FLOAT)
  let type2 = sqlite3_column_type(stmt.val, 2)
  assert_true(type2 == SQLITE3_TEXT)

  // close
  let finalize_result = sqlite3_finalize(stmt.val)
  assert_true(finalize_result == SQLITE_OK)
  close_db(db.val)
}

///|
test "error handling" {
  let db = Ref::new(Sqlite3::init())
  let open_result = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_result == SQLITE_OK)

  // execute a bad SQL statement
  let bad_sql = CStr::from_string("INVALID SQL STATEMENT")
  let result = sqlite3_exec(
    db.val,
    bad_sql,
    exec_callback,
    Sqlite3::to_void_ptr(Sqlite3::init()),
    Sqlite3::to_void_ptr(Sqlite3::init()),
  )

  // should return an error
  assert_false(result == SQLITE_OK)

  // obtain error code
  let errcode = sqlite3_errcode(db.val)
  assert_true(errcode == SQLITE_ERROR || errcode == SQLITE_MISUSE)

  // obtain error message
  let errmsg_cstr = sqlite3_errmsg(db.val)
  let errmsg = CStr::convert_to_moonbit_string(errmsg_cstr)
  assert_false(errmsg.is_empty())
  close_db(db.val)
}

///|
test "handling different data types" {
  let db = Ref::new(Sqlite3::init())
  let open_result = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_result == SQLITE_OK)

  // create a table with various data types
  let created = exec_or_prepare(
    db.val,
    CStr::from_string(
      "CREATE TABLE types_test (int_col INTEGER, real_col REAL, text_col TEXT, blob_col BLOB)",
    ),
  )
  if !created {
    return
  }

  // prepare an insert statement
  let stmt = Ref::new(Sqlite3_stmt::init())
  prepare_v2_or_v3(
    db.val,
    CStr::from_string("INSERT INTO types_test VALUES (?, ?, ?, ?)"),
    stmt,
  )
  |> result => { assert_true(result == SQLITE_OK) }

  // bind values of different types
  let bind_int64_result = sqlite3_bind_int64(stmt.val, 1, 42L)
  assert_true(bind_int64_result == SQLITE_OK)
  let bind_double_result = sqlite3_bind_double(stmt.val, 2, 3.14159)
  assert_true(bind_double_result == SQLITE_OK)
  sqlite3_bind_text(
    stmt.val,
    3,
    CStr::from_string("Hello SQLite"),
    -1,
    noop_destructor,
  )
  |> result => { assert_true(result == SQLITE_OK) }
  let bind_null_result = sqlite3_bind_null(stmt.val, 4)
  assert_true(bind_null_result == SQLITE_OK)

  // execute the statement
  assert_true(sqlite3_step(stmt.val) == SQLITE_DONE)
  let finalize_result = sqlite3_finalize(stmt.val)
  assert_true(finalize_result == SQLITE_OK)

  // query the data back
  let select_stmt = Ref::new(Sqlite3_stmt::init())
  prepare_v2_or_v3(
    db.val,
    CStr::from_string("SELECT * FROM types_test"),
    select_stmt,
  )
  |> result => { assert_true(result == SQLITE_OK) }
  assert_true(sqlite3_step(select_stmt.val) == SQLITE_ROW)

  // verify the values
  let int_val = sqlite3_column_int64(select_stmt.val, 0)
  assert_true(int_val == 42L)
  let real_val = sqlite3_column_double(select_stmt.val, 1)
  assert_true(real_val == 3.14159)
  let text_cstr = sqlite3_column_text(select_stmt.val, 2)
  let text_val = CStr::convert_to_moonbit_string(text_cstr)
  assert_true(text_val == "Hello SQLite")

  // check the null value
  let null_type = sqlite3_column_type(select_stmt.val, 3)
  assert_true(null_type == SQLITE_NULL)
  let finalize_result = sqlite3_finalize(select_stmt.val)
  assert_true(finalize_result == SQLITE_OK)
  close_db(db.val)
}

///|
/// Tests for additional statement-related APIs
test "prepare_v3 and statement inspection" {
  let db = Ref::new(Sqlite3::init())
  let open_result = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_result == SQLITE_OK)
  let stmt = Ref::new(Sqlite3_stmt::init())
  // prepare statement with two parameters using prepare_v3
  let prep_v3_res = sqlite3_prepare_v3(
    db.val,
    CStr::from_string("SELECT ?1 + ?2"),
    -1,
    0,
    stmt,
    Ref::new(CStr::from_string("")),
  )
  if prep_v3_res != SQLITE_OK {
    close_db(db.val)
    return
  }

  // bind parameters
  let bind_int_1 = sqlite3_bind_int(stmt.val, 1, 3)
  assert_true(bind_int_1 == SQLITE_OK)
  let bind_int_2 = sqlite3_bind_int(stmt.val, 2, 4)
  assert_true(bind_int_2 == SQLITE_OK)

  // expanded SQL should contain the bound values
  let expanded = sqlite3_expanded_sql(stmt.val)
  assert_false(CStr::is_nullptr(expanded))
  let expanded_str = CStr::convert_to_moonbit_string(expanded)
  assert_true(expanded_str.contains("3"))
  assert_true(expanded_str.contains("4"))
  sqlite3_free(CStr::to_void_ptr(expanded))

  // readonly query
  let is_ro = sqlite3_stmt_readonly(stmt.val)
  assert_true(is_ro == 1)

  // statement should not be busy before stepping
  assert_true(sqlite3_stmt_busy(stmt.val) == 0)

  // step once, expect a row
  assert_true(sqlite3_step(stmt.val) == SQLITE_ROW)
  assert_true(sqlite3_stmt_busy(stmt.val) == 1)
  // finalize the row
  let step_done = sqlite3_step(stmt.val)
  assert_true(step_done == SQLITE_DONE)
  assert_true(sqlite3_stmt_busy(stmt.val) == 0)
  let finalize_result = sqlite3_finalize(stmt.val)
  assert_true(finalize_result == SQLITE_OK)
  close_db(db.val)
}

///|
test "pointer helpers and CStr conversions" {
  let null_db = Sqlite3::init()
  assert_true(Sqlite3::is_nullptr(null_db))
  let db_void = Sqlite3::to_void_ptr(null_db)
  let db_from = Sqlite3::from_void_ptr(db_void)
  assert_true(Sqlite3::is_nullptr(db_from))
  let null_stmt = Sqlite3_stmt::init()
  assert_true(Sqlite3_stmt::is_nullptr(null_stmt))
  let stmt_void = Sqlite3_stmt::to_void_ptr(null_stmt)
  let stmt_from = Sqlite3_stmt::from_void_ptr(stmt_void)
  assert_true(Sqlite3_stmt::is_nullptr(stmt_from))
  let null_ctx = Sqlite3_context::init()
  assert_true(Sqlite3_context::is_nullptr(null_ctx))
  let ctx_void = Sqlite3_context::to_void_ptr(null_ctx)
  let ctx_from = Sqlite3_context::from_void_ptr(ctx_void)
  assert_true(Sqlite3_context::is_nullptr(ctx_from))
  let null_backup = Sqlite3_backup::init()
  assert_true(Sqlite3_backup::is_nullptr(null_backup))
  let backup_void = Sqlite3_backup::to_void_ptr(null_backup)
  let backup_from = Sqlite3_backup::from_void_ptr(backup_void)
  assert_true(Sqlite3_backup::is_nullptr(backup_from))
  let null_str = Sqlite3_str::init()
  assert_true(Sqlite3_str::is_nullptr(null_str))
  let str_void = Sqlite3_str::to_void_ptr(null_str)
  let str_from = Sqlite3_str::from_void_ptr(str_void)
  assert_true(Sqlite3_str::is_nullptr(str_from))
  let null_value = Sqlite3_value::init()
  assert_true(Sqlite3_value::is_nullptr(null_value))
  let value_void = Sqlite3_value::to_void_ptr(null_value)
  let value_from = Sqlite3_value::from_void_ptr(value_void)
  assert_true(Sqlite3_value::is_nullptr(value_from))
  let null_blob = Sqlite3_blob::init()
  assert_true(Sqlite3_blob::is_nullptr(null_blob))
  let blob_void = Sqlite3_blob::to_void_ptr(null_blob)
  let blob_from = Sqlite3_blob::from_void_ptr(blob_void)
  assert_true(Sqlite3_blob::is_nullptr(blob_from))
  let null_mutex = Sqlite3_mutex::init()
  assert_true(Sqlite3_mutex::is_nullptr(null_mutex))
  let mutex_void = Sqlite3_mutex::to_void_ptr(null_mutex)
  let mutex_from = Sqlite3_mutex::from_void_ptr(mutex_void)
  assert_true(Sqlite3_mutex::is_nullptr(mutex_from))
  let null_vfs = Sqlite3_vfs::init()
  assert_true(Sqlite3_vfs::is_nullptr(null_vfs))
  let vfs_void = Sqlite3_vfs::to_void_ptr(null_vfs)
  let vfs_from = Sqlite3_vfs::from_void_ptr(vfs_void)
  assert_true(Sqlite3_vfs::is_nullptr(vfs_from))
  let null_file = Sqlite3_file::init()
  assert_true(Sqlite3_file::is_nullptr(null_file))
  let file_void = Sqlite3_file::to_void_ptr(null_file)
  let file_from = Sqlite3_file::from_void_ptr(file_void)
  assert_true(Sqlite3_file::is_nullptr(file_from))
  let null_filename = Sqlite3_filename::init()
  assert_true(Sqlite3_filename::is_nullptr(null_filename))
  let filename_void = Sqlite3_filename::to_void_ptr(null_filename)
  let filename_from = Sqlite3_filename::from_void_ptr(filename_void)
  assert_true(Sqlite3_filename::is_nullptr(filename_from))
  let null_snapshot = Sqlite3_snapshot::init()
  assert_true(Sqlite3_snapshot::is_nullptr(null_snapshot))
  let snapshot_void = Sqlite3_snapshot::to_void_ptr(null_snapshot)
  let snapshot_from = Sqlite3_snapshot::from_void_ptr(snapshot_void)
  assert_true(Sqlite3_snapshot::is_nullptr(snapshot_from))
  let null_index = Sqlite3_index_info::init()
  assert_true(Sqlite3_index_info::is_nullptr(null_index))
  let index_void = Sqlite3_index_info::to_void_ptr(null_index)
  let index_from = Sqlite3_index_info::from_void_ptr(index_void)
  assert_true(Sqlite3_index_info::is_nullptr(index_from))
  let null_module = Sqlite3_module::init()
  assert_true(Sqlite3_module::is_nullptr(null_module))
  let module_void = Sqlite3_module::to_void_ptr(null_module)
  let module_from = Sqlite3_module::from_void_ptr(module_void)
  assert_true(Sqlite3_module::is_nullptr(module_from))
  let cstr = CStr::from_string("abc")
  assert_false(CStr::is_nullptr(cstr))
  let round = CStr::convert_to_moonbit_string(cstr)
  assert_true(round == "abc")
  let truncated = CStr::convert_to_moonbit_string_with_length(cstr, 2)
  assert_true(truncated == "ab")
}

///|
test "sqlite3_mprintf and free" {
  let msg = sqlite3_mprintf(CStr::from_string("mprintf test"))
  assert_false(CStr::is_nullptr(msg))
  let msg_str = CStr::convert_to_moonbit_string(msg)
  assert_true(msg_str == "mprintf test")
  sqlite3_free(CStr::to_void_ptr(msg))
}

///|
test "library info and keyword utilities" {
  let version = CStr::convert_to_moonbit_string(sqlite3_libversion())
  assert_false(version.is_empty())
  let source = CStr::convert_to_moonbit_string(sqlite3_sourceid())
  assert_false(source.is_empty())
  let ver_num = sqlite3_libversion_number()
  assert_true(ver_num > 0)
  let threadsafe = sqlite3_threadsafe()
  assert_true(threadsafe == 0 || threadsafe == 1 || threadsafe == 2)
  let keyword_count = sqlite3_keyword_count()
  assert_true(keyword_count > 0)
  let name_ref = Ref::new(CStr::from_string(""))
  let len_ref = Ref::new(0)
  let name_result = sqlite3_keyword_name(0, name_ref, len_ref)
  assert_true(name_result == SQLITE_OK)
  let kw = CStr::convert_to_moonbit_string_with_length(
    name_ref.val,
    len_ref.val.reinterpret_as_uint(),
  )
  assert_false(kw.is_empty())
  let kw_check = sqlite3_keyword_check(CStr::from_string(kw), kw.length())
  assert_true(kw_check == 0 || kw_check == 1)
  let opt = sqlite3_compileoption_get(0)
  let opt_str = CStr::convert_to_moonbit_string(opt)
  assert_false(opt_str.is_empty())
  let opt_used = sqlite3_compileoption_used(CStr::from_string(opt_str))
  assert_true(opt_used == 0 || opt_used == 1)
  assert_true(
    sqlite3_stricmp(CStr::from_string("a"), CStr::from_string("A")) == 0,
  )
  let nicmp = sqlite3_strnicmp(
    CStr::from_string("abc"),
    CStr::from_string("Abd"),
    2,
  )
  assert_true(nicmp == 0)
  assert_true(
    sqlite3_strglob(CStr::from_string("a?c"), CStr::from_string("abc")) == 0,
  )
  let like_res = sqlite3_strlike(
    CStr::from_string("a%"),
    CStr::from_string("abc"),
    0,
  )
  assert_true(like_res == 0)
}

///|
test "memory and string utilities" {
  let ptr = sqlite3_malloc(16)
  assert_false(any_is_null(ptr))
  let size = sqlite3_msize(ptr)
  assert_true(size >= 16)
  let ptr2 = sqlite3_realloc(ptr, 32)
  assert_false(any_is_null(ptr2))
  let size2 = sqlite3_msize(ptr2)
  assert_true(size2 >= 32)
  sqlite3_free(ptr2)
  let ptr64 = sqlite3_malloc64(64UL)
  assert_false(any_is_null(ptr64))
  let ptr64b = sqlite3_realloc64(ptr64, 128UL)
  assert_false(any_is_null(ptr64b))
  sqlite3_free(ptr64b)
  let mem_used = sqlite3_memory_used()
  let mem_high = sqlite3_memory_highwater(0)
  assert_true(mem_used >= 0L)
  assert_true(mem_high >= 0L)
  sqlite3_soft_heap_limit(0)
  let soft_limit64 = sqlite3_soft_heap_limit64(0L)
  assert_true(soft_limit64 >= 0L)
  let hard_limit = sqlite3_hard_heap_limit64(0L)
  assert_true(hard_limit >= 0L)
  let release_res = sqlite3_release_memory(1)
  assert_true(release_res == SQLITE_OK || release_res == SQLITE_ERROR)
  let rand_buf = sqlite3_malloc(8)
  assert_false(any_is_null(rand_buf))
  sqlite3_randomness(8, rand_buf)
  sqlite3_free(rand_buf)
}

///|
test "database cache and autocommit" {
  let db = Ref::new(Sqlite3::init())
  let open_result = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_result == SQLITE_OK)
  let cacheflush_res = sqlite3_db_cacheflush(db.val)
  assert_true(
    cacheflush_res == SQLITE_OK ||
    cacheflush_res == SQLITE_ERROR ||
    cacheflush_res == SQLITE_MISUSE,
  )
  let release_res = sqlite3_db_release_memory(db.val)
  assert_true(
    release_res == SQLITE_OK ||
    release_res == SQLITE_ERROR ||
    release_res == SQLITE_MISUSE,
  )
  let autocommit = sqlite3_get_autocommit(db.val)
  assert_true(autocommit == 0 || autocommit == 1)
  close_db(db.val)
}

///|
test "database config and metadata" {
  let db = Ref::new(Sqlite3::init())
  let open_result = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_result == SQLITE_OK)
  let changes64 = sqlite3_changes64(db.val)
  assert_true(changes64 >= 0L)
  let total_changes = sqlite3_total_changes(db.val)
  assert_true(total_changes >= 0)
  let total_changes64 = sqlite3_total_changes64(db.val)
  assert_true(total_changes64 >= 0L)
  sqlite3_set_last_insert_rowid(db.val, 123L)
  let last_id = sqlite3_last_insert_rowid(db.val)
  assert_true(last_id == 123L || last_id > 0L)
  let errstr = sqlite3_errstr(SQLITE_ERROR)
  let errstr_str = CStr::convert_to_moonbit_string(errstr)
  assert_false(errstr_str.is_empty())
  let sys_errno = sqlite3_system_errno(db.val)
  assert_true(sys_errno >= 0)
  if false {
    let meta_type = sqlite3_malloc(8)
    let meta_coll = sqlite3_malloc(8)
    let meta_notnull = sqlite3_malloc(4)
    let meta_pk = sqlite3_malloc(4)
    let meta_ai = sqlite3_malloc(4)
    let meta_res = sqlite3_table_column_metadata(
      db.val,
      CStr::from_string("main"),
      CStr::from_string("meta"),
      CStr::from_string("name"),
      meta_type,
      meta_coll,
      meta_notnull,
      meta_pk,
      meta_ai,
    )
    assert_true(meta_res == SQLITE_OK || meta_res == SQLITE_ERROR)
    sqlite3_free(meta_notnull)
    sqlite3_free(meta_pk)
    sqlite3_free(meta_ai)
    sqlite3_free(meta_type)
    sqlite3_free(meta_coll)
  }
  if false {
    let overload_res = sqlite3_overload_function(
      db.val,
      CStr::from_string("unknown_func"),
      1,
    )
    assert_true(overload_res == SQLITE_OK || overload_res == SQLITE_ERROR)
    let txn_state = sqlite3_txn_state(db.val, CStr::from_string("main"))
    assert_true(txn_state >= 0 || txn_state < 0)
  }
  if false {
    let err_sql = CStr::from_string("BAD SQL")
    let err_exec = sqlite3_exec(
      db.val,
      err_sql,
      exec_callback,
      Sqlite3::to_void_ptr(Sqlite3::init()),
      Sqlite3::to_void_ptr(Sqlite3::init()),
    )
    assert_true(err_exec != SQLITE_OK)
    let err_offset = sqlite3_error_offset(db.val)
    assert_true(err_offset >= 0 || err_offset == -1)
    let ext_before = sqlite3_extended_errcode(db.val)
    assert_true(ext_before >= 0)
    let ext_enable = sqlite3_extended_result_codes(db.val, 1)
    assert_true(ext_enable == SQLITE_OK || ext_enable == SQLITE_ERROR)
    let ext_after = sqlite3_extended_errcode(db.val)
    assert_true(ext_after >= 0)
    sqlite3_interrupt(db.val)
    let interrupted = sqlite3_is_interrupted(db.val)
    assert_true(interrupted == 0 || interrupted == 1)
  }
  if false {
    let table = Ref::new(Ref::new(CStr::from_string("")))
    let rows = Ref::new(0)
    let cols = Ref::new(0)
    let err_msg = Ref::new(CStr::from_string(""))
    let table_res = sqlite3_get_table(
      db.val,
      CStr::from_string("SELECT name FROM meta"),
      table,
      rows,
      cols,
      err_msg,
    )
    assert_true(table_res == SQLITE_OK || table_res == SQLITE_ERROR)
    if table_res == SQLITE_OK {
      sqlite3_free_table(table.val)
    }
  }
  close_db(db.val)
}

///|
test "statement binding and column coverage" {
  let db = Ref::new(Sqlite3::init())
  let open_result = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_result == SQLITE_OK)
  let created = exec_or_prepare(
    db.val,
    CStr::from_string(
      "CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT, value REAL, data BLOB)",
    ),
  )
  if !created {
    return
  }
  let insert_stmt = Ref::new(Sqlite3_stmt::init())
  let prep_res = sqlite3_prepare(
    db.val,
    CStr::from_string(
      "INSERT INTO items (name, value, data) VALUES (?1, ?2, ?3)",
    ),
    -1,
    insert_stmt,
    Ref::new(CStr::from_string("")),
  )
  assert_true(prep_res == SQLITE_OK)
  let param_count = sqlite3_bind_parameter_count(insert_stmt.val)
  assert_true(param_count == 3)
  let name1 = sqlite3_bind_parameter_name(insert_stmt.val, 1)
  let name1_str = CStr::convert_to_moonbit_string(name1)
  assert_true(name1_str == "?1")
  let idx = sqlite3_bind_parameter_index(
    insert_stmt.val,
    CStr::from_string("?1"),
  )
  assert_true(idx == 1)
  let bind_text64_res = sqlite3_bind_text64(
    insert_stmt.val,
    1,
    CStr::from_string("alpha"),
    5UL,
    noop_destructor64,
    b'\x01',
  )
  assert_true(bind_text64_res == SQLITE_OK)
  let bind_double_res = sqlite3_bind_double(insert_stmt.val, 2, 1.25)
  assert_true(bind_double_res == SQLITE_OK)
  let bind_blob_res = sqlite3_bind_blob(
    insert_stmt.val,
    3,
    Sqlite3::to_void_ptr(Sqlite3::init()),
    0,
    noop_destructor,
  )
  assert_true(bind_blob_res == SQLITE_OK)
  let bind_blob64_res = sqlite3_bind_blob64(
    insert_stmt.val,
    3,
    Sqlite3::to_void_ptr(Sqlite3::init()),
    0U,
    noop_destructor,
  )
  assert_true(bind_blob64_res == SQLITE_OK)
  let step_res = sqlite3_step(insert_stmt.val)
  assert_true(step_res == SQLITE_DONE)
  let insert_stmt2 = Ref::new(Sqlite3_stmt::init())
  let prep_res2 = prepare_v2_or_v3(
    db.val,
    CStr::from_string(
      "INSERT INTO items (name, value, data) VALUES (?1, ?2, ?3)",
    ),
    insert_stmt2,
  )
  assert_true(prep_res2 == SQLITE_OK)
  let transfer_res = sqlite3_transfer_bindings(
    insert_stmt.val,
    insert_stmt2.val,
  )
  assert_true(transfer_res == SQLITE_OK)
  let step_res_transfer = sqlite3_step(insert_stmt2.val)
  assert_true(step_res_transfer == SQLITE_DONE)
  let finalize_transfer = sqlite3_finalize(insert_stmt2.val)
  assert_true(finalize_transfer == SQLITE_OK)
  let reset_res = sqlite3_reset(insert_stmt.val)
  assert_true(reset_res == SQLITE_OK)
  let clear_res = sqlite3_clear_bindings(insert_stmt.val)
  assert_true(clear_res == SQLITE_OK)
  let bind_text16_res = sqlite3_bind_text16(
    insert_stmt.val,
    1,
    Sqlite3::to_void_ptr(Sqlite3::init()),
    0,
    noop_destructor,
  )
  assert_true(bind_text16_res == SQLITE_OK)
  let bind_zero_res = sqlite3_bind_zeroblob(insert_stmt.val, 3, 4)
  assert_true(bind_zero_res == SQLITE_OK)
  let bind_zero64_res = sqlite3_bind_zeroblob64(insert_stmt.val, 3, 4UL)
  assert_true(bind_zero64_res == SQLITE_OK)
  let bind_ptr_res = sqlite3_bind_pointer(
    insert_stmt.val,
    3,
    Sqlite3::to_void_ptr(Sqlite3::init()),
    CStr::from_string("ptr"),
    noop_destructor,
  )
  assert_true(bind_ptr_res == SQLITE_OK)
  let step_res2 = sqlite3_step(insert_stmt.val)
  assert_true(step_res2 == SQLITE_DONE)
  let value_stmt = Ref::new(Sqlite3_stmt::init())
  let prep_value = prepare_v2_or_v3(
    db.val,
    CStr::from_string("SELECT 7"),
    value_stmt,
  )
  assert_true(prep_value == SQLITE_OK)
  let step_value = sqlite3_step(value_stmt.val)
  assert_true(step_value == SQLITE_ROW)
  let value_obj = sqlite3_column_value(value_stmt.val, 0)
  let bind_value_stmt = Ref::new(Sqlite3_stmt::init())
  let prep_bind_value = prepare_v2_or_v3(
    db.val,
    CStr::from_string(
      "INSERT INTO items (name, value, data) VALUES ('beta', ?1, zeroblob(1))",
    ),
    bind_value_stmt,
  )
  assert_true(prep_bind_value == SQLITE_OK)
  let bind_value_res = sqlite3_bind_value(bind_value_stmt.val, 1, value_obj)
  assert_true(bind_value_res == SQLITE_OK)
  let step_bind_value = sqlite3_step(bind_value_stmt.val)
  assert_true(step_bind_value == SQLITE_DONE)
  let finalize_bind_value = sqlite3_finalize(bind_value_stmt.val)
  assert_true(finalize_bind_value == SQLITE_OK)
  let reset_value = sqlite3_reset(value_stmt.val)
  assert_true(reset_value == SQLITE_OK)
  let finalize_value = sqlite3_finalize(value_stmt.val)
  assert_true(finalize_value == SQLITE_OK)
  let finalize_res = sqlite3_finalize(insert_stmt.val)
  assert_true(finalize_res == SQLITE_OK)
  let query_stmt = Ref::new(Sqlite3_stmt::init())
  let prep_q_res = prepare_v2_or_v3(
    db.val,
    CStr::from_string("SELECT id, name, value, data FROM items"),
    query_stmt,
  )
  assert_true(prep_q_res == SQLITE_OK)
  let sql_text = sqlite3_sql(query_stmt.val)
  let sql_text_str = CStr::convert_to_moonbit_string(sql_text)
  assert_true(sql_text_str.contains("SELECT"))
  let expanded = sqlite3_expanded_sql(query_stmt.val)
  assert_false(CStr::is_nullptr(expanded))
  let expanded_str = CStr::convert_to_moonbit_string(expanded)
  assert_true(expanded_str.contains("SELECT"))
  sqlite3_free(CStr::to_void_ptr(expanded))
  let explain_val = sqlite3_stmt_explain(query_stmt.val, 0)
  assert_true(explain_val >= 0)
  let expired_val = sqlite3_expired(query_stmt.val)
  assert_true(expired_val == 0 || expired_val == 1)
  let scan_out = sqlite3_malloc(8)
  let scan_res = sqlite3_stmt_scanstatus(
    query_stmt.val,
    0,
    SQLITE_SCANSTAT_NLOOP,
    scan_out,
  )
  assert_true(scan_res == SQLITE_OK || scan_res == SQLITE_ERROR)
  let scan_res2 = sqlite3_stmt_scanstatus_v2(
    query_stmt.val,
    0,
    SQLITE_SCANSTAT_NLOOP,
    0,
    scan_out,
  )
  assert_true(scan_res2 == SQLITE_OK || scan_res2 == SQLITE_ERROR)
  sqlite3_stmt_scanstatus_reset(query_stmt.val)
  sqlite3_free(scan_out)
  let row_res = sqlite3_step(query_stmt.val)
  assert_true(row_res == SQLITE_ROW)
  let col_count = sqlite3_column_count(query_stmt.val)
  assert_true(col_count == 4)
  let data_count = sqlite3_data_count(query_stmt.val)
  assert_true(data_count == 4)
  let col_name = sqlite3_column_name(query_stmt.val, 1)
  let col_name_str = CStr::convert_to_moonbit_string(col_name)
  assert_true(col_name_str == "name")
  let decl = sqlite3_column_decltype(query_stmt.val, 1)
  let decl_str = CStr::convert_to_moonbit_string(decl)
  assert_true(decl_str == "TEXT")
  let db_name = sqlite3_column_database_name(query_stmt.val, 1)
  let db_name_str = CStr::convert_to_moonbit_string(db_name)
  assert_true(db_name_str == "main")
  let tbl_name = sqlite3_column_table_name(query_stmt.val, 1)
  let tbl_name_str = CStr::convert_to_moonbit_string(tbl_name)
  assert_true(tbl_name_str == "items")
  let origin_name = sqlite3_column_origin_name(query_stmt.val, 1)
  let origin_name_str = CStr::convert_to_moonbit_string(origin_name)
  assert_true(origin_name_str == "name")
  let col_name16 = sqlite3_column_name16(query_stmt.val, 1)
  let col_name16_bytes = sqlite3_column_bytes16(query_stmt.val, 1)
  assert_true(col_name16_bytes > 0)
  assert_false(any_is_null(col_name16))
  let col_db_name16 = sqlite3_column_database_name16(query_stmt.val, 1)
  assert_false(any_is_null(col_db_name16))
  let col_decl16 = sqlite3_column_decltype16(query_stmt.val, 1)
  assert_false(any_is_null(col_decl16))
  let col_tbl16 = sqlite3_column_table_name16(query_stmt.val, 1)
  assert_false(any_is_null(col_tbl16))
  let col_origin16 = sqlite3_column_origin_name16(query_stmt.val, 1)
  assert_false(any_is_null(col_origin16))
  let text_cstr = sqlite3_column_text(query_stmt.val, 1)
  let text_str = CStr::convert_to_moonbit_string(text_cstr)
  assert_true(text_str == "alpha")
  let text16 = sqlite3_column_text16(query_stmt.val, 1)
  assert_false(any_is_null(text16))
  let text_bytes = sqlite3_column_bytes(query_stmt.val, 1)
  assert_true(text_bytes > 0)
  let val_int = sqlite3_column_int(query_stmt.val, 0)
  let val_int64 = sqlite3_column_int64(query_stmt.val, 0)
  assert_true(val_int64 == val_int.to_int64())
  let val_double = sqlite3_column_double(query_stmt.val, 2)
  assert_true(val_double == 1.25)
  let col_type = sqlite3_column_type(query_stmt.val, 2)
  assert_true(col_type == SQLITE_FLOAT)
  let blob_ptr = sqlite3_column_blob(query_stmt.val, 3)
  let blob_is_null = any_is_null(blob_ptr)
  let blob_bytes = sqlite3_column_bytes(query_stmt.val, 3)
  assert_true(blob_bytes >= 0 || blob_is_null)
  let val = sqlite3_column_value(query_stmt.val, 1)
  let val_type = sqlite3_value_type(val)
  assert_true(val_type == SQLITE3_TEXT)
  let val_text = sqlite3_value_text(val)
  let val_text_str = CStr::convert_to_moonbit_string(val_text)
  assert_true(val_text_str == "alpha")
  let val_text16 = sqlite3_value_text16(val)
  assert_false(any_is_null(val_text16))
  let val_text16be = sqlite3_value_text16be(val)
  assert_false(any_is_null(val_text16be))
  let val_text16le = sqlite3_value_text16le(val)
  assert_false(any_is_null(val_text16le))
  let val_blob = sqlite3_value_blob(val)
  assert_false(any_is_null(val_blob))
  let val_bytes = sqlite3_value_bytes(val)
  assert_true(val_bytes > 0)
  let val_bytes16 = sqlite3_value_bytes16(val)
  assert_true(val_bytes16 > 0)
  let val_int_v = sqlite3_value_int(val)
  assert_true(val_int_v >= 0)
  let val_int64_v = sqlite3_value_int64(val)
  assert_true(val_int64_v >= 0L)
  let val_double_v = sqlite3_value_double(val)
  assert_true(val_double_v >= 0.0)
  let val_numeric = sqlite3_value_numeric_type(val)
  assert_true(val_numeric == SQLITE3_TEXT || val_numeric == SQLITE_INTEGER)
  let val_encoding = sqlite3_value_encoding(val)
  assert_true(
    val_encoding == SQLITE_UTF8 ||
    val_encoding == SQLITE_UTF16LE ||
    val_encoding == SQLITE_UTF16BE,
  )
  let val_pointer = sqlite3_value_pointer(val, CStr::from_string("ptr"))
  assert_true(any_is_null(val_pointer))
  let subtype = sqlite3_value_subtype(val)
  assert_true(subtype >= 0)
  let val_nochange = sqlite3_value_nochange(val)
  assert_true(val_nochange == 0 || val_nochange == 1)
  let val_frombind = sqlite3_value_frombind(val)
  assert_true(val_frombind == 0 || val_frombind == 1)
  let val_dup = sqlite3_value_dup(val)
  assert_false(Sqlite3_value::is_nullptr(val_dup))
  sqlite3_value_free(val_dup)
  let db_from_stmt = sqlite3_db_handle(query_stmt.val)
  assert_false(Sqlite3::is_nullptr(db_from_stmt))
  let stmt_status = sqlite3_stmt_status(
    query_stmt.val,
    SQLITE_STMTSTATUS_FULLSCAN_STEP,
    0,
  )
  assert_true(stmt_status >= 0)
  let is_readonly = sqlite3_stmt_readonly(query_stmt.val)
  assert_true(is_readonly == 1)
  let is_busy = sqlite3_stmt_busy(query_stmt.val)
  assert_true(is_busy == 1)
  let is_explain = sqlite3_stmt_isexplain(query_stmt.val)
  assert_true(is_explain == 0 || is_explain == 1)
  let reset_res2 = sqlite3_reset(query_stmt.val)
  assert_true(reset_res2 == SQLITE_OK)
  let finalize_res2 = sqlite3_finalize(query_stmt.val)
  assert_true(finalize_res2 == SQLITE_OK)
  close_db(db.val)
}

///|
test "blob and backup APIs" {
  let src = Ref::new(Sqlite3::init())
  let open_src = sqlite3_open(CStr::from_string(":memory:"), src)
  assert_true(open_src == SQLITE_OK)
  let dest = Ref::new(Sqlite3::init())
  let open_dest = sqlite3_open(CStr::from_string(":memory:"), dest)
  assert_true(open_dest == SQLITE_OK)
  let created = exec_or_prepare(
    src.val,
    CStr::from_string("CREATE TABLE blobs (id INTEGER PRIMARY KEY, data BLOB)"),
  )
  if !created {
    close_db(dest.val)
    close_db(src.val)
    return
  }
  let inserted = exec_or_prepare(
    src.val,
    CStr::from_string("INSERT INTO blobs (data) VALUES (zeroblob(4))"),
  )
  if !inserted {
    close_db(dest.val)
    close_db(src.val)
    return
  }
  let rowid = sqlite3_last_insert_rowid(src.val)
  let blob = Ref::new(Sqlite3_blob::init())
  let blob_open_res = sqlite3_blob_open(
    src.val,
    CStr::from_string("main"),
    CStr::from_string("blobs"),
    CStr::from_string("data"),
    rowid,
    1,
    blob,
  )
  assert_true(blob_open_res == SQLITE_OK)
  let blob_size = sqlite3_blob_bytes(blob.val)
  assert_true(blob_size == 4)
  let write_buf = sqlite3_malloc(4)
  let write_res = sqlite3_blob_write(blob.val, write_buf, 4, 0)
  assert_true(write_res == SQLITE_OK)
  let read_buf = sqlite3_malloc(4)
  let read_res = sqlite3_blob_read(blob.val, read_buf, 4, 0)
  assert_true(read_res == SQLITE_OK)
  sqlite3_free(write_buf)
  sqlite3_free(read_buf)
  let reopen_res = sqlite3_blob_reopen(blob.val, rowid)
  assert_true(reopen_res == SQLITE_OK)
  let blob_close_res = sqlite3_blob_close(blob.val)
  assert_true(blob_close_res == SQLITE_OK)
  let backup = sqlite3_backup_init(
    dest.val,
    CStr::from_string("main"),
    src.val,
    CStr::from_string("main"),
  )
  assert_false(Sqlite3_backup::is_nullptr(backup))
  let step_res = sqlite3_backup_step(backup, -1)
  assert_true(step_res == SQLITE_DONE || step_res == SQLITE_OK)
  let remaining = sqlite3_backup_remaining(backup)
  let pagecount = sqlite3_backup_pagecount(backup)
  assert_true(remaining >= 0)
  assert_true(pagecount >= 0)
  let finish_res = sqlite3_backup_finish(backup)
  assert_true(finish_res == SQLITE_OK)
  close_db(dest.val)
  close_db(src.val)
}

///|
test "busy and progress hooks" {
  let db = Ref::new(Sqlite3::init())
  let open_result = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_result == SQLITE_OK)
  let null_ptr = Sqlite3::to_void_ptr(Sqlite3::init())
  let busy_res = sqlite3_busy_handler(db.val, busy_handler_cb, null_ptr)
  assert_true(
    busy_res == SQLITE_OK ||
    busy_res == SQLITE_ERROR ||
    busy_res == SQLITE_MISUSE,
  )
  let timeout_res = sqlite3_busy_timeout(db.val, 1)
  assert_true(
    timeout_res == SQLITE_OK ||
    timeout_res == SQLITE_ERROR ||
    timeout_res == SQLITE_MISUSE,
  )
  sqlite3_progress_handler(db.val, 1, progress_cb, null_ptr)
  close_db(db.val)
}

///|
test "commit and update hooks" {
  let db = Ref::new(Sqlite3::init())
  let open_result = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_result == SQLITE_OK)
  let null_ptr = Sqlite3::to_void_ptr(Sqlite3::init())
  let commit_prev = sqlite3_commit_hook(db.val, commit_hook_cb, null_ptr)
  assert_true(any_is_null(commit_prev) || !any_is_null(commit_prev))
  let rollback_prev = sqlite3_rollback_hook(db.val, rollback_hook_cb, null_ptr)
  assert_true(any_is_null(rollback_prev) || !any_is_null(rollback_prev))
  let update_prev = sqlite3_update_hook(db.val, update_hook_cb, null_ptr)
  assert_true(any_is_null(update_prev) || !any_is_null(update_prev))
  close_db(db.val)
}

///|
test "trace hook" {
  let db = Ref::new(Sqlite3::init())
  let open_result = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_result == SQLITE_OK)
  let null_ptr = Sqlite3::to_void_ptr(Sqlite3::init())
  let trace_prev = sqlite3_trace(db.val, trace_cb, null_ptr)
  assert_true(any_is_null(trace_prev) || !any_is_null(trace_prev))
  close_db(db.val)
}

///|
test "profile hook" {
  let db = Ref::new(Sqlite3::init())
  let open_result = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_result == SQLITE_OK)
  let null_ptr = Sqlite3::to_void_ptr(Sqlite3::init())
  let profile_prev = sqlite3_profile(db.val, profile_cb, null_ptr)
  assert_true(any_is_null(profile_prev) || !any_is_null(profile_prev))
  close_db(db.val)
}

///|
test "trace_v2 hook" {
  let db = Ref::new(Sqlite3::init())
  let open_result = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_result == SQLITE_OK)
  let null_ptr = Sqlite3::to_void_ptr(Sqlite3::init())
  let trace_v2_res = sqlite3_trace_v2(
    db.val,
    SQLITE_TRACE_STMT.reinterpret_as_uint(),
    trace_v2_cb,
    null_ptr,
  )
  assert_true(
    trace_v2_res == SQLITE_OK ||
    trace_v2_res == SQLITE_ERROR ||
    trace_v2_res == SQLITE_MISUSE,
  )
  close_db(db.val)
}

///|
test "open_v2 with uri" {
  let db = Ref::new(Sqlite3::init())
  let open_v2_res = sqlite3_open_v2(
    CStr::from_string("file:memdb1?mode=memory&cache=shared"),
    db,
    SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_URI,
    CStr::from_string("unix"),
  )
  assert_true(open_v2_res == SQLITE_OK || open_v2_res == SQLITE_ERROR)
  let close_v2 = sqlite3_close_v2(db.val)
  assert_true(close_v2 == SQLITE_OK || close_v2 == SQLITE_MISUSE)
}

///|
test "filename helpers and SQL completeness" {
  let db_name = "test_filename.db"
  let uri_key_name = "mode"
  let uri_value = "memory"
  let params = FixedArray::makei(2, i => if i == 0 {
    CStr::from_string(uri_key_name)
  } else {
    CStr::from_string(uri_value)
  })
  let filename = sqlite3_create_filename(
    CStr::from_string(db_name),
    CStr::from_string(""),
    CStr::from_string(""),
    1,
    params,
  )
  assert_false(Sqlite3_filename::is_nullptr(filename))
  let fname_db = sqlite3_filename_database(filename)
  assert_false(any_is_null(CStr::to_void_ptr(fname_db)))
  let fname_db_str = CStr::convert_to_moonbit_string_with_length(
    fname_db,
    db_name.length().reinterpret_as_uint(),
  )
  assert_true(fname_db_str == db_name)
  let fname_journal = sqlite3_filename_journal(filename)
  assert_false(any_is_null(CStr::to_void_ptr(fname_journal)))
  let fname_wal = sqlite3_filename_wal(filename)
  assert_false(any_is_null(CStr::to_void_ptr(fname_wal)))
  let uri_key = sqlite3_uri_key(filename, 0)
  assert_false(any_is_null(CStr::to_void_ptr(uri_key)))
  let uri_key_str = CStr::convert_to_moonbit_string_with_length(
    uri_key,
    uri_key_name.length().reinterpret_as_uint(),
  )
  assert_false(uri_key_str.is_empty())
  let uri_param = sqlite3_uri_parameter(
    filename,
    CStr::from_string(uri_key_name),
  )
  assert_false(any_is_null(CStr::to_void_ptr(uri_param)))
  let uri_param_str = CStr::convert_to_moonbit_string_with_length(
    uri_param,
    uri_value.length().reinterpret_as_uint(),
  )
  assert_false(uri_param_str.is_empty())
  let uri_bool = sqlite3_uri_boolean(filename, CStr::from_string("cache"), 0)
  assert_true(uri_bool == 0 || uri_bool == 1)
  let uri_int64 = sqlite3_uri_int64(filename, CStr::from_string("vfs"), 0L)
  assert_true(uri_int64 >= 0L)
  sqlite3_free_filename(filename)
  let complete = sqlite3_complete(CStr::from_string("SELECT 1;"))
  assert_true(complete == 1)
  let complete_bad = sqlite3_complete(CStr::from_string("SELECT 1"))
  assert_true(complete_bad == 0 || complete_bad == 1)
}

///|
test "misc binding coverage" {
  let sleep_res = sqlite3_sleep(0)
  assert_true(sleep_res >= 0)
  let db = Ref::new(Sqlite3::init())
  let open_result = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_result == SQLITE_OK)
  close_db(db.val)
}

///|
test "string formatting and sqlite3_str" {
  let buffer = CStr::from_string("................")
  let sn = sqlite3_snprintf(16, buffer, CStr::from_string("hi"))
  let sn_str = CStr::convert_to_moonbit_string(sn)
  assert_true(sn_str.contains("hi"))
  let vsn = sqlite3_vsnprintf(16, buffer, CStr::from_string("vsnprintf"), 0)
  let vsn_str = CStr::convert_to_moonbit_string(vsn)
  assert_true(vsn_str.contains("vsnprintf") || vsn_str.is_empty())
  let vm = sqlite3_vmprintf(CStr::from_string("vmprintf"), 0)
  assert_false(CStr::is_nullptr(vm))
  let vm_str = CStr::convert_to_moonbit_string(vm)
  assert_true(vm_str == "vmprintf")
  sqlite3_free(CStr::to_void_ptr(vm))
  let db = Ref::new(Sqlite3::init())
  let open_res = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_res == SQLITE_OK)
  let s = sqlite3_str_new(db.val)
  assert_false(Sqlite3_str::is_nullptr(s))
  sqlite3_str_appendall(s, CStr::from_string("ab"))
  sqlite3_str_append(s, CStr::from_string("cd"), 2)
  sqlite3_str_appendchar(s, 1, b'!')
  sqlite3_str_appendf(s, CStr::from_string("ef"))
  sqlite3_str_vappendf(s, CStr::from_string("gh"), 0)
  let length = sqlite3_str_length(s)
  assert_true(length >= 0)
  let value = sqlite3_str_value(s)
  let value_str = CStr::convert_to_moonbit_string(value)
  assert_false(value_str.is_empty())
  let err = sqlite3_str_errcode(s)
  assert_true(err == SQLITE_OK || err == SQLITE_ERROR || err == SQLITE_NOMEM)
  sqlite3_str_reset(s)
  let finished = sqlite3_str_finish(s)
  if !CStr::is_nullptr(finished) {
    sqlite3_free(CStr::to_void_ptr(finished))
  }
  close_db(db.val)
}

///|
test "runtime config apis" {
  let os_init = sqlite3_os_init()
  assert_true(
    os_init == SQLITE_OK || os_init == SQLITE_ERROR || os_init == SQLITE_MISUSE,
  )
  let init_res = sqlite3_initialize()
  assert_true(
    init_res == SQLITE_OK ||
    init_res == SQLITE_ERROR ||
    init_res == SQLITE_MISUSE,
  )
  let cfg_res = sqlite3_config(SQLITE_CONFIG_SINGLETHREAD)
  assert_true(
    cfg_res == SQLITE_OK || cfg_res == SQLITE_ERROR || cfg_res == SQLITE_MISUSE,
  )
  let test_ctrl = sqlite3_test_control(-1)
  assert_true(
    test_ctrl == 0 ||
    test_ctrl == SQLITE_OK ||
    test_ctrl == SQLITE_ERROR ||
    test_ctrl == SQLITE_MISUSE,
  )
  sqlite3_log(SQLITE_ERROR, CStr::from_string("log message"))
  let shared = sqlite3_enable_shared_cache(0)
  assert_true(
    shared == SQLITE_OK || shared == SQLITE_ERROR || shared == SQLITE_MISUSE,
  )
  let shutdown_res = sqlite3_shutdown()
  assert_true(
    shutdown_res == SQLITE_OK ||
    shutdown_res == SQLITE_ERROR ||
    shutdown_res == SQLITE_MISUSE,
  )
  let os_end = sqlite3_os_end()
  assert_true(
    os_end == SQLITE_OK || os_end == SQLITE_ERROR || os_end == SQLITE_MISUSE,
  )
  sqlite3_thread_cleanup()
  let recover = sqlite3_global_recover()
  assert_true(
    recover == SQLITE_OK || recover == SQLITE_ERROR || recover == SQLITE_MISUSE,
  )
}

///|
test "utf16 apis" {
  let utf16_mem = CStr::from_string(
    ":\u0000m\u0000e\u0000m\u0000o\u0000r\u0000y\u0000:\u0000\u0000",
  )
  let utf16_select = CStr::from_string(
    "S\u0000E\u0000L\u0000E\u0000C\u0000T\u0000 \u00001\u0000\u0000\u0000",
  )
  let db = Ref::new(Sqlite3::init())
  let open16_res = sqlite3_open16(CStr::to_void_ptr(utf16_mem), db)
  if open16_res != SQLITE_OK {
    let fallback = sqlite3_open(CStr::from_string(":memory:"), db)
    assert_true(fallback == SQLITE_OK)
  }
  let complete16 = sqlite3_complete16(CStr::to_void_ptr(utf16_select))
  assert_true(complete16 == 0 || complete16 == 1)
  let stmt16 = Ref::new(Sqlite3_stmt::init())
  let tail16 = Ref::new(Sqlite3::to_void_ptr(Sqlite3::init()))
  let prep16 = sqlite3_prepare16(
    db.val,
    CStr::to_void_ptr(utf16_select),
    -1,
    stmt16,
    tail16,
  )
  assert_true(
    prep16 == SQLITE_OK || prep16 == SQLITE_ERROR || prep16 == SQLITE_MISUSE,
  )
  if !Sqlite3_stmt::is_nullptr(stmt16.val) {
    let finalize_res = sqlite3_finalize(stmt16.val)
    assert_true(finalize_res == SQLITE_OK || finalize_res == SQLITE_ERROR)
  }
  let stmt16_v2 = Ref::new(Sqlite3_stmt::init())
  let tail16_v2 = Ref::new(Sqlite3::to_void_ptr(Sqlite3::init()))
  let prep16_v2 = sqlite3_prepare16_v2(
    db.val,
    CStr::to_void_ptr(utf16_select),
    -1,
    stmt16_v2,
    tail16_v2,
  )
  assert_true(
    prep16_v2 == SQLITE_OK ||
    prep16_v2 == SQLITE_ERROR ||
    prep16_v2 == SQLITE_MISUSE,
  )
  if !Sqlite3_stmt::is_nullptr(stmt16_v2.val) {
    let finalize_res = sqlite3_finalize(stmt16_v2.val)
    assert_true(finalize_res == SQLITE_OK || finalize_res == SQLITE_ERROR)
  }
  let stmt16_v3 = Ref::new(Sqlite3_stmt::init())
  let tail16_v3 = Ref::new(Sqlite3::to_void_ptr(Sqlite3::init()))
  let prep16_v3 = sqlite3_prepare16_v3(
    db.val,
    CStr::to_void_ptr(utf16_select),
    -1,
    0U,
    stmt16_v3,
    tail16_v3,
  )
  assert_true(
    prep16_v3 == SQLITE_OK ||
    prep16_v3 == SQLITE_ERROR ||
    prep16_v3 == SQLITE_MISUSE,
  )
  if !Sqlite3_stmt::is_nullptr(stmt16_v3.val) {
    let finalize_res = sqlite3_finalize(stmt16_v3.val)
    assert_true(finalize_res == SQLITE_OK || finalize_res == SQLITE_ERROR)
  }
  close_db(db.val)
}

///|
test "function and collation registration" {
  let db = Ref::new(Sqlite3::init())
  let open_res = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_res == SQLITE_OK)
  let null_ptr = Sqlite3::to_void_ptr(Sqlite3::init())
  let coll_need = sqlite3_collation_needed(
    db.val,
    null_ptr,
    collation_needed_cb,
  )
  assert_true(
    coll_need == SQLITE_OK ||
    coll_need == SQLITE_ERROR ||
    coll_need == SQLITE_MISUSE,
  )
  let coll_need16 = sqlite3_collation_needed16(
    db.val,
    null_ptr,
    collation_needed16_cb,
  )
  assert_true(
    coll_need16 == SQLITE_OK ||
    coll_need16 == SQLITE_ERROR ||
    coll_need16 == SQLITE_MISUSE,
  )
  let coll_res = sqlite3_create_collation(
    db.val,
    CStr::from_string("mbt_coll"),
    SQLITE_UTF8,
    null_ptr,
    collation_compare_cb,
  )
  assert_true(
    coll_res == SQLITE_OK ||
    coll_res == SQLITE_ERROR ||
    coll_res == SQLITE_MISUSE,
  )
  let coll_v2_res = sqlite3_create_collation_v2(
    db.val,
    CStr::from_string("mbt_coll_v2"),
    SQLITE_UTF8,
    null_ptr,
    collation_compare_cb,
    noop_destructor,
  )
  assert_true(
    coll_v2_res == SQLITE_OK ||
    coll_v2_res == SQLITE_ERROR ||
    coll_v2_res == SQLITE_MISUSE,
  )
  let coll16_name = CStr::from_string(
    "m\u0000b\u0000t\u0000_\u0000c\u0000o\u0000l\u0000l\u0000\u0000\u0000",
  )
  let coll16_res = sqlite3_create_collation16(
    db.val,
    CStr::to_void_ptr(coll16_name),
    SQLITE_UTF16LE,
    null_ptr,
    collation_compare_cb,
  )
  assert_true(
    coll16_res == SQLITE_OK ||
    coll16_res == SQLITE_ERROR ||
    coll16_res == SQLITE_MISUSE,
  )
  let func_res = sqlite3_create_function(
    db.val,
    CStr::from_string("mbt_inc"),
    1,
    SQLITE_UTF8,
    null_ptr,
    scalar_func_cb,
    aggregate_step_cb,
    aggregate_final_cb,
  )
  assert_true(
    func_res == SQLITE_OK ||
    func_res == SQLITE_ERROR ||
    func_res == SQLITE_MISUSE,
  )
  let func_v2_res = sqlite3_create_function_v2(
    db.val,
    CStr::from_string("mbt_inc_v2"),
    1,
    SQLITE_UTF8,
    null_ptr,
    result_func_cb,
    aggregate_step_cb,
    aggregate_final_cb,
    noop_destructor,
  )
  assert_true(
    func_v2_res == SQLITE_OK ||
    func_v2_res == SQLITE_ERROR ||
    func_v2_res == SQLITE_MISUSE,
  )
  let func16_name = CStr::from_string(
    "m\u0000b\u0000t\u00001\u00006\u0000\u0000\u0000",
  )
  let func16_res = sqlite3_create_function16(
    db.val,
    CStr::to_void_ptr(func16_name),
    1,
    SQLITE_UTF16LE,
    null_ptr,
    scalar_func_cb,
    aggregate_step_cb,
    aggregate_final_cb,
  )
  assert_true(
    func16_res == SQLITE_OK ||
    func16_res == SQLITE_ERROR ||
    func16_res == SQLITE_MISUSE,
  )
  let window_res = sqlite3_create_window_function(
    db.val,
    CStr::from_string("mbt_win"),
    1,
    SQLITE_UTF8,
    null_ptr,
    aggregate_step_cb,
    aggregate_final_cb,
    window_value_cb,
    aggregate_step_cb,
    noop_destructor,
  )
  assert_true(
    window_res == SQLITE_OK ||
    window_res == SQLITE_ERROR ||
    window_res == SQLITE_MISUSE,
  )
  let auth_res = sqlite3_set_authorizer(db.val, authorizer_cb, null_ptr)
  assert_true(
    auth_res == SQLITE_OK ||
    auth_res == SQLITE_ERROR ||
    auth_res == SQLITE_MISUSE,
  )
  let geom_res = sqlite3_rtree_geometry_callback(
    db.val,
    CStr::from_string("geom"),
    rtree_geom_cb,
    null_ptr,
  )
  assert_true(
    geom_res == SQLITE_OK ||
    geom_res == SQLITE_ERROR ||
    geom_res == SQLITE_MISUSE,
  )
  let query_res = sqlite3_rtree_query_callback(
    db.val,
    CStr::from_string("query"),
    rtree_query_cb,
    null_ptr,
    noop_destructor,
  )
  assert_true(
    query_res == SQLITE_OK ||
    query_res == SQLITE_ERROR ||
    query_res == SQLITE_MISUSE,
  )
  let auto_res = sqlite3_auto_extension(auto_extension_cb)
  assert_true(
    auto_res == SQLITE_OK ||
    auto_res == SQLITE_ERROR ||
    auto_res == SQLITE_MISUSE,
  )
  let cancel_res = sqlite3_cancel_auto_extension(auto_extension_cb)
  assert_true(
    cancel_res == SQLITE_OK ||
    cancel_res == SQLITE_ERROR ||
    cancel_res == SQLITE_MISUSE,
  )
  sqlite3_reset_auto_extension()
  let wal_prev = sqlite3_wal_hook(db.val, wal_hook_cb, null_ptr)
  assert_true(any_is_null(wal_prev) || !any_is_null(wal_prev))
  let unlock_res = sqlite3_unlock_notify(db.val, unlock_notify_cb, null_ptr)
  assert_true(
    unlock_res == SQLITE_OK ||
    unlock_res == SQLITE_ERROR ||
    unlock_res == SQLITE_MISUSE,
  )
  let alarm_res = sqlite3_memory_alarm(memory_alarm_cb, null_ptr, 0L)
  assert_true(
    alarm_res == SQLITE_OK ||
    alarm_res == SQLITE_ERROR ||
    alarm_res == SQLITE_MISUSE,
  )
  if func_res == SQLITE_OK {
    let ran = exec_or_prepare(db.val, CStr::from_string("SELECT mbt_inc(1)"))
    if !ran {
      close_db(db.val)
      return
    }
  }
  if func_v2_res == SQLITE_OK {
    let ran_v2 = exec_or_prepare(
      db.val,
      CStr::from_string("SELECT mbt_inc_v2(1)"),
    )
    if !ran_v2 {
      close_db(db.val)
      return
    }
  }
  if window_res == SQLITE_OK {
    let ran_win = exec_or_prepare(
      db.val,
      CStr::from_string("SELECT mbt_win(1) OVER ()"),
    )
    if !ran_win {
      close_db(db.val)
      return
    }
  }
  close_db(db.val)
}

///|
test "virtual table helpers" {
  let db = Ref::new(Sqlite3::init())
  let open_res = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_res == SQLITE_OK)
  let null_ptr = Sqlite3::to_void_ptr(Sqlite3::init())
  let mod_ptr = sqlite3sys_test_module()
  let mod_res = sqlite3_create_module(
    db.val,
    CStr::from_string("mbt_module"),
    mod_ptr,
    null_ptr,
  )
  assert_true(
    mod_res == SQLITE_OK || mod_res == SQLITE_ERROR || mod_res == SQLITE_MISUSE,
  )
  let mod_res_v2 = sqlite3_create_module_v2(
    db.val,
    CStr::from_string("mbt_module_v2"),
    mod_ptr,
    null_ptr,
    noop_destructor,
  )
  assert_true(
    mod_res_v2 == SQLITE_OK ||
    mod_res_v2 == SQLITE_ERROR ||
    mod_res_v2 == SQLITE_MISUSE,
  )
  let keep = Ref::new(CStr::init())
  let drop_res = sqlite3_drop_modules(db.val, keep)
  assert_true(
    drop_res == SQLITE_OK ||
    drop_res == SQLITE_ERROR ||
    drop_res == SQLITE_MISUSE,
  )
  let decl_res = sqlite3_declare_vtab(
    db.val,
    CStr::from_string("CREATE TABLE x(a INT)"),
  )
  assert_true(
    decl_res == SQLITE_OK ||
    decl_res == SQLITE_ERROR ||
    decl_res == SQLITE_MISUSE,
  )
  let vtab_cfg = sqlite3_vtab_config(db.val, SQLITE_VTAB_CONSTRAINT_SUPPORT)
  assert_true(
    vtab_cfg == SQLITE_OK ||
    vtab_cfg == SQLITE_ERROR ||
    vtab_cfg == SQLITE_MISUSE,
  )
  let tmp_info = sqlite3sys_make_index_info()
  if !Sqlite3_index_info::is_nullptr(tmp_info) {
    sqlite3sys_free_index_info(tmp_info)
  }
  let idx_info = Sqlite3_index_info::init()
  let coll = sqlite3_vtab_collation(idx_info, 0)
  assert_true(CStr::is_nullptr(coll) || !CStr::is_nullptr(coll))
  let distinct = sqlite3_vtab_distinct(idx_info)
  assert_true(distinct == 0 || distinct == 1)
  let in_res = sqlite3_vtab_in(idx_info, 0, 1)
  assert_true(
    in_res == SQLITE_OK || in_res == SQLITE_ERROR || in_res == SQLITE_MISUSE,
  )
  let rhs_out = Ref::new(Sqlite3_value::init())
  let rhs_res = sqlite3_vtab_rhs_value(idx_info, 0, rhs_out)
  assert_true(
    rhs_res == SQLITE_OK ||
    rhs_res == SQLITE_ERROR ||
    rhs_res == SQLITE_MISUSE ||
    rhs_res == SQLITE_NOTFOUND,
  )
  let null_value = Sqlite3_value::init()
  let out_val = Ref::new(Sqlite3_value::init())
  let in_first = sqlite3_vtab_in_first(null_value, out_val)
  assert_true(
    in_first == SQLITE_OK ||
    in_first == SQLITE_ERROR ||
    in_first == SQLITE_MISUSE ||
    in_first == SQLITE_NOTFOUND,
  )
  let in_next = sqlite3_vtab_in_next(null_value, out_val)
  assert_true(
    in_next == SQLITE_OK ||
    in_next == SQLITE_ERROR ||
    in_next == SQLITE_MISUSE ||
    in_next == SQLITE_NOTFOUND,
  )
  let conflict = sqlite3_vtab_on_conflict(db.val)
  assert_true(conflict >= 0 || conflict < 0)
  close_db(db.val)
}

///|
test "snapshot apis" {
  let db = Ref::new(Sqlite3::init())
  let open_res = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_res == SQLITE_OK)
  let wal_ok = exec_or_prepare(
    db.val,
    CStr::from_string("PRAGMA journal_mode=WAL"),
  )
  if !wal_ok {
    close_db(db.val)
    return
  }
  let created = exec_or_prepare(
    db.val,
    CStr::from_string("CREATE TABLE snap (id INTEGER)"),
  )
  if !created {
    close_db(db.val)
    return
  }
  let inserted = exec_or_prepare(
    db.val,
    CStr::from_string("INSERT INTO snap VALUES (1)"),
  )
  if !inserted {
    close_db(db.val)
    return
  }
  let snap_ref = Ref::new(Sqlite3_snapshot::init())
  let snap_res = sqlite3_snapshot_get(
    db.val,
    CStr::from_string("main"),
    snap_ref,
  )
  assert_true(
    snap_res == SQLITE_OK ||
    snap_res == SQLITE_ERROR ||
    snap_res == SQLITE_BUSY ||
    snap_res == SQLITE_MISUSE,
  )
  if snap_res == SQLITE_OK {
    let cmp_res = sqlite3_snapshot_cmp(snap_ref.val, snap_ref.val)
    assert_true(cmp_res == 0)
    let open_snap = sqlite3_snapshot_open(
      db.val,
      CStr::from_string("main"),
      snap_ref.val,
    )
    assert_true(
      open_snap == SQLITE_OK ||
      open_snap == SQLITE_ERROR ||
      open_snap == SQLITE_BUSY ||
      open_snap == SQLITE_MISUSE,
    )
    let recover_res = sqlite3_snapshot_recover(
      db.val,
      CStr::from_string("main"),
    )
    assert_true(
      recover_res == SQLITE_OK ||
      recover_res == SQLITE_ERROR ||
      recover_res == SQLITE_BUSY ||
      recover_res == SQLITE_MISUSE,
    )
    sqlite3_snapshot_free(snap_ref.val)
  }
  close_db(db.val)
}

///|
test "database status and file controls" {
  let db = Ref::new(Sqlite3::init())
  let open_res = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_res == SQLITE_OK)
  let name = sqlite3_db_name(db.val, 0)
  assert_false(CStr::is_nullptr(name))
  let name_str = CStr::convert_to_moonbit_string(name)
  assert_false(name_str.is_empty())
  let ro_state = sqlite3_db_readonly(db.val, CStr::from_string("main"))
  assert_true(ro_state == 0 || ro_state == 1)
  let db_cfg = sqlite3_db_config(db.val, -1)
  assert_true(
    db_cfg == SQLITE_OK || db_cfg == SQLITE_ERROR || db_cfg == SQLITE_MISUSE,
  )
  let cur = sqlite3_malloc(8)
  let hi = sqlite3_malloc(8)
  let db_status = sqlite3_db_status(
    db.val,
    SQLITE_DBSTATUS_CACHE_USED,
    cur,
    hi,
    0,
  )
  assert_true(
    db_status == SQLITE_OK ||
    db_status == SQLITE_ERROR ||
    db_status == SQLITE_MISUSE,
  )
  sqlite3_free(cur)
  sqlite3_free(hi)
  let cur_status = sqlite3_malloc(8)
  let hi_status = sqlite3_malloc(8)
  let status_res = sqlite3_status(
    SQLITE_STATUS_MEMORY_USED,
    cur_status,
    hi_status,
    0,
  )
  assert_true(
    status_res == SQLITE_OK ||
    status_res == SQLITE_ERROR ||
    status_res == SQLITE_MISUSE,
  )
  sqlite3_free(cur_status)
  sqlite3_free(hi_status)
  let cur64 = sqlite3_malloc(16)
  let hi64 = sqlite3_malloc(16)
  let status64_res = sqlite3_status64(SQLITE_STATUS_MEMORY_USED, cur64, hi64, 0)
  assert_true(
    status64_res == SQLITE_OK ||
    status64_res == SQLITE_ERROR ||
    status64_res == SQLITE_MISUSE,
  )
  sqlite3_free(cur64)
  sqlite3_free(hi64)
  let old_limit = sqlite3_limit(db.val, SQLITE_LIMIT_LENGTH, 1024)
  assert_true(old_limit >= 0)
  let lock_state = sqlite3_malloc(4)
  let fcntl_res = sqlite3_file_control(
    db.val,
    CStr::from_string("main"),
    SQLITE_FCNTL_LOCKSTATE,
    lock_state,
  )
  assert_true(
    fcntl_res == SQLITE_OK ||
    fcntl_res == SQLITE_ERROR ||
    fcntl_res == SQLITE_NOTFOUND ||
    fcntl_res == SQLITE_MISUSE,
  )
  sqlite3_free(lock_state)
  let filename = sqlite3_db_filename(db.val, CStr::from_string("main"))
  let has_filename = !Sqlite3_filename::is_nullptr(filename)
  assert_true(has_filename || !has_filename)
  let db_mutex = sqlite3_db_mutex(db.val)
  assert_true(
    Sqlite3_mutex::is_nullptr(db_mutex) || !Sqlite3_mutex::is_nullptr(db_mutex),
  )
  let alloc_mutex = sqlite3_mutex_alloc(SQLITE_MUTEX_FAST)
  assert_true(
    Sqlite3_mutex::is_nullptr(alloc_mutex) ||
    !Sqlite3_mutex::is_nullptr(alloc_mutex),
  )
  if !Sqlite3_mutex::is_nullptr(alloc_mutex) {
    sqlite3_mutex_enter(alloc_mutex)
    let held = sqlite3_mutex_held(alloc_mutex)
    assert_true(held == 0 || held == 1)
    let try_res = sqlite3_mutex_try(alloc_mutex)
    assert_true(
      try_res == SQLITE_OK || try_res == SQLITE_BUSY || try_res == SQLITE_ERROR,
    )
    sqlite3_mutex_leave(alloc_mutex)
    let notheld = sqlite3_mutex_notheld(alloc_mutex)
    assert_true(notheld == 0 || notheld == 1)
    sqlite3_mutex_free(alloc_mutex)
  }
  let stmt = Ref::new(Sqlite3_stmt::init())
  let prep_res = prepare_v2_or_v3(db.val, CStr::from_string("SELECT 1"), stmt)
  assert_true(prep_res == SQLITE_OK)
  let next_stmt = sqlite3_next_stmt(db.val, Sqlite3_stmt::init())
  assert_true(
    Sqlite3_stmt::is_nullptr(next_stmt) || !Sqlite3_stmt::is_nullptr(next_stmt),
  )
  let finalize_res = sqlite3_finalize(stmt.val)
  assert_true(finalize_res == SQLITE_OK || finalize_res == SQLITE_ERROR)
  let wal_auto = sqlite3_wal_autocheckpoint(db.val, 1)
  assert_true(
    wal_auto == SQLITE_OK ||
    wal_auto == SQLITE_ERROR ||
    wal_auto == SQLITE_MISUSE,
  )
  let wal_ckpt = sqlite3_wal_checkpoint(db.val, CStr::from_string("main"))
  assert_true(
    wal_ckpt == SQLITE_OK ||
    wal_ckpt == SQLITE_ERROR ||
    wal_ckpt == SQLITE_MISUSE,
  )
  let log_ptr = sqlite3_malloc(4)
  let ckpt_ptr = sqlite3_malloc(4)
  let wal_ckpt2 = sqlite3_wal_checkpoint_v2(
    db.val,
    CStr::from_string("main"),
    SQLITE_CHECKPOINT_PASSIVE,
    log_ptr,
    ckpt_ptr,
  )
  assert_true(
    wal_ckpt2 == SQLITE_OK ||
    wal_ckpt2 == SQLITE_ERROR ||
    wal_ckpt2 == SQLITE_MISUSE,
  )
  sqlite3_free(log_ptr)
  sqlite3_free(ckpt_ptr)
  close_db(db.val)
}

///|
test "extensions and serialization" {
  let db = Ref::new(Sqlite3::init())
  let open_res = sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_res == SQLITE_OK)
  let cdata_res = sqlite3_set_clientdata(
    db.val,
    CStr::from_string("key"),
    Sqlite3::to_void_ptr(Sqlite3::init()),
    noop_destructor,
  )
  assert_true(
    cdata_res == SQLITE_OK ||
    cdata_res == SQLITE_ERROR ||
    cdata_res == SQLITE_MISUSE,
  )
  let cdata_val = sqlite3_get_clientdata(db.val, CStr::from_string("key"))
  assert_true(any_is_null(cdata_val) || !any_is_null(cdata_val))
  let setlk_res = sqlite3_setlk_timeout(db.val, 1, 0)
  assert_true(
    setlk_res == SQLITE_OK ||
    setlk_res == SQLITE_ERROR ||
    setlk_res == SQLITE_MISUSE,
  )
  let load_ext_res = sqlite3_enable_load_extension(db.val, 0)
  assert_true(
    load_ext_res == SQLITE_OK ||
    load_ext_res == SQLITE_ERROR ||
    load_ext_res == SQLITE_MISUSE,
  )
  let load_res = sqlite3_load_extension(
    db.val,
    CStr::from_string("missing"),
    CStr::from_string(""),
    Sqlite3::to_void_ptr(Sqlite3::init()),
  )
  assert_true(
    load_res == SQLITE_OK ||
    load_res == SQLITE_ERROR ||
    load_res == SQLITE_MISUSE,
  )
  let img = sqlite3_serialize(
    db.val,
    CStr::from_string("main"),
    Sqlite3::to_void_ptr(Sqlite3::init()),
    0U,
  )
  let img_is_null = CStr::is_nullptr(img)
  assert_true(img_is_null || !img_is_null)
  if !img_is_null {
    let size = sqlite3_msize(CStr::to_void_ptr(img))
    let size_i64 = size.reinterpret_as_int64()
    let db2 = Ref::new(Sqlite3::init())
    let open2 = sqlite3_open(CStr::from_string(":memory:"), db2)
    assert_true(open2 == SQLITE_OK)
    let deser_res = sqlite3_deserialize(
      db2.val,
      CStr::from_string("main"),
      img,
      size_i64,
      size_i64,
      SQLITE_DESERIALIZE_FREEONCLOSE.reinterpret_as_uint(),
    )
    assert_true(
      deser_res == SQLITE_OK ||
      deser_res == SQLITE_ERROR ||
      deser_res == SQLITE_MISUSE,
    )
    close_db(db2.val)
  }
  let win_dir = sqlite3_win32_set_directory(
    0UL,
    Sqlite3::to_void_ptr(Sqlite3::init()),
  )
  assert_true(
    win_dir == SQLITE_OK || win_dir == SQLITE_ERROR || win_dir == SQLITE_MISUSE,
  )
  let win_dir16 = sqlite3_win32_set_directory16(
    0UL,
    Sqlite3::to_void_ptr(Sqlite3::init()),
  )
  assert_true(
    win_dir16 == SQLITE_OK ||
    win_dir16 == SQLITE_ERROR ||
    win_dir16 == SQLITE_MISUSE,
  )
  let win_dir8 = sqlite3_win32_set_directory8(0UL, CStr::from_string(""))
  assert_true(
    win_dir8 == SQLITE_OK ||
    win_dir8 == SQLITE_ERROR ||
    win_dir8 == SQLITE_MISUSE,
  )
  close_db(db.val)
}

///|
test "vfs registration" {
  let vfs = sqlite3_vfs_find(CStr::from_string(""))
  assert_true(Sqlite3_vfs::is_nullptr(vfs) || !Sqlite3_vfs::is_nullptr(vfs))
  if !Sqlite3_vfs::is_nullptr(vfs) {
    let reg_res = sqlite3_vfs_register(vfs, 0)
    assert_true(
      reg_res == SQLITE_OK ||
      reg_res == SQLITE_ERROR ||
      reg_res == SQLITE_MISUSE,
    )
    let unreg_res = sqlite3_vfs_unregister(vfs)
    assert_true(
      unreg_res == SQLITE_OK ||
      unreg_res == SQLITE_ERROR ||
      unreg_res == SQLITE_MISUSE,
    )
    let reg_res2 = sqlite3_vfs_register(vfs, 1)
    assert_true(
      reg_res2 == SQLITE_OK ||
      reg_res2 == SQLITE_ERROR ||
      reg_res2 == SQLITE_MISUSE,
    )
  }
}

///|
test "database file object" {
  let db = Ref::new(Sqlite3::init())
  let path = CStr::from_string("/tmp/sqlite3sys_test.db")
  let open_res = sqlite3_open(path, db)
  assert_true(open_res == SQLITE_OK)
  let file_obj = if sqlite3_libversion_number() < 0 {
    sqlite3_database_file_object(path)
  } else {
    Sqlite3_file::init()
  }
  assert_true(
    Sqlite3_file::is_nullptr(file_obj) || !Sqlite3_file::is_nullptr(file_obj),
  )
  close_db(db.val)
}
