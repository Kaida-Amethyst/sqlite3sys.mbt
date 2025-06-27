///|
type Sqlite3 // sqlite*

///|
type Sqlite3_stmt // sqlite3_stmt*

///|
type Sqlite3_context // sqlite3_context*

///|
type Sqlite3_backup // sqlite3_backup*

///|
type Sqlite3_str // sqlite3_str*

///|
type Sqlite3_value // sqlite3_value*

///|
type Sqlite3_blob // sqlite3_blob*

///|
type Sqlite3_mutex // sqlite3_mutex*

///|
type Sqlite3_vfs // sqlite3_vfs*

///|
type Sqlite3_file // sqlite3_file*

///|
type Sqlite3_filename // sqlite3_filename

///|
type Sqlite3_snapshot // sqlite3_snapshot*

///|
type Sqlite3_index_info // sqlite3_index_info*

///|
type Sqlite3_module // sqlite3_module*

///|
type CStr // char*

///|
type AnyType // void*

///|
pub extern "C" fn Sqlite3::is_nullptr(ptr : Sqlite3) -> Bool = "is_nullptr"

///|
pub extern "C" fn Sqlite3_stmt::is_nullptr(ptr : Sqlite3_stmt) -> Bool = "is_nullptr"

///|
pub extern "C" fn Sqlite3_context::is_nullptr(ptr : Sqlite3_context) -> Bool = "is_nullptr"

///|
pub extern "C" fn Sqlite3_backup::is_nullptr(ptr : Sqlite3_backup) -> Bool = "is_nullptr"

///|
pub extern "C" fn Sqlite3_str::is_nullptr(ptr : Sqlite3_str) -> Bool = "is_nullptr"

///|
pub extern "C" fn Sqlite3_value::is_nullptr(ptr : Sqlite3_value) -> Bool = "is_nullptr"

///|
pub extern "C" fn Sqlite3_blob::is_nullptr(ptr : Sqlite3_blob) -> Bool = "is_nullptr"

///|
pub extern "C" fn Sqlite3_mutex::is_nullptr(ptr : Sqlite3_mutex) -> Bool = "is_nullptr"

///|
pub extern "C" fn Sqlite3_vfs::is_nullptr(ptr : Sqlite3_vfs) -> Bool = "is_nullptr"

///|
pub extern "C" fn Sqlite3_file::is_nullptr(ptr : Sqlite3_file) -> Bool = "is_nullptr"

///|
pub extern "C" fn Sqlite3_filename::is_nullptr(ptr : Sqlite3_filename) -> Bool = "is_nullptr"

///|
pub extern "C" fn Sqlite3_snapshot::is_nullptr(ptr : Sqlite3_snapshot) -> Bool = "is_nullptr"

///|
pub extern "C" fn Sqlite3_index_info::is_nullptr(
  ptr : Sqlite3_index_info
) -> Bool = "is_nullptr"

///|
pub extern "C" fn Sqlite3_module::is_nullptr(ptr : Sqlite3_module) -> Bool = "is_nullptr"

///|
pub extern "C" fn CStr::is_nullptr(ptr : CStr) -> Bool = "is_nullptr"

///|
pub extern "C" fn Sqlite3::init() -> Sqlite3 = "sqlite3_ptr_init"

///|
pub extern "C" fn Sqlite3::to_void_ptr(ptr : Sqlite3) -> AnyType = "sqlite3_ptr_to_void_ptr"

///|
pub extern "C" fn Sqlite3::from_void_ptr(ptr : AnyType) -> Sqlite3 = "sqlite3_ptr_from_void_ptr"

///|
pub extern "C" fn Sqlite3_stmt::init() -> Sqlite3_stmt = "sqlite3_stmt_ptr_init"

///|
pub extern "C" fn Sqlite3_stmt::from_void_ptr(ptr : AnyType) -> Sqlite3_stmt = "sqlite3_stmt_ptr_from_void_ptr"

///|
pub extern "C" fn Sqlite3_stmt::to_void_ptr(ptr : Sqlite3_stmt) -> AnyType = "sqlite3_stmt_ptr_to_void_ptr"

///|
pub extern "C" fn Sqlite3_context::init() -> Sqlite3_context = "sqlite3_context_ptr_init"

///|
pub extern "C" fn Sqlite3_context::from_void_ptr(
  ptr : AnyType
) -> Sqlite3_context = "sqlite3_context_ptr_from_void_ptr"

///|
pub extern "C" fn Sqlite3_context::to_void_ptr(
  ptr : Sqlite3_context
) -> AnyType = "sqlite3_context_ptr_to_void_ptr"

///|
pub extern "C" fn Sqlite3_backup::init() -> Sqlite3_backup = "sqlite3_backup_ptr_init"

///|
pub extern "C" fn Sqlite3_backup::from_void_ptr(
  ptr : AnyType
) -> Sqlite3_backup = "sqlite3_backup_ptr_from_void_ptr"

///|
pub extern "C" fn Sqlite3_backup::to_void_ptr(ptr : Sqlite3_backup) -> AnyType = "sqlite3_backup_ptr_to_void_ptr"

///|
pub extern "C" fn Sqlite3_str::init() -> Sqlite3_str = "sqlite3_str_ptr_init"

///|
pub extern "C" fn Sqlite3_str::from_void_ptr(ptr : AnyType) -> Sqlite3_str = "sqlite3_str_ptr_from_void_ptr"

///|
pub extern "C" fn Sqlite3_str::to_void_ptr(ptr : Sqlite3_str) -> AnyType = "sqlite3_str_ptr_to_void_ptr"

///|
pub extern "C" fn Sqlite3_value::init() -> Sqlite3_value = "sqlite3_value_ptr_init"

///|
pub extern "C" fn Sqlite3_value::from_void_ptr(ptr : AnyType) -> Sqlite3_value = "sqlite3_value_ptr_from_void_ptr"

///|
pub extern "C" fn Sqlite3_value::to_void_ptr(ptr : Sqlite3_value) -> AnyType = "sqlite3_value_ptr_to_void_ptr"

///|
pub extern "C" fn Sqlite3_blob::init() -> Sqlite3_blob = "sqlite3_blob_ptr_init"

///|
pub extern "C" fn Sqlite3_blob::from_void_ptr(ptr : AnyType) -> Sqlite3_blob = "sqlite3_blob_ptr_from_void_ptr"

///|
pub extern "C" fn Sqlite3_blob::to_void_ptr(ptr : Sqlite3_blob) -> AnyType = "sqlite3_blob_ptr_to_void_ptr"

///|
pub extern "C" fn Sqlite3_mutex::init() -> Sqlite3_mutex = "sqlite3_mutex_ptr_init"

///|
pub extern "C" fn Sqlite3_mutex::from_void_ptr(ptr : AnyType) -> Sqlite3_mutex = "sqlite3_mutex_ptr_from_void_ptr"

///|
pub extern "C" fn Sqlite3_mutex::to_void_ptr(ptr : Sqlite3_mutex) -> AnyType = "sqlite3_mutex_ptr_to_void_ptr"

///|
pub extern "C" fn Sqlite3_vfs::init() -> Sqlite3_vfs = "sqlite3_vfs_ptr_init"

///|
pub extern "C" fn Sqlite3_vfs::from_void_ptr(ptr : AnyType) -> Sqlite3_vfs = "sqlite3_vfs_ptr_from_void_ptr"

///|
pub extern "C" fn Sqlite3_vfs::to_void_ptr(ptr : Sqlite3_vfs) -> AnyType = "sqlite3_vfs_ptr_to_void_ptr"

///|
pub extern "C" fn Sqlite3_file::init() -> Sqlite3_file = "sqlite3_file_ptr_init"

///|
pub extern "C" fn Sqlite3_file::from_void_ptr(ptr : AnyType) -> Sqlite3_file = "sqlite3_file_ptr_from_void_ptr"

///|
pub extern "C" fn Sqlite3_file::to_void_ptr(ptr : Sqlite3_file) -> AnyType = "sqlite3_file_ptr_to_void_ptr"

///|
pub extern "C" fn Sqlite3_filename::init() -> Sqlite3_filename = "sqlite3_filename_ptr_init"

///|
pub extern "C" fn Sqlite3_filename::from_void_ptr(
  ptr : AnyType
) -> Sqlite3_filename = "sqlite3_filename_ptr_from_void_ptr"

///|
pub extern "C" fn Sqlite3_filename::to_void_ptr(
  ptr : Sqlite3_filename
) -> AnyType = "sqlite3_filename_ptr_to_void_ptr"

///|
pub extern "C" fn Sqlite3_snapshot::init() -> Sqlite3_snapshot = "sqlite3_snapshot_ptr_init"

///|
pub extern "C" fn Sqlite3_snapshot::from_void_ptr(
  ptr : AnyType
) -> Sqlite3_snapshot = "sqlite3_snapshot_ptr_from_void_ptr"

///|
pub extern "C" fn Sqlite3_snapshot::to_void_ptr(
  ptr : Sqlite3_snapshot
) -> AnyType = "sqlite3_snapshot_ptr_to_void_ptr"

///|
pub extern "C" fn Sqlite3_index_info::init() -> Sqlite3_index_info = "sqlite3_index_info_ptr_init"

///|
pub extern "C" fn Sqlite3_index_info::from_void_ptr(
  ptr : AnyType
) -> Sqlite3_index_info = "sqlite3_index_info_ptr_from_void_ptr"

///|
pub extern "C" fn Sqlite3_index_info::to_void_ptr(
  ptr : Sqlite3_index_info
) -> AnyType = "sqlite3_index_info_ptr_to_void_ptr"

///|
pub extern "C" fn Sqlite3_module::init() -> Sqlite3_module = "sqlite3_module_ptr_init"

///|
pub extern "C" fn Sqlite3_module::to_void_ptr(ptr : Sqlite3_module) -> AnyType = "sqlite3_module_ptr_to_void_ptr"

///|
pub extern "C" fn Sqlite3_module::from_void_ptr(
  ptr : AnyType
) -> Sqlite3_module = "sqlite3_module_ptr_from_void_ptr"

///|
pub extern "C" fn CStr::from_string(str : String) -> CStr = "moonbit_str_to_c_str"

///|
pub extern "C" fn CStr::convert_to_moonbit_string(str : CStr) -> String = "cstr_to_moonbit_str"

///|
pub extern "C" fn CStr::convert_to_moonbit_string_with_length(
  str : CStr,
  len : UInt
) -> String = "cstr_to_moonbit_str_with_length"

//char * sqlite3_expanded_sql(sqlite3_stmt * pStmt);

///|
pub extern "C" fn sqlite3_expanded_sql(pStmt : Sqlite3_stmt) -> CStr = "sqlite3_expanded_sql"

//char * sqlite3_mprintf(const char *);

///|
pub extern "C" fn sqlite3_mprintf(zFormat : CStr) -> CStr = "sqlite3_mprintf"

//char * sqlite3_snprintf(int, char *, const char *);

///|
pub extern "C" fn sqlite3_snprintf(
  n : Int,
  zBuf : CStr,
  zFormat : CStr
) -> CStr = "sqlite3_snprintf"

