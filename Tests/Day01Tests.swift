//
//  Day01.swift
//  AdventOfCode
//
//  Created by Ambas Chobsanti on 2024/12/01.
//

import Testing

@testable import AdventOfCode

struct Day01Tets {
  // Smoke test data provided in the challenge question
  let testData = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

  @Test func testPart1() async throws {
    let challenge = Day01(data: testData)
    #expect(String(describing: challenge.part1()) == "11")
  }

  @Test func testPart2() async throws {
    let challenge = Day01(data: testData)
    #expect(String(describing: challenge.part2()) == "31")
  }
}
