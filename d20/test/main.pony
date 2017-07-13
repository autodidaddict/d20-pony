/*actor Main
  new create(env:Env) =>

    let roller = Roller("3d6+5",env.out)
    let result = roller.roll()

    for v in result.values() do
      env.out.print(v._1.string() + ":" + v._2.string())
    end 
    env.out.print("Total " + result.total().string())*/

use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) =>
    test(BasicDieRolls)
    test(LongDieRolls)