///| Additional tests for unused SQLite functions
test "statement metadata retrieval" {
  let db = { val: Sqlite3::init() }
  sqlite3_open(CStr::from_string(":memory:"), db) |> ignore
  sqlite3_exec(
    db.val,
    CStr::from_string("CREATE TABLE meta(id INTEGER, name TEXT)"),
    fn(_d, _c, _v, _n) { 0 },
    Sqlite3::to_void_ptr(Sqlite3::init()),
    Sqlite3::to_void_ptr(Sqlite3::init()),
  )
  |> ignore
  let stmt = { val: Sqlite3_stmt::init() }
  sqlite3_prepare_v2(
    db.val,
    CStr::from_string("SELECT id, name FROM meta"),
    -1,
    stmt,
    @ref.new(CStr::from_string("")),
  )
  |> ignore
  let dbname = sqlite3_column_database_name(stmt.val, 0)
  let dbname_str = CStr::convert_to_moonbit_string(dbname)
  assert_true(dbname_str == "main")
  let tabname = sqlite3_column_table_name(stmt.val, 0)
  let tabname_str = CStr::convert_to_moonbit_string(tabname)
  assert_true(tabname_str == "meta")
  let origin = sqlite3_column_origin_name(stmt.val, 0)
  let origin_str = CStr::convert_to_moonbit_string(origin)
  assert_true(origin_str == "id")
  sqlite3_finalize(stmt.val) |> ignore
  sqlite3_close(db.val) |> ignore
}

///|
test "string utilities and mprintf" {
  // sqlite3_mprintf
  let mp = sqlite3_mprintf(CStr::from_string("hello"))
  let mp_str = CStr::convert_to_moonbit_string(mp)
  assert_true(mp_str == "hello")
  // free is skipped as conversion utilities are not available

  // sqlite3_snprintf
  let buf = CStr::from_string("....................")
  ignore(sqlite3_snprintf(20, buf, CStr::from_string("hi")))
  let buf_str = CStr::convert_to_moonbit_string(buf)
  assert_true(buf_str.has_prefix("hi"))

  // sqlite3_vmprintf and vsnprintf
  let vm = sqlite3_vmprintf(CStr::from_string("test"), 0)
  assert_false(CStr::is_nullptr(vm))
  let buf2 = CStr::from_string("....................")
  ignore(sqlite3_vsnprintf(20, buf2, CStr::from_string("done"), 0))
  let vs = CStr::convert_to_moonbit_string(buf2)
  assert_true(vs.has_prefix("done"))
}

///|
test "sqlite3_str advanced" {
  let s = sqlite3_str_new(Sqlite3::init())
  sqlite3_str_appendf(s, CStr::from_string("abc"))
  let err = sqlite3_str_errcode(s)
  assert_true(err == SQLITE_OK)
  sqlite3_str_reset(s)
  sqlite3_str_vappendf(s, CStr::from_string("xyz"), 0)
  let len = sqlite3_str_length(s)
  assert_true(len == 3)
  let finished = sqlite3_str_finish(s)
  let final_str = CStr::convert_to_moonbit_string(finished)
  assert_true(final_str == "xyz")
}

///|
test "extra helpers" {
  let s = CStr::from_string("abcdef")
  let full = CStr::convert_to_moonbit_string(s)
  let part = full.substring(start=0, end=3)
  assert_true(part == "abc")
  let err_msg = sqlite3_errstr(SQLITE_ERROR)
  assert_false(CStr::is_nullptr(err_msg))
}