//char * sqlite3_str_finish(sqlite3_str *);

///|
pub extern "C" fn sqlite3_str_finish(pStr : Sqlite3_str) -> CStr = "sqlite3_str_finish"

//char * sqlite3_str_value(sqlite3_str *);

///|
pub extern "C" fn sqlite3_str_value(pStr : Sqlite3_str) -> CStr = "sqlite3_str_value"

//char * sqlite3_vmprintf(const char *, int);

///|
pub extern "C" fn sqlite3_vmprintf(zFormat : CStr, n : Int) -> CStr = "sqlite3_vmprintf"

//char * sqlite3_vsnprintf(int, char *, const char *, int);

///|
pub extern "C" fn sqlite3_vsnprintf(
  n : Int,
  zBuf : CStr,
  zFormat : CStr,
  nFormat : Int
) -> CStr = "sqlite3_vsnprintf"

//const char * sqlite3_bind_parameter_name(sqlite3_stmt *, int);

///| REVIEW: This function cause unknow problem in Moonbit.
pub extern "C" fn sqlite3_bind_parameter_name(
  pStmt : Sqlite3_stmt,
  i : Int
) -> CStr = "sqlite3_bind_parameter_name"

//const char * sqlite3_column_database_name(sqlite3_stmt *, int);

///|
pub extern "C" fn sqlite3_column_database_name(
  pStmt : Sqlite3_stmt,
  iCol : Int
) -> CStr = "sqlite3_column_database_name"

//const char * sqlite3_column_decltype(sqlite3_stmt *, int);

///|
pub extern "C" fn sqlite3_column_decltype(
  pStmt : Sqlite3_stmt,
  iCol : Int
) -> CStr = "sqlite3_column_decltype"

//const char * sqlite3_column_name(sqlite3_stmt *, int N);

///|
pub extern "C" fn sqlite3_column_name(pStmt : Sqlite3_stmt, n : Int) -> CStr = "sqlite3_column_name"

//const char * sqlite3_column_origin_name(sqlite3_stmt *, int);

///|
pub extern "C" fn sqlite3_column_origin_name(
  pStmt : Sqlite3_stmt,
  iCol : Int
) -> CStr = "sqlite3_column_origin_name"

//const char * sqlite3_column_table_name(sqlite3_stmt *, int);

///|
pub extern "C" fn sqlite3_column_table_name(
  pStmt : Sqlite3_stmt,
  iCol : Int
) -> CStr = "sqlite3_column_table_name"

//const char * sqlite3_compileoption_get(int N);

///|
pub extern "C" fn sqlite3_compileoption_get(n : Int) -> CStr = "sqlite3_compileoption_get"

//const char * sqlite3_db_name(sqlite3 * db, int N);

///|
pub extern "C" fn sqlite3_db_name(db : Sqlite3, n : Int) -> CStr = "sqlite3_db_name"

//const char * sqlite3_errmsg(sqlite3 *);

///|
pub extern "C" fn sqlite3_errmsg(db : Sqlite3) -> CStr = "sqlite3_errmsg"

//const char * sqlite3_errstr(int);

///|
pub extern "C" fn sqlite3_errstr(rc : Int) -> CStr = "sqlite3_errstr"

//const char * sqlite3_filename_database(sqlite3_filename);

///|
pub extern "C" fn sqlite3_filename_database(z : Sqlite3_filename) -> CStr = "sqlite3_filename_database"

//const char * sqlite3_filename_journal(sqlite3_filename);

///|
pub extern "C" fn sqlite3_filename_journal(z : Sqlite3_filename) -> CStr = "sqlite3_filename_journal"

//const char * sqlite3_filename_wal(sqlite3_filename);

///|
pub extern "C" fn sqlite3_filename_wal(z : Sqlite3_filename) -> CStr = "sqlite3_filename_wal"

//const char * sqlite3_libversion();

///|
pub extern "C" fn sqlite3_libversion() -> CStr = "sqlite3_libversion"

//const char * sqlite3_sourceid();

///|
pub extern "C" fn sqlite3_sourceid() -> CStr = "sqlite3_sourceid"

//const char * sqlite3_sql(sqlite3_stmt * pStmt);

///|
pub extern "C" fn sqlite3_sql(pStmt : Sqlite3_stmt) -> CStr = "sqlite3_sql"

//const char * sqlite3_uri_key(sqlite3_filename z, int N);

///|
pub extern "C" fn sqlite3_uri_key(z : Sqlite3_filename, n : Int) -> CStr = "sqlite3_uri_key"

//const char * sqlite3_uri_parameter(sqlite3_filename z, const char * zParam);

///|
pub extern "C" fn sqlite3_uri_parameter(
  z : Sqlite3_filename,
  zParam : CStr
) -> CStr = "sqlite3_uri_parameter"

//const char * sqlite3_vtab_collation(sqlite3_index_info *, int);

///|
pub extern "C" fn sqlite3_vtab_collation(
  pIdxInfo : Sqlite3_index_info,
  iCons : Int
) -> CStr = "sqlite3_vtab_collation"

//const unsigned char * sqlite3_column_text(sqlite3_stmt *, int iCol);

///|
pub extern "C" fn sqlite3_column_text(pStmt : Sqlite3_stmt, iCol : Int) -> CStr = "sqlite3_column_text"

//const unsigned char * sqlite3_value_text(sqlite3_value *);

///|
pub extern "C" fn sqlite3_value_text(value : Sqlite3_value) -> CStr = "sqlite3_value_text"

//const void * sqlite3_column_blob(sqlite3_stmt *, int iCol);

///|
pub extern "C" fn sqlite3_column_blob(
  pStmt : Sqlite3_stmt,
  iCol : Int
) -> AnyType = "sqlite3_column_blob"

//const void * sqlite3_column_database_name16(sqlite3_stmt *, int);

///|
pub extern "C" fn sqlite3_column_database_name16(
  pStmt : Sqlite3_stmt,
  iCol : Int
) -> AnyType = "sqlite3_column_database_name16"

//const void * sqlite3_column_decltype16(sqlite3_stmt *, int);

///|
pub extern "C" fn sqlite3_column_decltype16(
  pStmt : Sqlite3_stmt,
  iCol : Int
) -> AnyType = "sqlite3_column_decltype16"

//const void * sqlite3_column_name16(sqlite3_stmt *, int N);

///|
pub extern "C" fn sqlite3_column_name16(
  pStmt : Sqlite3_stmt,
  n : Int
) -> AnyType = "sqlite3_column_name16"

//const void * sqlite3_column_origin_name16(sqlite3_stmt *, int);

///|
pub extern "C" fn sqlite3_column_origin_name16(
  pStmt : Sqlite3_stmt,
  iCol : Int
) -> AnyType = "sqlite3_column_origin_name16"

//const void * sqlite3_column_table_name16(sqlite3_stmt *, int);

///|
pub extern "C" fn sqlite3_column_table_name16(
  pStmt : Sqlite3_stmt,
  iCol : Int
) -> AnyType = "sqlite3_column_table_name16"

//const void * sqlite3_column_text16(sqlite3_stmt *, int iCol);

///|
pub extern "C" fn sqlite3_column_text16(
  pStmt : Sqlite3_stmt,
  iCol : Int
) -> AnyType = "sqlite3_column_text16"

//const void * sqlite3_errmsg16(sqlite3 *);

///|
pub extern "C" fn sqlite3_errmsg16(db : Sqlite3) -> AnyType = "sqlite3_errmsg16"

//const void * sqlite3_value_blob(sqlite3_value *);

///|
pub extern "C" fn sqlite3_value_blob(value : Sqlite3_value) -> AnyType = "sqlite3_value_blob"

//const void * sqlite3_value_text16(sqlite3_value *);

///|
pub extern "C" fn sqlite3_value_text16(value : Sqlite3_value) -> AnyType = "sqlite3_value_text16"

//const void * sqlite3_value_text16be(sqlite3_value *);

///|
pub extern "C" fn sqlite3_value_text16be(value : Sqlite3_value) -> AnyType = "sqlite3_value_text16be"

//const void * sqlite3_value_text16le(sqlite3_value *);

///|
pub extern "C" fn sqlite3_value_text16le(value : Sqlite3_value) -> AnyType = "sqlite3_value_text16le"

//double sqlite3_column_double(sqlite3_stmt *, int iCol);

///|
pub extern "C" fn sqlite3_column_double(
  pStmt : Sqlite3_stmt,
  iCol : Int
) -> Double = "sqlite3_column_double"

//double sqlite3_value_double(sqlite3_value *);

///|
pub extern "C" fn sqlite3_value_double(value : Sqlite3_value) -> Double = "sqlite3_value_double"

//int sqlite3_aggregate_count(sqlite3_context *);

///|
pub extern "C" fn sqlite3_aggregate_count(context : Sqlite3_context) -> Int = "sqlite3_aggregate_count"

//int sqlite3_auto_extension(void (*)() xEntryPoint);

///|
pub extern "C" fn sqlite3_auto_extension(
  xEntryPoint : FuncRef[() -> Unit]
) -> Int = "sqlite3_auto_extension"

//int sqlite3_autovacuum_pages(sqlite3 * db, unsigned int (*)(void *, const char *, unsigned int, unsigned int, unsigned int), void *, void (*)(void *));

///|
pub extern "C" fn sqlite3_autovacuum_pages(
  db : Sqlite3,
  xCallback : FuncRef[(AnyType, CStr, UInt, UInt, UInt) -> UInt],
  pArg : AnyType,
  xDestroy : FuncRef[(AnyType) -> Unit]
) -> Int = "sqlite3_autovacuum_pages"

//int sqlite3_backup_finish(sqlite3_backup * p);

///|
pub extern "C" fn sqlite3_backup_finish(p : Sqlite3_backup) -> Int = "sqlite3_backup_finish"

//int sqlite3_backup_pagecount(sqlite3_backup * p);

///|
pub extern "C" fn sqlite3_backup_pagecount(p : Sqlite3_backup) -> Int = "sqlite3_backup_pagecount"

//int sqlite3_backup_remaining(sqlite3_backup * p);

///|
pub extern "C" fn sqlite3_backup_remaining(p : Sqlite3_backup) -> Int = "sqlite3_backup_remaining"

//int sqlite3_backup_step(sqlite3_backup * p, int nPage);

///|
pub extern "C" fn sqlite3_backup_step(p : Sqlite3_backup, nPage : Int) -> Int = "sqlite3_backup_step"

//int sqlite3_bind_blob(sqlite3_stmt *, int, const void *, int n, void (*)(void *));

///|
pub extern "C" fn sqlite3_bind_blob(
  pStmt : Sqlite3_stmt,
  i : Int,
  zData : AnyType,
  n : Int,
  xDel : FuncRef[(AnyType) -> Unit]
) -> Int = "sqlite3_bind_blob"

//int sqlite3_bind_blob64(sqlite3_stmt *, int, const void *, sqlite3_uint64, void (*)(void *));

///|
pub extern "C" fn sqlite3_bind_blob64(
  pStmt : Sqlite3_stmt,
  i : Int,
  zData : AnyType,
  n : UInt,
  xDel : FuncRef[(AnyType) -> Unit]
) -> Int = "sqlite3_bind_blob64"

