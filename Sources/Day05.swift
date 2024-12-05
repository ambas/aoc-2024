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
    for pair in entities.firstPart {
      dict[pair.0, default: []].insert(pair.1)
    }

    let validRow = entities.secondPart.filter { check($0, dict) }

    return validRow.map { getMid($0) }.reduce(0, +)
  }

  func getMid(_ nums: [Int]) -> Int {
    let count = nums.count
    return nums[count / 2]
  }

  func check(_ nums: [Int], _ rules: [Int: Set<Int>]) -> Bool {
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

  func part2() -> Any {
    let entities = entities

    var rules = [Int: Set<Int>]()
    for pair in entities.firstPart {
      rules[pair.0, default: []].insert(pair.1)
    }

    let invalidRow = entities.secondPart.filter { !check($0, rules) }

    func fixInvalidRow(_ row: [Int]) -> [Int] {
      var res = [Int]()
      var set = Set<Int>()
      for num in row {
        if let target = rules[num], set.intersection(target).count > 0 {
          for i in 0..<res.count {
            if target.contains(res[i]) {
              res.insert(num, at: i)
              break
            }
          }
        } else {
          res.append(num)
        }
        set.insert(num)
      }

      return res
    }
    let res = invalidRow.map { fixInvalidRow($0) }
    let recheck = res.filter { check($0, rules) }
    return res.map { getMid($0) }.reduce(0, +)
  }
}
