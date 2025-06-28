///| Tests for previously unused SQLite functions

///| Verify column metadata helper functions
test "column metadata extras" {
  let db = { val: Sqlite3::init() }
  sqlite3_open(CStr::from_string(":memory:"), db) |> ignore
  sqlite3_exec(
    db.val,
    CStr::from_string("CREATE TABLE t1(id INTEGER PRIMARY KEY, name TEXT)"),
    fn(_d, _c, _v, _n) { 0 },
    Sqlite3::to_void_ptr(Sqlite3::init()),
    Sqlite3::to_void_ptr(Sqlite3::init()),
  )
  |> ignore
  let stmt = { val: Sqlite3_stmt::init() }
  sqlite3_prepare_v2(
    db.val,
    CStr::from_string("SELECT id, name FROM t1"),
    -1,
    stmt,
    @ref.new(CStr::from_string("")),
  )
  |> ignore
  let db_name = sqlite3_column_database_name(stmt.val, 0)
  if not(CStr::is_nullptr(db_name)) {
    let db_str = CStr::convert_to_moonbit_string(db_name)
    assert_true(db_str == "main")
  }
  let table_name = sqlite3_column_table_name(stmt.val, 0)
  if not(CStr::is_nullptr(table_name)) {
    let tab_str = CStr::convert_to_moonbit_string(table_name)
    assert_true(tab_str == "t1")
  }
  let origin_name = sqlite3_column_origin_name(stmt.val, 0)
  if not(CStr::is_nullptr(origin_name)) {
    let origin_str = CStr::convert_to_moonbit_string(origin_name)
    assert_true(origin_str == "id")
  }
  sqlite3_finalize(stmt.val) |> ignore
  sqlite3_close(db.val) |> ignore
}