//int sqlite3_bind_double(sqlite3_stmt *, int, double);

///|
pub extern "C" fn sqlite3_bind_double(
  pStmt : Sqlite3_stmt,
  i : Int,
  value : Double
) -> Int = "sqlite3_bind_double"

//int sqlite3_bind_int(sqlite3_stmt *, int, int);

///|
pub extern "C" fn sqlite3_bind_int(
  pStmt : Sqlite3_stmt,
  i : Int,
  value : Int
) -> Int = "sqlite3_bind_int"

//int sqlite3_bind_int64(sqlite3_stmt *, int, sqlite3_int64);

///|
pub extern "C" fn sqlite3_bind_int64(
  pStmt : Sqlite3_stmt,
  i : Int,
  value : Int64
) -> Int = "sqlite3_bind_int64"

//int sqlite3_bind_null(sqlite3_stmt *, int);

///|
pub extern "C" fn sqlite3_bind_null(pStmt : Sqlite3_stmt, i : Int) -> Int = "sqlite3_bind_null"

//int sqlite3_bind_parameter_count(sqlite3_stmt *);

///|
pub extern "C" fn sqlite3_bind_parameter_count(pStmt : Sqlite3_stmt) -> Int = "sqlite3_bind_parameter_count"

//int sqlite3_bind_parameter_index(sqlite3_stmt *, const char * zName);

///|
pub extern "C" fn sqlite3_bind_parameter_index(
  pStmt : Sqlite3_stmt,
  zName : CStr
) -> Int = "sqlite3_bind_parameter_index"

//int sqlite3_bind_pointer(sqlite3_stmt *, int, void *, const char *, void (*)(void *));

///|
pub extern "C" fn sqlite3_bind_pointer(
  pStmt : Sqlite3_stmt,
  i : Int,
  pPtr : AnyType,
  zPType : CStr,
  xDestructor : FuncRef[(AnyType) -> Unit]
) -> Int = "sqlite3_bind_pointer"

//int sqlite3_bind_text(sqlite3_stmt *, int, const char *, int, void (*)(void *));

///|
pub extern "C" fn sqlite3_bind_text(
  pStmt : Sqlite3_stmt,
  i : Int,
  z : CStr,
  n : Int,
  xDel : FuncRef[(AnyType) -> Unit]
) -> Int = "sqlite3_bind_text"

//int sqlite3_bind_text16(sqlite3_stmt *, int, const void *, int, void (*)(void *));

///|
pub extern "C" fn sqlite3_bind_text16(
  pStmt : Sqlite3_stmt,
  i : Int,
  z : AnyType,
  n : Int,
  xDel : FuncRef[(AnyType) -> Unit]
) -> Int = "sqlite3_bind_text16"

//int sqlite3_bind_text64(sqlite3_stmt *, int, const char *, sqlite3_uint64, void (*)(void *), unsigned char encoding);

///|
pub extern "C" fn sqlite3_bind_text64(
  pStmt : Sqlite3_stmt,
  i : Int,
  z : CStr,
  n : UInt64,
  xDel : FuncRef[(AnyType) -> Unit],
  encoding : Byte
) -> Int = "sqlite3_bind_text64"

//int sqlite3_bind_value(sqlite3_stmt *, int, const sqlite3_value *);

///|
pub extern "C" fn sqlite3_bind_value(
  pStmt : Sqlite3_stmt,
  i : Int,
  pValue : Sqlite3_value
) -> Int = "sqlite3_bind_value"

//int sqlite3_bind_zeroblob(sqlite3_stmt *, int, int n);

///|
pub extern "C" fn sqlite3_bind_zeroblob(
  pStmt : Sqlite3_stmt,
  i : Int,
  n : Int
) -> Int = "sqlite3_bind_zeroblob"

//int sqlite3_bind_zeroblob64(sqlite3_stmt *, int, sqlite3_uint64);

///|
pub extern "C" fn sqlite3_bind_zeroblob64(
  pStmt : Sqlite3_stmt,
  i : Int,
  n : UInt64
) -> Int = "sqlite3_bind_zeroblob64"

//int sqlite3_blob_bytes(sqlite3_blob *);

///|
pub extern "C" fn sqlite3_blob_bytes(pBlob : Sqlite3_blob) -> Int = "sqlite3_blob_bytes"

//int sqlite3_blob_close(sqlite3_blob *);

///|
pub extern "C" fn sqlite3_blob_close(pBlob : Sqlite3_blob) -> Int = "sqlite3_blob_close"

//int sqlite3_blob_open(sqlite3 *, const char * zDb, const char * zTable, const char * zColumn, sqlite3_int64 iRow, int flags, sqlite3_blob ** ppBlob);

///|
pub extern "C" fn sqlite3_blob_open(
  db : Sqlite3,
  zDb : CStr,
  zTable : CStr,
  zColumn : CStr,
  iRow : Int64,
  flags : Int,
  ppBlob : Ref[Sqlite3_blob]
) -> Int = "sqlite3_blob_open"

//int sqlite3_blob_read(sqlite3_blob *, void * Z, int N, int iOffset);

///|
pub extern "C" fn sqlite3_blob_read(
  pBlob : Sqlite3_blob,
  z : AnyType,
  n : Int,
  iOffset : Int
) -> Int = "sqlite3_blob_read"

//int sqlite3_blob_reopen(sqlite3_blob *, sqlite3_int64);

///|
pub extern "C" fn sqlite3_blob_reopen(
  pBlob : Sqlite3_blob,
  rowid : Int64
) -> Int = "sqlite3_blob_reopen"

//int sqlite3_blob_write(sqlite3_blob *, const void * z, int n, int iOffset);

///|
pub extern "C" fn sqlite3_blob_write(
  pBlob : Sqlite3_blob,
  z : AnyType,
  n : Int,
  iOffset : Int
) -> Int = "sqlite3_blob_write"
//int sqlite3_busy_handler(sqlite3 *, int (*)(void *, int), void *);

///|
pub extern "C" fn sqlite3_busy_handler(
  db : Sqlite3,
  xBusy : FuncRef[(AnyType, Int) -> Int],
  pArg : AnyType
) -> Int = "sqlite3_busy_handler"

//int sqlite3_busy_timeout(sqlite3 *, int ms);

///|
pub extern "C" fn sqlite3_busy_timeout(db : Sqlite3, ms : Int) -> Int = "sqlite3_busy_timeout"

//int sqlite3_cancel_auto_extension(void (*)() xEntryPoint);

///|
pub extern "C" fn sqlite3_cancel_auto_extension(
  xEntryPoint : FuncRef[() -> Unit]
) -> Int = "sqlite3_cancel_auto_extension"
//int sqlite3_changes(sqlite3 *);

///|
pub extern "C" fn sqlite3_changes(db : Sqlite3) -> Int = "sqlite3_changes"

//int sqlite3_clear_bindings(sqlite3_stmt *);

///|
pub extern "C" fn sqlite3_clear_bindings(pStmt : Sqlite3_stmt) -> Int = "sqlite3_clear_bindings"

//int sqlite3_close(sqlite3 *);

///|
pub extern "C" fn sqlite3_close(db : Sqlite3) -> Int = "sqlite3_close"

//int sqlite3_close_v2(sqlite3 *);

///|
pub extern "C" fn sqlite3_close_v2(db : Sqlite3) -> Int = "sqlite3_close_v2"
//int sqlite3_collation_needed(sqlite3 *, void *, void (*)(void *, sqlite3 *, int, const char *));

///|
pub extern "C" fn sqlite3_collation_needed(
  db : Sqlite3,
  pCollNeededArg : AnyType,
  xCollNeeded : FuncRef[(AnyType, Sqlite3, Int, CStr) -> Unit]
) -> Int = "sqlite3_collation_needed"

//int sqlite3_collation_needed16(sqlite3 *, void *, void (*)(void *, sqlite3 *, int, const void *));

///|
pub extern "C" fn sqlite3_collation_needed16(
  db : Sqlite3,
  pCollNeededArg : AnyType,
  xCollNeeded16 : FuncRef[(AnyType, Sqlite3, Int, AnyType) -> Unit]
) -> Int = "sqlite3_collation_needed16"
//int sqlite3_column_bytes(sqlite3_stmt *, int iCol);

///|
pub extern "C" fn sqlite3_column_bytes(pStmt : Sqlite3_stmt, iCol : Int) -> Int = "sqlite3_column_bytes"

//int sqlite3_column_bytes16(sqlite3_stmt *, int iCol);

///|
pub extern "C" fn sqlite3_column_bytes16(
  pStmt : Sqlite3_stmt,
  iCol : Int
) -> Int = "sqlite3_column_bytes16"

//int sqlite3_column_count(sqlite3_stmt * pStmt);

///|
pub extern "C" fn sqlite3_column_count(pStmt : Sqlite3_stmt) -> Int = "sqlite3_column_count"

//int sqlite3_column_int(sqlite3_stmt *, int iCol);

///|
pub extern "C" fn sqlite3_column_int(pStmt : Sqlite3_stmt, iCol : Int) -> Int = "sqlite3_column_int"

//int sqlite3_column_type(sqlite3_stmt *, int iCol);

///|
pub extern "C" fn sqlite3_column_type(pStmt : Sqlite3_stmt, iCol : Int) -> Int = "sqlite3_column_type"
//int sqlite3_compileoption_used(const char * zOptName);

///|
pub extern "C" fn sqlite3_compileoption_used(zOptName : CStr) -> Int = "sqlite3_compileoption_used"

//int sqlite3_complete(const char * sql);

///|
pub extern "C" fn sqlite3_complete(sql : CStr) -> Int = "sqlite3_complete"

//int sqlite3_complete16(const void * sql);

///|
pub extern "C" fn sqlite3_complete16(sql : AnyType) -> Int = "sqlite3_complete16"

//int sqlite3_config(int);

///|
pub extern "C" fn sqlite3_config(option : Int) -> Int = "sqlite3_config"

//int sqlite3_create_collation(sqlite3 *, const char * zName, int eTextRep, void * pArg, int (*)(void *, int, const void *, int, const void *) xCompare);

///|
pub extern "C" fn sqlite3_create_collation(
  db : Sqlite3,
  zName : CStr,
  eTextRep : Int,
  pArg : AnyType,
  xCompare : FuncRef[(AnyType, Int, AnyType, Int, AnyType) -> Int]
) -> Int = "sqlite3_create_collation"

//int sqlite3_create_collation16(sqlite3 *, const void * zName, int eTextRep, void * pArg, int (*)(void *, int, const void *, int, const void *) xCompare);

///|
pub extern "C" fn sqlite3_create_collation16(
  db : Sqlite3,
  zName : AnyType,
  eTextRep : Int,
  pArg : AnyType,
  xCompare : FuncRef[(AnyType, Int, AnyType, Int, AnyType) -> Int]
) -> Int = "sqlite3_create_collation16"

//int sqlite3_create_collation_v2(sqlite3 *, const char * zName, int eTextRep, void * pArg, int (*)(void *, int, const void *, int, const void *) xCompare, void (*)(void *) xDestroy);

