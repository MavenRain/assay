# Native Bend source, compiled by dev/build.py.
@unsafe
def Layout.print(+contract_274: String, +fields_275: ListOf(String)) -> String:
  (+scrut8643 = {SeqList.mapi(&2, &2, String, String, (+local8636 => +local8638 => (String.concat(["{\u{22}astId\u{22}:", Big.show(local8636), ",\u{22}contract\u{22}:", Abi.quote(contract_274), ",\u{22}label\u{22}:", Abi.quote(local8638), ",\u{22}offset\u{22}:0,\u{22}slot\u{22}:", Abi.quote(Big.show(local8636)), ",\u{22}type\u{22}:\u{22}t_uint256\u{22}}"]))), fields_275) : ListOf(String)}
  String.append("{\u{22}storage\u{22}:[", String.append(String.join(scrut8643, ","), "],\u{22}types\u{22}:{\u{22}t_uint256\u{22}:{\u{22}encoding\u{22}:\u{22}inplace\u{22},\u{22}label\u{22}:\u{22}uint256\u{22},\u{22}numberOfBytes\u{22}:\u{22}32\u{22}}}}\u{a}")))
