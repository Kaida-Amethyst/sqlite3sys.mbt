///| Test basic SQLite operations
test "SQLite open and close" {
  // test in-memory database connection
  let db = { val: Sqlite3::init() }
  let result = sqlite3_open(
    CStr::from_string(":memory:"),
    db,
  )

  // verify connection success
  assert_true(result == SQLITE_OK)
  assert_false(Sqlite3::is_nullptr(db.val))

  // close database
  let close_result = sqlite3_close(db.val)
  assert_true(close_result == SQLITE_OK)
}

///| Test SQL execution
test "simple sql execution" {
  let db = { val: Sqlite3::init() }
  let result = sqlite3_open(
    CStr::from_string(":memory:"),
    db,
  )
  assert_true(result == SQLITE_OK)

  // create table
  let create_sql = CStr::from_string(
    "CREATE TABLE test (id INTEGER PRIMARY KEY, name TEXT)",
  )
  let exec_result = sqlite3_exec(
    db.val,
    create_sql,
    fn(_data, _cols, _values, _names) { 0 },
    Sqlite3::to_void_ptr(Sqlite3::init()),
    Sqlite3::to_void_ptr(Sqlite3::init()),
  )
  assert_true(exec_result == SQLITE_OK)

  // Insert data
  let insert_sql = CStr::from_string(
    "INSERT INTO test (name) VALUES ('Hello')",
  )
  let insert_result = sqlite3_exec(
    db.val,
    insert_sql,
    fn(_data, _cols, _values, _names) { 0 },
    Sqlite3::to_void_ptr(Sqlite3::init()),
    Sqlite3::to_void_ptr(Sqlite3::init()),
  )
  assert_true(insert_result == SQLITE_OK)

  // check changes
  let changes = sqlite3_changes(db.val)
  assert_true(changes == 1)
  sqlite3_close(db.val) |> ignore
}

///| Test prepared statements
test "prepared statements" {
  let db = { val: Sqlite3::init() }
  sqlite3_open(CStr::from_string(":memory:"), db)
  |> ignore

  // create a table
  let create_sql = CStr::from_string(
    "CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
  )
  sqlite3_exec(
    db.val,
    create_sql,
    fn(_data, _cols, _values, _names) { 0 },
    Sqlite3::to_void_ptr(Sqlite3::init()),
    Sqlite3::to_void_ptr(Sqlite3::init()),
  )
  |> ignore

  // prepare insert statement
  let stmt = { val: Sqlite3_stmt::init() }
  let prepare_sql = CStr::from_string(
    "INSERT INTO users (name, age) VALUES (?, ?)",
  )
  let prepare_result = sqlite3_prepare_v2(
    db.val,
    prepare_sql,
    -1,
    stmt,
    @ref.new(CStr::from_string("")),
  )
  assert_true(prepare_result == SQLITE_OK)
  assert_false(Sqlite3_stmt::is_nullptr(stmt.val))

  // bind text
  let bind_name = sqlite3_bind_text(
    stmt.val,
    1,
    CStr::from_string("Alice"),
    -1,
    fn(_ptr) {  },
  )
  assert_true(bind_name == SQLITE_OK)
  let bind_age = sqlite3_bind_int(stmt.val, 2, 25)
  assert_true(bind_age == SQLITE_OK)

  // execute statement
  let step_result = sqlite3_step(stmt.val)
  assert_true(step_result == SQLITE_DONE)

  // cleanup
  sqlite3_finalize(stmt.val) |> ignore
  sqlite3_close(db.val) |> ignore
}

