lib:

with lib;



let
  escape = str: let
    out = lib.escape ["\"" "\\\""] str;
  in
    ''"${out}"'';

  mapAttrsListConcatSep = sep: f: attrs:
    concatStringsSep sep (mapAttrsToList f attrs);

  serializeValue = val:
    if builtins.isAttrs val then
      builtins.throw "Cannot serialize nested attrs"
    else if builtins.isBool val then
      if val then "true" else "false"
    else if builtins.isFloat val then
      "${toString val}"
    else if builtins.isFunction val then
      builtins.throw "Cannot serialize a function"
    else if builtins.isInt val then
      "${toString val}"
    else if builtins.isList val then
      builtins.throw "Cannot serialize nested list"
    else if builtins.isNull val then
      "null"
    else if builtins.isPath val then
      "${escape val}"
    else if builtins.isString val then
      "${escape val}"
    else
      builtins.throw "Unsupported type given";

  serializeKey = key: val:
    if builtins.isAttrs val then
      builtins.throw "Cannot serialize nested attrs"
    else if builtins.isBool val then
      if val then "  ${key} = true" else "  ${key} = false"
    else if builtins.isFloat val then
      "  ${key} = ${toString val}"
    else if builtins.isFunction val then
      builtins.throw "Cannot serialize a function"
    else if builtins.isInt val then
      "  ${key} = ${toString val}"
    else if builtins.isList val then
      "  ${key} = [${concatMapStringsSep ", " serializeValue val}]"
    else if builtins.isNull val then
      ""
    else if builtins.isPath val then
      "  ${key} = ${escape val}"
    else if builtins.isString val then
      "  ${key} = ${escape val}"
    else
      builtins.throw "Unsupported type given";
in
  attr: mapAttrsListConcatSep
    "\n"
    (key: value:
      ''${key}: {
${mapAttrsListConcatSep "\n" (serializeKey) value}
}''
    )
   attr
