use "random"
use "collections"

primitive _DiceEvaluator
  """
  Provides functions for evaluating a roll term. Accepts necessary input that 
  includes all pre-requisites, including the random number generator.
  """
  fun apply(rand:Random, term: RollTerm box): I32 => 
    """
    Takes a random number generator and a `RollTerm` object and performs a 
    die roll, returning the result as an `I32`
    """
    match term.value()
      | let t: Die box => _roll(rand, t.mult().i32(), t.sides().i32())
      | let t: I8 box => t.i32()
      else
        0      
    end 

  // Random code borrowed from https://github.com/jtfmumm/acolyte/blob/master/src/rand/rand.pony
  fun  _roll(rand:Random, dice: I32, sides: I32): I32 =>
    """
    Rolls a `sides`-sided die `dice` times, returning the result as 
    determined by the random number generator.
    """
    let mult: I32 = dice.abs().i32()
    var result: I32 = 0
    for i in Range[I32](0, mult) do
      result = result + _i32_between(rand, 1, sides)
    end
    if dice < 1 then
      result * -1
    else 
      result
    end 

   fun  _i32_between(rand: Random, low: I32, high: I32): I32 =>
    let r = (rand.int((high.u64() + 1) - low.u64()) and 0x0000FFFF).i32()
    let value = r + low
    value