
func fuelCostMultiCrab(forPosition: Int, startingPositions: [Int], fuelCost: (Int)->Int) -> Int{
    return startingPositions.map{ fuelCost(abs($0 - forPosition)) }.reduce(0, +)
}

func bruteForce(startingPositions: [Int], fuelCost: (Int)->Int) -> Int {
    return (0..<startingPositions.count).map{ fuelCostMultiCrab(forPosition: $0, startingPositions: startingPositions, fuelCost: fuelCost) }.min()!
}


func day07(){
    let starting_positions = try! String(contentsOfFile: "./inputs/day07.txt").split(separator: ",").map { Int($0)! }
    print("Part 1: ", bruteForce(startingPositions: starting_positions, fuelCost: {$0}))
    // sum(k,k=1..n) = 1/2*n*(n+1) 
    print("Part 2: ", bruteForce(startingPositions: starting_positions, fuelCost: {($0*($0+1)/2)}))
}