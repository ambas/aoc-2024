// Created by Ambas on 2024/12/12

// Created by Ambas on 2024/12/09

import Algorithms

struct Day12: AdventDay {
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
    let entities = self.entities
    let (rowCount, colCount) = (entities.count, entities[0].count)
    var allAreas = [[[Int]]]()
    var visited = Set<[Int]>()
    for row in 0..<rowCount {
      for col in 0..<colCount where !visited.contains([row, col]) {
        var area: [[Int]] = []
        traverse(
          point: [row, col],
          collector: &area,
          character: entities[row][col],
          visited: &visited,
          matrix: entities
        )
        allAreas.append(area)
      }
    }
    var res = 0
    for area in allAreas {
      res += calCost(area, entities) * area.count
    }

    return res
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    return 0
    // Sum the maximum entries in each set of data
  }

  func makeNeighbors(point: [Int], rowCount: Int, colCount: Int) -> [[Int]] {

    [[1, 0], [0,1], [-1, 0], [0, -1]].compactMap {
      let newRow = point[0] + $0[0]
      let newCol = point[1] + $0[1]
      guard newRow >= 0, newRow < rowCount, newCol >= 0, newCol < colCount else { return nil }
      return [newRow, newCol]
    }
  }

  func makeNeighbors2(point: [Int], rowCount: Int, colCount: Int) -> [[Int]] {

    [[1, 0], [0,1], [-1, 0], [0, -1]].compactMap {
      let newRow = point[0] + $0[0]
      let newCol = point[1] + $0[1]
//      guard newRow >= 0, newRow < rowCount, newCol >= 0, newCol < colCount else { return nil }
      return [newRow, newCol]
    }
  }

  func traverse(
    point: [Int],
    collector: inout [[Int]],
    character: Character,
    visited: inout Set<[Int]>,
    matrix: [[Character]]
  ) {
    let (rowCount, colCount) = (matrix.count, matrix[0].count)
    if visited.contains(point) { return }
    let (row, col) = (point[0], point[1])
    let currentChar = matrix[row][col]
    if currentChar != character { return }
    visited.insert(point)
    collector.append(point)
    for nei in makeNeighbors(point: point, rowCount: rowCount, colCount: colCount) {
      traverse(
        point: nei,
        collector: &collector,
        character: character,
        visited: &visited,
        matrix: matrix
      )
    }
  }

  func calCost(_ area: [[Int]], _ matrix: [[Character]]) -> Int {
    let (rowCount ,colCount) = (matrix.count, matrix[0].count)
    var res = 0
    for point in area {
      let neis = makeNeighbors2(point: point, rowCount: rowCount, colCount: colCount)
      for nei in neis {
        let (row, col) = (nei[0], nei[1])
        if row < 0  {
          res += 1
        }

        if row >= rowCount {
          res += 1
        }
        if col < 0 {
          res += 1
        }
        if col >= colCount {
          res += 1
        }
        if row >= 0 && row < rowCount && col >= 0 && col < colCount {
          if matrix[row][col] != matrix[point[0]][point[1]] {
            res += 1
          }
        }
      }
    }

    return res
  }
}
