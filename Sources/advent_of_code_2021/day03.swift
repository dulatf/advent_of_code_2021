func mostFrequentBit(_ lines: [String.SubSequence], position: Int) -> Bool {
    var counter = 0;
    for line in lines{
        let index = line.index(line.startIndex, offsetBy: position)
        if line[index] == "1"{
            counter+=1
        }else if line[index] == "0"{
            counter-=1
        }
    }
    return counter >= 0
}

func filterLines(_ lines: [String.SubSequence], digits: Int, keepMostFrequent: Bool) -> String.SubSequence? {
    let maybeInvert = {(x: Bool) ->  Bool in
        if keepMostFrequent{
            return x
        }else{
            return !x
        }
    }
    var current = lines;
    for pos in 0..<digits{
        let mfb : Character = maybeInvert(mostFrequentBit(current, position:pos)) ? "1" : "0"
        current = current.filter {
            let idx = $0.index($0.startIndex, offsetBy: pos)
            return $0[idx] == mfb           
        }
        if current.count == 1{
            return current.first
        }
    }
    if current.count != 1{
        return nil
    }
    return current.first
}

func day03(){
    let input = try! String(contentsOfFile: "./inputs/day03.txt");
    let lines = input.split(separator:"\n")
    let digits = lines[0].count
    
    var gamma_rate_str = "";
    var epsilon_rate_str = "";
    for pos in 0..<digits{
        if mostFrequentBit(lines, position: pos) {
            gamma_rate_str.append("1")
            epsilon_rate_str.append("0")
        }else{
            gamma_rate_str.append("0")
            epsilon_rate_str.append("1")
        }
    }
    let gamma_rate = Int(gamma_rate_str, radix:2)!
    let epsilon_rate = Int(epsilon_rate_str, radix:2)!
    print("Gamma rate: \(gamma_rate_str) => \(gamma_rate)")
    print("Epsilon rate: \(epsilon_rate_str) => \(epsilon_rate)")
    print("Result: \(epsilon_rate*gamma_rate)")

    let oxygen_generator_rating_str = filterLines(lines, digits: digits, keepMostFrequent: true)!
    let co2_scrubber_rating_str = filterLines(lines, digits: digits, keepMostFrequent: false)!
    let oxygen_generator_rating = Int(oxygen_generator_rating_str, radix:2)!
    let co2_scrubber_rating = Int(co2_scrubber_rating_str, radix:2)!
    print("Oxygen generator rating: \(oxygen_generator_rating_str) -> \(oxygen_generator_rating)")
    print("CO2 scrubber rating: \(co2_scrubber_rating_str) -> \(co2_scrubber_rating)")
    print("Result: \(oxygen_generator_rating*co2_scrubber_rating)")
}