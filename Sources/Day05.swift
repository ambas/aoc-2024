// Created by Ambas on 2024/12/05

import Algorithms
import Foundation

struct Day05: AdventDay {
    var data: String

    var entities: (rules: [(Int, Int)], rows: [[Int]]) {
        let sections = data.split(separator: "\n\n")
        let rules = sections[0].split(separator: "\n").map {
            let pair = $0.split(separator: "|").map { Int($0)! }
            return (pair[0], pair[1])
        }
        let rows = sections[1].split(separator: "\n").map {
            $0.split(separator: ",").map { Int($0)! }
        }
        return (rules, rows)
    }

    func part1() -> Int {
        let rules = createRulesDict(from: entities.rules)
        let validRows = entities.rows.filter { isValidRow($0, with: rules) }
        return validRows.map { getMid($0) }.reduce(0, +)
    }

    func part2() -> Int {
        let rules = createRulesDict(from: entities.rules)
        let invalidRows = entities.rows.filter { !isValidRow($0, with: rules) }

        let fixedRows = invalidRows.map { fixInvalidRow($0, rules: rules) }
        return fixedRows.map { getMid($0) }.reduce(0, +)
    }

    // Helper to calculate the middle element of an array
    private func getMid(_ nums: [Int]) -> Int {
        nums[nums.count / 2]
    }

    // Helper to validate rows against rules
    private func isValidRow(_ row: [Int], with rules: [Int: Set<Int>]) -> Bool {
        var seen = Set<Int>()
        for num in row {
            if let targets = rules[num], !targets.isDisjoint(with: seen) {
                return false
            }
            seen.insert(num)
        }
        return true
    }

    // Helper to fix invalid rows
    private func fixInvalidRow(_ row: [Int], rules: [Int: Set<Int>]) -> [Int] {
        var result = [Int]()
        var seen = Set<Int>()

        for num in row {
            if let targets = rules[num], !seen.isDisjoint(with: targets),
               let index = result.firstIndex(where: { targets.contains($0) }) {
                result.insert(num, at: index)
            } else {
                result.append(num)
            }
            seen.insert(num)
        }

        return result
    }

    // Helper to create a rules dictionary
    private func createRulesDict(from rules: [(Int, Int)]) -> [Int: Set<Int>] {
        rules.reduce(into: [Int: Set<Int>]()) { $0[$1.0, default: []].insert($1.1) }
    }
}
