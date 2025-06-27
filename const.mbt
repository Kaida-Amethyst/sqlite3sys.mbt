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
