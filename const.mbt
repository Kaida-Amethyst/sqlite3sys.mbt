///| Successful result
pub const SQLITE_OK : Int = 0

///| Generic error
pub const SQLITE_ERROR : Int = 1

///| Internal logic error in SQLite
pub const SQLITE_INTERNAL : Int = 2

///| Access permission denied
pub const SQLITE_PERM : Int = 3

///| Callback routine requested an abort
pub const SQLITE_ABORT : Int = 4

///| The database file is locked
pub const SQLITE_BUSY : Int = 5

///| A table in the database is locked
pub const SQLITE_LOCKED : Int = 6

///| A malloc() failed
pub const SQLITE_NOMEM : Int = 7

///| Attempt to write a readonly database
pub const SQLITE_READONLY : Int = 8

///| Operation terminated by sqlite3_interrupt()
pub const SQLITE_INTERRUPT : Int = 9

///| Some kind of disk I/O error occurred
pub const SQLITE_IOERR : Int = 10

///| The database disk image is malformed
pub const SQLITE_CORRUPT : Int = 11

///| Unknown opcode in sqlite3_file_control()
pub const SQLITE_NOTFOUND : Int = 12

///| Insertion failed because database is full
pub const SQLITE_FULL : Int = 13

///| Unable to open the database file
pub const SQLITE_CANTOPEN : Int = 14

///| Database lock protocol error
pub const SQLITE_PROTOCOL : Int = 15

///| Internal use only
pub const SQLITE_EMPTY : Int = 16

///| The database schema changed
pub const SQLITE_SCHEMA : Int = 17

///| String or BLOB exceeds size limit
pub const SQLITE_TOOBIG : Int = 18

///| Abort due to constraint violation
pub const SQLITE_CONSTRAINT : Int = 19

///| Data type mismatch
pub const SQLITE_MISMATCH : Int = 20

///| Library used incorrectly
pub const SQLITE_MISUSE : Int = 21

///| Uses OS features not supported on host
pub const SQLITE_NOLFS : Int = 22

///| Authorization denied
pub const SQLITE_AUTH : Int = 23

///| Not used
pub const SQLITE_FORMAT : Int = 24

///| 2nd parameter to sqlite3_bind out of range
pub const SQLITE_RANGE : Int = 25

///| File opened that is not a database file
pub const SQLITE_NOTADB : Int = 26

///| Notifications and warnings
pub const SQLITE_NOTICE : Int = 27

///| Warnings from sqlite3_log()
pub const SQLITE_WARNING : Int = 28

///| sqlite3_step() has another row ready
pub const SQLITE_ROW : Int = 100

///| sqlite3_step() has finished executing
pub const SQLITE_DONE : Int = 101
//

///|
pub const SQLITE_ERROR_MISSING_COLLSEQ : Int = SQLITE_ERROR | (1 << 8)

///|
pub const SQLITE_ERROR_RETRY : Int = SQLITE_ERROR | (2 << 8)

///|
pub const SQLITE_ERROR_SNAPSHOT : Int = SQLITE_ERROR | (3 << 8)

///|
pub const SQLITE_IOERR_READ : Int = SQLITE_IOERR | (1 << 8)

///|
pub const SQLITE_IOERR_SHORT_READ : Int = SQLITE_IOERR | (2 << 8)

///|
pub const SQLITE_IOERR_WRITE : Int = SQLITE_IOERR | (3 << 8)

///|
pub const SQLITE_IOERR_FSYNC : Int = SQLITE_IOERR | (4 << 8)

///|
pub const SQLITE_IOERR_DIR_FSYNC : Int = SQLITE_IOERR | (5 << 8)

///|
pub const SQLITE_IOERR_TRUNCATE : Int = SQLITE_IOERR | (6 << 8)

///|
pub const SQLITE_IOERR_FSTAT : Int = SQLITE_IOERR | (7 << 8)

///|
pub const SQLITE_IOERR_UNLOCK : Int = SQLITE_IOERR | (8 << 8)

///|
pub const SQLITE_IOERR_RDLOCK : Int = SQLITE_IOERR | (9 << 8)

///|
pub const SQLITE_IOERR_DELETE : Int = SQLITE_IOERR | (10 << 8)

///|
pub const SQLITE_IOERR_BLOCKED : Int = SQLITE_IOERR | (11 << 8)

///|
pub const SQLITE_IOERR_NOMEM : Int = SQLITE_IOERR | (12 << 8)

///|
pub const SQLITE_IOERR_ACCESS : Int = SQLITE_IOERR | (13 << 8)

///|
pub const SQLITE_IOERR_CHECKRESERVEDLOCK : Int = SQLITE_IOERR | (14 << 8)

///|
pub const SQLITE_IOERR_LOCK : Int = SQLITE_IOERR | (15 << 8)

///|
pub const SQLITE_IOERR_CLOSE : Int = SQLITE_IOERR | (16 << 8)

///|
pub const SQLITE_IOERR_DIR_CLOSE : Int = SQLITE_IOERR | (17 << 8)

///|
pub const SQLITE_IOERR_SHMOPEN : Int = SQLITE_IOERR | (18 << 8)

///|
pub const SQLITE_IOERR_SHMSIZE : Int = SQLITE_IOERR | (19 << 8)

///|
pub const SQLITE_IOERR_SHMLOCK : Int = SQLITE_IOERR | (20 << 8)

///|
pub const SQLITE_IOERR_SHMMAP : Int = SQLITE_IOERR | (21 << 8)

///|
pub const SQLITE_IOERR_SEEK : Int = SQLITE_IOERR | (22 << 8)

