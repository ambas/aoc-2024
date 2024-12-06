//
//  Day00 2.swift
//  AdventOfCode
//
//  Created by Ambas Chobsanti on 2024/12/05.
//

import Algorithms

struct Day06: AdventDay {

  var data: String

  var entities: [[Character]] {
    data.split(separator: "\n").map {
      Array($0)
    }
  }

  func part1() -> Any {
    return findExitStep(entities: entities) ?? 0
  }

  func part2() -> Any {
    let entities = entities
    let (rowCount, colCount) = (entities.count, entities[0].count)
    var res = 0
    for row in 0..<rowCount {
      for col in 0..<colCount where entities[row][col] == "." {
        var entities = entities
        entities[row][col] = "#"
        if findExitStep(entities: entities) == nil {
          res += 1
        }
      }
    }

    return res

  }

  func findExitStep(entities: [[Character]]) -> Int? {
      var (grid, direction, currentPos) = makeCleanGrid(entities)
      var visitedSteps = Set<[Int]>()
      var walls = Set<[Int]>()

      while true {
          visitedSteps.insert(currentPos)
          let currentAction = makeNextAction(grid, currDirection: direction, currPos: currentPos)

          switch currentAction {
          case .change(let newDirection, let wall):
              let wallKey = wall + [mapDirection[String(newDirection)]!]
              if walls.contains(wallKey) {
                  return nil
              }
              walls.insert(wallKey)
              direction = newDirection

          case .next(let nextPos):
              currentPos = nextPos

          case .end:
              return visitedSteps.count
          }
      }
  }

  func makeNextAction(
      _ grid: [[Character]],
      currDirection: Character,
      currPos: [Int]
  ) -> Action {
      let directions: [Character: (Int, Int)] = [
          "^": (-1, 0),
          "v": (1, 0),
          "<": (0, -1),
          ">": (0, 1)
      ]

      guard let movement = directions[currDirection] else {
          fatalError("Invalid direction: \(currDirection)")
      }

      let (row, col) = (currPos[0], currPos[1])
      let nextPos = [row + movement.0, col + movement.1]
      let (nextRow, nextCol) = (nextPos[0], nextPos[1])

      guard (0..<grid.count).contains(nextRow), (0..<grid[0].count).contains(nextCol) else {
          return .end
      }

      let nextPosVal = grid[nextRow][nextCol]
      if nextPosVal == "." {
          return .next(nextPos)
      }

      guard let newDirection = mapNextDirection[currDirection] else {
          fatalError("Invalid mapping for current direction: \(currDirection)")
      }

      return .change(newDirection, nextPos)
  }

  enum Action {
    case next([Int])
    case change(Character, [Int])
    case end
  }

  func makeCleanGrid(_ grid: [[Character]]) -> ([[Character]], Character, [Int]) {
      guard !grid.isEmpty, !grid[0].isEmpty else {
          return (grid, "^", [])
      }

      var cleanedGrid = grid
      var direction: Character = "^"
      var position: [Int] = []

      for (rowIndex, row) in grid.enumerated() {
          for (colIndex, value) in row.enumerated() {
              if mapNextDirection[value] != nil {
                  direction = value
                  position = [rowIndex, colIndex]
                  cleanedGrid[rowIndex][colIndex] = "."
              } else {
                  cleanedGrid[rowIndex][colIndex] = value
              }
          }
      }

      return (cleanedGrid, direction, position)
  }

  let mapNextDirection: [Character: Character] = [
    "^": ">",
    "v": "<",
    "<": "^",
    ">": "v",
  ]

  let mapDirection = [
    "^": 1,
    "v": 2,
    "<": 3,
    ">": 4,
  ]
}
