//
//  Day03.swift
//  AdventOfCode
//
//  Created by Ambas Chobsanti on 2024/12/03.
//

struct Day03: AdventDay {

  var data: String

  var entities: [Character] {
    Array(data)
  }

  func part1() -> Int {
    calculateResult(from: entities)
  }

  func part2() -> Int {
    calculateResult(from: entities, instructionMode: true)
  }

  func calculateResult(from entities: [Character], instructionMode: Bool = false) -> Int {
    findMulFunctionIndexes(in: entities, instructionMode: instructionMode)
      .compactMap { index in
        // Compute product if value exists
        findValue(start: index, in: entities).map { $0.0 * $0.1 }
      }
      .reduce(0, +)  // Sum up the results
  }

  private func findMulFunctionIndexes(in input: [Character], instructionMode: Bool = false) -> [Int] {
    var resultIndexes: [Int] = []
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
        resultIndexes.append(index)
        buffer.removeAll()
      case let prefix where isValidPrefix(prefix):
        continue  // Continue buffering for valid prefixes
      default:
        buffer.removeAll()  // Reset buffer for invalid sequences
      }
    }

    return resultIndexes
  }

  private func isValidPrefix(_ prefix: String) -> Bool {
    let validPrefixes: Set<String> = [
      "d", "do", "do(", "don", "don'", "don't", "don't(",
      "m", "mu",
    ]
    return validPrefixes.contains(prefix)
  }

  private func findValue(start: Int, in input: [Character]) -> (Int, Int)? {
    guard start < input.count - 1 else { return nil }
    let openParenthesesIndex = start + 1
    guard input[openParenthesesIndex] == "(" else { return nil }

    let startNumberIndex = openParenthesesIndex + 1
    let endNumberIndex = min(startNumberIndex + 10, input.count - 1)

    guard
      let pair = input[startNumberIndex..<endNumberIndex]
        .split(separator: ")")
        .first
    else { return nil }

    let components = pair.split(separator: ",").compactMap { Int(String($0)) }
    guard components.count == 2 else { return nil }

    return (components[0], components[1])
  }
}
