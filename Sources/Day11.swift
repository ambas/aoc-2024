// Created by Ambas on 2024/12/11

// Created by Ambas on 2024/12/09

import Algorithms

struct Day11: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [Int] {
    data.split(separator: " ").map {
      Int($0.trimmingCharacters(in: .whitespacesAndNewlines))!
    }
  }

  actor Counter {
    var count: Int = 0

    func increment(_ num: Int) {
      count += num
    }
  }

  // Replace this with your solution for the first part of the day's challenge.

  func part1() async -> Any {
    var cache = [[Int]: Int]()

    func transform2(_ i: Int, _ num: Int) -> Int {
      if i == 25 { return 1 }

      let key = [i, num]
      if let res = cache[key] { return res }

      var newNums: [Int] = []
      if num == 0 {
        newNums.append(1)
      } else if String(num).count % 2 != 0 {
        newNums.append(num * 2024)
      } else {
        let numStr = Array(String(num))
        let half = numStr.count / 2
        let first = Int(String(numStr[..<half]))!
        let second = Int(String(numStr[half...]))!
        newNums.append(first)
        newNums.append(second)
      }
      let res = newNums.reduce(0) { $0 + transform2(i + 1, $1) }
      cache[key] = res

      return res
    }

    let entities = entities
    let counter = Counter()

    // Use a group of tasks that run concurrently
      for num in entities {
          await counter.increment(transform2(0, num))
      }


    // Return the final count after all tasks complete
    return await counter.count
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() async -> Any {
    var cache = [[Int]: Int]()

    func transform2(_ i: Int, _ num: Int) -> Int {
      if i == 75 { return 1 }

      let key = [i, num]
      if let res = cache[key] { return res }

      var newNums: [Int] = []
      if num == 0 {
        newNums.append(1)
      } else if String(num).count % 2 != 0 {
        newNums.append(num * 2024)
      } else {
        let numStr = Array(String(num))
        let half = numStr.count / 2
        let first = Int(String(numStr[..<half]))!
        let second = Int(String(numStr[half...]))!
        newNums.append(first)
        newNums.append(second)
      }
      let res = newNums.reduce(0) { $0 + transform2(i + 1, $1) }
      cache[key] = res

      return res
    }

    let entities = entities
    let counter = Counter()

    // Use a group of tasks that run concurrently
      for num in entities {
          await counter.increment(transform2(0, num))
      }


    // Return the final count after all tasks complete
    return await counter.count
  }



  func transformInput(_ input: [Int]) -> [Int] {
    var res: [Int] = []
    for num in input {
      if num == 0 {
        res.append(1)
      } else if String(num).count % 2 != 0 {
        res.append(num * 2024)
      } else {
        let numStr = Array(String(num))
        let half = numStr.count / 2
        let first = Int(String(numStr[..<half]))!
        let second = Int(String(numStr[half...]))!
        res.append(first)
        res.append(second)
      }
    }
    return res
  }
}
