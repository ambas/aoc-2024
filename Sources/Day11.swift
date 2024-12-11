// Created by Ambas on 2024/12/11

import Algorithms

struct Day11: AdventDay {
  var data: String

  var entities: [Int] {
    data.split(separator: " ").map {
      Int($0.trimmingCharacters(in: .whitespacesAndNewlines))!
    }
  }

  func part1() async -> Any {
    var cache = [[Int]: Int]()
    return entities.reduce(0) { $0 + countTransformation(0, $1, &cache, 25) }
  }

  func part2() async -> Any {
    var cache = [[Int]: Int]()
    return entities.reduce(0) { $0 + countTransformation(0, $1, &cache, 75) }
  }

  func countTransformation(
    _ time: Int,
    _ currentNum: Int,
    _ cache: inout [[Int]: Int],
    _ blinkTime: Int
  ) -> Int {
    if time == blinkTime { return 1 }

    let key = [time, currentNum]
    if let res = cache[key] { return res }

    var transformedNums: [Int] = []
    let numStr = Array(String(currentNum))
    if currentNum == 0 {
      transformedNums.append(1)
    } else if numStr.count % 2 != 0 {
      transformedNums.append(currentNum * 2024)
    } else {
      let numStr = Array(numStr)
      let halfIndex = numStr.count / 2
      let first = Int(String(numStr[..<halfIndex]))!
      let second = Int(String(numStr[halfIndex...]))!
      transformedNums.append(first)
      transformedNums.append(second)
    }
    let totalTransformed = transformedNums.reduce(0) { $0 + countTransformation(time + 1, $1, &cache, blinkTime) }
    cache[key] = totalTransformed

    return totalTransformed
  }
}