///|
pub const SQLITE_IOERR_DELETE_NOENT : Int = SQLITE_IOERR | (23 << 8)

///|
pub const SQLITE_IOERR_MMAP : Int = SQLITE_IOERR | (24 << 8)

///|
pub const SQLITE_IOERR_GETTEMPPATH : Int = SQLITE_IOERR | (25 << 8)

///|
pub const SQLITE_IOERR_CONVPATH : Int = SQLITE_IOERR | (26 << 8)

///|
pub const SQLITE_IOERR_VNODE : Int = SQLITE_IOERR | (27 << 8)

///|
pub const SQLITE_IOERR_AUTH : Int = SQLITE_IOERR | (28 << 8)

///|
pub const SQLITE_IOERR_BEGIN_ATOMIC : Int = SQLITE_IOERR | (29 << 8)

///|
pub const SQLITE_IOERR_COMMIT_ATOMIC : Int = SQLITE_IOERR | (30 << 8)

///|
pub const SQLITE_IOERR_ROLLBACK_ATOMIC : Int = SQLITE_IOERR | (31 << 8)

///|
pub const SQLITE_IOERR_DATA : Int = SQLITE_IOERR | (32 << 8)

///|
pub const SQLITE_IOERR_CORRUPTFS : Int = SQLITE_IOERR | (33 << 8)

///|
pub const SQLITE_IOERR_IN_PAGE : Int = SQLITE_IOERR | (34 << 8)

///|
pub const SQLITE_LOCKED_SHAREDCACHE : Int = SQLITE_LOCKED | (1 << 8)

///|
pub const SQLITE_LOCKED_VTAB : Int = SQLITE_LOCKED | (2 << 8)

///|
pub const SQLITE_BUSY_RECOVERY : Int = SQLITE_BUSY | (1 << 8)

///|
pub const SQLITE_BUSY_SNAPSHOT : Int = SQLITE_BUSY | (2 << 8)

///|
pub const SQLITE_BUSY_TIMEOUT : Int = SQLITE_BUSY | (3 << 8)

///|
pub const SQLITE_CANTOPEN_NOTEMPDIR : Int = SQLITE_CANTOPEN | (1 << 8)

///|
pub const SQLITE_CANTOPEN_ISDIR : Int = SQLITE_CANTOPEN | (2 << 8)

///|
pub const SQLITE_CANTOPEN_FULLPATH : Int = SQLITE_CANTOPEN | (3 << 8)

///|
pub const SQLITE_CANTOPEN_CONVPATH : Int = SQLITE_CANTOPEN | (4 << 8)

///|
pub const SQLITE_CANTOPEN_DIRTYWAL : Int = SQLITE_CANTOPEN | (5 << 8)

///|
pub const SQLITE_CANTOPEN_SYMLINK : Int = SQLITE_CANTOPEN | (6 << 8)

///|
pub const SQLITE_CORRUPT_VTAB : Int = SQLITE_CORRUPT | (1 << 8)

///|
pub const SQLITE_CORRUPT_SEQUENCE : Int = SQLITE_CORRUPT | (2 << 8)

///|
pub const SQLITE_CORRUPT_INDEX : Int = SQLITE_CORRUPT | (3 << 8)

///|
pub const SQLITE_READONLY_RECOVERY : Int = SQLITE_READONLY | (1 << 8)

///|
pub const SQLITE_READONLY_CANTLOCK : Int = SQLITE_READONLY | (2 << 8)

///|
pub const SQLITE_READONLY_ROLLBACK : Int = SQLITE_READONLY | (3 << 8)

///|
pub const SQLITE_READONLY_DBMOVED : Int = SQLITE_READONLY | (4 << 8)

///|
pub const SQLITE_READONLY_CANTINIT : Int = SQLITE_READONLY | (5 << 8)

///|
pub const SQLITE_READONLY_DIRECTORY : Int = SQLITE_READONLY | (6 << 8)

///|
pub const SQLITE_ABORT_ROLLBACK : Int = SQLITE_ABORT | (2 << 8)

///|
pub const SQLITE_CONSTRAINT_CHECK : Int = SQLITE_CONSTRAINT | (1 << 8)

///|
pub const SQLITE_CONSTRAINT_COMMITHOOK : Int = SQLITE_CONSTRAINT | (2 << 8)

///|
pub const SQLITE_CONSTRAINT_FOREIGNKEY : Int = SQLITE_CONSTRAINT | (3 << 8)

///|
pub const SQLITE_CONSTRAINT_FUNCTION : Int = SQLITE_CONSTRAINT | (4 << 8)

///|
pub const SQLITE_CONSTRAINT_NOTNULL : Int = SQLITE_CONSTRAINT | (5 << 8)

///|
pub const SQLITE_CONSTRAINT_PRIMARYKEY : Int = SQLITE_CONSTRAINT | (6 << 8)

///|
pub const SQLITE_CONSTRAINT_TRIGGER : Int = SQLITE_CONSTRAINT | (7 << 8)

///|
pub const SQLITE_CONSTRAINT_UNIQUE : Int = SQLITE_CONSTRAINT | (8 << 8)

///|
pub const SQLITE_CONSTRAINT_VTAB : Int = SQLITE_CONSTRAINT | (9 << 8)

///|
pub const SQLITE_CONSTRAINT_ROWID : Int = SQLITE_CONSTRAINT | (10 << 8)

///|
pub const SQLITE_CONSTRAINT_PINNED : Int = SQLITE_CONSTRAINT | (11 << 8)

///|
pub const SQLITE_CONSTRAINT_DATATYPE : Int = SQLITE_CONSTRAINT | (12 << 8)

