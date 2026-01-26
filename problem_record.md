
# Problems

- `sqlite3_database_file_object` caused a SIGBUS when called from `test_capi.mbt` with a file-backed database path (`/tmp/sqlite3sys_test.db`). Guarded the call in tests to avoid crash.
