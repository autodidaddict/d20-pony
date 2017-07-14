primitive _SmartParser
  """
  The smart parser is a slightly more lenient converter from string to 
  integer. It will strip out interleaved whitespace and remove the "+" 
  from an expression. It will also strip out the "-" from an expression and 
  return a negative integer in response. 
  """

  fun string_to_i8(instr: String box): I8 =>
    let i = instr.clone()
    i.rstrip()
    i.lstrip()
    i.replace(" ", "")
    i.replace("+", "")
    let neg = i.replace("-", "")
    try 
      if neg > 0 then
        i.i8() * -1
      else
        i.i8()
      end 
    else
      0
    end 