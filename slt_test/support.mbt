///|
pub enum SortMode {
  NoSort
  RowSort
  ValueSort
}

///|
pub enum ExpectedResult {
  Values(Array[String])
  Hash(Int, String)
}

///|
pub enum Record {
  Statement(Bool, String, Bool)
  Query(String, SortMode, String?, String, ExpectedResult, Bool)
  HashThreshold(Int)
  Halt
}

///|
type LabelEntry = (String, String)

///|
fn char_to_string(c : Char) -> String { "\{c}" }

///|
fn int_to_string(i : Int) -> String { "\{i}" }

///|
fn int64_to_string(i : Int64) -> String { "\{i}" }

///|
fn sanitize_text(s : String) -> String {
  let mut out = ""
  for c in s {
    if c < ' ' || c > '~' {
      out = out + "@"
    } else {
      out = out + char_to_string(c)
    }
  }
  if out.length() == 0 { "(empty)" } else { out }
}

///|
fn pad3(n : Int) -> String {
  if n < 10 { "00" + int_to_string(n) }
  else if n < 100 { "0" + int_to_string(n) }
  else { int_to_string(n) }
}

///|
fn format_double_3(x : Double) -> String {
  let scaled = x * 1000.0
  let rounded = if scaled >= 0.0 { scaled + 0.5 } else { scaled - 0.5 }
  let mut i = rounded.to_int()
  let neg = i < 0
  if neg { i = -i }
  let int_part = i / 1000
  let frac = i % 1000
  let mut s = int_to_string(int_part) + "." + pad3(frac)
  if neg { s = "-" + s }
  s
}

///|
fn cmp_string(a : String, b : String) -> Int {
  let mut i = 0
  let len_a = a.length()
  let len_b = b.length()
  let min_len = if len_a < len_b { len_a } else { len_b }
  while i < min_len {
    let ca = a[i]
    let cb = b[i]
    if ca < cb { return -1 }
    if ca > cb { return 1 }
    i = i + 1
  }
  if len_a == len_b { 0 } else if len_a < len_b { -1 } else { 1 }
}

///|
fn sort_values(arr : Array[String]) -> Unit {
  arr.sort_by(fn(a, b) { cmp_string(a, b) })
}

///|
fn sort_rows(arr : Array[String], ncol : Int) -> Unit {
  let nrow = arr.length() / ncol
  if nrow <= 1 { return }
  let row_idx : Array[Int] = []
  let mut i = 0
  while i < nrow {
    row_idx.push(i)
    i = i + 1
  }
  row_idx.sort_by(fn(a, b) {
    let mut k = 0
    while k < ncol {
      let av = arr[a * ncol + k]
      let bv = arr[b * ncol + k]
      let c = cmp_string(av, bv)
      if c != 0 { return c }
      k = k + 1
    }
    0
  })
  let tmp : Array[String] = []
  i = 0
  while i < row_idx.length() {
    let r = row_idx[i]
    let mut k = 0
    while k < ncol {
      tmp.push(arr[r * ncol + k])
      k = k + 1
    }
    i = i + 1
  }
  i = 0
  while i < tmp.length() {
    arr[i] = tmp[i]
    i = i + 1
  }
}

///|
fn md5_values(values : Array[String]) -> String {
  let mut joined = ""
  let mut i = 0
  while i < values.length() {
    joined = joined + values[i] + "\n"
    i = i + 1
  }
  let bytes = @utf8.encode(joined)
  let d = @md5.Digest::new()
  for b in bytes {
    d.write(b)
  }
  d.check_sum()
}

///|
let slt_exec_callback : FuncRef[(AnyType, Int, FixedArray[CStr], FixedArray[CStr]) -> Int] =
  fn(_data, _cols, _values, _names) { 0 }

///|
fn run_statement(db : Sqlite3, sql : String, expect_ok : Bool) -> Unit raise Error {
  let rc = @sqlite3sys.sqlite3_exec(
    db,
    CStr::from_string(sql),
    slt_exec_callback,
    Sqlite3::to_void_ptr(Sqlite3::init()),
    Sqlite3::to_void_ptr(Sqlite3::init()),
  )
  if expect_ok {
    assert_true(rc == @sqlite3sys.SQLITE_OK)
  } else {
    assert_true(rc != @sqlite3sys.SQLITE_OK)
  }
}

