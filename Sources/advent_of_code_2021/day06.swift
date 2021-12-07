func evolve(_ state: Dictionary<Int, Int>) -> Dictionary<Int, Int>{
    var new_state = [8: state[0]!]
    for i in 0...7{
        if i == 6{
            new_state.updateValue(state[i+1]! + state[0]!, forKey:6)
        }else{
            new_state.updateValue(state[i+1]!, forKey: i)
        }
    }
    return new_state
}
func countFish(_ state: Dictionary<Int, Int>) -> Int{   
    return state.values.reduce(0, +)
}
func day06(){
    let counts = try! String(contentsOfFile: "./inputs/day06.txt").split(separator: ",").map { Int($0)! }
    print("Initial count: \(counts.count)")
    var state = [0: 0, 1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0, 8:0]
    for count in counts{
        state[count]! += 1
    }
    print(state)
    print(countFish(state))
    for day in 1...256{
        let new_state = evolve(state)
        state=new_state
        if day == 80{
            print("After 80 days: \(countFish(state))")
        }
    }
    print("After 256 days: \(countFish(state))")
}
