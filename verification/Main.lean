import AssayProofs
import Lean.Data.Json

open AssayProofs Lean

namespace SourceAdapter

inductive Error where
  | format (detail : String)
  | number
  | wordRange
  | limit
  | duplicate
  | unknownNode (tag : String)
  | source (error : SourceError)
  | io (detail : String)
  deriving Repr

def field (json : Json) (key : String) : Except Error Json :=
  (json.getObjVal? key).mapError Error.format

def text (json : Json) : Except Error String := json.getStr?.mapError Error.format

def natural (json : Json) : Except Error Nat := do
  let value ← text json
  if value.isEmpty || value.length > 78 || !value.toList.all Char.isDigit then .error .number
  else match value.toNat? with
    | .some number => .ok number
    | .none => .error .number

def word (json : Json) : Except Error Word := do
  let value ← natural json
  if bound : value < modulus then .ok ⟨value, bound⟩ else .error .wordRange

def parseOperand (json : Json) : Except Error Operand := do
  let tag ← text (← field json "tag")
  if tag == "literal" then return .literal (← word (← field json "value"))
  else if tag == "memory" then return .memory (← natural (← field json "index"))
  else .error (.unknownNode tag)

def parseTransaction : Nat → Json → Except Error Transaction
  | 0, _json => .error .limit
  | fuel + 1, json => do
    let tag ← text (← field json "tag")
    if tag == "finish" then return .finish (← parseOperand (← field json "value"))
    else if tag == "abort" then return .abort
    else if tag == "store" then
      return .store (← word (← field json "slot")) (← parseOperand (← field json "value"))
        (← parseTransaction fuel (← field json "next"))
    else if tag == "load" then
      return .load (← word (← field json "slot")) (← natural (← field json "index"))
        (← parseTransaction fuel (← field json "next"))
    else if tag == "add" || tag == "sub" then
      return .arithmetic (if tag == "add" then .add else .sub)
        (← parseOperand (← field json "left")) (← parseOperand (← field json "right"))
        (← natural (← field json "index")) (← parseTransaction fuel (← field json "yes"))
        (← parseTransaction fuel (← field json "no"))
    else if tag == "compare" then
      return .compare (← parseOperand (← field json "left")) (← parseOperand (← field json "right"))
        (← parseTransaction fuel (← field json "yes")) (← parseTransaction fuel (← field json "no"))
    else .error (.unknownNode tag)

def pair (json : Json) : Except Error (Json × Json) := do
  let values ← json.getArr?.mapError Error.format
  match values.toList with
  | [left, right] => .ok (left, right)
  | [] | [_] | _ :: _ :: _ :: _ => .error (.format "expected a pair")

def rows {α : Type} (key : Json → Except Error α) (json : Json) :
    Except Error (List (α × Word)) := do
  let values ← json.getArr?.mapError Error.format
  if values.size > 1024 then .error .limit
  else values.toList.mapM fun row => do
    let (left, right) ← pair row
    return (← key left, ← word right)

def distinct {α : Type} [BEq α] : List (α × Word) → Bool
  | [] => true
  | (key, _value) :: rest => !rest.any (fun row => row.1 == key) && distinct rest

def eventJson (event : Event) : Json :=
  let op := match event.operation with | .add => "add" | .sub => "sub"
  let result := match event.result with
    | .ok value => [("result", toJson "ok"), ("value", toJson (toString value.val))]
    | .error .overflow => [("result", toJson "overflow")]
    | .error .underflow => [("result", toJson "underflow")]
  Json.mkObj ([("op", toJson op), ("left", toJson (toString event.left.val)),
    ("right", toJson (toString event.right.val))] ++ result)

def executionJson (execution : Execution) : Json :=
  let (result, storage) := match execution.outcome with
    | .success value storage => ([("status", toJson "success"),
        ("value", toJson (toString value.val))], storage)
    | .revert storage => ([("status", toJson "revert")], storage)
  Json.mkObj (result ++ [("storage", toJson (storage.filter (fun row => row.2 != zero)
    |>.map (fun row => (toString row.1.val, toString row.2.val)))),
    ("events", Json.arr (execution.events.map eventJson).toArray)])

def run (source : String) : Except Error Json := do
  if source.utf8ByteSize > 65536 then .error .limit
  else
    let json ← (Json.parse source).mapError Error.format
    let storage ← rows word (← field json "storage")
    let memory ← rows natural (← field json "memory")
    if !distinct storage || !distinct memory then .error .duplicate
    else
      let program ← parseTransaction 129 (← field json "program")
      let execution ← (execute storage storage memory program).mapError Error.source
      return executionJson execution

def printOutput (output : String) : IO (Except Error Unit) := do
  try
    (← IO.getStdout).putStrLn output
    return .ok ()
  catch error => return .error (.io error.toString)

end SourceAdapter

def main (args : List String) : IO UInt32 := do
  let result := match args with
    | [source] => SourceAdapter.run source
    | [] | _ :: _ :: _ => .error (.format "usage: sourceModel JSON")
  let (output, code) := match result with
    | .ok output => (output, (0 : UInt32))
    | .error error => (Json.mkObj [("error", toJson (reprStr error))], (2 : UInt32))
  match ← SourceAdapter.printOutput output.compress with
  | .ok () => return code
  | .error error =>
    let stderr ← IO.getStderr
    let _ ← (stderr.putStrLn (reprStr error)).toBaseIO
    return 74
