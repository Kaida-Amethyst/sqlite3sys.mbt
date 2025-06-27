///| Additional tests for untested SQLite functions
test "memory allocation tracking" {
  // Check current memory usage and allocate a small buffer
  let before = @sqlite3sys.sqlite3_memory_used()
  let ptr = @sqlite3sys.sqlite3_malloc(128)
  let ptr_check = @sqlite3sys.Sqlite3::from_void_ptr(ptr)
  assert_false(@sqlite3sys.Sqlite3::is_nullptr(ptr_check))
  let after_alloc = @sqlite3sys.sqlite3_memory_used()
  assert_true(after_alloc >= before)
  @sqlite3sys.sqlite3_free(ptr)
  let high = @sqlite3sys.sqlite3_memory_highwater(0)
  assert_true(high >= after_alloc)
}

///|
test "sqlite3_str utilities" {
  let s = @sqlite3sys.sqlite3_str_new(@sqlite3sys.Sqlite3::init())
  assert_false(@sqlite3sys.Sqlite3_str::is_nullptr(s))
  @sqlite3sys.sqlite3_str_append(s, @sqlite3sys.CStr::from_string("hello"), 5)
  @sqlite3sys.sqlite3_str_appendchar(s, 1, 32)
  @sqlite3sys.sqlite3_str_appendall(s, @sqlite3sys.CStr::from_string("world"))
  let len = @sqlite3sys.sqlite3_str_length(s)
  assert_true(len == 11)
  let value_cstr = @sqlite3sys.sqlite3_str_value(s)
  let value = @sqlite3sys.CStr::convert_to_moonbit_string(value_cstr)
  assert_true(value == "hello world")
  let finished = @sqlite3sys.sqlite3_str_finish(s)
  let final_str = @sqlite3sys.CStr::convert_to_moonbit_string(finished)
  assert_true(final_str == "hello world")
}

///|
test "file open and filename helpers" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  let path = "test_filename.db"
  let rc = @sqlite3sys.sqlite3_open(@sqlite3sys.CStr::from_string(path), db)
  assert_true(rc == @sqlite3sys.SQLITE_OK)
  let fname = @sqlite3sys.sqlite3_db_filename(
    db.val,
    @sqlite3sys.CStr::from_string("main"),
  )
  assert_false(@sqlite3sys.Sqlite3_filename::is_nullptr(fname))
  let base = @sqlite3sys.sqlite3_filename_database(fname)
  let base_str = @sqlite3sys.CStr::convert_to_moonbit_string(base)
  assert_true(base_str.contains(path))
  let journal = @sqlite3sys.sqlite3_filename_journal(fname)
  assert_false(@sqlite3sys.CStr::is_nullptr(journal))
  let wal = @sqlite3sys.sqlite3_filename_wal(fname)
  assert_false(@sqlite3sys.CStr::is_nullptr(wal))
  @sqlite3sys.sqlite3_close(db.val) |> ignore
}

///|
test "busy timeout setting" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  @sqlite3sys.sqlite3_open(@sqlite3sys.CStr::from_string(":memory:"), db)
  |> ignore
  let rc = @sqlite3sys.sqlite3_busy_timeout(db.val, 1000)
  assert_true(rc == @sqlite3sys.SQLITE_OK)
  @sqlite3sys.sqlite3_close(db.val) |> ignore
}