///| 
test "querying data" {
  let db = { val: Sqlite3::init() }
  sqlite3_open(CStr::from_string(":memory:"), db)
  |> ignore
  sqlite3_exec(
    db.val,
    CStr::from_string(
      "CREATE TABLE numbers (id INTEGER, value REAL, text TEXT)",
    ),
    fn(_data, _cols, _values, _names) { 0 },
    Sqlite3::to_void_ptr(Sqlite3::init()),
    Sqlite3::to_void_ptr(Sqlite3::init()),
  )
  |> ignore
  sqlite3_exec(
    db.val,
    CStr::from_string("INSERT INTO numbers VALUES (1, 3.14, 'pi')"),
    fn(_data, _cols, _values, _names) { 0 },
    Sqlite3::to_void_ptr(Sqlite3::init()),
    Sqlite3::to_void_ptr(Sqlite3::init()),
  )
  |> ignore
  let stmt = { val: Sqlite3_stmt::init() }
  sqlite3_prepare_v2(
    db.val,
    CStr::from_string(
      "SELECT id, value, text FROM numbers WHERE id = 1",
    ),
    -1,
    stmt,
    @ref.new(CStr::from_string("")),
  )
  |> ignore
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
  sqlite3_finalize(stmt.val) |> ignore
  sqlite3_close(db.val) |> ignore
}

///|
test "error handling" {
  let db = { val: Sqlite3::init() }
  sqlite3_open(CStr::from_string(":memory:"), db)
  |> ignore

  // execute a bad SQL statement
  let bad_sql = CStr::from_string("INVALID SQL STATEMENT")
  let result = sqlite3_exec(
    db.val,
    bad_sql,
    fn(_data, _cols, _values, _names) { 0 },
    Sqlite3::to_void_ptr(Sqlite3::init()),
    Sqlite3::to_void_ptr(Sqlite3::init()),
  )

  // should return an error
  assert_false(result == SQLITE_OK)

  // obtain error code
  let errcode = sqlite3_errcode(db.val)
  assert_true(errcode == SQLITE_ERROR)

  // obtain error message
  let errmsg_cstr = sqlite3_errmsg(db.val)
  let errmsg = CStr::convert_to_moonbit_string(errmsg_cstr)
  assert_false(errmsg.is_empty())
  sqlite3_close(db.val) |> ignore
}

///|
test "handling different data types" {
  let db = { val: Sqlite3::init() }
  sqlite3_open(CStr::from_string(":memory:"), db)
  |> ignore

  // create a table with various data types
  sqlite3_exec(
    db.val,
    CStr::from_string(
      "CREATE TABLE types_test (int_col INTEGER, real_col REAL, text_col TEXT, blob_col BLOB)",
    ),
    fn(_data, _cols, _values, _names) { 0 },
    Sqlite3::to_void_ptr(Sqlite3::init()),
    Sqlite3::to_void_ptr(Sqlite3::init()),
  )
  |> ignore

  // prepare an insert statement
  let stmt = { val: Sqlite3_stmt::init() }
  sqlite3_prepare_v2(
    db.val,
    CStr::from_string("INSERT INTO types_test VALUES (?, ?, ?, ?)"),
    -1,
    stmt,
    @ref.new(CStr::from_string("")),
  )
  |> ignore

  // bind values of different types
  sqlite3_bind_int64(stmt.val, 1, 42L) |> ignore
  sqlite3_bind_double(stmt.val, 2, 3.14159) |> ignore
  sqlite3_bind_text(
    stmt.val,
    3,
    CStr::from_string("Hello SQLite"),
    -1,
    fn(_ptr) {  },
  )
  |> ignore
  sqlite3_bind_null(stmt.val, 4) |> ignore

  // execute the statement
  assert_true(sqlite3_step(stmt.val) == SQLITE_DONE)
  sqlite3_finalize(stmt.val) |> ignore

  // query the data back
  let select_stmt = { val: Sqlite3_stmt::init() }
  sqlite3_prepare_v2(
    db.val,
    CStr::from_string("SELECT * FROM types_test"),
    -1,
    select_stmt,
    @ref.new(CStr::from_string("")),
  )
  |> ignore
  assert_true(
    sqlite3_step(select_stmt.val) == SQLITE_ROW,
  )

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
  sqlite3_finalize(select_stmt.val) |> ignore
  sqlite3_close(db.val) |> ignore
}
