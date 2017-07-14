use "regex"
use "time"
use "random"
use "collections"
use "itertools"
use "debug"

type RollResult is (Roll | None)

type TermValue is (Die box | I8 box)
  """
  Die roll terms can be either expressed as numerical constants like `+12`
  or as a `Die`, which is a combination of a multiplier and number of sides 
  like `3D12`
  """

type EvaluatedTerm is (RollTerm box, I32)
  """
  An evaluated term is a tuple that pairs the originally parsed die roll term
  with the numerical result of the mathematical evaluation and random number
  generation for that term.
  """

class Die
  """
  A die is a combination of a multiplier and a number of sides, such as
  1D6 for a single roll of a 6-sided die or 3D10 for 3 successive and
  summed rolls of a 10-sided die.
  """
  let _multiplier: I8
  let _sides: U8

  new create(multiplier': I8, sides': U8) =>
    _multiplier = multiplier'
    _sides = sides'

  fun string(): String =>
    _multiplier.string() + "d" + _sides.string()

  fun sides(): U8 =>
    _sides

  fun mult(): I8 =>
    _multiplier 

class RollTerm
  """
  A roll term represents a single component within a larger die roll expression
  """
  var _term: String ref
  var _termvalue: TermValue = 0

  new ref create(term': String) =>    
    _term = term'.clone()
    _term.rstrip()
    if _term.lower().contains("d") then
      let components = _term.split("d")
      try         
        _termvalue = Die(_SmartParser.string_to_i8(components(0)),
         components(1).u8())
      else
        _termvalue = 0
      end
    else
      _termvalue = _SmartParser.string_to_i8(_term)     
    end 

  fun value() : TermValue box =>
    _termvalue 

  fun string() : String =>
    _termvalue.string() 

class Roll
  """
  Roll is an abstraction around a die roll expression. Every time a roll
  is created it computes the sum of the contained roll expressions by
  rolling the dice (random number generation) and simple addition on the
  constant value terms 
  """
  let _expression: String
  let _values: Array[EvaluatedTerm]  
  let _sum: I64 

  new create(expression': String, terms: Array[RollTerm] box) =>
    let rand = MT(Time.micros())
    _expression = expression'
    _values = Array[EvaluatedTerm]    
    for term in terms.values() do          
      _values.push( ( term, _DiceEvaluator(rand, term) ) )      
    end  
    _sum =
    try 
      Iter[EvaluatedTerm](_values.values()).fold[I64]( {(sum: I64,  x: EvaluatedTerm):I64 => sum + x._2.i64() }, 0)      
    else
      0
    end   

  fun rollterms() : Array[EvaluatedTerm] box =>
    _values   

  fun values() : Iterator[EvaluatedTerm] =>
    _values.values() 
  
  fun total() : I64 val =>
    _sum 

class Roller  
  """
  Roller is the main interface into D20. To use it, create an instance of 
  roller with a supplied die roll expression like `3d10+5`. Every time you
  invoke `roll` thereafter, the virtual dice will be rolled and the expression
  will be re-evaluated.
  """
  let _terms : Array[RollTerm]
  let _expression: String 
  
  new create(expression: String) =>    
    _terms = Array[RollTerm]
    _expression = expression

    try
      let r = Regex("([+-]?\\s*\\d+[dD]\\d+|[+-]?\\s*\\d+)")
      let mi = MatchIterator(r, expression)          
        for m in mi do          
          let t = RollTerm(m(0))
          _terms.push(t)          
        end 
    end

  fun roll(): Roll =>
    Roll(_expression, _terms)



