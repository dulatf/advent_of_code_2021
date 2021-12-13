enum ParseResult{
    case Ok
    case Corrupted(Int)
    case Incomplete(String)
}
func checkSyntax(line: String.SubSequence) -> ParseResult{
    var stack : [Character] = []
    let illegalScores : Dictionary <Character, Int> = [")": 3, "]": 57, "}": 1197, ">": 25137]
    for char in line{
        switch char{
            case "(":
                stack.append(")")
            case ")":
                let expected = stack.removeLast()
                if expected != char{
                    return ParseResult.Corrupted(illegalScores[char]!)
                }
            case "[":
                stack.append("]")
            case "]":
                let expected = stack.removeLast()
                if expected != char{
                    return ParseResult.Corrupted(illegalScores[char]!)
                }
            case "{":
                stack.append("}")
            case "}":
                let expected = stack.removeLast()
                if expected != char{
                    return ParseResult.Corrupted(illegalScores[char]!)
                }
            case "<":
                stack.append(">")
            case ">":
                let expected = stack.removeLast()
                if expected != char{
                    return ParseResult.Corrupted(illegalScores[char]!)
                }
            default:
                print("Invalid char", char);
                return ParseResult.Corrupted(0)
        }
    }
    return stack.isEmpty ? ParseResult.Ok : ParseResult.Incomplete(String(stack))
}

func completeLine(stack: String) -> Int{
    let scores: Dictionary<Character, Int> = [")": 1, "]": 2, "}": 3, ">": 4]
    var score = 0
    var stack = stack
    while !stack.isEmpty{
        let char : Character = stack.removeLast()
        score = 5*score + scores[char]!
    }
    return score
}


func day10(){
    let input = try! String(contentsOfFile: "./inputs/day10.txt").split(separator: "\n")
    let syntaxCheckResults = input.map { checkSyntax(line: $0) }
    let corrupted = syntaxCheckResults.filter { switch $0 {
        case .Corrupted:
            return true
        default:
            return false
    }}
    let incomplete = syntaxCheckResults.filter { switch $0 {
        case .Incomplete:
            return true
        default:
            return false
    }}
    let score = corrupted.map { switch $0 {
        case .Corrupted(let score):
            return score
        default:
            return 0
    }}.reduce(0, +)
    print("Part 1: ", score)
    let completionScores : [Int] = incomplete.map { switch $0 {
        case .Incomplete(let stack):
            return completeLine(stack: stack)
        default:
            return 0
    }
    }.sorted()
    print("Part 2: ", completionScores[completionScores.count/2])
}
