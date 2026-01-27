
fn md5(s: Bytes) -> String {
  let d = @md5.Digest::new();
  for b in s {
    d.write(b)
  }
  d.check_sum()
}

fn main {
  let args = @env.args()
  let input = if args.length() > 1 {
    args[1]
  } else {
    "Hello, World!"
  }
  let input = @utf8.encode(input)
  println(md5(input))

  let file = try @fs.read_file_to_string("slt/main.mbt") catch {
    e => { println("Could not read select.test: \{e}"); return }
  }

  println(file)

  // write a copy of this file
  //@fs.write_string_to_file(file, "slt/copy_of_main.mbt") catch {
  //  e => { println("Could not write copy_of_main.mbt: \{e}"); return }
  //}
}