///|
pub const SQLITE_NOTICE_RECOVER_WAL : Int = SQLITE_NOTICE | (1 << 8)

///|
pub const SQLITE_NOTICE_RECOVER_ROLLBACK : Int = SQLITE_NOTICE | (2 << 8)

///|
pub const SQLITE_NOTICE_RBU : Int = SQLITE_NOTICE | (3 << 8)

///|
pub const SQLITE_WARNING_AUTOINDEX : Int = SQLITE_WARNING | (1 << 8)

///|
pub const SQLITE_AUTH_USER : Int = SQLITE_AUTH | (1 << 8)

///|
pub const SQLITE_OK_LOAD_PERMANENTLY : Int = SQLITE_OK | (1 << 8)

///|
pub const SQLITE_OK_SYMLINK : Int = SQLITE_OK | (2 << 8)

///|
pub const SQLITE_OPEN_READONLY : Int = 0x00000001

///|
pub const SQLITE_OPEN_READWRITE : Int = 0x00000002

///|
pub const SQLITE_OPEN_CREATE : Int = 0x00000004

///|
pub const SQLITE_OPEN_DELETEONCLOSE : Int = 0x00000008

///|
pub const SQLITE_OPEN_EXCLUSIVE : Int = 0x00000010

///|
pub const SQLITE_OPEN_AUTOPROXY : Int = 0x00000020

///|
pub const SQLITE_OPEN_URI : Int = 0x00000040

///|
pub const SQLITE_OPEN_MEMORY : Int = 0x00000080

///|
pub const SQLITE_OPEN_MAIN_DB : Int = 0x00000100

///|
pub const SQLITE_OPEN_TEMP_DB : Int = 0x00000200

///|
pub const SQLITE_OPEN_TRANSIENT_DB : Int = 0x00000400

///|
pub const SQLITE_OPEN_MAIN_JOURNAL : Int = 0x00000800

///|
pub const SQLITE_OPEN_TEMP_JOURNAL : Int = 0x00001000

///|
pub const SQLITE_OPEN_SUBJOURNAL : Int = 0x00002000

///|
pub const SQLITE_OPEN_SUPER_JOURNAL : Int = 0x00004000

///|
pub const SQLITE_OPEN_NOMUTEX : Int = 0x00008000

///|
pub const SQLITE_OPEN_FULLMUTEX : Int = 0x00010000

///|
pub const SQLITE_OPEN_SHAREDCACHE : Int = 0x00020000

///|
pub const SQLITE_OPEN_PRIVATECACHE : Int = 0x00040000

///|
pub const SQLITE_OPEN_WAL : Int = 0x00080000

///|
pub const SQLITE_OPEN_NOFOLLOW : Int = 0x01000000

///|
pub const SQLITE_OPEN_EXRESCODE : Int = 0x02000000

///|
pub const SQLITE_OPEN_MASTER_JOURNAL : Int = 0x00004000

///|
pub const SQLITE_IOCAP_ATOMIC : Int = 0x00000001

///|
pub const SQLITE_IOCAP_ATOMIC512 : Int = 0x00000002

///|
pub const SQLITE_IOCAP_ATOMIC1K : Int = 0x00000004

///|
pub const SQLITE_IOCAP_ATOMIC2K : Int = 0x00000008

///|
pub const SQLITE_IOCAP_ATOMIC4K : Int = 0x00000010

///|
pub const SQLITE_IOCAP_ATOMIC8K : Int = 0x00000020

///|
pub const SQLITE_IOCAP_ATOMIC16K : Int = 0x00000040

///|
pub const SQLITE_IOCAP_ATOMIC32K : Int = 0x00000080

///|
pub const SQLITE_IOCAP_ATOMIC64K : Int = 0x00000100

///|
pub const SQLITE_IOCAP_SAFE_APPEND : Int = 0x00000200

///|
pub const SQLITE_IOCAP_SEQUENTIAL : Int = 0x00000400

///|
pub const SQLITE_IOCAP_UNDELETABLE_WHEN_OPEN : Int = 0x00000800

///|
pub const SQLITE_IOCAP_POWERSAFE_OVERWRITE : Int = 0x00001000

///|
pub const SQLITE_IOCAP_IMMUTABLE : Int = 0x00002000

///|
pub const SQLITE_IOCAP_BATCH_ATOMIC : Int = 0x00004000

///|
pub const SQLITE_IOCAP_SUBPAGE_READ : Int = 0x00008000

///|
pub const SQLITE_LOCK_NONE : Int = 0

///|
pub const SQLITE_LOCK_SHARED : Int = 1

///|
pub const SQLITE_LOCK_RESERVED : Int = 2

///|
pub const SQLITE_LOCK_PENDING : Int = 3

///|
pub const SQLITE_LOCK_EXCLUSIVE : Int = 4

///|
pub const SQLITE_SYNC_NORMAL : Int = 0x00002

///|
pub const SQLITE_SYNC_FULL : Int = 0x00003

///|
pub const SQLITE_SYNC_DATAONLY : Int = 0x00010

///|
pub const SQLITE_FCNTL_LOCKSTATE : Int = 1

///|
pub const SQLITE_FCNTL_GET_LOCKPROXYFILE : Int = 2

///|
pub const SQLITE_FCNTL_SET_LOCKPROXYFILE : Int = 3

///|
pub const SQLITE_FCNTL_LAST_ERRNO : Int = 4

///|
pub const SQLITE_FCNTL_SIZE_HINT : Int = 5

///|
pub const SQLITE_FCNTL_CHUNK_SIZE : Int = 6

///|
pub const SQLITE_FCNTL_FILE_POINTER : Int = 7

