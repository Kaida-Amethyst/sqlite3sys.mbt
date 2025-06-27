///| Test transaction operations and database state
test "basic transaction operations" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  @sqlite3sys.sqlite3_open(@sqlite3sys.CStr::from_string(":memory:"), db) |> ignore

  // Create a test table
  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string("CREATE TABLE transaction_test (id INTEGER, value TEXT)"),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  ) |> ignore

  // Check autocommit mode (should be 1 initially)
  let autocommit = @sqlite3sys.sqlite3_get_autocommit(db.val)
  assert_true(autocommit == 1)

  // Begin transaction
  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string("BEGIN TRANSACTION"),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  ) |> ignore

  // Check autocommit mode (should be 0 in transaction)
  let autocommit_in_transaction = @sqlite3sys.sqlite3_get_autocommit(db.val)
  assert_true(autocommit_in_transaction == 0)

  // Insert some data
  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string("INSERT INTO transaction_test (id, value) VALUES (1, 'test')"),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  ) |> ignore

  // Check changes
  let changes = @sqlite3sys.sqlite3_changes(db.val)
  assert_true(changes == 1)

  // Check total changes
  let total_changes = @sqlite3sys.sqlite3_total_changes(db.val)
  assert_true(total_changes >= 1)

  // Commit transaction
  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string("COMMIT"),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  ) |> ignore

  // Check autocommit mode (should be 1 again after commit)
  let autocommit_after = @sqlite3sys.sqlite3_get_autocommit(db.val)
  assert_true(autocommit_after == 1)

  @sqlite3sys.sqlite3_close(db.val) |> ignore
}

///| Test last insert rowid
test "last insert rowid tracking" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  @sqlite3sys.sqlite3_open(@sqlite3sys.CStr::from_string(":memory:"), db) |> ignore

  // Create table with auto-increment primary key
  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string("CREATE TABLE rowid_test (id INTEGER PRIMARY KEY, name TEXT)"),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  ) |> ignore

  // Insert first record
  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string("INSERT INTO rowid_test (name) VALUES ('first')"),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  ) |> ignore

  // Check last insert rowid
  let rowid1 = @sqlite3sys.sqlite3_last_insert_rowid(db.val)
  assert_true(rowid1 == 1L)

  // Insert second record
  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string("INSERT INTO rowid_test (name) VALUES ('second')"),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  ) |> ignore

  let rowid2 = @sqlite3sys.sqlite3_last_insert_rowid(db.val)
  assert_true(rowid2 == 2L)

  // Test setting last insert rowid
  @sqlite3sys.sqlite3_set_last_insert_rowid(db.val, 100L)
  let rowid_after_set = @sqlite3sys.sqlite3_last_insert_rowid(db.val)
  assert_true(rowid_after_set == 100L)

  @sqlite3sys.sqlite3_close(db.val) |> ignore
}

///| Test changes and total changes counters
test "changes tracking" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  @sqlite3sys.sqlite3_open(@sqlite3sys.CStr::from_string(":memory:"), db) |> ignore

  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string("CREATE TABLE changes_test (id INTEGER, value TEXT)"),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  ) |> ignore

  // Insert multiple records
  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string("INSERT INTO changes_test VALUES (1, 'one'), (2, 'two'), (3, 'three')"),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  ) |> ignore

  // Check changes (should be 3 for the INSERT)
  let changes_after_insert = @sqlite3sys.sqlite3_changes(db.val)
  assert_true(changes_after_insert == 3)

  // Test 64-bit versions of functions
  let changes64 = @sqlite3sys.sqlite3_changes64(db.val)
  assert_true(changes64 == 3L)

  let total_changes64 = @sqlite3sys.sqlite3_total_changes64(db.val)
  assert_true(total_changes64 >= 3L)

  // Update some records
  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string("UPDATE changes_test SET value = 'updated' WHERE id <= 2"),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  ) |> ignore

  // Check changes (should be 2 for the UPDATE)
  let changes_after_update = @sqlite3sys.sqlite3_changes(db.val)
  assert_true(changes_after_update == 2)

  @sqlite3sys.sqlite3_close(db.val) |> ignore
} 