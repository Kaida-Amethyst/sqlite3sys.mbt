///| Additional tests for previously untested functions

///| Test OS initialization and randomness
test "os init and randomness" {
  let rc_init = @sqlite3sys.sqlite3_os_init()
  assert_true(rc_init == @sqlite3sys.SQLITE_OK)
  let ptr = @sqlite3sys.sqlite3_malloc(16)
  let check_ptr = @sqlite3sys.Sqlite3::from_void_ptr(ptr)
  assert_false(@sqlite3sys.Sqlite3::is_nullptr(check_ptr))
  @sqlite3sys.sqlite3_randomness(16, ptr)
  @sqlite3sys.sqlite3_free(ptr)
  let rc_end = @sqlite3sys.sqlite3_os_end()
  assert_true(rc_end == @sqlite3sys.SQLITE_OK)
}

///| Test mutex allocation and locking
test "mutex basic operations" {
  let mutex = @sqlite3sys.sqlite3_mutex_alloc(@sqlite3sys.SQLITE_MUTEX_FAST)
  assert_false(@sqlite3sys.Sqlite3_mutex::is_nullptr(mutex))
  let try_rc = @sqlite3sys.sqlite3_mutex_try(mutex)
  assert_true(try_rc == @sqlite3sys.SQLITE_OK)
  @sqlite3sys.sqlite3_mutex_leave(mutex)
  @sqlite3sys.sqlite3_mutex_free(mutex)
}

///| Test interrupt and progress handler
test "interrupt and progress handler" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  let rc = @sqlite3sys.sqlite3_open(
    @sqlite3sys.CStr::from_string(":memory:"),
    db,
  )
  assert_true(rc == @sqlite3sys.SQLITE_OK)
  @sqlite3sys.sqlite3_progress_handler(
    db.val,
    1,
    fn(_arg : @sqlite3sys.AnyType) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  )
  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string("CREATE TABLE ph(id INTEGER);"),
    fn(_d, _c, _v, _n) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  )
  |> ignore
  @sqlite3sys.sqlite3_progress_handler(
    db.val,
    0,
    fn(_arg : @sqlite3sys.AnyType) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  )
  @sqlite3sys.sqlite3_interrupt(db.val)
  assert_true(@sqlite3sys.sqlite3_is_interrupted(db.val) != 0)
  @sqlite3sys.sqlite3_close(db.val) |> ignore
}