///|
pub extern "C" fn sqlite3_create_collation_v2(
  db : Sqlite3,
  zName : CStr,
  eTextRep : Int,
  pArg : AnyType,
  xCompare : FuncRef[(AnyType, Int, AnyType, Int, AnyType) -> Int],
  xDestroy : FuncRef[(AnyType) -> Unit]
) -> Int = "sqlite3_create_collation_v2"

//int sqlite3_create_function(sqlite3 * db, const char * zFunctionName, int nArg, int eTextRep, void * pApp, void (*)(sqlite3_context *, int, sqlite3_value **) xFunc, void (*)(sqlite3_context *, int, sqlite3_value **) xStep, void (*)(sqlite3_context *) xFinal);

///|
pub extern "C" fn sqlite3_create_function(
  db : Sqlite3,
  zFunctionName : CStr,
  nArg : Int,
  eTextRep : Int,
  pApp : AnyType,
  xFunc : FuncRef[(Sqlite3_context, Int, FixedArray[Sqlite3_value]) -> Unit],
  xStep : FuncRef[(Sqlite3_context, Int, AnyType) -> Unit],
  xFinal : FuncRef[(Sqlite3_context) -> Unit]
) -> Int = "sqlite3_create_function"

//int sqlite3_create_function16(sqlite3 * db, const void * zFunctionName, int nArg, int eTextRep, void * pApp, void (*)(sqlite3_context *, int, sqlite3_value **) xFunc, void (*)(sqlite3_context *, int, sqlite3_value **) xStep, void (*)(sqlite3_context *) xFinal);

///|
pub extern "C" fn sqlite3_create_function16(
  db : Sqlite3,
  zFunctionName : AnyType,
  nArg : Int,
  eTextRep : Int,
  pApp : AnyType,
  xFunc : FuncRef[(Sqlite3_context, Int, FixedArray[Sqlite3_value]) -> Unit],
  xStep : FuncRef[(Sqlite3_context, Int, AnyType) -> Unit],
  xFinal : FuncRef[(Sqlite3_context) -> Unit]
) -> Int = "sqlite3_create_function16"

//int sqlite3_create_function_v2(sqlite3 * db, const char * zFunctionName, int nArg, int eTextRep, void * pApp, void (*)(sqlite3_context *, int, sqlite3_value **) xFunc, void (*)(sqlite3_context *, int, sqlite3_value **) xStep, void (*)(sqlite3_context *) xFinal, void (*)(void *) xDestroy);

///|
pub extern "C" fn sqlite3_create_function_v2(
  db : Sqlite3,
  zFunctionName : CStr,
  nArg : Int,
  eTextRep : Int,
  pApp : AnyType,
  xFunc : FuncRef[(Sqlite3_context, Int, FixedArray[Sqlite3_value]) -> Unit],
  xStep : FuncRef[(Sqlite3_context, Int, AnyType) -> Unit],
  xFinal : FuncRef[(Sqlite3_context) -> Unit],
  xDestroy : FuncRef[(AnyType) -> Unit]
) -> Int = "sqlite3_create_function_v2"
//int sqlite3_create_module(sqlite3 * db, const char * zName, const sqlite3_module * p, void * pClientData);

///|
pub extern "C" fn sqlite3_create_module(
  db : Sqlite3,
  zName : CStr,
  p : Sqlite3_module,
  pClientData : AnyType
) -> Int = "sqlite3_create_module"

//int sqlite3_create_module_v2(sqlite3 * db, const char * zName, const sqlite3_module * p, void * pClientData, void (*)(void *) xDestroy);

///|
pub extern "C" fn sqlite3_create_module_v2(
  db : Sqlite3,
  zName : CStr,
  p : Sqlite3_module,
  pClientData : AnyType,
  xDestroy : FuncRef[(AnyType) -> Unit]
) -> Int = "sqlite3_create_module_v2"
//int sqlite3_create_window_function(sqlite3 * db, const char * zFunctionName, int nArg, int eTextRep, void * pApp, void (*)(sqlite3_context *, int, sqlite3_value **) xStep, void (*)(sqlite3_context *) xFinal, void (*)(sqlite3_context *) xValue, void (*)(sqlite3_context *, int, sqlite3_value **) xInverse, void (*)(void *) xDestroy);

///|
pub extern "C" fn sqlite3_create_window_function(
  db : Sqlite3,
  zFunctionName : CStr,
  nArg : Int,
  eTextRep : Int,
  pApp : AnyType,
  xStep : FuncRef[(Sqlite3_context, Int, FixedArray[Sqlite3_value]) -> Unit],
  xFinal : FuncRef[(Sqlite3_context) -> Unit],
  xValue : FuncRef[(Sqlite3_context) -> Unit],
  xInverse : FuncRef[(Sqlite3_context, Int, AnyType) -> Unit],
  xDestroy : FuncRef[(AnyType) -> Unit]
) -> Int = "sqlite3_create_window_function"
//int sqlite3_data_count(sqlite3_stmt * pStmt);

///|
pub extern "C" fn sqlite3_data_count(pStmt : Sqlite3_stmt) -> Int = "sqlite3_data_count"

//int sqlite3_db_cacheflush(sqlite3 *);

///|
pub extern "C" fn sqlite3_db_cacheflush(db : Sqlite3) -> Int = "sqlite3_db_cacheflush"

//int sqlite3_db_config(sqlite3 *, int op);

///|
pub extern "C" fn sqlite3_db_config(db : Sqlite3, op : Int) -> Int = "sqlite3_db_config"

//int sqlite3_db_readonly(sqlite3 * db, const char * zDbName);

///|
pub extern "C" fn sqlite3_db_readonly(db : Sqlite3, zDbName : CStr) -> Int = "sqlite3_db_readonly"

//int sqlite3_db_release_memory(sqlite3 *);

///|
pub extern "C" fn sqlite3_db_release_memory(db : Sqlite3) -> Int = "sqlite3_db_release_memory"

//int sqlite3_db_status(sqlite3 *, int op, int * pCur, int * pHiwtr, int resetFlg);

///|
pub extern "C" fn sqlite3_db_status(
  db : Sqlite3,
  op : Int,
  pCur : AnyType,
  pHiwtr : AnyType,
  resetFlg : Int
) -> Int = "sqlite3_db_status"

//int sqlite3_declare_vtab(sqlite3 *, const char * zSQL);

///|
pub extern "C" fn sqlite3_declare_vtab(db : Sqlite3, zSQL : CStr) -> Int = "sqlite3_declare_vtab"

//int sqlite3_deserialize(sqlite3 * db, const char * zSchema, unsigned char * pData, sqlite3_int64 szDb, sqlite3_int64 szBuf, unsigned int mFlags);

///|
pub extern "C" fn sqlite3_deserialize(
  db : Sqlite3,
  zSchema : CStr,
  pData : CStr,
  szDb : Int64,
  szBuf : Int64,
  mFlags : UInt
) -> Int = "sqlite3_deserialize"

//int sqlite3_drop_modules(sqlite3 * db, const char ** azKeep);

///|
pub extern "C" fn sqlite3_drop_modules(db : Sqlite3, azKeep : Ref[CStr]) -> Int = "sqlite3_drop_modules"

//int sqlite3_enable_load_extension(sqlite3 * db, int onoff);

///|
pub extern "C" fn sqlite3_enable_load_extension(
  db : Sqlite3,
  onoff : Int
) -> Int = "sqlite3_enable_load_extension"

//int sqlite3_enable_shared_cache(int);

///|
pub extern "C" fn sqlite3_enable_shared_cache(enable : Int) -> Int = "sqlite3_enable_shared_cache"

//int sqlite3_errcode(sqlite3 * db);

///|
pub extern "C" fn sqlite3_errcode(db : Sqlite3) -> Int = "sqlite3_errcode"

//int sqlite3_error_offset(sqlite3 * db);

///|
pub extern "C" fn sqlite3_error_offset(db : Sqlite3) -> Int = "sqlite3_error_offset"

//int sqlite3_exec(sqlite3 *, const char * sql, int (*)(void *, int, char **, char **) callback, void *, char ** errmsg);

///|
pub extern "C" fn sqlite3_exec(
  db : Sqlite3,
  sql : CStr,
  callback : FuncRef[(AnyType, Int, Ref[CStr], Ref[CStr]) -> Int],
  data : AnyType,
  errmsg : AnyType
) -> Int = "sqlite3_exec"

//int sqlite3_expired(sqlite3_stmt *);

///|
pub extern "C" fn sqlite3_expired(pStmt : Sqlite3_stmt) -> Int = "sqlite3_expired"

//int sqlite3_extended_errcode(sqlite3 * db);

///|
pub extern "C" fn sqlite3_extended_errcode(db : Sqlite3) -> Int = "sqlite3_extended_errcode"

//int sqlite3_extended_result_codes(sqlite3 *, int onoff);

///|
pub extern "C" fn sqlite3_extended_result_codes(
  db : Sqlite3,
  onoff : Int
) -> Int = "sqlite3_extended_result_codes"

//int sqlite3_file_control(sqlite3 *, const char * zDbName, int op, void *);

///|
pub extern "C" fn sqlite3_file_control(
  db : Sqlite3,
  zDbName : CStr,
  op : Int,
  data : AnyType
) -> Int = "sqlite3_file_control"

//int sqlite3_finalize(sqlite3_stmt * pStmt);

///|
pub extern "C" fn sqlite3_finalize(pStmt : Sqlite3_stmt) -> Int = "sqlite3_finalize"
//int sqlite3_get_autocommit(sqlite3 *);

///|
pub extern "C" fn sqlite3_get_autocommit(db : Sqlite3) -> Int = "sqlite3_get_autocommit"

//int sqlite3_get_table(sqlite3 * db, const char * zSql, char *** pazResult, int * pnRow, int * pnColumn, char ** pzErrmsg);

///|
#deprecated("not sure the pazResult's type")
pub extern "C" fn sqlite3_get_table(
  db : Sqlite3,
  zSql : CStr,
  pazResult : AnyType,
  pnRow : AnyType,
  pnColumn : AnyType,
  pzErrmsg : Ref[CStr]
) -> Int = "sqlite3_get_table"

//int sqlite3_global_recover();

///|
pub extern "C" fn sqlite3_global_recover() -> Int = "sqlite3_global_recover"

//int sqlite3_initialize();

///|
pub extern "C" fn sqlite3_initialize() -> Int = "sqlite3_initialize"

//int sqlite3_is_interrupted(sqlite3 *);

///|
pub extern "C" fn sqlite3_is_interrupted(db : Sqlite3) -> Int = "sqlite3_is_interrupted"

//int sqlite3_keyword_check(const char *, int);

///|
pub extern "C" fn sqlite3_keyword_check(z : CStr, n : Int) -> Int = "sqlite3_keyword_check"

//int sqlite3_keyword_count();

///|
pub extern "C" fn sqlite3_keyword_count() -> Int = "sqlite3_keyword_count"

//int sqlite3_keyword_name(int, const char **, int *);

