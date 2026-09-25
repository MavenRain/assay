def IOTest.written(result: StringResult(Unit)) -> IO(Unit):
  match result:
    case Done{_}: IO.pure(Unit, Unit{})
    case Fail{error}: NativeIO.die(Unit, 17, error)
def IOTest.copied(path: String, result: StringResult(String)) -> IO(Unit):
  match result:
    case Done{text}: IO.bind(StringResult(Unit), Unit, NativeIO.write(path, text), result => IOTest.written(result))
    case Fail{error}: NativeIO.die(Unit, 17, error)
def IOTest.read(result: StringResult(String)) -> IO(Unit):
  match result:
    case Done{text}: NativeIO.stdout(text)
    case Fail{error}: NativeIO.die(Unit, 17, error)
@unsafe
def IOTest.args(args: List<String>) -> IO(Unit):
  match args:
    case Con{"copy", Con{source, Con{target, Nil{}}}}: IO.bind(StringResult(String), Unit, NativeIO.read(source), result => IOTest.copied(target, result))
    case Con{"read", Con{source, Nil{}}}: IO.bind(StringResult(String), Unit, NativeIO.read(source), result => IOTest.read(result))
    case Con{"argv", Con{text, Nil{}}}: NativeIO.stdout(text)
    case _: NativeIO.die(Unit, 64, "invalid IO test arguments")
def IOTest.main() -> IO(Unit): IO.bind(List<String>, Unit, NativeIO.args(), args => IOTest.args(args))
