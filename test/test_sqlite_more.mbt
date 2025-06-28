///| Tests for additional SQLite APIs

///| Test mutex operations
test "mutex operations" {
  let mutex = @sqlite3sys.sqlite3_mutex_alloc(0)
  assert_false(@sqlite3sys.Sqlite3_mutex::is_nullptr(mutex))
  @sqlite3sys.sqlite3_mutex_enter(mutex)
  let try_busy = @sqlite3sys.sqlite3_mutex_try(mutex)
  assert_true(try_busy == @sqlite3sys.SQLITE_BUSY)
  @sqlite3sys.sqlite3_mutex_leave(mutex)
  @sqlite3sys.sqlite3_mutex_free(mutex)
}

///| Test formatting and utility functions
test "formatting and misc" {
  let msg_ptr = @sqlite3sys.sqlite3_mprintf(
    @sqlite3sys.CStr::from_string("hello"),
  )
  let msg = @sqlite3sys.CStr::convert_to_moonbit_string(msg_ptr)
  assert_true(msg == "hello")
  let err = @sqlite3sys.sqlite3_errstr(@sqlite3sys.SQLITE_ERROR)
  let err_msg = @sqlite3sys.CStr::convert_to_moonbit_string(err)
  assert_false(err_msg.is_empty())
  let buf = @sqlite3sys.sqlite3_malloc(16)
  @sqlite3sys.sqlite3_randomness(16, buf)
  @sqlite3sys.sqlite3_free(buf)
  let sleep_res = @sqlite3sys.sqlite3_sleep(1)
  assert_true(sleep_res >= 0)
}

///| Test heap limits and connection limits
test "heap and limits" {
  let current = @sqlite3sys.sqlite3_soft_heap_limit64(0L)
  let prev = @sqlite3sys.sqlite3_soft_heap_limit64(current)
  assert_true(prev >= 0L)
  let db = { val: @sqlite3sys.Sqlite3::init() }
  @sqlite3sys.sqlite3_open(@sqlite3sys.CStr::from_string(":memory:"), db)
  |> ignore
  let original = @sqlite3sys.sqlite3_limit(
    db.val,
    @sqlite3sys.SQLITE_LIMIT_LENGTH,
    100000,
  )
  let restored = @sqlite3sys.sqlite3_limit(
    db.val,
    @sqlite3sys.SQLITE_LIMIT_LENGTH,
    original,
  )
  assert_true(restored == 100000)
  @sqlite3sys.sqlite3_close(db.val) |> ignore
}