///|
pub extern "C" fn sqlite3_keyword_name(
  i : Int,
  pzName : Ref[CStr],
  pnName : Ref[Int]
) -> Int = "sqlite3_keyword_name"

//int sqlite3_libversion_number();

///|
pub extern "C" fn sqlite3_libversion_number() -> Int = "sqlite3_libversion_number"

//int sqlite3_limit(sqlite3 *, int id, int newVal);

///|
pub extern "C" fn sqlite3_limit(db : Sqlite3, id : Int, newVal : Int) -> Int = "sqlite3_limit"

//int sqlite3_load_extension(sqlite3 * db, const char * zFile, const char * zProc, char ** pzErrMsg);

///|
pub extern "C" fn sqlite3_load_extension(
  db : Sqlite3,
  zFile : CStr,
  zProc : CStr,
  pzErrMsg : AnyType
) -> Int = "sqlite3_load_extension"

//int sqlite3_memory_alarm(void (*)(void *, sqlite3_int64, int), void *, sqlite3_int64);

///|
pub extern "C" fn sqlite3_memory_alarm(
  xCallback : FuncRef[(AnyType, Int64, Int) -> Unit],
  pArg : AnyType,
  iThreshold : Int64
) -> Int = "sqlite3_memory_alarm"

//int sqlite3_mutex_held(sqlite3_mutex *);

///|
pub extern "C" fn sqlite3_mutex_held(mutex : Sqlite3_mutex) -> Int = "sqlite3_mutex_held"

//int sqlite3_mutex_notheld(sqlite3_mutex *);

///|
pub extern "C" fn sqlite3_mutex_notheld(mutex : Sqlite3_mutex) -> Int = "sqlite3_mutex_notheld"

//int sqlite3_mutex_try(sqlite3_mutex *);

///|
pub extern "C" fn sqlite3_mutex_try(mutex : Sqlite3_mutex) -> Int = "sqlite3_mutex_try"
//int sqlite3_open(const char * filename, sqlite3 ** ppDb);

///|
pub extern "C" fn sqlite3_open(filename : CStr, ppDb : Ref[Sqlite3]) -> Int = "sqlite3_open"

//int sqlite3_open16(const void * filename, sqlite3 ** ppDb);

///|
pub extern "C" fn sqlite3_open16(
  filename : AnyType,
  ppDb : Ref[Sqlite3]
) -> Int = "sqlite3_open16"

//int sqlite3_open_v2(const char * filename, sqlite3 ** ppDb, int flags, const char * zVfs);

///|
pub extern "C" fn sqlite3_open_v2(
  filename : CStr,
  ppDb : Ref[Sqlite3],
  flags : Int,
  zVfs : CStr
) -> Int = "sqlite3_open_v2"

//int sqlite3_os_end();

///|
pub extern "C" fn sqlite3_os_end() -> Int = "sqlite3_os_end"

//int sqlite3_os_init();

///|
pub extern "C" fn sqlite3_os_init() -> Int = "sqlite3_os_init"

//int sqlite3_overload_function(sqlite3 *, const char * zFuncName, int nArg);

///|
pub extern "C" fn sqlite3_overload_function(
  db : Sqlite3,
  zFuncName : CStr,
  nArg : Int
) -> Int = "sqlite3_overload_function"

//int sqlite3_prepare(sqlite3 * db, const char * zSql, int nByte, sqlite3_stmt ** ppStmt, const char ** pzTail);

///|
pub extern "C" fn sqlite3_prepare(
  db : Sqlite3,
  zSql : CStr,
  nByte : Int,
  ppStmt : Ref[Sqlite3_stmt],
  pzTail : Ref[CStr]
) -> Int = "sqlite3_prepare"

//int sqlite3_prepare16(sqlite3 * db, const void * zSql, int nByte, sqlite3_stmt ** ppStmt, const void ** pzTail);

///|
pub extern "C" fn sqlite3_prepare16(
  db : Sqlite3,
  zSql : AnyType,
  nByte : Int,
  ppStmt : Ref[Sqlite3_stmt],
  pzTail : Ref[CStr]
) -> Int = "sqlite3_prepare16"

//int sqlite3_prepare16_v2(sqlite3 * db, const void * zSql, int nByte, sqlite3_stmt ** ppStmt, const void ** pzTail);

///|
pub extern "C" fn sqlite3_prepare16_v2(
  db : Sqlite3,
  zSql : AnyType,
  nByte : Int,
  ppStmt : Ref[Sqlite3_stmt],
  pzTail : AnyType
) -> Int = "sqlite3_prepare16_v2"

//int sqlite3_prepare16_v3(sqlite3 * db, const void * zSql, int nByte, unsigned int prepFlags, sqlite3_stmt ** ppStmt, const void ** pzTail);

///|
pub extern "C" fn sqlite3_prepare16_v3(
  db : Sqlite3,
  zSql : AnyType,
  nByte : Int,
  prepFlags : UInt,
  ppStmt : Ref[Sqlite3_stmt],
  pzTail : AnyType
) -> Int = "sqlite3_prepare16_v3"

//int sqlite3_prepare_v2(sqlite3 * db, const char * zSql, int nByte, sqlite3_stmt ** ppStmt, const char ** pzTail);

///|
pub extern "C" fn sqlite3_prepare_v2(
  db : Sqlite3,
  zSql : CStr,
  nByte : Int,
  ppStmt : Ref[Sqlite3_stmt],
  pzTail : AnyType
) -> Int = "sqlite3_prepare_v2"

//int sqlite3_prepare_v3(sqlite3 * db, const char * zSql, int nByte, unsigned int prepFlags, sqlite3_stmt ** ppStmt, const char ** pzTail);

///|
pub extern "C" fn sqlite3_prepare_v3(
  db : Sqlite3,
  zSql : CStr,
  nByte : Int,
  prepFlags : UInt,
  ppStmt : Ref[Sqlite3_stmt],
  pzTail : AnyType
) -> Int = "sqlite3_prepare_v3"
//int sqlite3_release_memory(int);

///|
pub extern "C" fn sqlite3_release_memory(n : Int) -> Int = "sqlite3_release_memory"

//int sqlite3_reset(sqlite3_stmt * pStmt);

///|
pub extern "C" fn sqlite3_reset(pStmt : Sqlite3_stmt) -> Int = "sqlite3_reset"

//int sqlite3_result_zeroblob64(sqlite3_context *, sqlite3_uint64 n);

///|
pub extern "C" fn sqlite3_result_zeroblob64(
  context : Sqlite3_context,
  n : UInt64
) -> Int = "sqlite3_result_zeroblob64"

//int sqlite3_rtree_geometry_callback(sqlite3 * db, const char * zGeom, int (*)(sqlite3_rtree_geometry *, int, sqlite3_rtree_dbl *, int *) xGeom, void * pContext);

///|
pub extern "C" fn sqlite3_rtree_geometry_callback(
  db : Sqlite3,
  zGeom : CStr,
  xGeom : FuncRef[(AnyType, Int, AnyType, AnyType) -> Int],
  pContext : AnyType
) -> Int = "sqlite3_rtree_geometry_callback"

//int sqlite3_rtree_query_callback(sqlite3 * db, const char * zQueryFunc, int (*)(sqlite3_rtree_query_info *) xQueryFunc, void * pContext, void (*)(void *) xDestructor);

///|
pub extern "C" fn sqlite3_rtree_query_callback(
  db : Sqlite3,
  zQueryFunc : CStr,
  xQueryFunc : FuncRef[(AnyType) -> Int],
  pContext : AnyType,
  xDestructor : FuncRef[(AnyType) -> Unit]
) -> Int = "sqlite3_rtree_query_callback"

//int sqlite3_set_authorizer(sqlite3 *, int (*)(void *, int, const char *, const char *, const char *, const char *) xAuth, void * pUserData);

///|
pub extern "C" fn sqlite3_set_authorizer(
  db : Sqlite3,
  xAuth : FuncRef[(AnyType, Int, CStr, CStr, CStr, CStr) -> Int],
  pUserData : AnyType
) -> Int = "sqlite3_set_authorizer"

//int sqlite3_set_clientdata(sqlite3 *, const char *, void *, void (*)(void *));

///|
pub extern "C" fn sqlite3_set_clientdata(
  db : Sqlite3,
  zName : CStr,
  pData : AnyType,
  xDestructor : FuncRef[(AnyType) -> Unit]
) -> Int = "sqlite3_set_clientdata"
//int sqlite3_setlk_timeout(sqlite3 *, int ms, int flags);

///|
pub extern "C" fn sqlite3_setlk_timeout(
  db : Sqlite3,
  ms : Int,
  flags : Int
) -> Int = "sqlite3_setlk_timeout"
//int sqlite3_shutdown();

///|
pub extern "C" fn sqlite3_shutdown() -> Int = "sqlite3_shutdown"

//int sqlite3_sleep(int);

///|
pub extern "C" fn sqlite3_sleep(ms : Int) -> Int = "sqlite3_sleep"

//int sqlite3_snapshot_cmp(sqlite3_snapshot * p1, sqlite3_snapshot * p2);

///|
pub extern "C" fn sqlite3_snapshot_cmp(
  p1 : Sqlite3_snapshot,
  p2 : Sqlite3_snapshot
) -> Int = "sqlite3_snapshot_cmp"

//int sqlite3_snapshot_get(sqlite3 * db, const char * zSchema, sqlite3_snapshot ** ppSnapshot);

///|
pub extern "C" fn sqlite3_snapshot_get(
  db : Sqlite3,
  zSchema : CStr,
  ppSnapshot : Ref[Sqlite3_snapshot]
) -> Int = "sqlite3_snapshot_get"

//int sqlite3_snapshot_open(sqlite3 * db, const char * zSchema, sqlite3_snapshot * pSnapshot);

///|
pub extern "C" fn sqlite3_snapshot_open(
  db : Sqlite3,
  zSchema : CStr,
  pSnapshot : Sqlite3_snapshot
) -> Int = "sqlite3_snapshot_open"

//int sqlite3_snapshot_recover(sqlite3 * db, const char * zDb);

///|
pub extern "C" fn sqlite3_snapshot_recover(db : Sqlite3, zDb : CStr) -> Int = "sqlite3_snapshot_recover"
//int sqlite3_status(int op, int * pCurrent, int * pHighwater, int resetFlag);

///|
pub extern "C" fn sqlite3_status(
  op : Int,
  pCurrent : AnyType,
  pHighwater : AnyType,
  resetFlag : Int
) -> Int = "sqlite3_status"

//int sqlite3_status64(int op, sqlite3_int64 * pCurrent, sqlite3_int64 * pHighwater, int resetFlag);

///|
pub extern "C" fn sqlite3_status64(
  op : Int,
  pCurrent : AnyType,
  pHighwater : AnyType,
  resetFlag : Int
) -> Int = "sqlite3_status64"
//int sqlite3_step(sqlite3_stmt *);

///|
pub extern "C" fn sqlite3_step(pStmt : Sqlite3_stmt) -> Int = "sqlite3_step"

//int sqlite3_stmt_busy(sqlite3_stmt *);

