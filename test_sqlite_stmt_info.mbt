///| Tests for additional statement-related APIs
test "prepare_v3 and statement inspection" {
  let db = { val: Sqlite3::init() }
  sqlite3_open(CStr::from_string(":memory:"), db) |> ignore
  let stmt = { val: Sqlite3_stmt::init() }
  // prepare statement with two parameters using prepare_v3
  sqlite3_prepare_v3(
    db.val,
    CStr::from_string("SELECT ?1 + ?2"),
    -1,
    0,
    stmt,
    @ref.new(CStr::from_string("")),
  )
  |> ignore

  // bind parameters
  sqlite3_bind_int(stmt.val, 1, 3) |> ignore
  sqlite3_bind_int(stmt.val, 2, 4) |> ignore

  // expanded SQL should contain the bound values
  let expanded = sqlite3_expanded_sql(stmt.val)
  let expanded_str = CStr::convert_to_moonbit_string(expanded)
  assert_true(expanded_str.contains("3"))
  assert_true(expanded_str.contains("4"))

  // readonly query
  let is_ro = sqlite3_stmt_readonly(stmt.val)
  assert_true(is_ro == 1)

  // statement should not be busy before stepping
  assert_true(sqlite3_stmt_busy(stmt.val) == 0)

  // step once, expect a row
  assert_true(sqlite3_step(stmt.val) == SQLITE_ROW)
  assert_true(sqlite3_stmt_busy(stmt.val) == 1)
  // finalize the row
  sqlite3_step(stmt.val) |> ignore
  assert_true(sqlite3_stmt_busy(stmt.val) == 0)
  sqlite3_finalize(stmt.val) |> ignore
  sqlite3_close(db.val) |> ignore
}

///|
test "error string and printf functions" {
  // use error code to get message
  let err = sqlite3_errstr(SQLITE_ERROR)
  let err_str = CStr::convert_to_moonbit_string(err)
  assert_false(err_str.is_empty())

  // check error string formatting
  let err_msg = CStr::convert_to_moonbit_string(sqlite3_errstr(SQLITE_PERM))
  assert_false(err_msg.is_empty())
}

///|
test "status and sleep" {
  let cur_ptr = sqlite3_malloc(8)
  let hi_ptr = sqlite3_malloc(8)
  sqlite3_status64(SQLITE_STATUS_MEMORY_USED, cur_ptr, hi_ptr, 0) |> ignore
  sqlite3_free(cur_ptr)
  sqlite3_free(hi_ptr)
  sqlite3_sleep(10) |> ignore
}
