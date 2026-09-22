module A = Assay_abi.Abi
module S = A.Schema
module K = Assay_keccak.Keccak

let p typ name : S.parameter = { name; typ }
let uint = p S.Uint256
let address = p S.Address
let fn name inputs outputs mutability : S.function_ = { name; inputs; outputs; mutability }
let functions = [
  fn "name" [] [p S.String ""] A.View;
  fn "symbol" [] [p S.String ""] A.View;
  fn "decimals" [] [p S.Uint8 ""] A.View;
  fn "totalSupply" [] [uint ""] A.View;
  fn "balanceOf" [address "owner"] [uint ""] A.View;
  fn "allowance" [address "owner"; address "spender"] [uint ""] A.View;
  fn "transfer" [address "to"; uint "value"] [p S.Bool ""] A.Nonpayable;
  fn "approve" [address "spender"; uint "value"] [p S.Bool ""] A.Nonpayable;
  fn "transferFrom" [address "from"; address "to"; uint "value"] [p S.Bool ""] A.Nonpayable;
]
let indexed parameter : S.event_parameter = { parameter; indexed = true }
let data parameter : S.event_parameter = { parameter; indexed = false }
let events = [
  "Transfer", [indexed (address "from"); indexed (address "to"); data (uint "value")];
  "Approval", [indexed (address "owner"); indexed (address "spender"); data (uint "value")];
]
let erc20 = S.Constructor ([], false) ::
  List.map (fun f -> S.Function f) functions @
  List.map (fun (name, inputs) -> S.Event (name, inputs, false)) events
let edge = [
  S.Constructor ([address "owner"], true);
  S.Function (fn "write" [p S.Uint8 "a"; uint "b"; address "c"; p S.Bool "d";
    p S.String "line\n\"\\\001"] [] A.Payable);
  S.Function (fn "pair" [] [address "owner"; p S.Uint8 "count"] A.View);
  S.Error ("Rejected", [p S.Bool "reason"; address "caller"]);
  S.Event ("Anonymous", [data (p S.String "text"); indexed (uint "key")], true);
  S.Fallback true; S.Fallback false;
]
let legacy_entries : A.entry list = [
  { name = "read"; inputs = []; mutability = A.View };
  { name = "write"; inputs = ["amount"; "to"]; mutability = A.Nonpayable };
  { name = "pay"; inputs = ["line\n\"\\\001"]; mutability = A.Payable };
]
let legacy_errors : A.custom_error list = [
  { error_name = "Stopped"; arguments = [] };
  { error_name = "Bounds"; arguments = ["actual"; "limit"] };
]
let object_ rows = "{" ^ String.concat "," (List.map
  (fun (key, value) -> A.quote key ^ ":" ^ value) rows) ^ "}"
let signatures = List.map (fun f -> let signature = S.function_signature f in
  signature, A.quote (K.selector signature)) functions
let topics = List.map (fun (name, inputs) ->
  name, A.quote ("0x" ^ K.keccak256 (S.event_signature name inputs))) events
let invariant = fn "same" [address "before"; uint "value"] [uint ""] A.View
let changed = fn "same" [address "after"; uint "renamed"] [] A.Payable
let () = print_endline (object_ [
  "erc20", S.print erc20;
  "selectors", object_ signatures;
  "topics", object_ topics;
  "edge", S.print edge;
  "empty", A.quote (S.print []);
  "legacy", A.quote (A.print ~errors:legacy_errors ~fallback:true legacy_entries);
  "legacy_empty", A.quote (A.print []);
  "legacy_signatures", object_ (List.map (fun e -> e.A.name, A.quote (A.signature e)) legacy_entries);
  "error_signatures", object_ (List.map
    (fun e -> e.A.error_name, A.quote (A.error_signature e)) legacy_errors);
  "invariant", A.quote (S.function_signature invariant);
  "changed", A.quote (S.function_signature changed);
])
