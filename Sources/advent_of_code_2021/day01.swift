import Foundation;

func countIncreases(data: [Int]) -> Int{
    var counter = 0;
    for i in 1..<data.count{
        if data[i] > data[i-1]{
            counter += 1
        }
    }
    return counter;
}

func slidingWindowSum(data: [Int], window: Int) -> [Int] {
    var result : [Int] = [];
    for i in (window-1)..<data.count {
        let sum = data[(i-(window-1))...i].reduce(0,+)
        result.append(sum)
    }
    return result;
}

func day01(){
    let input = try! String(contentsOfFile: "./inputs/day01.txt");
    let lines = input.split(separator:"\n")
    
    let depths = lines.map { Int($0)! }
    print("\(depths.count) lines")
    let depth_increases = countIncreases(data: depths);
    print("The depth increased \(depth_increases) times")

    let depth_sliding_sums = slidingWindowSum(data: depths, window: 3)
    let sliding_increases = countIncreases(data: depth_sliding_sums)
    print("The sliding depth increased \(sliding_increases) times")
}