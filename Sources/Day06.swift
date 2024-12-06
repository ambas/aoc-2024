//
//  Day00 2.swift
//  AdventOfCode
//
//  Created by Ambas Chobsanti on 2024/12/05.
//


import Algorithms

struct Day06: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Character]] {
    data.split(separator: "\n").map {
      Array($0)
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var (grid, direction, pos)  = cleanUpGrid(entities)
    var res = Set<[Int]>()
    var curr = makeNext(grid, currDirection: direction, currPos: pos)
    while true {
      res.insert(pos)
      switch curr {
      case .change(let _direction, _):
        direction = _direction
        curr = makeNext(grid, currDirection: direction, currPos: pos)
      case .next(let _pos):
        pos = _pos
        curr = makeNext(grid, currDirection: direction, currPos: pos)
      case .end: return res.count
      }
    }
    return res.count
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var walls = Set<[Int]>()
    var (grid, direction, pos)  = cleanUpGrid(entities)
    let (rowCount, colCount) = (grid.count, grid[0].count)
    func check(_ pos: [Int]) -> Bool {
      let (row, col) = (pos[0], pos[1])
      return row >= 0 && row < rowCount && col >= 0 && col < colCount
    }
    func buildNewWall(_ pos: [Int], _ direction: Character) -> [Int]? {
      let (row, col) = (pos[0], pos[1])
      switch direction {
        case "^":
        for i in 0..<row where walls.contains([i, col]) {
          return [row, col - 1]
        }
      case "v":
        for i in (row + 1)..<rowCount where walls.contains([i, col]) {
          return [row, col + 1]
        }
      case "<":
        for i in 0..<col where walls.contains([row, i]) {
          return [row + 1, col]
        }
      case ">":
        for i in (col + 1)..<colCount where walls.contains([row, i]) {
          return [row - 1, col]
        }
      default:
        fatalError()
      }
      return nil
    }
    var curr = makeNext(grid, currDirection: direction, currPos: pos)
    var buildWall = Set<[Int]>()
    a: while true {
      switch curr {
      case .change(let _direction, let wall):
        walls.insert(wall)
        direction = _direction
        curr = makeNext(grid, currDirection: direction, currPos: pos)
      case .next(let _pos):
        pos = _pos
        if let wall = buildNewWall(pos, map[direction]!), check(wall) {
          buildWall.insert(wall)
        }
        curr = makeNext(grid, currDirection: direction, currPos: pos)
      case .end: break a
      }
    }
    for wall in walls {
      buildWall.remove(wall)
    }
    return buildWall.count
  }

  func makeNext(_ grid: [[Character]], currDirection: Character, currPos: [Int]) -> ResultMove {
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

    let (nextPosRow, nextPosCol) = (nextPos[0], nextPos[1])
    if nextPosRow < 0 || nextPosRow >= rowCount || nextPosCol < 0 || nextPosCol >= colCount {
      return .end
    }

    let nextPosVal = grid[nextPos[0]][nextPos[1]]
    if nextPosVal == "." {
      return .next(nextPos)
    } else {
      return .change(map[currDirection]!, nextPos)
    }
  }
  enum ResultMove {
    case next([Int])
    case change(Character, [Int])
    case end
  }

  let map: [Character: Character] = [
    "^": ">",
    "v": "<",
    "<":"^",
    ">":"v"
  ]

  func cleanUpGrid(_ grid: [[Character]]) -> ([[Character]], Character, [Int]) {
    let (rowCount , colCount) = (grid.count, grid[0].count)
    var res = grid
    var d: Character = "^"
    var pos = [Int]()

    for row in 0..<rowCount {
      for col in 0..<colCount {
        let val = grid[row][col]
        if map.keys.contains(val) {
          d = val
          pos = [row, col]
          res[row][col] = "."
        } else {
          res[row][col] = val
        }
      }
    }
    return (res, d, pos)
  }
}

// 1468 wrong
