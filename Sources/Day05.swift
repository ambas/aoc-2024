// Created by Ambas on 2024/12/05

import Algorithms
import Foundation

struct Day05: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: (firstPart: [(Int, Int)], secondPart: [[Int]]) {
    let splited = data.split(separator: "\n\n")
    let firstPart = splited[0].split(separator: "\n").map {
      let pair = String($0).split(separator: "|")
      return (Int(pair[0])!, Int(pair[1])!)
    }
    let secondPart = splited[1].split(separator: "\n").map {
      $0.split(separator: ",").map { Int(String($0))! }
    }
    return (firstPart, secondPart)
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let entities = entities

    var dict = [Int: Set<Int>]()
    var dict2 = [Int: Int]()
    for pair in entities.firstPart {
      dict[pair.0, default: []].insert(pair.1)
    }
    for pair in entities.firstPart {
      dict2[pair.1] = pair.0
    }

    let validRow = entities.secondPart.filter { check($0, dict, dict2) }

    return validRow.map { getMid($0) }.reduce(0, +)
  }

  func getMid(_ nums: [Int]) -> Int {
    let count = nums.count
    return nums[count / 2]
  }

  func check(_ nums: [Int], _ rules: [Int: Set<Int>], _ rules2: [Int: Int]) -> Bool {
    var set = Set<Int>()
    for num in nums {
      if let target = rules[num] {
        for a in target {
          if set.contains((a)) { return false }
        }
      }
      set.insert(num)
    }
    return true
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    return 0
  }
}

// 7750
