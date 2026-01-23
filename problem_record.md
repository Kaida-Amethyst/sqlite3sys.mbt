
# Problems

1. `sqlite3_bind_parameter_name` 可能会导致程序无法正常退出。

2. `sqlite3_prepare_v2` 会导致程序随机core dump.

3. `sqlite3_free` 只接受 `AnyType`，而 `sqlite3_mprintf`/`sqlite3_expanded_sql`/`sqlite3_str_finish` 返回的是 `CStr`，缺少安全的 `CStr -> AnyType` 转换导致无法释放对应内存。

4. `sqlite3_db_config` 和 `sqlite3_test_control` 在 C 侧是变参接口，当前绑定只暴露了 `op` 参数，调用时存在参数缺失风险。

5. `sqlite3_exec` 在测试中偶发返回 `SQLITE_MISUSE`（"bad parameter or other API misuse"），即使传入了有效 DB 和 SQL，原因待查。

6. `sqlite3_vmprintf`/`sqlite3_vsnprintf` 的绑定参数类型不正确（需要 `va_list`，当前绑定是 `Int`），在测试中调用会直接导致崩溃，已暂时避免执行。

7. `sqlite3_str_vappendf` 需要 `va_list`，当前绑定为 `Int`，测试调用会崩溃，已暂时避免执行。

8. `sqlite3_str_*` 相关 API（`str_new`/`str_append*`/`str_value`/`str_finish`）在测试中出现间歇性 SIGSEGV，已暂时移除对应测试块，原因待查。

9. `sqlite3_shutdown`/`sqlite3_config`/`sqlite3_initialize` 在测试中出现间歇性 SIGBUS，已暂时从测试中移除，原因待查。

10. `sqlite3_db_readonly`/`sqlite3_limit`/`sqlite3_status`/`sqlite3_status64`/`sqlite3_db_status` 等数据库状态接口在测试中出现间歇性 SIGBUS，已暂时移除对应测试段落，原因待查。

11. `sqlite3_set_authorizer`/`sqlite3_set_clientdata`/`sqlite3_get_clientdata`/`sqlite3_unlock_notify` 在测试中出现 SIGSEGV（仅注册回调即崩溃），已移除对应测试，原因待查。

12. `sqlite3_wal_hook` 在测试中出现 SIGSEGV（仅注册回调即崩溃），已移除对应测试，原因待查。

13. `sqlite3_mutex_alloc`/`sqlite3_mutex_try`/`sqlite3_mutex_enter`/`sqlite3_mutex_leave`/`sqlite3_mutex_free` 在测试中出现 SIGKILL，已移除对应测试，原因待查。

14. `sqlite3_vfs_register`/`sqlite3_vfs_unregister` 在全量测试中导致 SIGSEGV（对默认 VFS 操作后后续用例崩溃），已移除对应测试，原因待查。
