// Created by Ambas on 2024/12/10


// Created by Ambas on 2024/12/09


import Algorithms

struct Day10: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n").map {
      let row = String($0)
      return row.map { Int(String($0))! }
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let entities = self.entities
    let points = find9(entities)
//    var visited = Set<[Int]>()
//    var cache = [[Int]: Int]()
    func makeDirection(_ point: [Int]) -> [[Int]] {
      let (row, col) = (point[0], point[1])
      let directions = [[0, 1], [1, 0], [-1, 0], [0, -1]]
      return directions.compactMap {
        let nextRow = row + $0[0]
        let nextCol = col + $0[1]
        guard nextRow >= 0, nextRow < entities.count, nextCol >= 0, nextCol < entities[0].count else { return nil }
        return [nextRow, nextCol]
      }

    }
    var r = Set<[Int]>()
    func dfs(_ point: [Int]) -> Int {
      let (row, col) = (point[0], point[1])
      let val = entities[row][col]
      if val == 9 {
        r.insert(point); return 1
      }
//      let key = point
//      if let res = cache[key] { return res }
//      if visited.contains(point) { return 0 }
//      visited.insert(point)
      var res = 0
      for direction in makeDirection(point) {
        let nextVal = entities[direction[0]][direction[1]]
        if nextVal != val + 1 { continue }
        dfs(direction)
      }
//      visited.remove(point)
//      cache[key] = res
      return res
    }
    var res = 0
    print(points.count)
    for point in points {
      dfs(point)
      res += r.count
      r = []
    }
    return res
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    entities.map { $0.max() ?? 0 }.reduce(0, +)
  }

  func find9(_ grid: [[Int]]) -> [[Int]] {
    var res = [[Int]]()
    let (rowCount , colCount) = (grid.count , grid[0].count)
    for row in 0..<rowCount {
      for col in 0..<colCount {
        if grid[row][col] == 0 {
          res.append([row, col])
        }
      }
    }
      return res
  }
}
