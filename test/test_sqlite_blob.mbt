///| Test BLOB data handling
test "BLOB data binding and retrieval" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  @sqlite3sys.sqlite3_open(@sqlite3sys.CStr::from_string(":memory:"), db) |> ignore

  // Create table with BLOB column
  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string("CREATE TABLE blob_test (id INTEGER, data BLOB)"),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  ) |> ignore

  // Test just the basic functions for BLOB
  // We'll use a NULL blob for simplicity
  let stmt = { val: @sqlite3sys.Sqlite3_stmt::init() }
  @sqlite3sys.sqlite3_prepare_v2(
    db.val,
    @sqlite3sys.CStr::from_string("INSERT INTO blob_test (id, data) VALUES (?, ?)"),
    -1,
    stmt,
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  ) |> ignore

  // Bind values
  @sqlite3sys.sqlite3_bind_int(stmt.val, 1, 1) |> ignore
  @sqlite3sys.sqlite3_bind_null(stmt.val, 2) |> ignore

  // Execute
  assert_true(@sqlite3sys.sqlite3_step(stmt.val) == @sqlite3sys.SQLITE_DONE)
  @sqlite3sys.sqlite3_finalize(stmt.val) |> ignore

  // Query back the data
  let select_stmt = { val: @sqlite3sys.Sqlite3_stmt::init() }
  @sqlite3sys.sqlite3_prepare_v2(
    db.val,
    @sqlite3sys.CStr::from_string("SELECT id, data FROM blob_test WHERE id = 1"),
    -1,
    select_stmt,
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  ) |> ignore

  assert_true(@sqlite3sys.sqlite3_step(select_stmt.val) == @sqlite3sys.SQLITE_ROW)

  // Check BLOB column functions exist and work
  let blob_bytes = @sqlite3sys.sqlite3_column_bytes(select_stmt.val, 1)
  assert_true(blob_bytes == 0) // NULL blob has 0 bytes

  // Verify column type
  let col_type = @sqlite3sys.sqlite3_column_type(select_stmt.val, 1)
  assert_true(col_type == @sqlite3sys.SQLITE_NULL)

  @sqlite3sys.sqlite3_finalize(select_stmt.val) |> ignore
  @sqlite3sys.sqlite3_close(db.val) |> ignore
}

///| Test BLOB with zero length
test "BLOB zeroblob operations" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  @sqlite3sys.sqlite3_open(@sqlite3sys.CStr::from_string(":memory:"), db) |> ignore

  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string("CREATE TABLE zeroblob_test (id INTEGER, data BLOB)"),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  ) |> ignore

  let stmt = { val: @sqlite3sys.Sqlite3_stmt::init() }
  @sqlite3sys.sqlite3_prepare_v2(
    db.val,
    @sqlite3sys.CStr::from_string("INSERT INTO zeroblob_test (id, data) VALUES (?, ?)"),
    -1,
    stmt,
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  ) |> ignore

  // Bind zeroblob
  @sqlite3sys.sqlite3_bind_int(stmt.val, 1, 2) |> ignore
  let zeroblob_result = @sqlite3sys.sqlite3_bind_zeroblob(stmt.val, 2, 100)
  assert_true(zeroblob_result == @sqlite3sys.SQLITE_OK)

  assert_true(@sqlite3sys.sqlite3_step(stmt.val) == @sqlite3sys.SQLITE_DONE)
  @sqlite3sys.sqlite3_finalize(stmt.val) |> ignore

  // Query the zeroblob
  let select_stmt = { val: @sqlite3sys.Sqlite3_stmt::init() }
  @sqlite3sys.sqlite3_prepare_v2(
    db.val,
    @sqlite3sys.CStr::from_string("SELECT data FROM zeroblob_test WHERE id = 2"),
    -1,
    select_stmt,
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  ) |> ignore

  assert_true(@sqlite3sys.sqlite3_step(select_stmt.val) == @sqlite3sys.SQLITE_ROW)
  
  let blob_size = @sqlite3sys.sqlite3_column_bytes(select_stmt.val, 0)
  assert_true(blob_size == 100)

  @sqlite3sys.sqlite3_finalize(select_stmt.val) |> ignore
  @sqlite3sys.sqlite3_close(db.val) |> ignore
}

///| Test BLOB operations with sqlite3_blob_* functions
test "BLOB incremental I/O" {
  let db = { val: @sqlite3sys.Sqlite3::init() }
  @sqlite3sys.sqlite3_open(@sqlite3sys.CStr::from_string(":memory:"), db) |> ignore

  // Create table and insert a row with BLOB
  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string("CREATE TABLE blob_io_test (id INTEGER PRIMARY KEY, data BLOB)"),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  ) |> ignore

  @sqlite3sys.sqlite3_exec(
    db.val,
    @sqlite3sys.CStr::from_string("INSERT INTO blob_io_test (data) VALUES (zeroblob(50))"),
    fn(_data, _cols, _values, _names) { 0 },
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
    @sqlite3sys.Sqlite3::to_void_ptr(@sqlite3sys.Sqlite3::init()),
  ) |> ignore

  // Open BLOB for writing
  let blob_handle = { val: @sqlite3sys.Sqlite3_blob::init() }
  let open_result = @sqlite3sys.sqlite3_blob_open(
    db.val,
    @sqlite3sys.CStr::from_string("main"),
    @sqlite3sys.CStr::from_string("blob_io_test"),
    @sqlite3sys.CStr::from_string("data"),
    1L, // rowid
    1,  // flags: 1 for write, 0 for read
    blob_handle
  )
  assert_true(open_result == @sqlite3sys.SQLITE_OK)
  assert_false(@sqlite3sys.Sqlite3_blob::is_nullptr(blob_handle.val))

  // Check BLOB size
  let blob_size = @sqlite3sys.sqlite3_blob_bytes(blob_handle.val)
  assert_true(blob_size == 50)

  // Write some data - use malloc for proper pointer
  let write_data = @sqlite3sys.sqlite3_malloc(10)
  let write_result = @sqlite3sys.sqlite3_blob_write(
    blob_handle.val,
    write_data,
    9, // write 9 bytes
    0  // offset
  )
  assert_true(write_result == @sqlite3sys.SQLITE_OK)

  // Close BLOB handle
  let close_result = @sqlite3sys.sqlite3_blob_close(blob_handle.val)
  assert_true(close_result == @sqlite3sys.SQLITE_OK)

  // Now read back the data using another BLOB handle
  let read_blob_handle = { val: @sqlite3sys.Sqlite3_blob::init() }
  let read_open_result = @sqlite3sys.sqlite3_blob_open(
    db.val,
    @sqlite3sys.CStr::from_string("main"),
    @sqlite3sys.CStr::from_string("blob_io_test"),
    @sqlite3sys.CStr::from_string("data"),
    1L, // rowid
    0,  // flags: 0 for read
    read_blob_handle
  )
  assert_true(read_open_result == @sqlite3sys.SQLITE_OK)

  // Read data back (we'll just verify we can call the function)
  let read_buffer = @sqlite3sys.sqlite3_malloc(10)
  let read_result = @sqlite3sys.sqlite3_blob_read(
    read_blob_handle.val,
    read_buffer,
    9, // bytes to read
    0  // offset
  )
  assert_true(read_result == @sqlite3sys.SQLITE_OK)

  // Free the buffer
  @sqlite3sys.sqlite3_free(read_buffer)

  // Close read handle
  @sqlite3sys.sqlite3_blob_close(read_blob_handle.val) |> ignore
  @sqlite3sys.sqlite3_close(db.val) |> ignore
} 