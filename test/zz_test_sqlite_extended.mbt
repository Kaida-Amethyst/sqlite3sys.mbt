///| Additional tests for untested APIs

// Test additional APIs including limits, randomness, sleep, and
// statement inspection functions like sqlite3_stmt_busy/readonly/status

test "randomness limit and sleep" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  @sqlite3sys.sqlite3_open(@sqlite3sys.CStr::from_string(":memory:"), db)
  |> ignore

  // sqlite3_randomness fills a buffer
  let buf = @sqlite3sys.sqlite3_malloc(8)
  @sqlite3sys.sqlite3_randomness(8, buf)
  // just ensure msize reports at least 8 bytes allocated
  let size = @sqlite3sys.sqlite3_msize(buf)
  assert_true(size >= 8)
  @sqlite3sys.sqlite3_free(buf)

  // sqlite3_limit can get current limit
  let old = @sqlite3sys.sqlite3_limit(
    db.val,
    @sqlite3sys.SQLITE_LIMIT_LENGTH,
    -1,
  )
  assert_true(old > 0)

  // sqlite3_sleep should return the amount slept (ms)
  let slept = @sqlite3sys.sqlite3_sleep(1)
  assert_true(slept >= 0)
  @sqlite3sys.sqlite3_close(db.val) |> ignore
}

///|
test "statement busy readonly status" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  @sqlite3sys.sqlite3_open(@sqlite3sys.CStr::from_string(":memory:"), db)
  |> ignore
  let stmt = { val: @sqlite3sys.Sqlite3_stmt::init() }
  @sqlite3sys.sqlite3_prepare_v2(
    db.val,
    @sqlite3sys.CStr::from_string("SELECT 1"),
    -1,
    stmt,
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  )
  |> ignore

  // before stepping, statement not busy
  let busy0 = @sqlite3sys.sqlite3_stmt_busy(stmt.val)
  assert_true(busy0 == 0)
  assert_true(@sqlite3sys.sqlite3_stmt_readonly(stmt.val) == 1)
  let step_rc = @sqlite3sys.sqlite3_step(stmt.val)
  assert_true(step_rc == @sqlite3sys.SQLITE_ROW)

  // now the statement should be busy
  let busy1 = @sqlite3sys.sqlite3_stmt_busy(stmt.val)
  assert_true(busy1 == 1)

  // step again to finish
  @sqlite3sys.sqlite3_step(stmt.val) |> ignore
  let runs = @sqlite3sys.sqlite3_stmt_status(
    stmt.val,
    @sqlite3sys.SQLITE_STMTSTATUS_RUN,
    0,
  )
  assert_true(runs == 1)
  @sqlite3sys.sqlite3_finalize(stmt.val) |> ignore
  @sqlite3sys.sqlite3_close(db.val) |> ignore
}
