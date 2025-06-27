#include <sqlite3.h>
#include <stdlib.h>
#include <string.h>
#include "moonbit.h"


// type Sqlite3 // sqlite*
// type Sqlite3_stmt // sqlite3_stmt*
// type Sqlite3_context // sqlite3_context*
// type Sqlite3_backup // sqlite3_backup*
// type Sqlite3_str // sqlite3_str*
// type Sqlite3_value // sqlite3_value*
// type Sqlite3_blob // sqlite3_blob*
// type Sqlite3_mutex // sqlite3_mutex*
// type Sqlite3_vfs // sqlite3_vfs*
// type Sqlite3_file // sqlite3_file*
// type Sqlite3_filename // sqlite3_filename
// type Sqlite3_snapshot // sqlite3_snapshot*
// type Sqlite3_index_info // sqlite3_index_info*
// type Sqlite3_module // sqlite3_module*

int is_nullptr(void* ptr) {
  return ptr == NULL;
}

sqlite3* sqlite3_ptr_init() { return NULL; }
sqlite3_stmt* sqlite3_stmt_ptr_init() { return NULL; }
sqlite3_context* sqlite3_context_ptr_init() { return NULL; }
sqlite3_backup* sqlite3_backup_ptr_init() { return NULL; }
sqlite3_str* sqlite3_str_ptr_init() { return NULL; }
sqlite3_value* sqlite3_value_ptr_init() { return NULL; }
sqlite3_blob* sqlite3_blob_ptr_init() { return NULL; }
sqlite3_mutex* sqlite3_mutex_ptr_init() { return NULL; }
sqlite3_vfs* sqlite3_vfs_ptr_init() { return NULL; }
sqlite3_file* sqlite3_file_ptr_init() { return NULL; }
sqlite3_filename* sqlite3_filename_ptr_init() { return NULL; }
sqlite3_snapshot* sqlite3_snapshot_ptr_init() { return NULL; }
sqlite3_index_info* sqlite3_index_info_ptr_init() { return NULL; }
sqlite3_module* sqlite3_module_ptr_init() { return NULL; }

sqlite3* sqlite3_ptr_from_void_ptr(void *ptr) { return (sqlite3 *)ptr; }
sqlite3_stmt* sqlite3_stmt_ptr_from_void_ptr(void *ptr) { return (sqlite3_stmt *)ptr; }
sqlite3_context* sqlite3_context_ptr_from_void_ptr(void *ptr) { return (sqlite3_context *)ptr; }
sqlite3_backup* sqlite3_backup_ptr_from_void_ptr(void *ptr) { return (sqlite3_backup *)ptr; }
sqlite3_str* sqlite3_str_ptr_from_void_ptr(void *ptr) { return (sqlite3_str *)ptr; }
sqlite3_value* sqlite3_value_ptr_from_void_ptr(void *ptr) { return (sqlite3_value *)ptr; }
sqlite3_blob* sqlite3_blob_ptr_from_void_ptr(void *ptr) { return (sqlite3_blob *)ptr; }
sqlite3_mutex* sqlite3_mutex_ptr_from_void_ptr(void *ptr) { return (sqlite3_mutex *)ptr; }
sqlite3_vfs* sqlite3_vfs_ptr_from_void_ptr(void *ptr) { return (sqlite3_vfs *)ptr; }
sqlite3_file* sqlite3_file_ptr_from_void_ptr(void *ptr) { return (sqlite3_file *)ptr; }
sqlite3_filename* sqlite3_filename_ptr_from_void_ptr(void *ptr) { return (sqlite3_filename *)ptr; }
sqlite3_snapshot* sqlite3_snapshot_ptr_from_void_ptr(void *ptr) { return (sqlite3_snapshot *)ptr; }
sqlite3_index_info* sqlite3_index_info_ptr_from_void_ptr(void *ptr) { return (sqlite3_index_info *)ptr; }
sqlite3_module* sqlite3_module_ptr_from_void_ptr(void *ptr) { return (sqlite3_module *)ptr; }

void* sqlite3_ptr_to_void_ptr(sqlite3 *ptr) { return (void *)ptr; }
void* sqlite3_stmt_ptr_to_void_ptr(sqlite3_stmt *ptr) { return (void *)ptr; }
void* sqlite3_context_ptr_to_void_ptr(sqlite3_context *ptr) { return (void *)ptr; }
void* sqlite3_backup_ptr_to_void_ptr(sqlite3_backup *ptr) { return (void *)ptr; }
void* sqlite3_str_ptr_to_void_ptr(sqlite3_str *ptr) { return (void *)ptr; }
void* sqlite3_value_ptr_to_void_ptr(sqlite3_value *ptr) { return (void *)ptr; }
void* sqlite3_blob_ptr_to_void_ptr(sqlite3_blob *ptr) { return (void *)ptr; }
void* sqlite3_mutex_ptr_to_void_ptr(sqlite3_mutex *ptr) { return (void *)ptr; }
void* sqlite3_vfs_ptr_to_void_ptr(sqlite3_vfs *ptr) { return (void *)ptr; }
void* sqlite3_file_ptr_to_void_ptr(sqlite3_file *ptr) { return (void *)ptr; }
void* sqlite3_filename_ptr_to_void_ptr(sqlite3_filename *ptr) { return (void *)ptr; }
void* sqlite3_snapshot_ptr_to_void_ptr(sqlite3_snapshot *ptr) { return (void *)ptr; }
void* sqlite3_index_info_ptr_to_void_ptr(sqlite3_index_info *ptr) { return (void *)ptr; }
void* sqlite3_module_ptr_to_void_ptr(sqlite3_module *ptr) { return (void *)ptr; }

void *moonbit_str_to_c_str(moonbit_string_t ms) {
  int32_t len = Moonbit_array_length(ms);
  char *ptr = (char *)malloc(len + 1);
  for (int i = 0; i < len; i++) {
    if (ms[i] < 0x80) {
      ptr[i] = ms[i];
    } else {
      ptr[i] = '?';
    }
  }
  ptr[len] = '\0';
  return ptr;
}

moonbit_string_t cstr_to_moonbit_str(void *ptr) {
  char *cptr = (char *)ptr;
  int32_t len = strlen(cptr);
  moonbit_string_t ms = moonbit_make_string(len, 0);
  for (int i = 0; i < len; i++) {
    ms[i] = (uint16_t)cptr[i];
  }
  // free(ptr);
  return ms;
}

moonbit_string_t c_str_to_moonbit_str_with_length(void *ptr, unsigned len) {
  char *cptr = (char *)ptr;
  moonbit_string_t ms = moonbit_make_string(len, 0);
  for (int i = 0; i < len; i++) {
    ms[i] = (uint16_t)cptr[i];
  }
  // free(ptr);
  return ms;
}
