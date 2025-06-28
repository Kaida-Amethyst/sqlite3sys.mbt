# 关于这个仓库

这个仓库是一个sqlite3的简易版moonbit binding，提供一个无抽象的sqlite3接口binding，每一个接口基本上都对应了一个sqlite3的c-api，为以后的高阶抽象打下基础。

目标是确保每一个moonbit接口都可以正常运转。

# 文件结构

- `capi.mbt`: 存放sqlite3sys库提供的capi到moonbit api的一对一绑定。

- `const.mbt`: sqlite3中的常量。

- `wrap.c`：一些必要的C封装。

- `sqlite3.h`: sqlite3头文件。

- `sqlite3_define.h`: 将sqlite3中定义宏单独拿出，用于const.mbt的来源。

- `problems_record.md`: 记录存在但很难解决的问题。

# Moonbit C-FFI机制

基本如类型`Int`，`Double`等是一一对应的。`Int -> int`, `Double -> double`。

Moonbit定义的复合类型，如String，Array等在`~/.moon/include/moonbit.h`

通过`type X`定义的类型，在C侧都是`void*`，无论是`type Sqlite3`还是`type CStr`，编译成C都是`void*`。调用函数时需要依赖C语言的隐式类型转换。

moonbit的函数`(A, B, C) -> D`实际上是一个闭包，转换成C是一个结构体，只有`FuncRef[(A, B, C) -> D]`转换成C才是一个函数指针。

`FixedArray[T]` 转换成C是一个`T*`, C函数如果需要传入一个C对象序列就要传入这个。

`Ref[T]` 转换成C是一个结构体，但是可以当做`T*`来看待。

# 如何查看编译出来的c代码

运行`moon test --target native`后，可以在`target`目录下找到`.c`文件。

# 当前版本AI的权限

- 目前本仓库的版本定义为alpha，AI拥有极大的权限，可以修改仓库下的任意代码。

# moonbit命令

- `moon check --target native`: 运行静态分析器，检查代码是否有类型错误，是否有没有使用过的函数，或者是其他的问题。

- `moon test --target native`：运行所有测试，包括在注释文档中的用`moonbit`标记的代码块。

- `moon test --target native -p test`: 只运行`test`目录下的测试。

- `moon test --target native --verbose`: 会多输出一些额外的内容来辅助测试。

- `moon info --target native`: 从代码库中生成`.mbti`文件，因此不要直接改.mbti文件，而是使用这个命令。

- `moon fmt`: 格式化代码，因此不要手动格式化，使用这个命令。


# 在github上CI运行的任务

1. `moon fmt`，格式化代码。

2. `moon info --target native`，获取`.mbti`文件，这个文件保存了所有函数接口的类型信息。相当于一份代码地图。

3. `moon check --target native`，静态分析，特别地，会把所有没有使用过的函数列出来。

4. `moon test --target native`：测试所有代码，包括文档中的代码块。

5. `moon clean && moon test --target native --release`：这个命令会运行多次（大约20次），以保证没有随机bug，`moon clean`会清除已经编译的内容。

# AI的主要任务

1. 检查每一个api接口是否有良好的对应。也就是类型对应是否正确。有模糊的地方，需要写报告。

2. 在test下编写测试，看一些函数能否正常运转。需要注意，不要测试哪些与平台或者版本强相关的接口，例如test块中不要测`libversion`这个函数。

3. 编写测试的时候，注意使用一些没有使用过的函数接口，使用`moon check --target native`会输出警告，其中一些就会提示哪些函数没有使用过。比较简便的方式是`moon check --target native --output-json > diag.json` 得到一个diag.json的诊断列表，接着使用`grep -rn "Unused function\'sqlite3" diag.json` 来快速得到所有没有使用的sqlite3接口。根据这些提示来新创建test文件来测试。

4. 所有测试文件都需要以`test_`开头，`.mbt`结尾，不可以通过删除capi.mbt下的接口来消去warning！

