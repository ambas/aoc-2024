//
//  Day03.swift
//  AdventOfCode
//
//  Created by Ambas Chobsanti on 2024/12/03.
//

import Algorithms

struct Day03: AdventDay {

  var data: String

  var entities: [Character] {
    Array(data)
  }

  func part1() -> Int {
    calculateResult(from: entities, withInstructionMode: false)
  }

  func part2() -> Int {
    calculateResult(from: entities, withInstructionMode: true)
  }

  private func calculateResult(from entities: [Character], withInstructionMode instructionMode: Bool) -> Int {
    findMulFunction(entities, instructionMode: instructionMode)
      .compactMap { index in
        guard let (num1, num2) = findValue(start: index, in: entities) else { return nil }
        return num1 * num2
      }
      .reduce(0, +)
  }

  func findMulFunction(_ input: [Character], instructionMode: Bool = false) -> [Int] {
    var resultIndices: [Int] = []
    var isEnabled = true
    var buffer = ""

    for (index, char) in input.enumerated() {
      buffer.append(char)

      switch buffer {
      case "do()":
        isEnabled = true
        buffer.removeAll()
      case "don't()":
        isEnabled = false
        buffer.removeAll()
      case "mul" where isEnabled || !instructionMode:
        resultIndices.append(index)
        buffer.removeAll()
      case let prefix where isValidPrefix(prefix):
        // Keep buffering for valid prefixes
        continue
      default:
        buffer.removeAll()  // Reset buffer for invalid sequences
      }
    }

    return resultIndices
  }

  private func isValidPrefix(_ prefix: String) -> Bool {
    let validPrefixes = Set([
      "d", "do", "do(", "don", "don'", "don't", "don't(",
      "m", "mu",
    ])
    return validPrefixes.contains(prefix)
  }

  func findValue(start: Int, in input: [Character]) -> (Int, Int)? {
    guard start < input.count - 1 else { return nil }
    let openParenthesesIndex = start + 1
    guard input[openParenthesesIndex] == "(" else { return nil }

    let startNumberIndex = openParenthesesIndex + 1
    let endNumberIndex = min(startNumberIndex + 10, input.count - 1)

    let substring = input[startNumberIndex..<endNumberIndex]
      .split(separator: ")")
      .first

    guard let pair = substring else { return nil }
    let components = pair.split(separator: ",").map { String($0) }

    guard components.count == 2,
      let num1 = Int(components[0]),
      let num2 = Int(components[1])
    else { return nil }

    return (num1, num2)
  }
}
