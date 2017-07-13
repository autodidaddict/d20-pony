use "ponytest"
use ".."
use "debug"

class LongDieRolls is UnitTest
  new iso create() => None

  fun name(): String => "d20.LongDieRolls"

  fun apply(h: TestHelper) =>
    let roller = Roller("3d6+4d20+30-5d5+12")
    let result = roller.roll()
    for r in result.values() do 
      Debug.out(r._1.string() + ":" + r._2.string())
    end 

    h.assert_eq[USize](result.rollterms().size(), 5)