///|
pub const SQLITE_FCNTL_SYNC_OMITTED : Int = 8

///|
pub const SQLITE_FCNTL_WIN32_AV_RETRY : Int = 9

///|
pub const SQLITE_FCNTL_PERSIST_WAL : Int = 10

///|
pub const SQLITE_FCNTL_OVERWRITE : Int = 11

///|
pub const SQLITE_FCNTL_VFSNAME : Int = 12

///|
pub const SQLITE_FCNTL_POWERSAFE_OVERWRITE : Int = 13

///|
pub const SQLITE_FCNTL_PRAGMA : Int = 14

///|
pub const SQLITE_FCNTL_BUSYHANDLER : Int = 15

///|
pub const SQLITE_FCNTL_TEMPFILENAME : Int = 16

///|
pub const SQLITE_FCNTL_MMAP_SIZE : Int = 18

///|
pub const SQLITE_FCNTL_TRACE : Int = 19

///|
pub const SQLITE_FCNTL_HAS_MOVED : Int = 20

///|
pub const SQLITE_FCNTL_SYNC : Int = 21

///|
pub const SQLITE_FCNTL_COMMIT_PHASETWO : Int = 22

///|
pub const SQLITE_FCNTL_WIN32_SET_HANDLE : Int = 23

///|
pub const SQLITE_FCNTL_WAL_BLOCK : Int = 24

///|
pub const SQLITE_FCNTL_ZIPVFS : Int = 25

///|
pub const SQLITE_FCNTL_RBU : Int = 26

///|
pub const SQLITE_FCNTL_VFS_POINTER : Int = 27

///|
pub const SQLITE_FCNTL_JOURNAL_POINTER : Int = 28

///|
pub const SQLITE_FCNTL_WIN32_GET_HANDLE : Int = 29

///|
pub const SQLITE_FCNTL_PDB : Int = 30

///|
pub const SQLITE_FCNTL_BEGIN_ATOMIC_WRITE : Int = 31

///|
pub const SQLITE_FCNTL_COMMIT_ATOMIC_WRITE : Int = 32

///|
pub const SQLITE_FCNTL_ROLLBACK_ATOMIC_WRITE : Int = 33

///|
pub const SQLITE_FCNTL_LOCK_TIMEOUT : Int = 34

///|
pub const SQLITE_FCNTL_DATA_VERSION : Int = 35

///|
pub const SQLITE_FCNTL_SIZE_LIMIT : Int = 36

///|
pub const SQLITE_FCNTL_CKPT_DONE : Int = 37

///|
pub const SQLITE_FCNTL_RESERVE_BYTES : Int = 38

///|
pub const SQLITE_FCNTL_CKPT_START : Int = 39

///|
pub const SQLITE_FCNTL_EXTERNAL_READER : Int = 40

///|
pub const SQLITE_FCNTL_CKSM_FILE : Int = 41

///|
pub const SQLITE_FCNTL_RESET_CACHE : Int = 42

///|
pub const SQLITE_FCNTL_NULL_IO : Int = 43

///|
pub const SQLITE_FCNTL_BLOCK_ON_CONNECT : Int = 44

///|
pub const SQLITE_GET_LOCKPROXYFILE : Int = SQLITE_FCNTL_GET_LOCKPROXYFILE

///|
pub const SQLITE_SET_LOCKPROXYFILE : Int = SQLITE_FCNTL_SET_LOCKPROXYFILE

///|
pub const SQLITE_LAST_ERRNO : Int = SQLITE_FCNTL_LAST_ERRNO

///|
pub const SQLITE_ACCESS_EXISTS : Int = 0

///|
pub const SQLITE_ACCESS_READWRITE : Int = 1

///|
pub const SQLITE_ACCESS_READ : Int = 2

///|
pub const SQLITE_SHM_UNLOCK : Int = 1

///|
pub const SQLITE_SHM_LOCK : Int = 2

///|
pub const SQLITE_SHM_SHARED : Int = 4

///|
pub const SQLITE_SHM_EXCLUSIVE : Int = 8

///|
pub const SQLITE_SHM_NLOCK : Int = 8

///|
pub const SQLITE_CONFIG_SINGLETHREAD : Int = 1

///|
pub const SQLITE_CONFIG_MULTITHREAD : Int = 2

///|
pub const SQLITE_CONFIG_SERIALIZED : Int = 3

///|
pub const SQLITE_CONFIG_MALLOC : Int = 4

///|
pub const SQLITE_CONFIG_GETMALLOC : Int = 5

///|
pub const SQLITE_CONFIG_SCRATCH : Int = 6

///|
pub const SQLITE_CONFIG_PAGECACHE : Int = 7

///|
pub const SQLITE_CONFIG_HEAP : Int = 8

///|
pub const SQLITE_CONFIG_MEMSTATUS : Int = 9

///|
pub const SQLITE_CONFIG_MUTEX : Int = 10

///|
pub const SQLITE_CONFIG_GETMUTEX : Int = 11

///|
pub const SQLITE_CONFIG_LOOKASIDE : Int = 13

///|
pub const SQLITE_CONFIG_PCACHE : Int = 14

///|
pub const SQLITE_CONFIG_GETPCACHE : Int = 15

///|
pub const SQLITE_CONFIG_LOG : Int = 16

///|
pub const SQLITE_CONFIG_URI : Int = 17

///|
pub const SQLITE_CONFIG_PCACHE2 : Int = 18

///|
pub const SQLITE_CONFIG_GETPCACHE2 : Int = 19

///|
pub const SQLITE_CONFIG_COVERING_INDEX_SCAN : Int = 20

///|
pub const SQLITE_CONFIG_SQLLOG : Int = 21

