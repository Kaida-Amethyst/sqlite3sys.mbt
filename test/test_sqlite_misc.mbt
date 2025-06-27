///| Test miscellaneous SQLite functions
test "column metadata and names" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  @sqlite3sys.sqlite3_open(@sqlite3sys.CStr::from_string(":memory:"), db)
  |> ignore
  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string(
      "CREATE TABLE meta_test (id INTEGER PRIMARY KEY, name TEXT NOT NULL, age REAL)",
    ),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  )
  |> ignore
  let stmt = { val: @sqlite3sys.Sqlite3_stmt::init() }
  @sqlite3sys.sqlite3_prepare_v2(
    db.val,
    @sqlite3sys.CStr::from_string("SELECT id, name, age FROM meta_test"),
    -1,
    stmt,
    @ref.new(@sqlite3sys.CStr::from_string("")),
  )
  |> ignore

  // Test column names
  let col0_name = @sqlite3sys.sqlite3_column_name(stmt.val, 0)
  let col0_str = @sqlite3sys.CStr::convert_to_moonbit_string(col0_name)
  assert_true(col0_str == "id")
  let col1_name = @sqlite3sys.sqlite3_column_name(stmt.val, 1)
  let col1_str = @sqlite3sys.CStr::convert_to_moonbit_string(col1_name)
  assert_true(col1_str == "name")
  let col2_name = @sqlite3sys.sqlite3_column_name(stmt.val, 2)
  let col2_str = @sqlite3sys.CStr::convert_to_moonbit_string(col2_name)
  assert_true(col2_str == "age")

  // Test column declared types
  let col0_decltype = @sqlite3sys.sqlite3_column_decltype(stmt.val, 0)
  let col0_type_str = @sqlite3sys.CStr::convert_to_moonbit_string(col0_decltype)
  assert_true(col0_type_str == "INTEGER")
  let col1_decltype = @sqlite3sys.sqlite3_column_decltype(stmt.val, 1)
  let col1_type_str = @sqlite3sys.CStr::convert_to_moonbit_string(col1_decltype)
  assert_true(col1_type_str == "TEXT")
  let col2_decltype = @sqlite3sys.sqlite3_column_decltype(stmt.val, 2)
  let col2_type_str = @sqlite3sys.CStr::convert_to_moonbit_string(col2_decltype)
  assert_true(col2_type_str == "REAL")
  @sqlite3sys.sqlite3_finalize(stmt.val) |> ignore
  @sqlite3sys.sqlite3_close(db.val) |> ignore
}

///| Test database information functions
test "database information" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  @sqlite3sys.sqlite3_open(@sqlite3sys.CStr::from_string(":memory:"), db)
  |> ignore

  // Test threadsafe flag
  let threadsafe = @sqlite3sys.sqlite3_threadsafe()
  assert_true(threadsafe >= 0)

  // Test database name
  let db_name = @sqlite3sys.sqlite3_db_name(db.val, 0)
  let db_name_str = @sqlite3sys.CStr::convert_to_moonbit_string(db_name)
  assert_true(db_name_str == "main")

  // Test getting database handle from database (should be same)
  let autocommit = @sqlite3sys.sqlite3_get_autocommit(db.val)
  assert_true(autocommit == 1) // Should be in autocommit mode initially
  @sqlite3sys.sqlite3_close(db.val) |> ignore
}

///| Test SQL statement utilities
test "SQL statement utilities" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  @sqlite3sys.sqlite3_open(@sqlite3sys.CStr::from_string(":memory:"), db)
  |> ignore
  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string(
      "CREATE TABLE util_test (id INTEGER, name TEXT)",
    ),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  )
  |> ignore
  let stmt = { val: @sqlite3sys.Sqlite3_stmt::init() }
  @sqlite3sys.sqlite3_prepare_v2(
    db.val,
    @sqlite3sys.CStr::from_string("SELECT * FROM util_test WHERE id = ?"),
    -1,
    stmt,
    @ref.new(@sqlite3sys.CStr::from_string("")),
  )
  |> ignore

  // Test getting SQL text
  let sql_text = @sqlite3sys.sqlite3_sql(stmt.val)
  assert_false(@sqlite3sys.CStr::is_nullptr(sql_text))
  let sql_str = @sqlite3sys.CStr::convert_to_moonbit_string(sql_text)
  assert_true(sql_str.contains("SELECT"))

  // Test getting database handle from statement
  let db_handle = @sqlite3sys.sqlite3_db_handle(stmt.val)
  assert_false(@sqlite3sys.Sqlite3::is_nullptr(db_handle))
  @sqlite3sys.sqlite3_finalize(stmt.val) |> ignore
  @sqlite3sys.sqlite3_close(db.val) |> ignore
}

///| Test string comparison functions
test "string comparison functions" {
  // Test case-insensitive string comparison
  let result1 = @sqlite3sys.sqlite3_stricmp(
    @sqlite3sys.CStr::from_string("Hello"),
    @sqlite3sys.CStr::from_string("HELLO"),
  )
  assert_true(result1 == 0) // Should be equal
  let result2 = @sqlite3sys.sqlite3_stricmp(
    @sqlite3sys.CStr::from_string("Hello"),
    @sqlite3sys.CStr::from_string("World"),
  )
  assert_false(result2 == 0) // Should not be equal

  // Test limited case-insensitive comparison
  let result3 = @sqlite3sys.sqlite3_strnicmp(
    @sqlite3sys.CStr::from_string("Hello World"),
    @sqlite3sys.CStr::from_string("HELLO UNIVERSE"),
    5, // Compare only first 5 characters
  )
  assert_true(result3 == 0) // First 5 chars should be equal

  // Test pattern matching
  let glob_result = @sqlite3sys.sqlite3_strglob(
    @sqlite3sys.CStr::from_string("H*"),
    @sqlite3sys.CStr::from_string("Hello"),
  )
  assert_true(glob_result == 0) // Should match
  let like_result = @sqlite3sys.sqlite3_strlike(
    @sqlite3sys.CStr::from_string("H%"),
    @sqlite3sys.CStr::from_string("Hello"),
    0U, // No escape character
  )
  assert_true(like_result == 0) // Should match
}
