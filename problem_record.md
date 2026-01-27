
# Problems

- `sqlite3_database_file_object` caused a SIGBUS when called with a normal database filename (`/tmp/sqlite3sys_test.db`). Per `sqlite3.h`, this API only accepts a journal/WAL filename that was passed to VFS `xOpen`; any other use is undefined and can crash. Guarded the call in tests to avoid crash.