///|
pub const SQLITE_CONFIG_MMAP_SIZE : Int = 22

///|
pub const SQLITE_CONFIG_WIN32_HEAPSIZE : Int = 23

///|
pub const SQLITE_CONFIG_PCACHE_HDRSZ : Int = 24

///|
pub const SQLITE_CONFIG_PMASZ : Int = 25

///|
pub const SQLITE_CONFIG_STMTJRNL_SPILL : Int = 26

///|
pub const SQLITE_CONFIG_SMALL_MALLOC : Int = 27

///|
pub const SQLITE_CONFIG_SORTERREF_SIZE : Int = 28

///|
pub const SQLITE_CONFIG_MEMDB_MAXSIZE : Int = 29

///|
pub const SQLITE_CONFIG_ROWID_IN_VIEW : Int = 30

///|
pub const SQLITE_DBCONFIG_MAINDBNAME : Int = 1000

///|
pub const SQLITE_DBCONFIG_LOOKASIDE : Int = 1001

///|
pub const SQLITE_DBCONFIG_ENABLE_FKEY : Int = 1002

///|
pub const SQLITE_DBCONFIG_ENABLE_TRIGGER : Int = 1003

///|
pub const SQLITE_DBCONFIG_ENABLE_FTS3_TOKENIZER : Int = 1004

///|
pub const SQLITE_DBCONFIG_ENABLE_LOAD_EXTENSION : Int = 1005

///|
pub const SQLITE_DBCONFIG_NO_CKPT_ON_CLOSE : Int = 1006

///|
pub const SQLITE_DBCONFIG_ENABLE_QPSG : Int = 1007

///|
pub const SQLITE_DBCONFIG_TRIGGER_EQP : Int = 1008

///|
pub const SQLITE_DBCONFIG_RESET_DATABASE : Int = 1009

///|
pub const SQLITE_DBCONFIG_DEFENSIVE : Int = 1010

///|
pub const SQLITE_DBCONFIG_WRITABLE_SCHEMA : Int = 1011

///|
pub const SQLITE_DBCONFIG_LEGACY_ALTER_TABLE : Int = 1012

///|
pub const SQLITE_DBCONFIG_DQS_DML : Int = 1013

///|
pub const SQLITE_DBCONFIG_DQS_DDL : Int = 1014

///|
pub const SQLITE_DBCONFIG_ENABLE_VIEW : Int = 1015

///|
pub const SQLITE_DBCONFIG_LEGACY_FILE_FORMAT : Int = 1016

///|
pub const SQLITE_DBCONFIG_TRUSTED_SCHEMA : Int = 1017

///|
pub const SQLITE_DBCONFIG_STMT_SCANSTATUS : Int = 1018

///|
pub const SQLITE_DBCONFIG_REVERSE_SCANORDER : Int = 1019

///|
pub const SQLITE_DBCONFIG_ENABLE_ATTACH_CREATE : Int = 1020

///|
pub const SQLITE_DBCONFIG_ENABLE_ATTACH_WRITE : Int = 1021

///|
pub const SQLITE_DBCONFIG_ENABLE_COMMENTS : Int = 1022

///|
pub const SQLITE_DBCONFIG_MAX : Int = 1022

///|
pub const SQLITE_SETLK_BLOCK_ON_CONNECT : Int = 0x01

///|
pub const SQLITE_DENY : Int = 1

///|
pub const SQLITE_IGNORE : Int = 2

///|
pub const SQLITE_CREATE_INDEX : Int = 1

///|
pub const SQLITE_CREATE_TABLE : Int = 2

///|
pub const SQLITE_CREATE_TEMP_INDEX : Int = 3

///|
pub const SQLITE_CREATE_TEMP_TABLE : Int = 4

///|
pub const SQLITE_CREATE_TEMP_TRIGGER : Int = 5

///|
pub const SQLITE_CREATE_TEMP_VIEW : Int = 6

///|
pub const SQLITE_CREATE_TRIGGER : Int = 7

///|
pub const SQLITE_CREATE_VIEW : Int = 8

///|
pub const SQLITE_DELETE : Int = 9

///|
pub const SQLITE_DROP_INDEX : Int = 10

///|
pub const SQLITE_DROP_TABLE : Int = 11

///|
pub const SQLITE_DROP_TEMP_INDEX : Int = 12

///|
pub const SQLITE_DROP_TEMP_TABLE : Int = 13

///|
pub const SQLITE_DROP_TEMP_TRIGGER : Int = 14

///|
pub const SQLITE_DROP_TEMP_VIEW : Int = 15

///|
pub const SQLITE_DROP_TRIGGER : Int = 16

///|
pub const SQLITE_DROP_VIEW : Int = 17

///|
pub const SQLITE_INSERT : Int = 18

///|
pub const SQLITE_PRAGMA : Int = 19

///|
pub const SQLITE_READ : Int = 20

///|
pub const SQLITE_SELECT : Int = 21

///|
pub const SQLITE_TRANSACTION : Int = 22

///|
pub const SQLITE_UPDATE : Int = 23

///|
pub const SQLITE_ATTACH : Int = 24

///|
pub const SQLITE_DETACH : Int = 25

///|
pub const SQLITE_ALTER_TABLE : Int = 26

///|
pub const SQLITE_REINDEX : Int = 27

///|
pub const SQLITE_ANALYZE : Int = 28

///|
pub const SQLITE_CREATE_VTABLE : Int = 29

///|
pub const SQLITE_DROP_VTABLE : Int = 30

///|
pub const SQLITE_FUNCTION : Int = 31

///|
pub const SQLITE_SAVEPOINT : Int = 32

