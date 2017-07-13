use "regex"
use "time"
use "random"
use "collections"
use "itertools"
use "debug"

type RollResult is (Roll | None)

type TermValue is (Die box | I8 box)

type EvaluatedTerm is (RollTerm box, I32)

class Die
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
  var _term: String ref
  var _termvalue: TermValue = 0

  new ref create(term': String) =>
    _term = term'.clone()
    _term.rstrip()
    if _term.lower().contains("d") then
      let components = _term.split("d")
      try 
        _termvalue = Die(components(0).i8(), components(1).u8())
      else
        _termvalue = 0
      end
    else
      try 
        _term.replace(" ", "")
        _term.replace("+", "")
        let neg = _term.replace("-", "")
        if neg > 0 then 
          _termvalue = _term.i8() * -1
        else 
          _termvalue = _term.i8()
        end 
      end
    end 

  fun value() : TermValue box =>
    _termvalue 

  fun string() : String =>
    _termvalue.string() 

class Roll
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



