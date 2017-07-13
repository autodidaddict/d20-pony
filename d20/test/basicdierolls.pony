use "ponytest"
use ".."
use "debug"

class BasicDieRolls is UnitTest
  new iso create() => None

  fun name(): String => "d20.BasicDieRolls"

  fun apply(h: TestHelper) =>
    let roller = Roller("3d6+5")
    let result = roller.roll()
    for r in result.values() do 
      Debug.out(r._1.string() + ":" + r._2.string())
    end 

    h.assert_true(result.total() >= 7)    

    let r2 = Roller("5d20 +  + 30")
    let result2 = r2.roll()

    for r in result2.values() do 
      Debug.out(r._1.string() + ":" + r._2.string())
    end 
    
    h.assert_true(result2.total() >= 35)    