///|
pub const SQLITE_COPY : Int = 0

///|
pub const SQLITE_RECURSIVE : Int = 33

///|
pub const SQLITE_TRACE_STMT : Int = 0x01

///|
pub const SQLITE_TRACE_PROFILE : Int = 0x02

///|
pub const SQLITE_TRACE_ROW : Int = 0x04

///|
pub const SQLITE_TRACE_CLOSE : Int = 0x08

///|
pub const SQLITE_LIMIT_LENGTH : Int = 0

///|
pub const SQLITE_LIMIT_SQL_LENGTH : Int = 1

///|
pub const SQLITE_LIMIT_COLUMN : Int = 2

///|
pub const SQLITE_LIMIT_EXPR_DEPTH : Int = 3

///|
pub const SQLITE_LIMIT_COMPOUND_SELECT : Int = 4

///|
pub const SQLITE_LIMIT_VDBE_OP : Int = 5

///|
pub const SQLITE_LIMIT_FUNCTION_ARG : Int = 6

///|
pub const SQLITE_LIMIT_ATTACHED : Int = 7

///|
pub const SQLITE_LIMIT_LIKE_PATTERN_LENGTH : Int = 8

///|
pub const SQLITE_LIMIT_VARIABLE_NUMBER : Int = 9

///|
pub const SQLITE_LIMIT_TRIGGER_DEPTH : Int = 10

///|
pub const SQLITE_LIMIT_WORKER_THREADS : Int = 11

///|
pub const SQLITE_PREPARE_PERSISTENT : Int = 0x01

///|
pub const SQLITE_PREPARE_NORMALIZE : Int = 0x02

///|
pub const SQLITE_PREPARE_NO_VTAB : Int = 0x04

///|
pub const SQLITE_PREPARE_DONT_LOG : Int = 0x10

///|
pub const SQLITE_INTEGER : Int = 1

///|
pub const SQLITE_FLOAT : Int = 2

///|
pub const SQLITE_BLOB : Int = 4

///|
pub const SQLITE_NULL : Int = 5

///|
pub const SQLITE3_TEXT : Int = 3

///|
pub const SQLITE_UTF8 : Int = 1

///|
pub const SQLITE_UTF16LE : Int = 2

///|
pub const SQLITE_UTF16BE : Int = 3

///|
pub const SQLITE_UTF16 : Int = 4

///|
pub const SQLITE_ANY : Int = 5

///|
pub const SQLITE_UTF16_ALIGNED : Int = 8

///|
pub const SQLITE_DETERMINISTIC : Int = 0x000000800

///|
pub const SQLITE_DIRECTONLY : Int = 0x000080000

///|
pub const SQLITE_SUBTYPE : Int = 0x000100000

///|
pub const SQLITE_INNOCUOUS : Int = 0x000200000

///|
pub const SQLITE_RESULT_SUBTYPE : Int = 0x001000000

///|
pub const SQLITE_SELFORDER1 : Int = 0x002000000

///|
pub const SQLITE_STATIC : Int = 0

///|
pub const SQLITE_TRANSIENT : Int = -1

///|
pub const SQLITE_WIN32_DATA_DIRECTORY_TYPE : Int = 1

///|
pub const SQLITE_WIN32_TEMP_DIRECTORY_TYPE : Int = 2

///|
pub const SQLITE_TXN_NONE : Int = 0

///|
pub const SQLITE_TXN_READ : Int = 1

///|
pub const SQLITE_TXN_WRITE : Int = 2

///|
pub const SQLITE_INDEX_SCAN_UNIQUE : Int = 0x00000001

///|
pub const SQLITE_INDEX_SCAN_HEX : Int = 0x00000002

///|
pub const SQLITE_INDEX_CONSTRAINT_EQ : Int = 2

///|
pub const SQLITE_INDEX_CONSTRAINT_GT : Int = 4

///|
pub const SQLITE_INDEX_CONSTRAINT_LE : Int = 8

///|
pub const SQLITE_INDEX_CONSTRAINT_LT : Int = 16

///|
pub const SQLITE_INDEX_CONSTRAINT_GE : Int = 32

///|
pub const SQLITE_INDEX_CONSTRAINT_MATCH : Int = 64

///|
pub const SQLITE_INDEX_CONSTRAINT_LIKE : Int = 65

///|
pub const SQLITE_INDEX_CONSTRAINT_GLOB : Int = 66

///|
pub const SQLITE_INDEX_CONSTRAINT_REGEXP : Int = 67

///|
pub const SQLITE_INDEX_CONSTRAINT_NE : Int = 68

///|
pub const SQLITE_INDEX_CONSTRAINT_ISNOT : Int = 69

///|
pub const SQLITE_INDEX_CONSTRAINT_ISNOTNULL : Int = 70

///|
pub const SQLITE_INDEX_CONSTRAINT_ISNULL : Int = 71

///|
pub const SQLITE_INDEX_CONSTRAINT_IS : Int = 72

///|
pub const SQLITE_INDEX_CONSTRAINT_LIMIT : Int = 73

///|
pub const SQLITE_INDEX_CONSTRAINT_OFFSET : Int = 74

///|
pub const SQLITE_INDEX_CONSTRAINT_FUNCTION : Int = 150

///|
pub const SQLITE_MUTEX_FAST : Int = 0

///|
pub const SQLITE_MUTEX_RECURSIVE : Int = 1

///|
pub const SQLITE_MUTEX_STATIC_MAIN : Int = 2

///|
pub const SQLITE_MUTEX_STATIC_MEM : Int = 3

///|
pub const SQLITE_MUTEX_STATIC_MEM2 : Int = 4

