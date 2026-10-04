import AssayProofs.Storage
import Lean.Data.Json

open Lean AssayProofs AssayProofs.Storage

namespace StorageAdapter

def scalar (name : String) : Except String Scalar :=
  if name == "uint8" then .ok .uint8
  else if name == "uint256" then .ok .uint256
  else if name == "address" then .ok .address
  else if name == "bool" then .ok .bool
  else .error "unsupported-type"

def scalarName : Scalar → String
  | .uint8 => "uint8"
  | .uint256 => "uint256"
  | .address => "address"
  | .bool => "bool"

def error : Error → String
  | .invalidLocation => "invalid-location"
  | .outOfRange typ => "out-of-range:" ++ scalarName typ
  | .certificateFailure => "certificate-failure"

def natural (label text : String) : Except String Nat :=
  if text.isEmpty || !text.toList.all Char.isDigit then
    .error label
  else match text.toNat? with
    | .some value => .ok value
    | .none => .error label

def word (label text : String) : Except String Word := do
  let value ← natural label text
  if bound : value < modulus then .ok ⟨value, bound⟩ else .error label

def access (command typ offset slot before : String) (values : List String) :
    Except String Nat := do
  let typ ← scalar typ
  let offset ← natural "invalid-location" offset
  let slot ← word "invalid-location" slot
  let before ← word "invalid-word" before
  let location ← (field typ offset slot).mapError error
  if command == "read" then
    if values.isEmpty then do
      let value ← (read location before).val.mapError error
      .ok value.val
    else .error "command"
  else if command == "write" then
    match values with
    | [value] =>
      let value ← natural "invalid-value" value
      let value ← (refine location.scalar value).val.mapError error
      let result ← (write location before value).mapError error
      .ok result.val.val
    | [] => .error "command"
    | head :: next :: tail =>
      let _ := (head, next, tail)
      .error "command"
  else .error "command"

def query (source : String) : String :=
  let result := match source.splitOn "|" with
    | [command, typ, value] =>
      if command == "refine" then do
        let typ ← scalar typ
        let value ← natural "invalid-value" value
        let refined ← (refine typ value).val.mapError error
        pure refined.val
      else .error "command"
    | command :: typ :: offset :: slot :: before :: values =>
      access command typ offset slot before values
    | [] | [_a] | [_a, _b] | [_a, _b, _c, _d] => .error "command"
  match result with
  | .ok value => "OK " ++ toString value
  | .error detail => "ERR " ++ detail

def run (source : String) : Except String Json := do
  let json ← Json.parse source
  let rows ← json.getArr?
  if rows.size > 4096 then .error "row-limit" else do
    let results ← rows.toList.mapM fun row => do
      let text ← row.getStr?
      pure (toJson (query text))
    pure (toJson results)

end StorageAdapter

def main (args : List String) : IO UInt32 := do
  let result := match args with
    | [source] => StorageAdapter.run source
    | [] => .error "usage: storageModel JSON"
    | first :: second :: rest =>
      let _ := (first, second, rest)
      .error "usage: storageModel JSON"
  let (output, code) := match result with
    | .ok value => (value, (0 : UInt32))
    | .error detail => (Json.mkObj [("error", toJson detail)], (2 : UInt32))
  let stdout ← IO.getStdout
  match ← (stdout.putStrLn output.compress).toBaseIO with
    | .ok () => return code
    | .error detail =>
      let _ := detail
      return 74
