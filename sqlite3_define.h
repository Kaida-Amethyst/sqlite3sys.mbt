sqlite3.h:#define SQLITE3_H
sqlite3.h:#define SQLITE_DEPRECATED
sqlite3.h:#define SQLITE_EXPERIMENTAL
sqlite3.h:#define SQLITE_VERSION        "3.50.1"
sqlite3.h:#define SQLITE_VERSION_NUMBER 3050001
sqlite3.h:#define SQLITE_SOURCE_ID      "2025-06-06 14:52:32 b77dc5e0f596d2140d9ac682b2893ff65d3a4140aa86067a3efebe29dc914c95"
sqlite3.h:#define SQLITE_OK           0   /* Successful result */
sqlite3.h:#define SQLITE_ERROR        1   /* Generic error */
sqlite3.h:#define SQLITE_INTERNAL     2   /* Internal logic error in SQLite */
sqlite3.h:#define SQLITE_PERM         3   /* Access permission denied */
sqlite3.h:#define SQLITE_ABORT        4   /* Callback routine requested an abort */
sqlite3.h:#define SQLITE_BUSY         5   /* The database file is locked */
sqlite3.h:#define SQLITE_LOCKED       6   /* A table in the database is locked */
sqlite3.h:#define SQLITE_NOMEM        7   /* A malloc() failed */
sqlite3.h:#define SQLITE_READONLY     8   /* Attempt to write a readonly database */
sqlite3.h:#define SQLITE_INTERRUPT    9   /* Operation terminated by sqlite3_interrupt()*/
sqlite3.h:#define SQLITE_IOERR       10   /* Some kind of disk I/O error occurred */
sqlite3.h:#define SQLITE_CORRUPT     11   /* The database disk image is malformed */
sqlite3.h:#define SQLITE_NOTFOUND    12   /* Unknown opcode in sqlite3_file_control() */
sqlite3.h:#define SQLITE_FULL        13   /* Insertion failed because database is full */
sqlite3.h:#define SQLITE_CANTOPEN    14   /* Unable to open the database file */
sqlite3.h:#define SQLITE_PROTOCOL    15   /* Database lock protocol error */
sqlite3.h:#define SQLITE_EMPTY       16   /* Internal use only */
sqlite3.h:#define SQLITE_SCHEMA      17   /* The database schema changed */
sqlite3.h:#define SQLITE_TOOBIG      18   /* String or BLOB exceeds size limit */
sqlite3.h:#define SQLITE_CONSTRAINT  19   /* Abort due to constraint violation */
sqlite3.h:#define SQLITE_MISMATCH    20   /* Data type mismatch */
sqlite3.h:#define SQLITE_MISUSE      21   /* Library used incorrectly */
sqlite3.h:#define SQLITE_NOLFS       22   /* Uses OS features not supported on host */
sqlite3.h:#define SQLITE_AUTH        23   /* Authorization denied */
sqlite3.h:#define SQLITE_FORMAT      24   /* Not used */
sqlite3.h:#define SQLITE_RANGE       25   /* 2nd parameter to sqlite3_bind out of range */
sqlite3.h:#define SQLITE_NOTADB      26   /* File opened that is not a database file */
sqlite3.h:#define SQLITE_NOTICE      27   /* Notifications from sqlite3_log() */
sqlite3.h:#define SQLITE_WARNING     28   /* Warnings from sqlite3_log() */
sqlite3.h:#define SQLITE_ROW         100  /* sqlite3_step() has another row ready */
sqlite3.h:#define SQLITE_DONE        101  /* sqlite3_step() has finished executing */
sqlite3.h:#define SQLITE_ERROR_MISSING_COLLSEQ   (SQLITE_ERROR | (1<<8))
sqlite3.h:#define SQLITE_ERROR_RETRY             (SQLITE_ERROR | (2<<8))
sqlite3.h:#define SQLITE_ERROR_SNAPSHOT          (SQLITE_ERROR | (3<<8))
sqlite3.h:#define SQLITE_IOERR_READ              (SQLITE_IOERR | (1<<8))
sqlite3.h:#define SQLITE_IOERR_SHORT_READ        (SQLITE_IOERR | (2<<8))
sqlite3.h:#define SQLITE_IOERR_WRITE             (SQLITE_IOERR | (3<<8))
sqlite3.h:#define SQLITE_IOERR_FSYNC             (SQLITE_IOERR | (4<<8))
sqlite3.h:#define SQLITE_IOERR_DIR_FSYNC         (SQLITE_IOERR | (5<<8))
sqlite3.h:#define SQLITE_IOERR_TRUNCATE          (SQLITE_IOERR | (6<<8))
sqlite3.h:#define SQLITE_IOERR_FSTAT             (SQLITE_IOERR | (7<<8))
sqlite3.h:#define SQLITE_IOERR_UNLOCK            (SQLITE_IOERR | (8<<8))
sqlite3.h:#define SQLITE_IOERR_RDLOCK            (SQLITE_IOERR | (9<<8))
sqlite3.h:#define SQLITE_IOERR_DELETE            (SQLITE_IOERR | (10<<8))
sqlite3.h:#define SQLITE_IOERR_BLOCKED           (SQLITE_IOERR | (11<<8))
sqlite3.h:#define SQLITE_IOERR_NOMEM             (SQLITE_IOERR | (12<<8))
sqlite3.h:#define SQLITE_IOERR_ACCESS            (SQLITE_IOERR | (13<<8))
sqlite3.h:#define SQLITE_IOERR_CHECKRESERVEDLOCK (SQLITE_IOERR | (14<<8))
sqlite3.h:#define SQLITE_IOERR_LOCK              (SQLITE_IOERR | (15<<8))
sqlite3.h:#define SQLITE_IOERR_CLOSE             (SQLITE_IOERR | (16<<8))
sqlite3.h:#define SQLITE_IOERR_DIR_CLOSE         (SQLITE_IOERR | (17<<8))
sqlite3.h:#define SQLITE_IOERR_SHMOPEN           (SQLITE_IOERR | (18<<8))
sqlite3.h:#define SQLITE_IOERR_SHMSIZE           (SQLITE_IOERR | (19<<8))
sqlite3.h:#define SQLITE_IOERR_SHMLOCK           (SQLITE_IOERR | (20<<8))
sqlite3.h:#define SQLITE_IOERR_SHMMAP            (SQLITE_IOERR | (21<<8))
sqlite3.h:#define SQLITE_IOERR_SEEK              (SQLITE_IOERR | (22<<8))
sqlite3.h:#define SQLITE_IOERR_DELETE_NOENT      (SQLITE_IOERR | (23<<8))
sqlite3.h:#define SQLITE_IOERR_MMAP              (SQLITE_IOERR | (24<<8))
sqlite3.h:#define SQLITE_IOERR_GETTEMPPATH       (SQLITE_IOERR | (25<<8))
sqlite3.h:#define SQLITE_IOERR_CONVPATH          (SQLITE_IOERR | (26<<8))
sqlite3.h:#define SQLITE_IOERR_VNODE             (SQLITE_IOERR | (27<<8))
sqlite3.h:#define SQLITE_IOERR_AUTH              (SQLITE_IOERR | (28<<8))
sqlite3.h:#define SQLITE_IOERR_BEGIN_ATOMIC      (SQLITE_IOERR | (29<<8))
sqlite3.h:#define SQLITE_IOERR_COMMIT_ATOMIC     (SQLITE_IOERR | (30<<8))
sqlite3.h:#define SQLITE_IOERR_ROLLBACK_ATOMIC   (SQLITE_IOERR | (31<<8))
sqlite3.h:#define SQLITE_IOERR_DATA              (SQLITE_IOERR | (32<<8))
sqlite3.h:#define SQLITE_IOERR_CORRUPTFS         (SQLITE_IOERR | (33<<8))
sqlite3.h:#define SQLITE_IOERR_IN_PAGE           (SQLITE_IOERR | (34<<8))
sqlite3.h:#define SQLITE_LOCKED_SHAREDCACHE      (SQLITE_LOCKED |  (1<<8))
sqlite3.h:#define SQLITE_LOCKED_VTAB             (SQLITE_LOCKED |  (2<<8))
sqlite3.h:#define SQLITE_BUSY_RECOVERY           (SQLITE_BUSY   |  (1<<8))
sqlite3.h:#define SQLITE_BUSY_SNAPSHOT           (SQLITE_BUSY   |  (2<<8))
sqlite3.h:#define SQLITE_BUSY_TIMEOUT            (SQLITE_BUSY   |  (3<<8))
sqlite3.h:#define SQLITE_CANTOPEN_NOTEMPDIR      (SQLITE_CANTOPEN | (1<<8))
sqlite3.h:#define SQLITE_CANTOPEN_ISDIR          (SQLITE_CANTOPEN | (2<<8))
sqlite3.h:#define SQLITE_CANTOPEN_FULLPATH       (SQLITE_CANTOPEN | (3<<8))
sqlite3.h:#define SQLITE_CANTOPEN_CONVPATH       (SQLITE_CANTOPEN | (4<<8))
sqlite3.h:#define SQLITE_CANTOPEN_DIRTYWAL       (SQLITE_CANTOPEN | (5<<8)) /* Not Used */
sqlite3.h:#define SQLITE_CANTOPEN_SYMLINK        (SQLITE_CANTOPEN | (6<<8))
sqlite3.h:#define SQLITE_CORRUPT_VTAB            (SQLITE_CORRUPT | (1<<8))
sqlite3.h:#define SQLITE_CORRUPT_SEQUENCE        (SQLITE_CORRUPT | (2<<8))
sqlite3.h:#define SQLITE_CORRUPT_INDEX           (SQLITE_CORRUPT | (3<<8))
sqlite3.h:#define SQLITE_READONLY_RECOVERY       (SQLITE_READONLY | (1<<8))
sqlite3.h:#define SQLITE_READONLY_CANTLOCK       (SQLITE_READONLY | (2<<8))
sqlite3.h:#define SQLITE_READONLY_ROLLBACK       (SQLITE_READONLY | (3<<8))
sqlite3.h:#define SQLITE_READONLY_DBMOVED        (SQLITE_READONLY | (4<<8))
sqlite3.h:#define SQLITE_READONLY_CANTINIT       (SQLITE_READONLY | (5<<8))
sqlite3.h:#define SQLITE_READONLY_DIRECTORY      (SQLITE_READONLY | (6<<8))
sqlite3.h:#define SQLITE_ABORT_ROLLBACK          (SQLITE_ABORT | (2<<8))
sqlite3.h:#define SQLITE_CONSTRAINT_CHECK        (SQLITE_CONSTRAINT | (1<<8))
sqlite3.h:#define SQLITE_CONSTRAINT_COMMITHOOK   (SQLITE_CONSTRAINT | (2<<8))
sqlite3.h:#define SQLITE_CONSTRAINT_FOREIGNKEY   (SQLITE_CONSTRAINT | (3<<8))
sqlite3.h:#define SQLITE_CONSTRAINT_FUNCTION     (SQLITE_CONSTRAINT | (4<<8))
sqlite3.h:#define SQLITE_CONSTRAINT_NOTNULL      (SQLITE_CONSTRAINT | (5<<8))
sqlite3.h:#define SQLITE_CONSTRAINT_PRIMARYKEY   (SQLITE_CONSTRAINT | (6<<8))
sqlite3.h:#define SQLITE_CONSTRAINT_TRIGGER      (SQLITE_CONSTRAINT | (7<<8))
sqlite3.h:#define SQLITE_CONSTRAINT_UNIQUE       (SQLITE_CONSTRAINT | (8<<8))
sqlite3.h:#define SQLITE_CONSTRAINT_VTAB         (SQLITE_CONSTRAINT | (9<<8))
sqlite3.h:#define SQLITE_CONSTRAINT_ROWID        (SQLITE_CONSTRAINT |(10<<8))
sqlite3.h:#define SQLITE_CONSTRAINT_PINNED       (SQLITE_CONSTRAINT |(11<<8))
sqlite3.h:#define SQLITE_CONSTRAINT_DATATYPE     (SQLITE_CONSTRAINT |(12<<8))
sqlite3.h:#define SQLITE_NOTICE_RECOVER_WAL      (SQLITE_NOTICE | (1<<8))
sqlite3.h:#define SQLITE_NOTICE_RECOVER_ROLLBACK (SQLITE_NOTICE | (2<<8))
sqlite3.h:#define SQLITE_NOTICE_RBU              (SQLITE_NOTICE | (3<<8))
sqlite3.h:#define SQLITE_WARNING_AUTOINDEX       (SQLITE_WARNING | (1<<8))
sqlite3.h:#define SQLITE_AUTH_USER               (SQLITE_AUTH | (1<<8))
sqlite3.h:#define SQLITE_OK_LOAD_PERMANENTLY     (SQLITE_OK | (1<<8))
sqlite3.h:#define SQLITE_OK_SYMLINK              (SQLITE_OK | (2<<8)) /* internal use only */
sqlite3.h:#define SQLITE_OPEN_READONLY         0x00000001  /* Ok for sqlite3_open_v2() */
sqlite3.h:#define SQLITE_OPEN_READWRITE        0x00000002  /* Ok for sqlite3_open_v2() */
sqlite3.h:#define SQLITE_OPEN_CREATE           0x00000004  /* Ok for sqlite3_open_v2() */
sqlite3.h:#define SQLITE_OPEN_DELETEONCLOSE    0x00000008  /* VFS only */
sqlite3.h:#define SQLITE_OPEN_EXCLUSIVE        0x00000010  /* VFS only */
sqlite3.h:#define SQLITE_OPEN_AUTOPROXY        0x00000020  /* VFS only */
sqlite3.h:#define SQLITE_OPEN_URI              0x00000040  /* Ok for sqlite3_open_v2() */
sqlite3.h:#define SQLITE_OPEN_MEMORY           0x00000080  /* Ok for sqlite3_open_v2() */
sqlite3.h:#define SQLITE_OPEN_MAIN_DB          0x00000100  /* VFS only */
sqlite3.h:#define SQLITE_OPEN_TEMP_DB          0x00000200  /* VFS only */
sqlite3.h:#define SQLITE_OPEN_TRANSIENT_DB     0x00000400  /* VFS only */
sqlite3.h:#define SQLITE_OPEN_MAIN_JOURNAL     0x00000800  /* VFS only */
sqlite3.h:#define SQLITE_OPEN_TEMP_JOURNAL     0x00001000  /* VFS only */
sqlite3.h:#define SQLITE_OPEN_SUBJOURNAL       0x00002000  /* VFS only */
sqlite3.h:#define SQLITE_OPEN_SUPER_JOURNAL    0x00004000  /* VFS only */
sqlite3.h:#define SQLITE_OPEN_NOMUTEX          0x00008000  /* Ok for sqlite3_open_v2() */
sqlite3.h:#define SQLITE_OPEN_FULLMUTEX        0x00010000  /* Ok for sqlite3_open_v2() */
sqlite3.h:#define SQLITE_OPEN_SHAREDCACHE      0x00020000  /* Ok for sqlite3_open_v2() */
sqlite3.h:#define SQLITE_OPEN_PRIVATECACHE     0x00040000  /* Ok for sqlite3_open_v2() */
sqlite3.h:#define SQLITE_OPEN_WAL              0x00080000  /* VFS only */
sqlite3.h:#define SQLITE_OPEN_NOFOLLOW         0x01000000  /* Ok for sqlite3_open_v2() */
sqlite3.h:#define SQLITE_OPEN_EXRESCODE        0x02000000  /* Extended result codes */
sqlite3.h:#define SQLITE_OPEN_MASTER_JOURNAL   0x00004000  /* VFS only */
sqlite3.h:#define SQLITE_IOCAP_ATOMIC                 0x00000001
sqlite3.h:#define SQLITE_IOCAP_ATOMIC512              0x00000002
sqlite3.h:#define SQLITE_IOCAP_ATOMIC1K               0x00000004
sqlite3.h:#define SQLITE_IOCAP_ATOMIC2K               0x00000008
sqlite3.h:#define SQLITE_IOCAP_ATOMIC4K               0x00000010
sqlite3.h:#define SQLITE_IOCAP_ATOMIC8K               0x00000020
sqlite3.h:#define SQLITE_IOCAP_ATOMIC16K              0x00000040
sqlite3.h:#define SQLITE_IOCAP_ATOMIC32K              0x00000080
sqlite3.h:#define SQLITE_IOCAP_ATOMIC64K              0x00000100
sqlite3.h:#define SQLITE_IOCAP_SAFE_APPEND            0x00000200
sqlite3.h:#define SQLITE_IOCAP_SEQUENTIAL             0x00000400
sqlite3.h:#define SQLITE_IOCAP_UNDELETABLE_WHEN_OPEN  0x00000800
sqlite3.h:#define SQLITE_IOCAP_POWERSAFE_OVERWRITE    0x00001000
sqlite3.h:#define SQLITE_IOCAP_IMMUTABLE              0x00002000
sqlite3.h:#define SQLITE_IOCAP_BATCH_ATOMIC           0x00004000
sqlite3.h:#define SQLITE_IOCAP_SUBPAGE_READ           0x00008000
sqlite3.h:#define SQLITE_LOCK_NONE          0       /* xUnlock() only */
sqlite3.h:#define SQLITE_LOCK_SHARED        1       /* xLock() or xUnlock() */
sqlite3.h:#define SQLITE_LOCK_RESERVED      2       /* xLock() only */
sqlite3.h:#define SQLITE_LOCK_PENDING       3       /* xLock() only */
sqlite3.h:#define SQLITE_LOCK_EXCLUSIVE     4       /* xLock() only */
sqlite3.h:#define SQLITE_SYNC_NORMAL        0x00002
sqlite3.h:#define SQLITE_SYNC_FULL          0x00003
sqlite3.h:#define SQLITE_SYNC_DATAONLY      0x00010
sqlite3.h:#define SQLITE_FCNTL_LOCKSTATE               1
sqlite3.h:#define SQLITE_FCNTL_GET_LOCKPROXYFILE       2
sqlite3.h:#define SQLITE_FCNTL_SET_LOCKPROXYFILE       3
sqlite3.h:#define SQLITE_FCNTL_LAST_ERRNO              4
sqlite3.h:#define SQLITE_FCNTL_SIZE_HINT               5
sqlite3.h:#define SQLITE_FCNTL_CHUNK_SIZE              6
sqlite3.h:#define SQLITE_FCNTL_FILE_POINTER            7
sqlite3.h:#define SQLITE_FCNTL_SYNC_OMITTED            8
sqlite3.h:#define SQLITE_FCNTL_WIN32_AV_RETRY          9
sqlite3.h:#define SQLITE_FCNTL_PERSIST_WAL            10
sqlite3.h:#define SQLITE_FCNTL_OVERWRITE              11
sqlite3.h:#define SQLITE_FCNTL_VFSNAME                12
sqlite3.h:#define SQLITE_FCNTL_POWERSAFE_OVERWRITE    13
sqlite3.h:#define SQLITE_FCNTL_PRAGMA                 14
sqlite3.h:#define SQLITE_FCNTL_BUSYHANDLER            15
sqlite3.h:#define SQLITE_FCNTL_TEMPFILENAME           16
sqlite3.h:#define SQLITE_FCNTL_MMAP_SIZE              18
sqlite3.h:#define SQLITE_FCNTL_TRACE                  19
sqlite3.h:#define SQLITE_FCNTL_HAS_MOVED              20
sqlite3.h:#define SQLITE_FCNTL_SYNC                   21
sqlite3.h:#define SQLITE_FCNTL_COMMIT_PHASETWO        22
sqlite3.h:#define SQLITE_FCNTL_WIN32_SET_HANDLE       23
sqlite3.h:#define SQLITE_FCNTL_WAL_BLOCK              24
sqlite3.h:#define SQLITE_FCNTL_ZIPVFS                 25
sqlite3.h:#define SQLITE_FCNTL_RBU                    26
sqlite3.h:#define SQLITE_FCNTL_VFS_POINTER            27
sqlite3.h:#define SQLITE_FCNTL_JOURNAL_POINTER        28
sqlite3.h:#define SQLITE_FCNTL_WIN32_GET_HANDLE       29
sqlite3.h:#define SQLITE_FCNTL_PDB                    30
sqlite3.h:#define SQLITE_FCNTL_BEGIN_ATOMIC_WRITE     31
sqlite3.h:#define SQLITE_FCNTL_COMMIT_ATOMIC_WRITE    32
sqlite3.h:#define SQLITE_FCNTL_ROLLBACK_ATOMIC_WRITE  33
sqlite3.h:#define SQLITE_FCNTL_LOCK_TIMEOUT           34
sqlite3.h:#define SQLITE_FCNTL_DATA_VERSION           35
sqlite3.h:#define SQLITE_FCNTL_SIZE_LIMIT             36
sqlite3.h:#define SQLITE_FCNTL_CKPT_DONE              37
sqlite3.h:#define SQLITE_FCNTL_RESERVE_BYTES          38
sqlite3.h:#define SQLITE_FCNTL_CKPT_START             39
sqlite3.h:#define SQLITE_FCNTL_EXTERNAL_READER        40
sqlite3.h:#define SQLITE_FCNTL_CKSM_FILE              41
sqlite3.h:#define SQLITE_FCNTL_RESET_CACHE            42
sqlite3.h:#define SQLITE_FCNTL_NULL_IO                43
sqlite3.h:#define SQLITE_FCNTL_BLOCK_ON_CONNECT       44
sqlite3.h:#define SQLITE_GET_LOCKPROXYFILE      SQLITE_FCNTL_GET_LOCKPROXYFILE
sqlite3.h:#define SQLITE_SET_LOCKPROXYFILE      SQLITE_FCNTL_SET_LOCKPROXYFILE
sqlite3.h:#define SQLITE_LAST_ERRNO             SQLITE_FCNTL_LAST_ERRNO
sqlite3.h:#define SQLITE_ACCESS_EXISTS    0
sqlite3.h:#define SQLITE_ACCESS_READWRITE 1   /* Used by PRAGMA temp_store_directory */
sqlite3.h:#define SQLITE_ACCESS_READ      2   /* Unused */
sqlite3.h:#define SQLITE_SHM_UNLOCK       1
sqlite3.h:#define SQLITE_SHM_LOCK         2
sqlite3.h:#define SQLITE_SHM_SHARED       4
sqlite3.h:#define SQLITE_SHM_EXCLUSIVE    8
sqlite3.h:#define SQLITE_SHM_NLOCK        8
sqlite3.h:#define SQLITE_CONFIG_SINGLETHREAD         1  /* nil */
sqlite3.h:#define SQLITE_CONFIG_MULTITHREAD          2  /* nil */
sqlite3.h:#define SQLITE_CONFIG_SERIALIZED           3  /* nil */
sqlite3.h:#define SQLITE_CONFIG_MALLOC               4  /* sqlite3_mem_methods* */
sqlite3.h:#define SQLITE_CONFIG_GETMALLOC            5  /* sqlite3_mem_methods* */
sqlite3.h:#define SQLITE_CONFIG_SCRATCH              6  /* No longer used */
sqlite3.h:#define SQLITE_CONFIG_PAGECACHE            7  /* void*, int sz, int N */
sqlite3.h:#define SQLITE_CONFIG_HEAP                 8  /* void*, int nByte, int min */
sqlite3.h:#define SQLITE_CONFIG_MEMSTATUS            9  /* boolean */
sqlite3.h:#define SQLITE_CONFIG_MUTEX               10  /* sqlite3_mutex_methods* */
sqlite3.h:#define SQLITE_CONFIG_GETMUTEX            11  /* sqlite3_mutex_methods* */
sqlite3.h:#define SQLITE_CONFIG_LOOKASIDE           13  /* int int */
sqlite3.h:#define SQLITE_CONFIG_PCACHE              14  /* no-op */
sqlite3.h:#define SQLITE_CONFIG_GETPCACHE           15  /* no-op */
sqlite3.h:#define SQLITE_CONFIG_LOG                 16  /* xFunc, void* */
sqlite3.h:#define SQLITE_CONFIG_URI                 17  /* int */
sqlite3.h:#define SQLITE_CONFIG_PCACHE2             18  /* sqlite3_pcache_methods2* */
sqlite3.h:#define SQLITE_CONFIG_GETPCACHE2          19  /* sqlite3_pcache_methods2* */
sqlite3.h:#define SQLITE_CONFIG_COVERING_INDEX_SCAN 20  /* int */
sqlite3.h:#define SQLITE_CONFIG_SQLLOG              21  /* xSqllog, void* */
sqlite3.h:#define SQLITE_CONFIG_MMAP_SIZE           22  /* sqlite3_int64, sqlite3_int64 */
sqlite3.h:#define SQLITE_CONFIG_WIN32_HEAPSIZE      23  /* int nByte */
sqlite3.h:#define SQLITE_CONFIG_PCACHE_HDRSZ        24  /* int *psz */
sqlite3.h:#define SQLITE_CONFIG_PMASZ               25  /* unsigned int szPma */
sqlite3.h:#define SQLITE_CONFIG_STMTJRNL_SPILL      26  /* int nByte */
sqlite3.h:#define SQLITE_CONFIG_SMALL_MALLOC        27  /* boolean */
sqlite3.h:#define SQLITE_CONFIG_SORTERREF_SIZE      28  /* int nByte */
sqlite3.h:#define SQLITE_CONFIG_MEMDB_MAXSIZE       29  /* sqlite3_int64 */
sqlite3.h:#define SQLITE_CONFIG_ROWID_IN_VIEW       30  /* int* */
sqlite3.h:#define SQLITE_DBCONFIG_MAINDBNAME            1000 /* const char* */
sqlite3.h:#define SQLITE_DBCONFIG_LOOKASIDE             1001 /* void* int int */
sqlite3.h:#define SQLITE_DBCONFIG_ENABLE_FKEY           1002 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_ENABLE_TRIGGER        1003 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_ENABLE_FTS3_TOKENIZER 1004 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_ENABLE_LOAD_EXTENSION 1005 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_NO_CKPT_ON_CLOSE      1006 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_ENABLE_QPSG           1007 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_TRIGGER_EQP           1008 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_RESET_DATABASE        1009 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_DEFENSIVE             1010 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_WRITABLE_SCHEMA       1011 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_LEGACY_ALTER_TABLE    1012 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_DQS_DML               1013 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_DQS_DDL               1014 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_ENABLE_VIEW           1015 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_LEGACY_FILE_FORMAT    1016 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_TRUSTED_SCHEMA        1017 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_STMT_SCANSTATUS       1018 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_REVERSE_SCANORDER     1019 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_ENABLE_ATTACH_CREATE  1020 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_ENABLE_ATTACH_WRITE   1021 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_ENABLE_COMMENTS       1022 /* int int* */
sqlite3.h:#define SQLITE_DBCONFIG_MAX                   1022 /* Largest DBCONFIG */
sqlite3.h:#define SQLITE_SETLK_BLOCK_ON_CONNECT 0x01
sqlite3.h:#define SQLITE_DENY   1   /* Abort the SQL statement with an error */
sqlite3.h:#define SQLITE_IGNORE 2   /* Don't allow access, but don't generate an error */
sqlite3.h:#define SQLITE_CREATE_INDEX          1   /* Index Name      Table Name      */
sqlite3.h:#define SQLITE_CREATE_TABLE          2   /* Table Name      NULL            */
sqlite3.h:#define SQLITE_CREATE_TEMP_INDEX     3   /* Index Name      Table Name      */
sqlite3.h:#define SQLITE_CREATE_TEMP_TABLE     4   /* Table Name      NULL            */
sqlite3.h:#define SQLITE_CREATE_TEMP_TRIGGER   5   /* Trigger Name    Table Name      */
sqlite3.h:#define SQLITE_CREATE_TEMP_VIEW      6   /* View Name       NULL            */
sqlite3.h:#define SQLITE_CREATE_TRIGGER        7   /* Trigger Name    Table Name      */
sqlite3.h:#define SQLITE_CREATE_VIEW           8   /* View Name       NULL            */
sqlite3.h:#define SQLITE_DELETE                9   /* Table Name      NULL            */
sqlite3.h:#define SQLITE_DROP_INDEX           10   /* Index Name      Table Name      */
sqlite3.h:#define SQLITE_DROP_TABLE           11   /* Table Name      NULL            */
sqlite3.h:#define SQLITE_DROP_TEMP_INDEX      12   /* Index Name      Table Name      */
sqlite3.h:#define SQLITE_DROP_TEMP_TABLE      13   /* Table Name      NULL            */
sqlite3.h:#define SQLITE_DROP_TEMP_TRIGGER    14   /* Trigger Name    Table Name      */
sqlite3.h:#define SQLITE_DROP_TEMP_VIEW       15   /* View Name       NULL            */
sqlite3.h:#define SQLITE_DROP_TRIGGER         16   /* Trigger Name    Table Name      */
sqlite3.h:#define SQLITE_DROP_VIEW            17   /* View Name       NULL            */
sqlite3.h:#define SQLITE_INSERT               18   /* Table Name      NULL            */
sqlite3.h:#define SQLITE_PRAGMA               19   /* Pragma Name     1st arg or NULL */
sqlite3.h:#define SQLITE_READ                 20   /* Table Name      Column Name     */
sqlite3.h:#define SQLITE_SELECT               21   /* NULL            NULL            */
sqlite3.h:#define SQLITE_TRANSACTION          22   /* Operation       NULL            */
sqlite3.h:#define SQLITE_UPDATE               23   /* Table Name      Column Name     */
sqlite3.h:#define SQLITE_ATTACH               24   /* Filename        NULL            */
sqlite3.h:#define SQLITE_DETACH               25   /* Database Name   NULL            */
sqlite3.h:#define SQLITE_ALTER_TABLE          26   /* Database Name   Table Name      */
sqlite3.h:#define SQLITE_REINDEX              27   /* Index Name      NULL            */
sqlite3.h:#define SQLITE_ANALYZE              28   /* Table Name      NULL            */
sqlite3.h:#define SQLITE_CREATE_VTABLE        29   /* Table Name      Module Name     */
sqlite3.h:#define SQLITE_DROP_VTABLE          30   /* Table Name      Module Name     */
sqlite3.h:#define SQLITE_FUNCTION             31   /* NULL            Function Name   */
sqlite3.h:#define SQLITE_SAVEPOINT            32   /* Operation       Savepoint Name  */
sqlite3.h:#define SQLITE_COPY                  0   /* No longer used */
sqlite3.h:#define SQLITE_RECURSIVE            33   /* NULL            NULL            */
sqlite3.h:#define SQLITE_TRACE_STMT       0x01
sqlite3.h:#define SQLITE_TRACE_PROFILE    0x02
sqlite3.h:#define SQLITE_TRACE_ROW        0x04
sqlite3.h:#define SQLITE_TRACE_CLOSE      0x08
sqlite3.h:#define SQLITE_LIMIT_LENGTH                    0
sqlite3.h:#define SQLITE_LIMIT_SQL_LENGTH                1
sqlite3.h:#define SQLITE_LIMIT_COLUMN                    2
sqlite3.h:#define SQLITE_LIMIT_EXPR_DEPTH                3
sqlite3.h:#define SQLITE_LIMIT_COMPOUND_SELECT           4
sqlite3.h:#define SQLITE_LIMIT_VDBE_OP                   5
sqlite3.h:#define SQLITE_LIMIT_FUNCTION_ARG              6
sqlite3.h:#define SQLITE_LIMIT_ATTACHED                  7
sqlite3.h:#define SQLITE_LIMIT_LIKE_PATTERN_LENGTH       8
sqlite3.h:#define SQLITE_LIMIT_VARIABLE_NUMBER           9
sqlite3.h:#define SQLITE_LIMIT_TRIGGER_DEPTH            10
sqlite3.h:#define SQLITE_LIMIT_WORKER_THREADS           11
sqlite3.h:#define SQLITE_PREPARE_PERSISTENT              0x01
sqlite3.h:#define SQLITE_PREPARE_NORMALIZE               0x02
sqlite3.h:#define SQLITE_PREPARE_NO_VTAB                 0x04
sqlite3.h:#define SQLITE_PREPARE_DONT_LOG                0x10
sqlite3.h:#define SQLITE_INTEGER  1
sqlite3.h:#define SQLITE_FLOAT    2
sqlite3.h:#define SQLITE_BLOB     4
sqlite3.h:#define SQLITE_NULL     5
sqlite3.h:#define SQLITE3_TEXT     3
sqlite3.h:#define SQLITE_UTF8           1    /* IMP: R-37514-35566 */
sqlite3.h:#define SQLITE_UTF16LE        2    /* IMP: R-03371-37637 */
sqlite3.h:#define SQLITE_UTF16BE        3    /* IMP: R-51971-34154 */
sqlite3.h:#define SQLITE_UTF16          4    /* Use native byte order */
sqlite3.h:#define SQLITE_ANY            5    /* Deprecated */
sqlite3.h:#define SQLITE_UTF16_ALIGNED  8    /* sqlite3_create_collation only */
sqlite3.h:#define SQLITE_DETERMINISTIC    0x000000800
sqlite3.h:#define SQLITE_DIRECTONLY       0x000080000
sqlite3.h:#define SQLITE_SUBTYPE          0x000100000
sqlite3.h:#define SQLITE_INNOCUOUS        0x000200000
sqlite3.h:#define SQLITE_RESULT_SUBTYPE   0x001000000
sqlite3.h:#define SQLITE_SELFORDER1       0x002000000
sqlite3.h:#define SQLITE_STATIC      ((sqlite3_destructor_type)0)
sqlite3.h:#define SQLITE_TRANSIENT   ((sqlite3_destructor_type)-1)
sqlite3.h:#define SQLITE_WIN32_DATA_DIRECTORY_TYPE  1
sqlite3.h:#define SQLITE_WIN32_TEMP_DIRECTORY_TYPE  2
sqlite3.h:#define SQLITE_TXN_NONE  0
sqlite3.h:#define SQLITE_TXN_READ  1
sqlite3.h:#define SQLITE_TXN_WRITE 2
sqlite3.h:#define SQLITE_INDEX_SCAN_UNIQUE 0x00000001 /* Scan visits at most 1 row */
sqlite3.h:#define SQLITE_INDEX_SCAN_HEX    0x00000002 /* Display idxNum as hex */
sqlite3.h:#define SQLITE_INDEX_CONSTRAINT_EQ          2
sqlite3.h:#define SQLITE_INDEX_CONSTRAINT_GT          4
sqlite3.h:#define SQLITE_INDEX_CONSTRAINT_LE          8
sqlite3.h:#define SQLITE_INDEX_CONSTRAINT_LT         16
sqlite3.h:#define SQLITE_INDEX_CONSTRAINT_GE         32
sqlite3.h:#define SQLITE_INDEX_CONSTRAINT_MATCH      64
sqlite3.h:#define SQLITE_INDEX_CONSTRAINT_LIKE       65
sqlite3.h:#define SQLITE_INDEX_CONSTRAINT_GLOB       66
sqlite3.h:#define SQLITE_INDEX_CONSTRAINT_REGEXP     67
sqlite3.h:#define SQLITE_INDEX_CONSTRAINT_NE         68
sqlite3.h:#define SQLITE_INDEX_CONSTRAINT_ISNOT      69
sqlite3.h:#define SQLITE_INDEX_CONSTRAINT_ISNOTNULL  70
sqlite3.h:#define SQLITE_INDEX_CONSTRAINT_ISNULL     71
sqlite3.h:#define SQLITE_INDEX_CONSTRAINT_IS         72
sqlite3.h:#define SQLITE_INDEX_CONSTRAINT_LIMIT      73
sqlite3.h:#define SQLITE_INDEX_CONSTRAINT_OFFSET     74
sqlite3.h:#define SQLITE_INDEX_CONSTRAINT_FUNCTION  150
sqlite3.h:#define SQLITE_MUTEX_FAST             0
sqlite3.h:#define SQLITE_MUTEX_RECURSIVE        1
sqlite3.h:#define SQLITE_MUTEX_STATIC_MAIN      2
sqlite3.h:#define SQLITE_MUTEX_STATIC_MEM       3  /* sqlite3_malloc() */
sqlite3.h:#define SQLITE_MUTEX_STATIC_MEM2      4  /* NOT USED */
sqlite3.h:#define SQLITE_MUTEX_STATIC_OPEN      4  /* sqlite3BtreeOpen() */
sqlite3.h:#define SQLITE_MUTEX_STATIC_PRNG      5  /* sqlite3_randomness() */
sqlite3.h:#define SQLITE_MUTEX_STATIC_LRU       6  /* lru page list */
sqlite3.h:#define SQLITE_MUTEX_STATIC_LRU2      7  /* NOT USED */
sqlite3.h:#define SQLITE_MUTEX_STATIC_PMEM      7  /* sqlite3PageMalloc() */
sqlite3.h:#define SQLITE_MUTEX_STATIC_APP1      8  /* For use by application */
sqlite3.h:#define SQLITE_MUTEX_STATIC_APP2      9  /* For use by application */
sqlite3.h:#define SQLITE_MUTEX_STATIC_APP3     10  /* For use by application */
sqlite3.h:#define SQLITE_MUTEX_STATIC_VFS1     11  /* For use by built-in VFS */
sqlite3.h:#define SQLITE_MUTEX_STATIC_VFS2     12  /* For use by extension VFS */
sqlite3.h:#define SQLITE_MUTEX_STATIC_VFS3     13  /* For use by application VFS */
sqlite3.h:#define SQLITE_MUTEX_STATIC_MASTER    2
sqlite3.h:#define SQLITE_TESTCTRL_FIRST                    5
sqlite3.h:#define SQLITE_TESTCTRL_PRNG_SAVE                5
sqlite3.h:#define SQLITE_TESTCTRL_PRNG_RESTORE             6
sqlite3.h:#define SQLITE_TESTCTRL_PRNG_RESET               7  /* NOT USED */
sqlite3.h:#define SQLITE_TESTCTRL_FK_NO_ACTION             7
sqlite3.h:#define SQLITE_TESTCTRL_BITVEC_TEST              8
sqlite3.h:#define SQLITE_TESTCTRL_FAULT_INSTALL            9
sqlite3.h:#define SQLITE_TESTCTRL_BENIGN_MALLOC_HOOKS     10
sqlite3.h:#define SQLITE_TESTCTRL_PENDING_BYTE            11
sqlite3.h:#define SQLITE_TESTCTRL_ASSERT                  12
sqlite3.h:#define SQLITE_TESTCTRL_ALWAYS                  13
sqlite3.h:#define SQLITE_TESTCTRL_RESERVE                 14  /* NOT USED */
sqlite3.h:#define SQLITE_TESTCTRL_JSON_SELFCHECK          14
sqlite3.h:#define SQLITE_TESTCTRL_OPTIMIZATIONS           15
sqlite3.h:#define SQLITE_TESTCTRL_ISKEYWORD               16  /* NOT USED */
sqlite3.h:#define SQLITE_TESTCTRL_GETOPT                  16
sqlite3.h:#define SQLITE_TESTCTRL_SCRATCHMALLOC           17  /* NOT USED */
sqlite3.h:#define SQLITE_TESTCTRL_INTERNAL_FUNCTIONS      17
sqlite3.h:#define SQLITE_TESTCTRL_LOCALTIME_FAULT         18
sqlite3.h:#define SQLITE_TESTCTRL_EXPLAIN_STMT            19  /* NOT USED */
sqlite3.h:#define SQLITE_TESTCTRL_ONCE_RESET_THRESHOLD    19
sqlite3.h:#define SQLITE_TESTCTRL_NEVER_CORRUPT           20
sqlite3.h:#define SQLITE_TESTCTRL_VDBE_COVERAGE           21
sqlite3.h:#define SQLITE_TESTCTRL_BYTEORDER               22
sqlite3.h:#define SQLITE_TESTCTRL_ISINIT                  23
sqlite3.h:#define SQLITE_TESTCTRL_SORTER_MMAP             24
sqlite3.h:#define SQLITE_TESTCTRL_IMPOSTER                25
sqlite3.h:#define SQLITE_TESTCTRL_PARSER_COVERAGE         26
sqlite3.h:#define SQLITE_TESTCTRL_RESULT_INTREAL          27
sqlite3.h:#define SQLITE_TESTCTRL_PRNG_SEED               28
sqlite3.h:#define SQLITE_TESTCTRL_EXTRA_SCHEMA_CHECKS     29
sqlite3.h:#define SQLITE_TESTCTRL_SEEK_COUNT              30
sqlite3.h:#define SQLITE_TESTCTRL_TRACEFLAGS              31
sqlite3.h:#define SQLITE_TESTCTRL_TUNE                    32
sqlite3.h:#define SQLITE_TESTCTRL_LOGEST                  33
sqlite3.h:#define SQLITE_TESTCTRL_USELONGDOUBLE           34  /* NOT USED */
sqlite3.h:#define SQLITE_TESTCTRL_LAST                    34  /* Largest TESTCTRL */
sqlite3.h:#define SQLITE_STATUS_MEMORY_USED          0
sqlite3.h:#define SQLITE_STATUS_PAGECACHE_USED       1
sqlite3.h:#define SQLITE_STATUS_PAGECACHE_OVERFLOW   2
sqlite3.h:#define SQLITE_STATUS_SCRATCH_USED         3  /* NOT USED */
sqlite3.h:#define SQLITE_STATUS_SCRATCH_OVERFLOW     4  /* NOT USED */
sqlite3.h:#define SQLITE_STATUS_MALLOC_SIZE          5
sqlite3.h:#define SQLITE_STATUS_PARSER_STACK         6
sqlite3.h:#define SQLITE_STATUS_PAGECACHE_SIZE       7
sqlite3.h:#define SQLITE_STATUS_SCRATCH_SIZE         8  /* NOT USED */
sqlite3.h:#define SQLITE_STATUS_MALLOC_COUNT         9
sqlite3.h:#define SQLITE_DBSTATUS_LOOKASIDE_USED       0
sqlite3.h:#define SQLITE_DBSTATUS_CACHE_USED           1
sqlite3.h:#define SQLITE_DBSTATUS_SCHEMA_USED          2
sqlite3.h:#define SQLITE_DBSTATUS_STMT_USED            3
sqlite3.h:#define SQLITE_DBSTATUS_LOOKASIDE_HIT        4
sqlite3.h:#define SQLITE_DBSTATUS_LOOKASIDE_MISS_SIZE  5
sqlite3.h:#define SQLITE_DBSTATUS_LOOKASIDE_MISS_FULL  6
sqlite3.h:#define SQLITE_DBSTATUS_CACHE_HIT            7
sqlite3.h:#define SQLITE_DBSTATUS_CACHE_MISS           8
sqlite3.h:#define SQLITE_DBSTATUS_CACHE_WRITE          9
sqlite3.h:#define SQLITE_DBSTATUS_DEFERRED_FKS        10
sqlite3.h:#define SQLITE_DBSTATUS_CACHE_USED_SHARED   11
sqlite3.h:#define SQLITE_DBSTATUS_CACHE_SPILL         12
sqlite3.h:#define SQLITE_DBSTATUS_MAX                 12   /* Largest defined DBSTATUS */
sqlite3.h:#define SQLITE_STMTSTATUS_FULLSCAN_STEP     1
sqlite3.h:#define SQLITE_STMTSTATUS_SORT              2
sqlite3.h:#define SQLITE_STMTSTATUS_AUTOINDEX         3
sqlite3.h:#define SQLITE_STMTSTATUS_VM_STEP           4
sqlite3.h:#define SQLITE_STMTSTATUS_REPREPARE         5
sqlite3.h:#define SQLITE_STMTSTATUS_RUN               6
sqlite3.h:#define SQLITE_STMTSTATUS_FILTER_MISS       7
sqlite3.h:#define SQLITE_STMTSTATUS_FILTER_HIT        8
sqlite3.h:#define SQLITE_STMTSTATUS_MEMUSED           99
sqlite3.h:#define SQLITE_CHECKPOINT_PASSIVE  0  /* Do as much as possible w/o blocking */
sqlite3.h:#define SQLITE_CHECKPOINT_FULL     1  /* Wait for writers, then checkpoint */
sqlite3.h:#define SQLITE_CHECKPOINT_RESTART  2  /* Like FULL but wait for readers */
sqlite3.h:#define SQLITE_CHECKPOINT_TRUNCATE 3  /* Like RESTART but also truncate WAL */
sqlite3.h:#define SQLITE_VTAB_CONSTRAINT_SUPPORT 1
sqlite3.h:#define SQLITE_VTAB_INNOCUOUS          2
sqlite3.h:#define SQLITE_VTAB_DIRECTONLY         3
sqlite3.h:#define SQLITE_VTAB_USES_ALL_SCHEMAS   4
sqlite3.h:#define SQLITE_ROLLBACK 1
sqlite3.h:/* #define SQLITE_IGNORE 2 // Also used by sqlite3_authorizer() callback */
sqlite3.h:#define SQLITE_FAIL     3
sqlite3.h:/* #define SQLITE_ABORT 4  // Also an error code */
sqlite3.h:#define SQLITE_REPLACE  5
sqlite3.h:#define SQLITE_SCANSTAT_NLOOP    0
sqlite3.h:#define SQLITE_SCANSTAT_NVISIT   1
sqlite3.h:#define SQLITE_SCANSTAT_EST      2
sqlite3.h:#define SQLITE_SCANSTAT_NAME     3
sqlite3.h:#define SQLITE_SCANSTAT_EXPLAIN  4
sqlite3.h:#define SQLITE_SCANSTAT_SELECTID 5
sqlite3.h:#define SQLITE_SCANSTAT_PARENTID 6
sqlite3.h:#define SQLITE_SCANSTAT_NCYCLE   7
sqlite3.h:#define SQLITE_SCANSTAT_COMPLEX 0x0001
sqlite3.h:#define SQLITE_SERIALIZE_NOCOPY 0x001   /* Do no memory allocations */
sqlite3.h:#define SQLITE_DESERIALIZE_FREEONCLOSE 1 /* Call sqlite3_free() on close */
sqlite3.h:#define SQLITE_DESERIALIZE_RESIZEABLE  2 /* Resize using sqlite3_realloc64() */
sqlite3.h:#define SQLITE_DESERIALIZE_READONLY    4 /* Database is read-only */
sqlite3.h:#define _SQLITE3RTREE_H_
sqlite3.h:#define NOT_WITHIN       0   /* Object completely outside of query region */
sqlite3.h:#define PARTLY_WITHIN    1   /* Object partially overlaps query region */
sqlite3.h:#define FULLY_WITHIN     2   /* Object fully contained within query region */
sqlite3.h:#define __SQLITESESSION_H_ 1
sqlite3.h:#define SQLITE_SESSION_OBJCONFIG_SIZE  1
sqlite3.h:#define SQLITE_SESSION_OBJCONFIG_ROWID 2
sqlite3.h:#define SQLITE_CHANGESETSTART_INVERT        0x0002
sqlite3.h:#define SQLITE_CHANGESETAPPLY_NOSAVEPOINT   0x0001
sqlite3.h:#define SQLITE_CHANGESETAPPLY_INVERT        0x0002
sqlite3.h:#define SQLITE_CHANGESETAPPLY_IGNORENOOP    0x0004
sqlite3.h:#define SQLITE_CHANGESETAPPLY_FKNOACTION    0x0008
sqlite3.h:#define SQLITE_CHANGESET_DATA        1
sqlite3.h:#define SQLITE_CHANGESET_NOTFOUND    2
sqlite3.h:#define SQLITE_CHANGESET_CONFLICT    3
sqlite3.h:#define SQLITE_CHANGESET_CONSTRAINT  4
sqlite3.h:#define SQLITE_CHANGESET_FOREIGN_KEY 5
sqlite3.h:#define SQLITE_CHANGESET_OMIT       0
sqlite3.h:#define SQLITE_CHANGESET_REPLACE    1
sqlite3.h:#define SQLITE_CHANGESET_ABORT      2
sqlite3.h:#define SQLITE_SESSION_CONFIG_STRMSIZE 1
sqlite3.h:#define _FTS5_H
sqlite3.h:#define FTS5_TOKENIZE_QUERY     0x0001
sqlite3.h:#define FTS5_TOKENIZE_PREFIX    0x0002
sqlite3.h:#define FTS5_TOKENIZE_DOCUMENT  0x0004
sqlite3.h:#define FTS5_TOKENIZE_AUX       0x0008
sqlite3.h:#define FTS5_TOKEN_COLOCATED    0x0001      /* Same position as prev. token */
