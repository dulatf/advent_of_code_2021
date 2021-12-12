struct Coordinate{
    var row : Int
    var col : Int

    var neighbours : [Coordinate] {
        get{
            return [Coordinate(row: row-1, col: col),
            Coordinate(row: row+1, col: col),
            Coordinate(row: row, col: col-1),
            Coordinate(row: row, col: col+1)]
        }
    }
}
extension Coordinate: Hashable{
    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool{
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
    func hash(into hasher: inout Hasher){
        hasher.combine(row)
        hasher.combine(col)
    }
}

struct HeightMap{
    var rows : Int 
    var cols : Int
    var map : [Int]
    init(input: String){
        let lines = input.split(separator:"\n")
        rows = lines.count
        cols = lines.first!.count
        map = []
        for line in lines{
            for char in line{
                map.append(Int(String(char))!)
            }
        }
    }
    func getValue(_ coordinate: Coordinate) -> Int? {
        return getValue(row: coordinate.row, col: coordinate.col)
    }
    func getValue(row: Int, col: Int) -> Int?{
        if row < 0 || row >= rows || col < 0 || col >= cols{
            return nil
        }
        return map[col + row * cols]
    }
    func lowPoints() -> [Coordinate]{
        var lows : [Coordinate] = []
        for y in 0..<rows{
            for x in 0..<cols{
                let current = getValue(row: y, col: x)!
                let north = getValue(row: y-1, col: x) ?? 999
                let south = getValue(row: y+1, col: x) ?? 999
                let west = getValue(row: y, col: x-1)  ?? 999
                let east = getValue(row: y, col: x+1)  ?? 999
                if current < north && current < south && current < west && current < east{
                    //lows.append((x,y))
                    lows.append(Coordinate(row: y, col: x))
                }
            }
        }
        return lows
    }
    // func basinSize(row: Int, col: Int) -> Int {
    //     var size = 0
    //     var todo : [(Int, Int)] = [(row, col)]
    //     let visited : Set<(Int, Int)> = [(row,col)]
    //     while !todo.isEmpty{
    //         let (row, col) = todo.removeFirst()
    //         size+=1
    //         for (nrow, ncol) in [(row-1, col), (row+1, col), (row, col-1), (row, col+1)]{
    //             if !visited.contains((nrow, ncol)) && (getValue(row: nrow, col: ncol) ?? 999) < 9{
    //                 todo.append((nrow, ncol))
    //                 visited.insert((nrow, ncol))
    //             }
    //         }
    //     }
    //     return size
    // }
    func basinSize(low: Coordinate) -> Int {
        var size = 0
        var todo = [low]
        var visited : Set<Coordinate> = [low]
        while !todo.isEmpty{
            let next = todo.removeFirst()
            size += 1
            for coord in next.neighbours{
                if !visited.contains(coord) && (getValue(coord) ?? 999) < 9{
                    todo.append(coord)
                    visited.insert(coord)
                }
            } 
        }
        return size
    }

}
func day09(){
    let input = try! String(contentsOfFile: "./inputs/day09.txt")
    let map = HeightMap(input: input)
    print("Part 1: ", map.lowPoints().map { map.getValue(row: $0.row, col: $0.col)! + 1 }.reduce(0, +))
    let basinSizes = map.lowPoints().map{ map.basinSize(low: $0) }.sorted().reversed()
    print("Part 2: ", basinSizes[..<basinSizes.index(basinSizes.startIndex, offsetBy: 3)].reduce(1, *))
}