5. 一旦发现某个函数的使用会导致异常行为，例如core dump，程序无法正常退出，或者得到了预期不符的结果，需要记录在problem_record.md下。

# Moonbit中的一些语法糖(本仓库中不一定会用到)

- `match`语法，类似Rust，但是注意每一个语句末尾不要使用`,`

```moonbit
let s = "hello world"

let len = match s.length() {
  0 => 0
  1 => 1
  n => n
}
// ...
```

moonbit可以支持字符串匹配：

```moonbit
let s = "hello world"

mathc s {
  ['w', 'o', ..] => println("start with 'wo'")
  [.."hello", ..rest] => println("start with hello, and rest is \{rest}")
  other if other == "none" => println("str is none")
  _ => println("other cases")
}

```

- `loop`函数式循环。
循环体类似于 match 表达式，每个分支尝试匹配循环变量并执行对应操作。您可以使用 continue 关键字以给定的循环值开始下一次迭代，或者使用 break 关键字以给定的输出值退出循环。在每个分支的尾部表达式中，break 是隐式的，因此不需要写出。

```moonbit
enum List {
  Nil
  Cons(Int, List)
}

let sum = loop xs, 0 {
  Nil, acc => acc
  Cons(x, rest), acc => continue rest, x + acc
}
```

- `is`表达式

`is`表达式可以用于简易模式匹配。

```moonbit

let s : Int? = Some(3)
assert_true(s is Some(3))

let t: Result[Int, Error] = some_func()
assert_true(t is Ok(_))
```

- `guard` 守卫语句，有时可代替`if`

```moonbit
let res : Result[Int, Error] = some_func()
guard res is Some(x) else {
  //
}

assert_true(x == 3)
```

- `fn` 函数内定义函数:

```moonbit
fn f() -> Unit {
  fn g() {
    println("call g in f")
  }
  g()
}
```

也可以使用`letrec`加上箭头函数：

```moonbit
fn f() -> Unit {
  letrec g = () => println("call g in f")
  g()
}
```

`letrec`可以指定类型：

```moonbit
fn f() -> Unit {
  letrec g : ()-> Unit = () => println("call g in f")
  g()
}
```
注意这里的函数类型`() -> Unit`，标记成`FuncRef[() -> Unit]`是可以的，但是`() -> Unit`编译成C的时候是一个闭包结构体，而`FuncRef[() -> Unit]`是一个`void (*)()`函数指针，在调用sys的接口时，务必需要注意一下。

- 函数的返回类型，如果包含错误，建议使用`T raise Error` 的形式，而并非Rust的直接返回Result，这是因为moonbit有一个`try?`语法可以将这种函数转换成Result返回类型：

```moonbit
// 定义error
suberror MyError {
  Error_A
  Error_B
  Error_C
} derive(Show)

fn foo(x: Int) -> Int raise Error {
  match x {
    _..<0 => raise Error_A // _..<0 means less than 0
    10..=20 => raise Error_B // 10..=20 means from 10 to 20 (including 20)
    21..<_ => raise Error_c // 21..<_ means larger than 21
    n => n
  }
}

fn main_err() -> Unit raise Error {
  let t = foo(5) // 在允许抛出异常的函数内，可以直接调用可抛出异常的函数。
  println(t)
}

// 不可以抛出异常的函数，不能直接调用，需要使用`try?`来将函数类型转换成Result.
fn main {
  match (try? foo(100)) { // (try? foo(100)) 的返回值是Result[Int, Error]
    Ok(n) => println(n)
    Err(e) => println(e)
  }
}
```

# 任务提交要求

每一次提交任务，必须`moon test --target native`命令让所有测试通过。

`.mbt`代码文件必须使用英文，不可以使用中文，这是因为在部分平台下，代码文件出现中文可能会出现编译错误，如果发现.mbt出现中文，需要修改成英文。
