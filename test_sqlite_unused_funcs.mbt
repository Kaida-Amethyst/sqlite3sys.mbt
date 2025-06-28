///| Test unused SQLite APIs
test "randomness and prepare" {
  let db = { val: Sqlite3::init() }
  sqlite3_open(CStr::from_string(":memory:"), db) |> ignore
  let stmt = { val: Sqlite3_stmt::init() }
  let rc = sqlite3_prepare(
    db.val,
    CStr::from_string("CREATE TABLE t(x INT)"),
    -1,
    stmt,
    @ref.new(CStr::from_string("")),
  )
  assert_true(rc == SQLITE_OK)
  assert_true(sqlite3_step(stmt.val) == SQLITE_DONE)
  sqlite3_finalize(stmt.val) |> ignore
  let rand_buf = sqlite3_malloc(8)
  sqlite3_randomness(8, rand_buf)
  sqlite3_free(rand_buf)
  sqlite3_close(db.val) |> ignore
}