///|
pub extern "C" fn sqlite3_stmt_busy(pStmt : Sqlite3_stmt) -> Int = "sqlite3_stmt_busy"

//int sqlite3_stmt_explain(sqlite3_stmt * pStmt, int eMode);

///|
pub extern "C" fn sqlite3_stmt_explain(
  pStmt : Sqlite3_stmt,
  eMode : Int
) -> Int = "sqlite3_stmt_explain"

//int sqlite3_stmt_isexplain(sqlite3_stmt * pStmt);

///|
pub extern "C" fn sqlite3_stmt_isexplain(pStmt : Sqlite3_stmt) -> Int = "sqlite3_stmt_isexplain"

//int sqlite3_stmt_readonly(sqlite3_stmt * pStmt);

///|
pub extern "C" fn sqlite3_stmt_readonly(pStmt : Sqlite3_stmt) -> Int = "sqlite3_stmt_readonly"

//int sqlite3_stmt_scanstatus(sqlite3_stmt * pStmt, int idx, int iScanStatusOp, void * pOut);

///|
pub extern "C" fn sqlite3_stmt_scanstatus(
  pStmt : Sqlite3_stmt,
  idx : Int,
  iScanStatusOp : Int,
  pOut : AnyType
) -> Int = "sqlite3_stmt_scanstatus"

//int sqlite3_stmt_scanstatus_v2(sqlite3_stmt * pStmt, int idx, int iScanStatusOp, int flags, void * pOut);

///|
pub extern "C" fn sqlite3_stmt_scanstatus_v2(
  pStmt : Sqlite3_stmt,
  idx : Int,
  iScanStatusOp : Int,
  flags : Int,
  pOut : AnyType
) -> Int = "sqlite3_stmt_scanstatus_v2"

//int sqlite3_stmt_status(sqlite3_stmt *, int op, int resetFlg);

///|
pub extern "C" fn sqlite3_stmt_status(
  pStmt : Sqlite3_stmt,
  op : Int,
  resetFlg : Int
) -> Int = "sqlite3_stmt_status"

//int sqlite3_str_errcode(sqlite3_str *);

///|
pub extern "C" fn sqlite3_str_errcode(pStr : Sqlite3_str) -> Int = "sqlite3_str_errcode"

//int sqlite3_str_length(sqlite3_str *);

///|
pub extern "C" fn sqlite3_str_length(pStr : Sqlite3_str) -> Int = "sqlite3_str_length"

//int sqlite3_strglob(const char * zGlob, const char * zStr);

///|
pub extern "C" fn sqlite3_strglob(zGlob : CStr, zStr : CStr) -> Int = "sqlite3_strglob"

//int sqlite3_stricmp(const char *, const char *);

///|
pub extern "C" fn sqlite3_stricmp(zLeft : CStr, zRight : CStr) -> Int = "sqlite3_stricmp"

//int sqlite3_strlike(const char * zGlob, const char * zStr, unsigned int cEsc);

///|
pub extern "C" fn sqlite3_strlike(
  zGlob : CStr,
  zStr : CStr,
  cEsc : UInt
) -> Int = "sqlite3_strlike"

//int sqlite3_strnicmp(const char *, const char *, int);

///|
pub extern "C" fn sqlite3_strnicmp(zLeft : CStr, zRight : CStr, n : Int) -> Int = "sqlite3_strnicmp"

//int sqlite3_system_errno(sqlite3 *);

///|
pub extern "C" fn sqlite3_system_errno(db : Sqlite3) -> Int = "sqlite3_system_errno"

//int sqlite3_table_column_metadata(sqlite3 * db, const char * zDbName, const char * zTableName, const char * zColumnName, const char ** pzDataType, const char ** pzCollSeq, int * pNotNull, int * pPrimaryKey, int * pAutoinc);

///|
pub extern "C" fn sqlite3_table_column_metadata(
  db : Sqlite3,
  zDbName : CStr,
  zTableName : CStr,
  zColumnName : CStr,
  pzDataType : AnyType,
  pzCollSeq : AnyType,
  pNotNull : AnyType,
  pPrimaryKey : AnyType,
  pAutoinc : AnyType
) -> Int = "sqlite3_table_column_metadata"

//int sqlite3_test_control(int op);

///|
pub extern "C" fn sqlite3_test_control(op : Int) -> Int = "sqlite3_test_control"

//int sqlite3_threadsafe();

///|
pub extern "C" fn sqlite3_threadsafe() -> Int = "sqlite3_threadsafe"

//int sqlite3_total_changes(sqlite3 *);

///|
pub extern "C" fn sqlite3_total_changes(db : Sqlite3) -> Int = "sqlite3_total_changes"
//int sqlite3_trace_v2(sqlite3 *, unsigned int uMask, int (*)(unsigned int, void *, void *, void *) xCallback, void * pCtx);

///|
pub extern "C" fn sqlite3_trace_v2(
  db : Sqlite3,
  uMask : UInt,
  xCallback : FuncRef[(UInt, AnyType, AnyType, AnyType) -> Int],
  pCtx : AnyType
) -> Int = "sqlite3_trace_v2"
//int sqlite3_transfer_bindings(sqlite3_stmt *, sqlite3_stmt *);

///|
pub extern "C" fn sqlite3_transfer_bindings(
  pFrom : Sqlite3_stmt,
  pTo : Sqlite3_stmt
) -> Int = "sqlite3_transfer_bindings"

//int sqlite3_txn_state(sqlite3 *, const char * zSchema);

///|
pub extern "C" fn sqlite3_txn_state(db : Sqlite3, zSchema : CStr) -> Int = "sqlite3_txn_state"

//int sqlite3_unlock_notify(sqlite3 * pBlocked, void (*)(void **, int) xNotify, void * pNotifyArg);

///|
pub extern "C" fn sqlite3_unlock_notify(
  pBlocked : Sqlite3,
  xNotify : FuncRef[(AnyType, Int) -> Unit],
  pNotifyArg : AnyType
) -> Int = "sqlite3_unlock_notify"

//int sqlite3_uri_boolean(sqlite3_filename z, const char * zParam, int bDefault);

///|
pub extern "C" fn sqlite3_uri_boolean(
  z : Sqlite3_filename,
  zParam : CStr,
  bDefault : Int
) -> Int = "sqlite3_uri_boolean"

//int sqlite3_value_bytes(sqlite3_value *);

///|
pub extern "C" fn sqlite3_value_bytes(value : Sqlite3_value) -> Int = "sqlite3_value_bytes"

//int sqlite3_value_bytes16(sqlite3_value *);

///|
pub extern "C" fn sqlite3_value_bytes16(value : Sqlite3_value) -> Int = "sqlite3_value_bytes16"

//int sqlite3_value_encoding(sqlite3_value *);

///|
pub extern "C" fn sqlite3_value_encoding(value : Sqlite3_value) -> Int = "sqlite3_value_encoding"

//int sqlite3_value_frombind(sqlite3_value *);

///|
pub extern "C" fn sqlite3_value_frombind(value : Sqlite3_value) -> Int = "sqlite3_value_frombind"

//int sqlite3_value_int(sqlite3_value *);

///|
pub extern "C" fn sqlite3_value_int(value : Sqlite3_value) -> Int = "sqlite3_value_int"

//int sqlite3_value_nochange(sqlite3_value *);

///|
pub extern "C" fn sqlite3_value_nochange(value : Sqlite3_value) -> Int = "sqlite3_value_nochange"

//int sqlite3_value_numeric_type(sqlite3_value *);

///|
pub extern "C" fn sqlite3_value_numeric_type(value : Sqlite3_value) -> Int = "sqlite3_value_numeric_type"

//int sqlite3_value_type(sqlite3_value *);

///|
pub extern "C" fn sqlite3_value_type(value : Sqlite3_value) -> Int = "sqlite3_value_type"

//int sqlite3_vfs_register(sqlite3_vfs *, int makeDflt);

///|
pub extern "C" fn sqlite3_vfs_register(
  vfs : Sqlite3_vfs,
  makeDflt : Int
) -> Int = "sqlite3_vfs_register"

//int sqlite3_vfs_unregister(sqlite3_vfs *);

///|
pub extern "C" fn sqlite3_vfs_unregister(vfs : Sqlite3_vfs) -> Int = "sqlite3_vfs_unregister"

//int sqlite3_vtab_config(sqlite3 *, int op);

///|
pub extern "C" fn sqlite3_vtab_config(db : Sqlite3, op : Int) -> Int = "sqlite3_vtab_config"

//int sqlite3_vtab_distinct(sqlite3_index_info *);

///|
pub extern "C" fn sqlite3_vtab_distinct(pIdxInfo : Sqlite3_index_info) -> Int = "sqlite3_vtab_distinct"

//int sqlite3_vtab_in(sqlite3_index_info *, int iCons, int bHandle);

///|
pub extern "C" fn sqlite3_vtab_in(
  pIdxInfo : Sqlite3_index_info,
  iCons : Int,
  bHandle : Int
) -> Int = "sqlite3_vtab_in"

//int sqlite3_vtab_in_first(sqlite3_value * pVal, sqlite3_value ** ppOut);

///|
pub extern "C" fn sqlite3_vtab_in_first(
  pVal : Sqlite3_value,
  ppOut : Ref[Sqlite3_value]
) -> Int = "sqlite3_vtab_in_first"

//int sqlite3_vtab_in_next(sqlite3_value * pVal, sqlite3_value ** ppOut);

///|
pub extern "C" fn sqlite3_vtab_in_next(
  pVal : Sqlite3_value,
  ppOut : Ref[Sqlite3_value]
) -> Int = "sqlite3_vtab_in_next"

//int sqlite3_vtab_nochange(sqlite3_context *);

///|
pub extern "C" fn sqlite3_vtab_nochange(context : Sqlite3_context) -> Int = "sqlite3_vtab_nochange"

//int sqlite3_vtab_on_conflict(sqlite3 *);

///|
pub extern "C" fn sqlite3_vtab_on_conflict(db : Sqlite3) -> Int = "sqlite3_vtab_on_conflict"

//int sqlite3_vtab_rhs_value(sqlite3_index_info *, int, sqlite3_value ** ppVal);

///|
pub extern "C" fn sqlite3_vtab_rhs_value(
  pIdxInfo : Sqlite3_index_info,
  j : Int,
  ppVal : Ref[Sqlite3_value]
) -> Int = "sqlite3_vtab_rhs_value"

//int sqlite3_wal_autocheckpoint(sqlite3 * db, int N);

///|
pub extern "C" fn sqlite3_wal_autocheckpoint(db : Sqlite3, n : Int) -> Int = "sqlite3_wal_autocheckpoint"

//int sqlite3_wal_checkpoint(sqlite3 * db, const char * zDb);

///|
pub extern "C" fn sqlite3_wal_checkpoint(db : Sqlite3, zDb : CStr) -> Int = "sqlite3_wal_checkpoint"

//int sqlite3_wal_checkpoint_v2(sqlite3 * db, const char * zDb, int eMode, int * pnLog, int * pnCkpt);

