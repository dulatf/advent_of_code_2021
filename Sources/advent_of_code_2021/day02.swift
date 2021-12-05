enum Command{
    case forward(Int)
    case down(Int)
    case up(Int)
}

func parse_command(command: String.SubSequence) -> Command?{
    let parts = command.split(separator: " ")
    if parts.count != 2{
        return nil
    }
    if let number = Int(parts[1]){
        if parts[0] == "forward"{
            return Command.forward(number)
        }else if parts[0] == "down"{
            return Command.down(number)
        }else if parts[0] == "up"{
            return Command.up(number)
        }
    }
    return nil;
}
func day02(){
    let input = try! String(contentsOfFile: "./inputs/day02.txt");
    let lines = input.split(separator:"\n")
    let directions = lines.map(parse_command).compactMap { $0 }
    let (horizontal, depth) = directions.reduce((0,0), {pos, command in
        let (x,y) = pos
        switch command{
            case .forward(let dx):
                return (x+dx, y)
            case .down(let dy):
                return (x, y+dy)
            case .up(let dy):
                return (x, y-dy)
        }
    })
    print("End position: (\(horizontal), \(depth)) -> \(horizontal*depth)")
    print("\nPart 2\n")
    let (new_horizontal, new_depth, aim) = directions.reduce((0,0,0), {pos, command in 
        let (x,y,aim) = pos
        switch command {
        case .forward(let dx):
            return (x+dx, y+dx*aim, aim)
        case .down(let dy):
            return (x,y,aim+dy)
        case .up(let dy):
            return (x,y,aim-dy)
        }
    })
    print("End position and aim: (\(new_horizontal), \(new_depth), \(aim)) -> \(new_horizontal*new_depth)")
}