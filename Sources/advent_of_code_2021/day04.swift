enum BoardError : Error{
    case invalidBoard
}
struct Board{
    struct Cell{
        var value : Int
        var marked : Bool
        init(_ val: Int){
            value = val
            marked = false
        }
    }
    var rows = 0
    var cols = 0
    var entries : [Cell] = []

    init(_ input: ArraySlice<String.SubSequence>) throws{
        rows = input.count
        cols = input.first!.split(separator: " ").count
        for line in input{
            let numbers = line.split(separator: " ")
            for number in numbers{
                entries.append(Cell(Int(number)!))
            }
        }
        if rows * cols != entries.count{
            throw BoardError.invalidBoard
        }
    }
    mutating func mark(_ number: Int){
        for idx in entries.indices{
            if entries[idx].value == number{
                entries[idx].marked = true
            }
        }
    }
    func isWinner() -> Bool{
        for row in 0..<rows{
            var marked = true
            for col in 0..<cols{
                marked = marked && entries[row * cols + col].marked
            }
            if marked {
                return true
            }
        }
        for col in 0..<cols{
            var marked = true
            for row in 0..<rows{
                marked = marked && entries[row * cols + col].marked
            }
            if marked{
                return true
            }
        }
        return false
    }

    func sumUnmarked() -> Int{
        var acc = 0
        for cell in entries{
            if !cell.marked{
                acc += cell.value
            }
        }
        return acc
    }
}

func day04(){
    let input = try! String(contentsOfFile: "./inputs/day04.txt");
    let lines = input.split(separator:"\n", omittingEmptySubsequences: false)
    let drawn_numbers = lines.first!.split(separator:",").map{Int($0)!}
    // Empty lines mark the beginning of a new board
    let boards_input = lines.dropFirst()
    let board_strings = boards_input.split(separator:"")
    do{
        var boards = try board_strings.map { try Board($0) }
        
        var winners : [(Int, Int)] = []
        for number in drawn_numbers{
            for idx in boards.indices{
                boards[idx].mark(number)

                if boards[idx].isWinner() && !winners.contains(where: { $0.0 == idx }){
                    let unmarked_sum = boards[idx].sumUnmarked()
                    let score = unmarked_sum * number
                    winners.append((idx, score))
                }
            }
            if(winners.count == boards.count){
                break
            }
        }

        print("First winner: board \(winners.first!.0) with score \(winners.first!.1)")
        print("Last winner: board \(winners.last!.0) with score \(winners.last!.1)")

    } catch{
        print("Invalid board")
    }
}