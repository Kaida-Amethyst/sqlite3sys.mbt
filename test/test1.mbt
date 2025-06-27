///|
test "Just some examples" {
  let s = "Hello, World!"
  inspect(s, content="Hello, World!")
  let x = 1 + 2
  assert_true(x == 3)
  assert_false(x == 4)
  let x : Int? = Some(42)
  assert_true(x is Some(42)) // pattern matching

  // call functions in sqlite3sys.
  let s = @sqlite3sys.sqlite3_libversion()
    |> @sqlite3sys.CStr::convert_to_moonbit_string
  inspect(s, content="3.43.2")
}
