///| Additional tests for untested SQLite functions
test "memory allocation tracking" {
  // Check current memory usage and allocate a small buffer
  let before = sqlite3_memory_used()
  let ptr = sqlite3_malloc(128)
  let ptr_check = Sqlite3::from_void_ptr(ptr)
  assert_false(Sqlite3::is_nullptr(ptr_check))
  let after_alloc = sqlite3_memory_used()
  assert_true(after_alloc >= before)
  sqlite3_free(ptr)
  let high = sqlite3_memory_highwater(0)
  assert_true(high >= after_alloc)
}

///|
test "sqlite3_str utilities" {
  let s = sqlite3_str_new(Sqlite3::init())
  assert_false(Sqlite3_str::is_nullptr(s))
  sqlite3_str_append(s, CStr::from_string("hello"), 5)
  sqlite3_str_appendchar(s, 1, 32)
  sqlite3_str_appendall(s, CStr::from_string("world"))
  let len = sqlite3_str_length(s)
  assert_true(len == 11)
  let value_cstr = sqlite3_str_value(s)
  let value = CStr::convert_to_moonbit_string(value_cstr)
  assert_true(value == "hello world")
  let finished = sqlite3_str_finish(s)
  let final_str = CStr::convert_to_moonbit_string(finished)
  assert_true(final_str == "hello world")
}

///|
test "file open and filename helpers" {
  let db = { val: Sqlite3::init() }
  let path = "test_filename.db"
  let rc = sqlite3_open(CStr::from_string(path), db)
  assert_true(rc == SQLITE_OK)
  let fname = sqlite3_db_filename(
    db.val,
    CStr::from_string("main"),
  )
  assert_false(Sqlite3_filename::is_nullptr(fname))
  let base = sqlite3_filename_database(fname)
  let base_str = CStr::convert_to_moonbit_string(base)
  assert_true(base_str.contains(path))
  let journal = sqlite3_filename_journal(fname)
  assert_false(CStr::is_nullptr(journal))
  let wal = sqlite3_filename_wal(fname)
  assert_false(CStr::is_nullptr(wal))
  sqlite3_close(db.val) |> ignore
}

///|
test "busy timeout setting" {
  let db = { val: Sqlite3::init() }
  sqlite3_open(CStr::from_string(":memory:"), db)
  |> ignore
  let rc = sqlite3_busy_timeout(db.val, 1000)
  assert_true(rc == SQLITE_OK)
  sqlite3_close(db.val) |> ignore
}