///|
fn query_results(db : Sqlite3, sql : String, types : String) -> Array[String] raise Error {
  let stmt = Ref::new(Sqlite3_stmt::init())
  let tail = Ref::new(CStr::from_string(""))
  let prep = @sqlite3sys.sqlite3_prepare_v2(db, CStr::from_string(sql), -1, stmt, tail)
  assert_true(prep == @sqlite3sys.SQLITE_OK)
  let ncol = @sqlite3sys.sqlite3_column_count(stmt.val)
  assert_true(ncol == types.length())
  let values : Array[String] = []
  let mut step = @sqlite3sys.sqlite3_step(stmt.val)
  while step == @sqlite3sys.SQLITE_ROW {
    let mut i = 0
    while i < ncol {
      if @sqlite3sys.sqlite3_column_type(stmt.val, i) == @sqlite3sys.SQLITE_NULL {
        values.push("NULL")
      } else {
        let t = types[i]
        if t == 'T' {
          let text = @sqlite3sys.sqlite3_column_text(stmt.val, i)
          if CStr::is_nullptr(text) {
            values.push("NULL")
          } else {
            let s = CStr::convert_to_moonbit_string(text)
            values.push(sanitize_text(s))
          }
        } else if t == 'I' {
          let v = @sqlite3sys.sqlite3_column_int64(stmt.val, i)
          values.push(int64_to_string(v))
        } else {
          let v = @sqlite3sys.sqlite3_column_double(stmt.val, i)
          values.push(format_double_3(v))
        }
      }
      i = i + 1
    }
    step = @sqlite3sys.sqlite3_step(stmt.val)
  }
  let fin = @sqlite3sys.sqlite3_finalize(stmt.val)
  assert_true(fin == @sqlite3sys.SQLITE_OK)
  values
}

///|
fn check_label(label_map : Ref[Array[LabelEntry]], label : String, hash : String) -> Unit raise Error {
  let mut i = 0
  while i < label_map.val.length() {
    let entry = label_map.val[i]
    if entry.0 == label {
      assert_true(entry.1 == hash)
      return
    }
    i = i + 1
  }
  label_map.val.push((label, hash))
}

///|
fn run_query(
  db : Sqlite3,
  types : String,
  sort_mode : SortMode,
  label : String?,
  sql : String,
  expected : ExpectedResult,
  skip : Bool,
  hash_threshold : Int,
  label_map : Ref[Array[LabelEntry]],
) -> Unit raise Error {
  if skip {
    match label {
      None => ()
      Some(lab) => {
        let h = match expected {
          Hash(_, hv) => hv
          Values(vals) => md5_values(vals)
        }
        check_label(label_map, lab, h)
      }
    }
    return
  }
  let results = query_results(db, sql, types)
  match sort_mode {
    NoSort => ()
    RowSort => sort_rows(results, types.length())
    ValueSort => sort_values(results)
  }
  let use_hash = hash_threshold > 0 && results.length() > hash_threshold
  match label {
    None => ()
    Some(lab) => {
      let h = md5_values(results)
      check_label(label_map, lab, h)
    }
  }
  match expected {
    Values(vals) => {
      if use_hash {
        let h = md5_values(results)
        let line = int_to_string(results.length()) + " values hashing to " + h
        if !(vals.length() == 1 && vals[0] == line) {
          println("slt mismatch (hash-mode)")
          println("sql:\n" + sql)
          println("expected: " + (if vals.length() > 0 { vals[0] } else { "<empty>" }))
          println("actual: " + line)
          assert_true(false)
        }
      } else {
        if results != vals {
          println("slt mismatch (values)")
          println("sql:\n" + sql)
          if vals.length() <= 12 && results.length() <= 12 {
            println("expected all: " + vals.to_string())
            println("actual all: " + results.to_string())
          }
          let mut idx = 0
          let min_len = if results.length() < vals.length() { results.length() } else { vals.length() }
          while idx < min_len && results[idx] == vals[idx] {
            idx = idx + 1
          }
          if idx < min_len {
            println("first diff at index " + int_to_string(idx))
            println("expected: " + vals[idx])
            println("actual: " + results[idx])
          } else if results.length() != vals.length() {
            println(
              "length mismatch expected=" + int_to_string(vals.length()) + " actual=" +
              int_to_string(results.length()),
            )
          }
          assert_true(false)
        }
      }
    }
    Hash(count, hash) => {
      let h = md5_values(results)
      if results.length() != count || h != hash {
        println("slt mismatch (hash)")
        println("sql:\n" + sql)
        println(
          "expected count/hash: " + int_to_string(count) + " / " + hash +
          " actual: " + int_to_string(results.length()) + " / " + h,
        )
        assert_true(false)
      }
    }
  }
}
