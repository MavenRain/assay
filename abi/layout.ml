(* One whole word per field, in declaration order.  M0 has no packing. *)
let print ~contract fields =
  let rows = List.mapi (fun index label ->
    Printf.sprintf
      "{\"astId\":%d,\"contract\":%s,\"label\":%s,\"offset\":0,\"slot\":%s,\"type\":\"t_uint256\"}"
      index (Abi.quote contract) (Abi.quote label) (Abi.quote (string_of_int index))) fields in
  "{\"storage\":[" ^ String.concat "," rows ^
  "],\"types\":{\"t_uint256\":{\"encoding\":\"inplace\",\"label\":\"uint256\",\"numberOfBytes\":\"32\"}}}\n"
