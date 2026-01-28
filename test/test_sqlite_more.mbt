///| Additional tests for previously-untested SQLite functions
test "error string and completion" {
  let msg_cstr = @sqlite3sys.sqlite3_errstr(@sqlite3sys.SQLITE_BUSY)
  let msg = @sqlite3sys.CStr::convert_to_moonbit_string(msg_cstr)
  assert_false(msg.is_empty())
  let complete_ok = @sqlite3sys.sqlite3_complete(
    @sqlite3sys.CStr::from_string("SELECT 1;"),
  )
  assert_true(complete_ok == 1)
  let complete_bad = @sqlite3sys.sqlite3_complete(
    @sqlite3sys.CStr::from_string("SELECT 1"),
  )
  assert_true(complete_bad == 0)
}

///|
test "randomness and sleep" {
  let buf = @sqlite3sys.sqlite3_malloc(8)
  assert_false(
    @sqlite3sys.Sqlite3::is_nullptr(@sqlite3sys.Sqlite3::from_void_ptr(buf)),
  )
  @sqlite3sys.sqlite3_randomness(8, buf)
  let sleep_result = @sqlite3sys.sqlite3_sleep(1)
  assert_true(sleep_result >= 0)
  @sqlite3sys.sqlite3_free(buf)
}

///|
test "keyword lookup utilities" {
  let count = @sqlite3sys.sqlite3_keyword_count()
  assert_true(count > 0)
  let name_ref = { val: @sqlite3sys.CStr::from_string(" ") }
  let len_ref = { val: 0 }
  let rc = @sqlite3sys.sqlite3_keyword_name(0, name_ref, len_ref)
  assert_true(rc == 0)
  assert_true(len_ref.val > 0)
  assert_false(@sqlite3sys.CStr::is_nullptr(name_ref.val))
}