///|
pub extern "C" fn sqlite3_wal_checkpoint_v2(
  db : Sqlite3,
  zDb : CStr,
  eMode : Int,
  pnLog : AnyType,
  pnCkpt : AnyType
) -> Int = "sqlite3_wal_checkpoint_v2"

//int sqlite3_win32_set_directory(unsigned long type, void * zValue);

///|
pub extern "C" fn sqlite3_win32_set_directory(
  type_ : UInt64,
  zValue : AnyType
) -> Int = "sqlite3_win32_set_directory"

//int sqlite3_win32_set_directory16(unsigned long type, const void * zValue);

///|
pub extern "C" fn sqlite3_win32_set_directory16(
  type_ : UInt64,
  zValue : AnyType
) -> Int = "sqlite3_win32_set_directory16"

//int sqlite3_win32_set_directory8(unsigned long type, const char * zValue);

///|
pub extern "C" fn sqlite3_win32_set_directory8(
  type_ : UInt64,
  zValue : CStr
) -> Int = "sqlite3_win32_set_directory8"

//sqlite3 * sqlite3_context_db_handle(sqlite3_context *);

///|
pub extern "C" fn sqlite3_context_db_handle(
  context : Sqlite3_context
) -> Sqlite3 = "sqlite3_context_db_handle"

//sqlite3 * sqlite3_db_handle(sqlite3_stmt *);

///|
pub extern "C" fn sqlite3_db_handle(pStmt : Sqlite3_stmt) -> Sqlite3 = "sqlite3_db_handle"

//sqlite3_backup * sqlite3_backup_init(sqlite3 * pDest, const char * zDestName, sqlite3 * pSource, const char * zSourceName);

///|
pub extern "C" fn sqlite3_backup_init(
  pDest : Sqlite3,
  zDestName : CStr,
  pSource : Sqlite3,
  zSourceName : CStr
) -> Sqlite3_backup = "sqlite3_backup_init"

//sqlite3_file * sqlite3_database_file_object(const char *);

///|
pub extern "C" fn sqlite3_database_file_object(zName : CStr) -> Sqlite3_file = "sqlite3_database_file_object"

//sqlite3_filename sqlite3_create_filename(const char * zDatabase, const char * zJournal, const char * zWal, int nParam, const char ** azParam);

///|
pub extern "C" fn sqlite3_create_filename(
  zDatabase : CStr,
  zJournal : CStr,
  zWal : CStr,
  nParam : Int,
  azParam : FixedArray[CStr]
) -> Sqlite3_filename = "sqlite3_create_filename"

//sqlite3_filename sqlite3_db_filename(sqlite3 * db, const char * zDbName);

///|
pub extern "C" fn sqlite3_db_filename(
  db : Sqlite3,
  zDbName : CStr
) -> Sqlite3_filename = "sqlite3_db_filename"

//sqlite3_int64 sqlite3_changes64(sqlite3 *);

///|
pub extern "C" fn sqlite3_changes64(db : Sqlite3) -> Int64 = "sqlite3_changes64"

//sqlite3_int64 sqlite3_column_int64(sqlite3_stmt *, int iCol);

///|
pub extern "C" fn sqlite3_column_int64(
  pStmt : Sqlite3_stmt,
  iCol : Int
) -> Int64 = "sqlite3_column_int64"

//sqlite3_int64 sqlite3_hard_heap_limit64(sqlite3_int64 N);

///|
pub extern "C" fn sqlite3_hard_heap_limit64(n : Int64) -> Int64 = "sqlite3_hard_heap_limit64"

//sqlite3_int64 sqlite3_last_insert_rowid(sqlite3 *);

///|
pub extern "C" fn sqlite3_last_insert_rowid(db : Sqlite3) -> Int64 = "sqlite3_last_insert_rowid"

//sqlite3_int64 sqlite3_memory_highwater(int resetFlag);

///|
pub extern "C" fn sqlite3_memory_highwater(resetFlag : Int) -> Int64 = "sqlite3_memory_highwater"

//sqlite3_int64 sqlite3_memory_used();

///|
pub extern "C" fn sqlite3_memory_used() -> Int64 = "sqlite3_memory_used"

//sqlite3_int64 sqlite3_soft_heap_limit64(sqlite3_int64 N);

///|
pub extern "C" fn sqlite3_soft_heap_limit64(n : Int64) -> Int64 = "sqlite3_soft_heap_limit64"

//sqlite3_int64 sqlite3_total_changes64(sqlite3 *);

///|
pub extern "C" fn sqlite3_total_changes64(db : Sqlite3) -> Int64 = "sqlite3_total_changes64"

//sqlite3_int64 sqlite3_uri_int64(sqlite3_filename, const char *, sqlite3_int64);

///|
pub extern "C" fn sqlite3_uri_int64(
  z : Sqlite3_filename,
  zParam : CStr,
  bDefault : Int64
) -> Int64 = "sqlite3_uri_int64"

//sqlite3_int64 sqlite3_value_int64(sqlite3_value *);

///|
pub extern "C" fn sqlite3_value_int64(value : Sqlite3_value) -> Int64 = "sqlite3_value_int64"

//sqlite3_mutex * sqlite3_db_mutex(sqlite3 *);

///|
pub extern "C" fn sqlite3_db_mutex(db : Sqlite3) -> Sqlite3_mutex = "sqlite3_db_mutex"

//sqlite3_mutex * sqlite3_mutex_alloc(int);

///|
pub extern "C" fn sqlite3_mutex_alloc(id : Int) -> Sqlite3_mutex = "sqlite3_mutex_alloc"

//sqlite3_stmt * sqlite3_next_stmt(sqlite3 * pDb, sqlite3_stmt * pStmt);

///|
pub extern "C" fn sqlite3_next_stmt(
  pDb : Sqlite3,
  pStmt : Sqlite3_stmt
) -> Sqlite3_stmt = "sqlite3_next_stmt"

//sqlite3_str * sqlite3_str_new(sqlite3 *);

///|
pub extern "C" fn sqlite3_str_new(db : Sqlite3) -> Sqlite3_str = "sqlite3_str_new"

//sqlite3_uint64 sqlite3_msize(void *);

///|
pub extern "C" fn sqlite3_msize(p : AnyType) -> UInt64 = "sqlite3_msize"

//sqlite3_value * sqlite3_column_value(sqlite3_stmt *, int iCol);

///|
pub extern "C" fn sqlite3_column_value(
  pStmt : Sqlite3_stmt,
  iCol : Int
) -> Sqlite3_value = "sqlite3_column_value"

//sqlite3_value * sqlite3_value_dup(const sqlite3_value *);

///|
pub extern "C" fn sqlite3_value_dup(pOrig : Sqlite3_value) -> Sqlite3_value = "sqlite3_value_dup"

//sqlite3_vfs * sqlite3_vfs_find(const char * zVfsName);

///|
pub extern "C" fn sqlite3_vfs_find(zVfsName : CStr) -> Sqlite3_vfs = "sqlite3_vfs_find"
//unsigned char * sqlite3_serialize(sqlite3 * db, const char * zSchema, sqlite3_int64 * piSize, unsigned int mFlags);

///|
pub extern "C" fn sqlite3_serialize(
  db : Sqlite3,
  zSchema : CStr,
  piSize : AnyType,
  mFlags : UInt
) -> CStr = "sqlite3_serialize"

//unsigned int sqlite3_value_subtype(sqlite3_value *);

///|
pub extern "C" fn sqlite3_value_subtype(value : Sqlite3_value) -> UInt = "sqlite3_value_subtype"
//void * sqlite3_aggregate_context(sqlite3_context *, int nBytes);

///|
pub extern "C" fn sqlite3_aggregate_context(
  context : Sqlite3_context,
  nBytes : Int
) -> AnyType = "sqlite3_aggregate_context"

//void * sqlite3_commit_hook(sqlite3 *, int (*)(void *), void *);

///|
pub extern "C" fn sqlite3_commit_hook(
  db : Sqlite3,
  xCallback : FuncRef[(AnyType) -> Int],
  pArg : AnyType
) -> AnyType = "sqlite3_commit_hook"

//void * sqlite3_get_auxdata(sqlite3_context *, int N);

///|
pub extern "C" fn sqlite3_get_auxdata(
  context : Sqlite3_context,
  n : Int
) -> AnyType = "sqlite3_get_auxdata"

//void * sqlite3_get_clientdata(sqlite3 *, const char *);

///|
pub extern "C" fn sqlite3_get_clientdata(db : Sqlite3, zName : CStr) -> AnyType = "sqlite3_get_clientdata"

//void * sqlite3_malloc(int);

///|
pub extern "C" fn sqlite3_malloc(n : Int) -> AnyType = "sqlite3_malloc"

//void * sqlite3_malloc64(sqlite3_uint64);

///|
pub extern "C" fn sqlite3_malloc64(n : UInt64) -> AnyType = "sqlite3_malloc64"

//void * sqlite3_profile(sqlite3 *, void (*)(void *, const char *, sqlite3_uint64) xProfile, void *);

///|
pub extern "C" fn sqlite3_profile(
  db : Sqlite3,
  xProfile : FuncRef[(AnyType, CStr, UInt64) -> Unit],
  pArg : AnyType
) -> AnyType = "sqlite3_profile"

//void * sqlite3_realloc(void *, int);

///|
pub extern "C" fn sqlite3_realloc(pOld : AnyType, n : Int) -> AnyType = "sqlite3_realloc"

//void * sqlite3_realloc64(void *, sqlite3_uint64);

///|
pub extern "C" fn sqlite3_realloc64(pOld : AnyType, n : UInt64) -> AnyType = "sqlite3_realloc64"

//void * sqlite3_rollback_hook(sqlite3 *, void (*)(void *), void *);

///|
pub extern "C" fn sqlite3_rollback_hook(
  db : Sqlite3,
  xCallback : FuncRef[(AnyType) -> Unit],
  pArg : AnyType
) -> AnyType = "sqlite3_rollback_hook"

//void * sqlite3_trace(sqlite3 *, void (*)(void *, const char *) xTrace, void *);

///|
pub extern "C" fn sqlite3_trace(
  db : Sqlite3,
  xTrace : FuncRef[(AnyType, CStr) -> Unit],
  pArg : AnyType
) -> AnyType = "sqlite3_trace"

//void * sqlite3_update_hook(sqlite3 *, void (*)(void *, int, const char *, const char *, sqlite3_int64), void *);

///|
pub extern "C" fn sqlite3_update_hook(
  db : Sqlite3,
  xCallback : FuncRef[(AnyType, Int, CStr, CStr, Int64) -> Unit],
  pArg : AnyType
) -> AnyType = "sqlite3_update_hook"

//void * sqlite3_user_data(sqlite3_context *);

///|
pub extern "C" fn sqlite3_user_data(context : Sqlite3_context) -> AnyType = "sqlite3_user_data"

//void * sqlite3_value_pointer(sqlite3_value *, const char *);

///|
pub extern "C" fn sqlite3_value_pointer(
  value : Sqlite3_value,
  zPType : CStr
) -> AnyType = "sqlite3_value_pointer"

//void * sqlite3_wal_hook(sqlite3 *, int (*)(void *, sqlite3 *, const char *, int), void *);

