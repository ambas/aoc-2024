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
    var steps = Set<[Int]>()
    var currentAction = makeNextAction(grid, currDirection: direction, currPos: currentPos)
    var walls = Set<[Int]>()
    while true {
      steps.insert(currentPos)
      switch currentAction {
      case .change(let _direction, let wall):
        let key = wall + [mapDirection[String(_direction)]!]
        if walls.contains(key) {
          return nil
        }
        walls.insert(key)
        direction = _direction
        currentAction = makeNextAction(grid, currDirection: direction, currPos: currentPos)
      case .next(let _pos):
        currentPos = _pos
        currentAction = makeNextAction(grid, currDirection: direction, currPos: currentPos)
      case .end: return steps.count
      }
    }
    return steps.count
  }

  func makeNextAction(
    _ grid: [[Character]],
    currDirection: Character,
    currPos: [Int]
  ) -> Action {
    let (rowCount, colCount) = (grid.count, grid[0].count)
    let (row, col) = (currPos[0], currPos[1])
    var nextPos: [Int]!
    switch currDirection {
    case "^":
      nextPos = [row - 1, col]
    case "v":
      nextPos = [row + 1, col]
    case "<":
      nextPos = [row, col - 1]
    case ">":
      nextPos = [row, col + 1]
    default:
      fatalError()
    }

    let (nextRow, nextCol) = (nextPos[0], nextPos[1])
    if nextRow < 0 || nextRow >= rowCount || nextCol < 0 || nextCol >= colCount {
      return .end
    }

    let nextPosVal = grid[nextPos[0]][nextPos[1]]
    if nextPosVal == "." {
      return .next(nextPos)
    } else {
      return .change(mapNextDirection[currDirection]!, nextPos)
    }
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
