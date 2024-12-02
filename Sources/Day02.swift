enum OrderMode {
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
    entities
      .filter {
        checker(report: $0, mode: .decrement) || checker(report: $0, mode: .increment)
      }
      .count
  }

  func part2() -> Any {
    entities
      .filter {
        checker(report: $0, mode: .decrement, fixQuota: 1)
          || checker(report: $0, mode: .increment, fixQuota: 1)
      }
      .count
  }

  func checker(report: [Int], mode: OrderMode, fixQuota: Int = 0) -> Bool {

    func isValidOrder(_ num1: Int, _ num2: Int, _ mode: OrderMode) -> Bool {
      switch mode {
      case .decrement: num1 > num2
      case .increment: num1 < num2
      }
    }

    func attemptFix(_ report: [Int], at index: Int) -> Bool {
      guard fixQuota > 0 else { return false }

      var newReport1 = report
      newReport1.remove(at: index)
      var newReport2 = report
      newReport2.remove(at: index - 1)

      return checker(report: newReport1, mode: mode, fixQuota: fixQuota - 1)
        || checker(report: newReport2, mode: mode, fixQuota: fixQuota - 1)
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
