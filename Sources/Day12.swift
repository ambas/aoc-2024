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
    // Get all areas
    for row in 0..<rowCount {
      for col in 0..<colCount where !visited.contains([row, col]) {
        var area: [[Int]] = []
        traverse(
          point: [row, col],
          collector: &area,
          char: entities[row][col],
          visited: &visited,
          matrix: entities
        )
        allAreas.append(area)
      }
    }
    // Calculate cost for each area
    var res = 0
    for area in allAreas {
      res += calCost(area, entities) * area.count
    }

    return res
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    return 0
  }

  func makeNeighbors(point: [Int], matrix: [[Character]], skipInvalid: Bool = false)
    -> [[Int]]
  {
   return  [[1, 0], [0, 1], [-1, 0], [0, -1]].compactMap {
      let newRow = point[0] + $0[0]
      let newCol = point[1] + $0[1]
      let isInBound = checkInBounds([newRow, newCol], matrix: matrix)
      guard skipInvalid || isInBound else { return nil }
      return [newRow, newCol]
    }
  }

  func traverse(
    point: [Int],
    collector: inout [[Int]],
    char: Character,
    visited: inout Set<[Int]>,
    matrix: [[Character]]
  ) {
    let (rows, cols) = (matrix.count, matrix[0].count)
    guard !visited.contains(point),
      (0..<rows).contains(point[0]), (0..<cols).contains(point[1]),
      matrix[point[0]][point[1]] == char
    else { return }

    visited.insert(point)
    collector.append(point)

    for nei in makeNeighbors(point: point, matrix: matrix) {
      traverse(point: nei, collector: &collector, char: char, visited: &visited, matrix: matrix)
    }
  }

  func calCost(_ area: [[Int]], _ matrix: [[Character]]) -> Int {
    let (rowCount, colCount) = (matrix.count, matrix[0].count)
    var result = 0

    for point in area {
      let neighbors = makeNeighbors(
        point: point, matrix: matrix, skipInvalid: true)
      for nei in neighbors {
        let (row, col) = (nei[0], nei[1])

        // Add cost for out-of-bound neighbors
        if row < 0 || row >= rowCount || col < 0 || col >= colCount {
          result += 1
        } else if matrix[row][col] != matrix[point[0]][point[1]] {
          // Add cost for valid but different-character neighbors
          result += 1
        }
      }
    }
    return result
  }

  func findTop(_ area: [[Int]], _ matrix: [[Character]]) -> Int {
    let (startRow, endRow, startCol, endCol) = findBounds(area: area)
    let char = matrix[area[0][0]][area[0][1]]
    var curr = 0
    var res = 0
    for row in startRow...endRow {
      for col in startCol...endCol where matrix[row][col] == char {
        let aboveRow = [row - 1, col]
        if !checkInBounds(aboveRow, matrix: matrix) {
          curr = 1
        } else if matrix[aboveRow[0]][aboveRow[1]] != char {
          curr = 1
        } else {
          res += curr
          curr = 0
        }
      }
      res += curr
      curr = 0
    }

    return res

  }

  func checkInBounds(_ point: [Int], matrix: [[Character]]) -> Bool {
    let (rowCount, colCount) = (matrix.count, matrix[0].count)
    return point.allSatisfy { $0 >= 0 && $0 < rowCount } && point.allSatisfy { $0 >= 0 && $0 < colCount }
  }

  func findBounds(area: [[Int]]) -> (startRow: Int, endRow: Int, startCol: Int, endCol: Int) {
    (
      area.map { $0[0] }.min()!,
      area.map { $0[0] }.max()!,
      area.map { $0[1] }.min()!,
      area.map { $0[1] }.max()!
    )
  }
}
