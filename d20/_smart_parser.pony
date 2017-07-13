primitive _SmartParser

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