struct VentLine{
    var start: (Int, Int)
    var end: (Int, Int)

    init(from: (Int, Int), to: (Int, Int)){
        start = from
        end = to
    }
    init(parse: String.SubSequence){
        let parts = parse.components(separatedBy: " -> ")
        let from_coord_str = parts.first!.components(separatedBy: ",")
        let to_coord_str = parts.last!.components(separatedBy: ",")
        self.init(from: (Int(from_coord_str.first!)!, Int(from_coord_str.last!)!),
             to: (Int(to_coord_str.first!)!, Int(to_coord_str.last!)!))
    }
}

func boundingBox(_ vents: [VentLine]) -> ((Int, Int), (Int, Int)){
    var min_x = Int.max, max_x = Int.min
    var min_y = Int.max, max_y = Int.min
    for vent in vents{
        min_x = min(min_x, vent.start.0)
        min_x = min(min_x, vent.end.0)

        min_y = min(min_y, vent.start.1)
        min_y = min(min_y, vent.end.1)

        max_x = max(max_x, vent.start.0)
        max_x = max(max_x, vent.end.0)

        max_y = max(max_y, vent.start.1)
        max_y = max(max_y, vent.end.1)
    }
    return ((min_x, min_y), (max_x, max_y))
}

struct VentGrid{
    var origin : (Int, Int)
    var width : Int
    var height : Int
    var grid : Array<Int>

    init(_ vent_lines: [VentLine], skip_diagonals: Bool = true){
        let (min_point, max_point) = boundingBox(vent_lines)
        origin = min_point
        width = max_point.0 - min_point.0+1
        height = max_point.1 - min_point.1+1
        grid = Array<Int>(repeating: 0, count: width * height)
        
        for vent_line in vent_lines{
            fill_line(vent_line, skip_diagonals: skip_diagonals)
        }
    }
    mutating func fill_line(_ vent_line: VentLine, skip_diagonals: Bool){
        let vx = vent_line.end.0 - vent_line.start.0
        let vy = vent_line.end.1 - vent_line.start.1
        let len = abs(vx != 0 ? vx : vy)
        let dx : Int = vx / len
        let dy : Int = vy / len        
        if dx != 0 && dy != 0 && skip_diagonals{
            return
        }
        for i in 0...len{
            let cx =  vent_line.start.0 + i * dx
            let cy = vent_line.start.1 + i * dy
            add_point(x: cx, y: cy)
        }
    }
    mutating func add_point(x: Int, y: Int) {
        let cx = x - origin.0
        let cy = y - origin.1
        grid[cx + cy * width]+=1
    }

    func count_overlap_points() -> Int {
        var counter = 0
        for cell in grid{
            if cell > 1{
                counter += 1
            }
        }
        return counter
    }
}

func day05(){
    let input = try! String(contentsOfFile: "./inputs/day05.txt").split(separator: "\n");
    let lines = input.map{ VentLine(parse: $0)}
    let grid = VentGrid(lines)
    let overlapping_points = grid.count_overlap_points()
    print("Overlapping points: \(overlapping_points)")
    let grid_with_diagonals = VentGrid(lines, skip_diagonals: false)
    let overlapping_points_with_diagonals = grid_with_diagonals.count_overlap_points()
    print("Overlapping points with diagonals: \(overlapping_points_with_diagonals)")
}