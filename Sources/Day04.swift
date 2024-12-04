
struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Character]] {
    data.split(separator: "\n").map {
      Array($0)
    }
  }

  let target = Array("XMAS")

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var map = [
        [1, 0]: [[1, 0], [1, 1], [1, -1]],
        [0, 1]: [[0, 1], [0, -1], [1, 1]],
        [-1, 0]: [[-1, 0], [-1, -1], [-1, 1]],
        [0, -1]: [[0, -1], [-1, -1], [1, -1]],
        [1, 1]: [[1, 1], [0, 1], [1, 0]],
        [-1, -1]: [[-1, -1], [0, -1], [-1, 0]],
        [1, -1]: [[1, -1], [1, 0], [0, -1]],
        [-1, 1]: [[-1, 1], [0, 1], [-1, 0]]
    ]
    let grid = entities
    let (rowCount, colCount) = (grid.count, grid[0].count)
    var visited = Set<[Int]>()
    func dfs(_ point: [Int], _ i: Int, _ direction: [[Int]], _ prev: [Int]) -> Int {
      if i == 4 { return 1 }
      let (row, col) = (point[0], point[1])
      let curr = grid[row][col]
      if i == 3 && curr == "S" { visited.insert(point);return 1 }
      if curr != target[i] { return 0 }
//      if visited.contains(point) { return 0 }
      for nei in makeNei(point, d, rowCount, colCount) where nei != point {
        if dfs(nei, i + 1, d, point) == 1 { return 1 }
      }
//      visited.remove(point)
      return 0
    }
    var res = 0
    for row in 0..<rowCount {
      for col in 0..<colCount where grid[row][col] == "X" {
//        res += dfs([row, col], 0, [[0, 1], [1,0], [0, -1],[-1,0],[1,1],[-1,-1],[-1,1],[1,-1]])
        res += dfs([row, col], 0, [[0, 1]], [-1,-1])
        res += dfs([row, col], 0, [[1, 0]], [-1,-1])
        res += dfs([row, col], 0, [[0, -1]], [-1,-1])
        res += dfs([row, col], 0, [[-1, 0]], [-1,-1])
        res += dfs([row, col], 0, [[1, 1]], [-1,-1])
        res += dfs([row, col], 0, [[-1, -1]], [-1,-1])
        res += dfs([row, col], 0, [[-1, 0]], [-1,-1])
        res += dfs([row, col], 0, [[0, -1]], [-1,-1])
      }
    }
    return res
  }

  func makeNei(_ point: [Int],_ direction: [[Int]], _ rowCount: Int, _ colCount: Int) -> [[Int]] {
    direction.compactMap {
      let newRow = point[0] + $0[0]
      let newCol = point[1] + $0[1]
      if newRow >= 0 && newRow < rowCount && newCol >= 0 && newCol < colCount {
        return [newRow, newCol]
      } else {
        return nil
      }
    }
  }



  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    return 0
  }
}