///|
pub extern "C" fn sqlite3_wal_hook(
  db : Sqlite3,
  xCallback : FuncRef[(AnyType, Sqlite3, CStr, Int) -> Int],
  pArg : AnyType
) -> AnyType = "sqlite3_wal_hook"

//void sqlite3_free(void *);

///|
pub extern "C" fn sqlite3_free(p : AnyType) -> Unit = "sqlite3_free"

//void sqlite3_free_filename(sqlite3_filename);

///|
pub extern "C" fn sqlite3_free_filename(filename : Sqlite3_filename) -> Unit = "sqlite3_free_filename"

//void sqlite3_free_table(char ** result);

///|
pub extern "C" fn sqlite3_free_table(result : Ref[CStr]) -> Unit = "sqlite3_free_table"

//void sqlite3_interrupt(sqlite3 *);

///|
pub extern "C" fn sqlite3_interrupt(db : Sqlite3) -> Unit = "sqlite3_interrupt"

//void sqlite3_log(int iErrCode, const char * zFormat);

///|
pub extern "C" fn sqlite3_log(iErrCode : Int, zFormat : CStr) -> Unit = "sqlite3_log"

//void sqlite3_mutex_enter(sqlite3_mutex *);

///|
pub extern "C" fn sqlite3_mutex_enter(mutex : Sqlite3_mutex) -> Unit = "sqlite3_mutex_enter"

//void sqlite3_mutex_free(sqlite3_mutex *);

///|
pub extern "C" fn sqlite3_mutex_free(mutex : Sqlite3_mutex) -> Unit = "sqlite3_mutex_free"

//void sqlite3_mutex_leave(sqlite3_mutex *);

///|
pub extern "C" fn sqlite3_mutex_leave(mutex : Sqlite3_mutex) -> Unit = "sqlite3_mutex_leave"

//void sqlite3_progress_handler(sqlite3 *, int, int (*)(void *), void *);

///|
pub extern "C" fn sqlite3_progress_handler(
  db : Sqlite3,
  n : Int,
  xProgress : FuncRef[(AnyType) -> Int],
  pArg : AnyType
) -> Unit = "sqlite3_progress_handler"

//void sqlite3_randomness(int N, void * P);

///|
pub extern "C" fn sqlite3_randomness(n : Int, p : AnyType) -> Unit = "sqlite3_randomness"

//void sqlite3_reset_auto_extension();

///|
pub extern "C" fn sqlite3_reset_auto_extension() -> Unit = "sqlite3_reset_auto_extension"
//void sqlite3_result_blob(sqlite3_context *, const void *, int, void (*)(void *));

///|
pub extern "C" fn sqlite3_result_blob(
  context : Sqlite3_context,
  z : AnyType,
  n : Int,
  xDel : FuncRef[(AnyType) -> Unit]
) -> Unit = "sqlite3_result_blob"

//void sqlite3_result_blob64(sqlite3_context *, const void *, sqlite3_uint64, void (*)(void *));

///|
pub extern "C" fn sqlite3_result_blob64(
  context : Sqlite3_context,
  z : AnyType,
  n : UInt64,
  xDel : FuncRef[(AnyType) -> Unit]
) -> Unit = "sqlite3_result_blob64"

//void sqlite3_result_double(sqlite3_context *, double);

///|
pub extern "C" fn sqlite3_result_double(
  context : Sqlite3_context,
  value : Double
) -> Unit = "sqlite3_result_double"

//void sqlite3_result_error(sqlite3_context *, const char *, int);

///|
pub extern "C" fn sqlite3_result_error(
  context : Sqlite3_context,
  z : CStr,
  n : Int
) -> Unit = "sqlite3_result_error"

//void sqlite3_result_error16(sqlite3_context *, const void *, int);

///|
pub extern "C" fn sqlite3_result_error16(
  context : Sqlite3_context,
  z : AnyType,
  n : Int
) -> Unit = "sqlite3_result_error16"

//void sqlite3_result_error_code(sqlite3_context *, int);

///|
pub extern "C" fn sqlite3_result_error_code(
  context : Sqlite3_context,
  errCode : Int
) -> Unit = "sqlite3_result_error_code"

//void sqlite3_result_error_nomem(sqlite3_context *);

///|
pub extern "C" fn sqlite3_result_error_nomem(context : Sqlite3_context) -> Unit = "sqlite3_result_error_nomem"

//void sqlite3_result_error_toobig(sqlite3_context *);

///|
pub extern "C" fn sqlite3_result_error_toobig(
  context : Sqlite3_context
) -> Unit = "sqlite3_result_error_toobig"

//void sqlite3_result_int(sqlite3_context *, int);

///|
pub extern "C" fn sqlite3_result_int(
  context : Sqlite3_context,
  value : Int
) -> Unit = "sqlite3_result_int"

//void sqlite3_result_int64(sqlite3_context *, sqlite3_int64);

///|
pub extern "C" fn sqlite3_result_int64(
  context : Sqlite3_context,
  value : Int64
) -> Unit = "sqlite3_result_int64"

//void sqlite3_result_null(sqlite3_context *);

///|
pub extern "C" fn sqlite3_result_null(context : Sqlite3_context) -> Unit = "sqlite3_result_null"

//void sqlite3_result_pointer(sqlite3_context *, void *, const char *, void (*)(void *));

///|
pub extern "C" fn sqlite3_result_pointer(
  context : Sqlite3_context,
  ptr : AnyType,
  zPType : CStr,
  xDestructor : FuncRef[(AnyType) -> Unit]
) -> Unit = "sqlite3_result_pointer"

//void sqlite3_result_subtype(sqlite3_context *, unsigned int);

///|
pub extern "C" fn sqlite3_result_subtype(
  context : Sqlite3_context,
  subtype : UInt
) -> Unit = "sqlite3_result_subtype"

//void sqlite3_result_text(sqlite3_context *, const char *, int, void (*)(void *));

///|
pub extern "C" fn sqlite3_result_text(
  context : Sqlite3_context,
  z : CStr,
  n : Int,
  xDel : FuncRef[(AnyType) -> Unit]
) -> Unit = "sqlite3_result_text"

//void sqlite3_result_text16(sqlite3_context *, const void *, int, void (*)(void *));

///|
pub extern "C" fn sqlite3_result_text16(
  context : Sqlite3_context,
  z : AnyType,
  n : Int,
  xDel : FuncRef[(AnyType) -> Unit]
) -> Unit = "sqlite3_result_text16"

//void sqlite3_result_text16be(sqlite3_context *, const void *, int, void (*)(void *));

///|
pub extern "C" fn sqlite3_result_text16be(
  context : Sqlite3_context,
  z : AnyType,
  n : Int,
  xDel : FuncRef[(AnyType) -> Unit]
) -> Unit = "sqlite3_result_text16be"

//void sqlite3_result_text16le(sqlite3_context *, const void *, int, void (*)(void *));

///|
pub extern "C" fn sqlite3_result_text16le(
  context : Sqlite3_context,
  z : AnyType,
  n : Int,
  xDel : FuncRef[(AnyType) -> Unit]
) -> Unit = "sqlite3_result_text16le"

//void sqlite3_result_text64(sqlite3_context *, const char *, sqlite3_uint64, void (*)(void *), unsigned char encoding);

///|
pub extern "C" fn sqlite3_result_text64(
  context : Sqlite3_context,
  z : CStr,
  n : UInt64,
  xDel : FuncRef[(AnyType) -> Unit],
  encoding : Byte
) -> Unit = "sqlite3_result_text64"

//void sqlite3_result_value(sqlite3_context *, sqlite3_value *);

///|
pub extern "C" fn sqlite3_result_value(
  context : Sqlite3_context,
  value : Sqlite3_value
) -> Unit = "sqlite3_result_value"

//void sqlite3_result_zeroblob(sqlite3_context *, int n);

///|
pub extern "C" fn sqlite3_result_zeroblob(
  context : Sqlite3_context,
  n : Int
) -> Unit = "sqlite3_result_zeroblob"
//void sqlite3_set_auxdata(sqlite3_context *, int N, void *, void (*)(void *));

///|
pub extern "C" fn sqlite3_set_auxdata(
  context : Sqlite3_context,
  n : Int,
  data : AnyType,
  xDelete : FuncRef[(AnyType) -> Unit]
) -> Unit = "sqlite3_set_auxdata"

//void sqlite3_set_last_insert_rowid(sqlite3 *, sqlite3_int64);

///|
pub extern "C" fn sqlite3_set_last_insert_rowid(
  db : Sqlite3,
  rowid : Int64
) -> Unit = "sqlite3_set_last_insert_rowid"

//void sqlite3_snapshot_free(sqlite3_snapshot *);

///|
pub extern "C" fn sqlite3_snapshot_free(snapshot : Sqlite3_snapshot) -> Unit = "sqlite3_snapshot_free"

//void sqlite3_soft_heap_limit(int N);

///|
pub extern "C" fn sqlite3_soft_heap_limit(n : Int) -> Unit = "sqlite3_soft_heap_limit"

//void sqlite3_stmt_scanstatus_reset(sqlite3_stmt *);

///|
pub extern "C" fn sqlite3_stmt_scanstatus_reset(pStmt : Sqlite3_stmt) -> Unit = "sqlite3_stmt_scanstatus_reset"

//void sqlite3_str_append(sqlite3_str *, const char * zIn, int N);

///|
pub extern "C" fn sqlite3_str_append(
  pStr : Sqlite3_str,
  zIn : CStr,
  n : Int
) -> Unit = "sqlite3_str_append"

//void sqlite3_str_appendall(sqlite3_str *, const char * zIn);

///|
pub extern "C" fn sqlite3_str_appendall(pStr : Sqlite3_str, zIn : CStr) -> Unit = "sqlite3_str_appendall"

//void sqlite3_str_appendchar(sqlite3_str *, int N, char C);

///|
pub extern "C" fn sqlite3_str_appendchar(
  pStr : Sqlite3_str,
  n : Int,
  c : Byte
) -> Unit = "sqlite3_str_appendchar"

//void sqlite3_str_appendf(sqlite3_str *, const char * zFormat);

///|
pub extern "C" fn sqlite3_str_appendf(
  pStr : Sqlite3_str,
  zFormat : CStr
) -> Unit = "sqlite3_str_appendf"

//void sqlite3_str_reset(sqlite3_str *);

///|
pub extern "C" fn sqlite3_str_reset(pStr : Sqlite3_str) -> Unit = "sqlite3_str_reset"

//void sqlite3_str_vappendf(sqlite3_str *, const char * zFormat, int);

///|
pub extern "C" fn sqlite3_str_vappendf(
  pStr : Sqlite3_str,
  zFormat : CStr,
  n : Int
) -> Unit = "sqlite3_str_vappendf"

//void sqlite3_thread_cleanup();

///|
pub extern "C" fn sqlite3_thread_cleanup() -> Unit = "sqlite3_thread_cleanup"

//void sqlite3_value_free(sqlite3_value *);

///|
pub extern "C" fn sqlite3_value_free(value : Sqlite3_value) -> Unit = "sqlite3_value_free"
