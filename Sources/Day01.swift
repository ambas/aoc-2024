
struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    let lines = data.split(separator: "\n")
    var firstArray = [Int]()
    var secondArray = [Int]()
    for row in lines {
      let components = row.split(separator: " ", omittingEmptySubsequences: true).map { Int($0)! }
      firstArray.append(components[0])
      secondArray.append(components[1])
    }
    return [firstArray, secondArray]
  }

  func part1() -> Any {
    let entities = self.entities
    let sorted1 = entities[0].sorted()
    let sorted2 = entities[1].sorted()
    let count = sorted1.count
    var diff = 0
    for i in 0..<count {
      diff += abs(sorted1[i] - sorted2[i])
    }
    return diff
  }

  func part2() -> Any {
    var result: Int = 0
    let entities = self.entities
    let count1 = entities[0].reduce(into: [Int: Int]()) { $0[$1, default: 0] += 1 }
    let count2 = entities[1].reduce(into: [Int: Int]()) { $0[$1, default: 0] += 1 }
    for (key, count) in count1 {
      result += (count2[key] ?? 0) * key * count
    }

    return result
  }
}