///|
pub const SQLITE_MUTEX_STATIC_OPEN : Int = 4

///|
pub const SQLITE_MUTEX_STATIC_PRNG : Int = 5

///|
pub const SQLITE_MUTEX_STATIC_LRU : Int = 6

///|
pub const SQLITE_MUTEX_STATIC_LRU2 : Int = 7

///|
pub const SQLITE_MUTEX_STATIC_PMEM : Int = 7

///|
pub const SQLITE_MUTEX_STATIC_APP1 : Int = 8

///|
pub const SQLITE_MUTEX_STATIC_APP2 : Int = 9

///|
pub const SQLITE_MUTEX_STATIC_APP3 : Int = 10

///|
pub const SQLITE_MUTEX_STATIC_VFS1 : Int = 11

///|
pub const SQLITE_MUTEX_STATIC_VFS2 : Int = 12

///|
pub const SQLITE_MUTEX_STATIC_VFS3 : Int = 13

///|
pub const SQLITE_MUTEX_STATIC_MASTER : Int = 2

///|
pub const SQLITE_TESTCTRL_FIRST : Int = 5

///|
pub const SQLITE_TESTCTRL_PRNG_SAVE : Int = 5

///|
pub const SQLITE_TESTCTRL_PRNG_RESTORE : Int = 6

///|
pub const SQLITE_TESTCTRL_PRNG_RESET : Int = 7

///|
pub const SQLITE_TESTCTRL_FK_NO_ACTION : Int = 7

///|
pub const SQLITE_TESTCTRL_BITVEC_TEST : Int = 8

///|
pub const SQLITE_TESTCTRL_FAULT_INSTALL : Int = 9

///|
pub const SQLITE_TESTCTRL_BENIGN_MALLOC_HOOKS : Int = 10

///|
pub const SQLITE_TESTCTRL_PENDING_BYTE : Int = 11

///|
pub const SQLITE_TESTCTRL_ASSERT : Int = 12

///|
pub const SQLITE_TESTCTRL_ALWAYS : Int = 13

///|
pub const SQLITE_TESTCTRL_RESERVE : Int = 14

///|
pub const SQLITE_TESTCTRL_JSON_SELFCHECK : Int = 14

///|
pub const SQLITE_TESTCTRL_OPTIMIZATIONS : Int = 15

///|
pub const SQLITE_TESTCTRL_ISKEYWORD : Int = 16

///|
pub const SQLITE_TESTCTRL_GETOPT : Int = 16

///|
pub const SQLITE_TESTCTRL_SCRATCHMALLOC : Int = 17

///|
pub const SQLITE_TESTCTRL_INTERNAL_FUNCTIONS : Int = 17

///|
pub const SQLITE_TESTCTRL_LOCALTIME_FAULT : Int = 18

///|
pub const SQLITE_TESTCTRL_EXPLAIN_STMT : Int = 19

///|
pub const SQLITE_TESTCTRL_ONCE_RESET_THRESHOLD : Int = 19

///|
pub const SQLITE_TESTCTRL_NEVER_CORRUPT : Int = 20

///|
pub const SQLITE_TESTCTRL_VDBE_COVERAGE : Int = 21

///|
pub const SQLITE_TESTCTRL_BYTEORDER : Int = 22

///|
pub const SQLITE_TESTCTRL_ISINIT : Int = 23

///|
pub const SQLITE_TESTCTRL_SORTER_MMAP : Int = 24

///|
pub const SQLITE_TESTCTRL_IMPOSTER : Int = 25

///|
pub const SQLITE_TESTCTRL_PARSER_COVERAGE : Int = 26

///|
pub const SQLITE_TESTCTRL_RESULT_INTREAL : Int = 27

///|
pub const SQLITE_TESTCTRL_PRNG_SEED : Int = 28

///|
pub const SQLITE_TESTCTRL_EXTRA_SCHEMA_CHECKS : Int = 29

///|
pub const SQLITE_TESTCTRL_SEEK_COUNT : Int = 30

///|
pub const SQLITE_TESTCTRL_TRACEFLAGS : Int = 31

///|
pub const SQLITE_TESTCTRL_TUNE : Int = 32

///|
pub const SQLITE_TESTCTRL_LOGEST : Int = 33

///|
pub const SQLITE_TESTCTRL_USELONGDOUBLE : Int = 34

///|
pub const SQLITE_TESTCTRL_LAST : Int = 34

///|
pub const SQLITE_STATUS_MEMORY_USED : Int = 0

///|
pub const SQLITE_STATUS_PAGECACHE_USED : Int = 1

///|
pub const SQLITE_STATUS_PAGECACHE_OVERFLOW : Int = 2

///|
pub const SQLITE_STATUS_SCRATCH_USED : Int = 3

///|
pub const SQLITE_STATUS_SCRATCH_OVERFLOW : Int = 4

///|
pub const SQLITE_STATUS_MALLOC_SIZE : Int = 5

///|
pub const SQLITE_STATUS_PARSER_STACK : Int = 6

///|
pub const SQLITE_STATUS_PAGECACHE_SIZE : Int = 7

///|
pub const SQLITE_STATUS_SCRATCH_SIZE : Int = 8

///|
pub const SQLITE_STATUS_MALLOC_COUNT : Int = 9

///|
pub const SQLITE_DBSTATUS_LOOKASIDE_USED : Int = 0

///|
pub const SQLITE_DBSTATUS_CACHE_USED : Int = 1

///|
pub const SQLITE_DBSTATUS_SCHEMA_USED : Int = 2

///|
pub const SQLITE_DBSTATUS_STMT_USED : Int = 3

