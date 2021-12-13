struct Map{
    var rows : Int
    var cols : Int
    var map : [Int]
    init(_ input: String){
        let lines = input.split(separator: "\n")
        rows = lines.count
        cols = lines.first!.count
        map = []
        for line in lines{
            for char in line{
                map.append(Int(String(char))!)
            }
        }
    }
    func readyToFlash(alreadyFlashed: [Bool]) -> [(Int, Int)]{
        var result : [(Int, Int)] = []
        for row in 0..<rows{
            for col in 0..<cols{
                if map[row * cols + col] > 9 && !alreadyFlashed[row * cols + col]{
                    result.append((row, col))
                }
            }
        } 
        return result
    }
    func validate(row: Int, col: Int) -> (Int, Int)?{
        if(row >= 0 && row < rows && col >= 0 && col < cols){
            return (row, col)
        }
        return nil
    }
    func neighbours(row: Int, col: Int) -> [(Int, Int)]{
        var neighbours : [(Int, Int)] = []
        if let coord = validate(row: row-1, col: col-1){
            neighbours.append(coord)
        }
        if let coord = validate(row: row-1, col: col){
            neighbours.append(coord)
        }
        if let coord = validate(row: row-1, col: col+1){
            neighbours.append(coord)
        }
        if let coord = validate(row: row, col: col-1){
            neighbours.append(coord)
        }
        if let coord = validate(row: row, col: col+1){
            neighbours.append(coord)
        }
        if let coord = validate(row: row+1, col: col-1){
            neighbours.append(coord)
        }
        if let coord = validate(row: row+1, col: col){
            neighbours.append(coord)
        }
        if let coord = validate(row: row+1, col: col+1){
            neighbours.append(coord)
        }
        return neighbours
    }
    mutating func step() -> Int{
        var flashed = Array(repeating: false, count: map.count)
        for row in 0..<rows{
            for col in 0..<cols{
                map[row * cols + col] += 1
            }
        }
        var todo = readyToFlash(alreadyFlashed: flashed)
        while !todo.isEmpty{
            for (row, col) in todo{
                for (nrow, ncol) in neighbours(row: row, col: col){
                    map[nrow * cols + ncol] += 1
                }
                flashed[row * cols + col] = true
            }
            todo = readyToFlash(alreadyFlashed: flashed)
        }

        var counter = 0
        for row in 0..<rows{
            for col in 0..<cols{
                if flashed[row * cols + col]{
                    counter += 1
                    map[row * cols + col] = 0
                }
            }
        }
        return counter
    }
    func prettyPrint(){
        for row in 0..<rows{
            for col in 0..<cols{
                print(map[row*cols + col], terminator: "")
            }
            print()
        }
    }
}
func day11(){
    let input = try! String(contentsOfFile: "./inputs/day11.txt")
    var state = Map(input)
    var totalFlashed = 0 
  
    for step in 0..<1000{
        let flashesThisStep = state.step()
        if step < 100{
        totalFlashed += flashesThisStep
        }
        if flashesThisStep == state.cols * state.rows{
            print("Synchronized flash at step \(step+1)")
            break
        }
    }
    print("Part 1: ", totalFlashed)

}