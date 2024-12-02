// Created by Ambas on 2024/12/02

import Algorithms

enum Mode {
  case increment
  case decrement
}

struct Day02: AdventDay {

  var data: String

  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }

  func part1() -> Any {
    let validReports = entities.filter {
      checker(report: $0, mode: .decrement) || checker(report: $0, mode: .increment)
    }
    return validReports.count
  }

  func part2() -> Any {
    let validReports = entities.filter {
      checker(report: $0, mode: .decrement, fixQuota: 1) || checker(report: $0, mode: .increment, fixQuota: 1)
    }
    return validReports.count
  }

  func checker(report: [Int], mode: Mode, fixQuota: Int = 0) -> Bool {
    // mode: 0 = decreasing, 1 = increasing

    func isValidOrder(_ num1: Int, _ num2: Int, _ mode: Mode) -> Bool {
      switch mode {
      case .decrement: return num1 >= num2
      case .increment: return num1 <= num2
      }
    }

    func attemptFix(_ report: [Int], at index: Int) -> Bool {
      guard fixQuota > 0 else { return false }

      var newReport1 = report
      newReport1.remove(at: index)
      var newReport2 = report
      newReport2.remove(at: index - 1)

      return checker(report: newReport1, mode: .decrement, fixQuota: fixQuota - 1)
        || checker(report: newReport1, mode: .increment, fixQuota: fixQuota - 1)
        || checker(report: newReport2, mode: .decrement, fixQuota: fixQuota - 1)
        || checker(report: newReport2, mode: .increment, fixQuota: fixQuota - 1)
    }

    for i in 1..<report.count {
      let num1 = report[i - 1]
      let num2 = report[i]

      // Check for invalid differences
      let diff = abs(num1 - num2)
      if diff < 1 || diff > 3 {
        return attemptFix(report, at: i)
      }

      // Check mode-specific constraints
      if !isValidOrder(num1, num2, mode) {
        return attemptFix(report, at: i)
      }
    }

    return true
  }
}