///|
pub const SQLITE_DBSTATUS_LOOKASIDE_HIT : Int = 4

///|
pub const SQLITE_DBSTATUS_LOOKASIDE_MISS_SIZE : Int = 5

///|
pub const SQLITE_DBSTATUS_LOOKASIDE_MISS_FULL : Int = 6

///|
pub const SQLITE_DBSTATUS_CACHE_HIT : Int = 7

///|
pub const SQLITE_DBSTATUS_CACHE_MISS : Int = 8

///|
pub const SQLITE_DBSTATUS_CACHE_WRITE : Int = 9

///|
pub const SQLITE_DBSTATUS_DEFERRED_FKS : Int = 10

///|
pub const SQLITE_DBSTATUS_CACHE_USED_SHARED : Int = 11

///|
pub const SQLITE_DBSTATUS_CACHE_SPILL : Int = 12

///|
pub const SQLITE_DBSTATUS_MAX : Int = 12

///|
pub const SQLITE_STMTSTATUS_FULLSCAN_STEP : Int = 1

///|
pub const SQLITE_STMTSTATUS_SORT : Int = 2

///|
pub const SQLITE_STMTSTATUS_AUTOINDEX : Int = 3

///|
pub const SQLITE_STMTSTATUS_VM_STEP : Int = 4

///|
pub const SQLITE_STMTSTATUS_REPREPARE : Int = 5

///|
pub const SQLITE_STMTSTATUS_RUN : Int = 6

///|
pub const SQLITE_STMTSTATUS_FILTER_MISS : Int = 7

///|
pub const SQLITE_STMTSTATUS_FILTER_HIT : Int = 8

///|
pub const SQLITE_STMTSTATUS_MEMUSED : Int = 99

///|
pub const SQLITE_CHECKPOINT_PASSIVE : Int = 0

///|
pub const SQLITE_CHECKPOINT_FULL : Int = 1

///|
pub const SQLITE_CHECKPOINT_RESTART : Int = 2

///|
pub const SQLITE_CHECKPOINT_TRUNCATE : Int = 3

///|
pub const SQLITE_VTAB_CONSTRAINT_SUPPORT : Int = 1

///|
pub const SQLITE_VTAB_INNOCUOUS : Int = 2

///|
pub const SQLITE_VTAB_DIRECTONLY : Int = 3

///|
pub const SQLITE_VTAB_USES_ALL_SCHEMAS : Int = 4

///|
pub const SQLITE_ROLLBACK : Int = 1

///|
pub const SQLITE_FAIL : Int = 3

///|
pub const SQLITE_REPLACE : Int = 5

///|
pub const SQLITE_SCANSTAT_NLOOP : Int = 0

///|
pub const SQLITE_SCANSTAT_NVISIT : Int = 1

///|
pub const SQLITE_SCANSTAT_EST : Int = 2

///|
pub const SQLITE_SCANSTAT_NAME : Int = 3

///|
pub const SQLITE_SCANSTAT_EXPLAIN : Int = 4

///|
pub const SQLITE_SCANSTAT_SELECTID : Int = 5

///|
pub const SQLITE_SCANSTAT_PARENTID : Int = 6

///|
pub const SQLITE_SCANSTAT_NCYCLE : Int = 7

///|
pub const SQLITE_SCANSTAT_COMPLEX : Int = 0x0001

///|
pub const SQLITE_SERIALIZE_NOCOPY : Int = 0x001

///|
pub const SQLITE_DESERIALIZE_FREEONCLOSE : Int = 1

///|
pub const SQLITE_DESERIALIZE_RESIZEABLE : Int = 2

///|
pub const SQLITE_DESERIALIZE_READONLY : Int = 4

///|
pub const NOT_WITHIN : Int = 0

///|
pub const PARTLY_WITHIN : Int = 1

///|
pub const FULLY_WITHIN : Int = 2

///|
pub const SQLITE_SESSION_OBJCONFIG_SIZE : Int = 1

///|
pub const SQLITE_SESSION_OBJCONFIG_ROWID : Int = 2

///|
pub const SQLITE_CHANGESETSTART_INVERT : Int = 0x0002

///|
pub const SQLITE_CHANGESETAPPLY_NOSAVEPOINT : Int = 0x0001

///|
pub const SQLITE_CHANGESETAPPLY_INVERT : Int = 0x0002

///|
pub const SQLITE_CHANGESETAPPLY_IGNORENOOP : Int = 0x0004

///|
pub const SQLITE_CHANGESETAPPLY_FKNOACTION : Int = 0x0008

///|
pub const SQLITE_CHANGESET_DATA : Int = 1

///|
pub const SQLITE_CHANGESET_NOTFOUND : Int = 2

///|
pub const SQLITE_CHANGESET_CONFLICT : Int = 3

///|
pub const SQLITE_CHANGESET_CONSTRAINT : Int = 4

///|
pub const SQLITE_CHANGESET_FOREIGN_KEY : Int = 5

///|
pub const SQLITE_CHANGESET_OMIT : Int = 0

///|
pub const SQLITE_CHANGESET_REPLACE : Int = 1

///|
pub const SQLITE_CHANGESET_ABORT : Int = 2

///|
pub const SQLITE_SESSION_CONFIG_STRMSIZE : Int = 1

///|
pub const FTS5_TOKENIZE_QUERY : Int = 0x0001

///|
pub const FTS5_TOKENIZE_PREFIX : Int = 0x0002

///|
pub const FTS5_TOKENIZE_DOCUMENT : Int = 0x0004

///|
pub const FTS5_TOKENIZE_AUX : Int = 0x0008

///|
pub const FTS5_TOKEN_COLOCATED : Int = 0x0001
