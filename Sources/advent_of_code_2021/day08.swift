struct InputLine{
    var pattern_2 : String = ""
    var pattern_3 : String = ""
    var pattern_4 : String = ""
    var patterns_5 : [String] = []
    var patterns_6 : [String] = []
    var pattern_7 : String = ""
    var output_value: [String]

    init(_ line: String.SubSequence){
        let split = line.split(separator: "|")
        let candidatesFor9 = split.first!.split(separator: " ").map { String($0.sorted()) }

        for pattern in candidatesFor9{
            switch pattern.count{
                case 2:
                    pattern_2 = pattern
                case 3:
                    pattern_3 = pattern
                case 4:
                    pattern_4 = pattern
                case 5:
                    patterns_5.append(pattern)
                case 6:
                    patterns_6.append(pattern)
                case 7:
                    pattern_7 = pattern
                default:
                    print("Error")
            }
        }
        output_value = split.last!.split(separator: " ").map { String($0.sorted()) }   
    }

    func find5SegmentPatternFromSubset(query: String) -> [String] {
        let subset = Set(query)
        var result : [String] = []
        for pattern in patterns_5{
            var counter = 0
            for char in pattern{
                if subset.contains(char){
                    counter += 1
                }
            }
            if counter == query.count{
                result.append(pattern)
            }
        }
        return result
    }


    func find6SegmentPatternFromSubset(query: String) -> [String] {
        let subset = Set(query)
        var result : [String] = []
        for pattern in patterns_6{
            var counter = 0
            for char in pattern{
                if subset.contains(char){
                    counter += 1
                }
            }
            if counter == query.count{
                result.append(pattern)
            }
        }
        return result
    }

    func countSignalsWith(segments: Int) -> Int {
        return output_value.map{ $0.count == segments ? 1 : 0 }.reduce(0, +)
    }

    func makeDigitDictionary() -> Dictionary<String, Int>{
        var dict :  Dictionary<String, Int> = [:]
        dict.updateValue(1, forKey: pattern_2)
        dict.updateValue(7, forKey: pattern_3)
        dict.updateValue(4, forKey: pattern_4)
        dict.updateValue(8, forKey: pattern_7)

        // 9 = unique(7+4) + 1 extra segment
        let queryfor9 = String(Array(Set(pattern_3+pattern_4)).sorted())
        let candidatesFor9 = find6SegmentPatternFromSubset(query: queryfor9)
        if candidatesFor9.count != 1{
            print("Found more than one pattern  for 9\(candidatesFor9)")
            return [:]
        }
        dict.updateValue(9, forKey: candidatesFor9.first!)
        let lower_segment = String(Set(candidatesFor9.first!).subtracting(Set(queryfor9)))
        let queryFor3 = String(Array(pattern_3 + lower_segment).sorted())
        let candidatesFor3 = find5SegmentPatternFromSubset(query: queryFor3)
        if candidatesFor3.count != 1{
            print("Found more than one pattern for 3 \(candidatesFor3)")
            return [:]
        }
        dict.updateValue(3, forKey: candidatesFor3.first!)
        let middle_segment = String(Set(candidatesFor3.first!).subtracting(Set(queryFor3)))
        let patternFor0 = String(Array(Set(pattern_7).subtracting(Set(middle_segment))).sorted())
        dict.updateValue(0, forKey: patternFor0)
        let bottom_left_segment = String(Set(pattern_7).subtracting(Set(candidatesFor9.first!)))
        //let top_left_segment = String(Set(pattern_7).subtracting(Set(candidatesFor3.first!+bottom_left_segment)))
        let candidatesFor6 = Array(Set(patterns_6).subtracting([candidatesFor9.first!, patternFor0]))
        if candidatesFor6.count != 1{
            print("Found more than one pattern for 6 \(candidatesFor6)")
            return [:]
        }
        dict.updateValue(6, forKey: candidatesFor6.first!)
        // Todo: 2,5
        let patternFor5 = String(Array(Set(candidatesFor6.first!).subtracting(Set(bottom_left_segment))).sorted())
        dict.updateValue(5, forKey: patternFor5)
        let candidatesFor2 = Array(Set(patterns_5).subtracting([candidatesFor3.first!, patternFor5]))
        if candidatesFor2.count != 1{
            print("Found more than one pattern for 2 \(candidatesFor2)")
            return [:]
        }
        dict.updateValue(2, forKey: candidatesFor2.first!)
        return dict
    }

    func decodeOutputValue(dict: Dictionary<String, Int>) -> Int{
        return 1000 * dict[output_value[0]]! + 100 * dict[output_value[1]]! + 10 * dict[output_value[2]]! + 1 * dict[output_value[3]]!
    }
}

func day08(){
    let input = try! String(contentsOfFile: "./inputs/day08.txt").split(separator: "\n")
    let input_lines = input.map { InputLine($0) }
    let ones_count = input_lines.map { $0.countSignalsWith(segments: 2) }.reduce(0, +)
    let sevens_count = input_lines.map { $0.countSignalsWith(segments: 3) }.reduce(0, +)
    let fours_count = input_lines.map { $0.countSignalsWith(segments: 4) }.reduce(0, +)
    let eights_count = input_lines.map { $0.countSignalsWith(segments: 7) }.reduce(0, +)
    let total = ones_count + sevens_count + fours_count + eights_count
    print("\(ones_count) 1s + \(fours_count) 4s + \(sevens_count) 7s + \(eights_count) 8s = \(total)")
    let output_values : [Int] = input_lines.map{ let dict = $0.makeDigitDictionary()
                                         return $0.decodeOutputValue(dict: dict)}
    print("Sum of output values: ", output_values.reduce(0, +))
}