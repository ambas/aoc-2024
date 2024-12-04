struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var entities: [[Character]] {
    data.split(separator: "\n").map {
      Array($0)
    }
  }

  let target = Array("XMAS")

  func part1() -> Any {
    let grid = entities
    let (rowCount, colCount) = (grid.count, grid[0].count)
    func dfs(_ point: [Int], _ i: Int, _ direction: [[Int]]) -> Int {
      let (row, col) = (point[0], point[1])
      let curr = grid[row][col]
      if curr != target[i] { return 0 }
      if i == (target.count - 1) { return 1 }
      for nei in makeNei(point, direction, rowCount, colCount) {
        if dfs(nei, i + 1, direction) == 1 { return 1 }
      }
      return 0
    }
    var res = 0
    for row in 0..<rowCount {
      for col in 0..<colCount where grid[row][col] == "X" {
        res += dfs([row, col], 0, [[0, 1]])
        res += dfs([row, col], 0, [[1, 0]])
        res += dfs([row, col], 0, [[0, -1]])
        res += dfs([row, col], 0, [[-1, 0]])
        res += dfs([row, col], 0, [[1, 1]])
        res += dfs([row, col], 0, [[-1, -1]])
        res += dfs([row, col], 0, [[-1, 1]])
        res += dfs([row, col], 0, [[1, -1]])
      }
    }
    return res
  }

  func makeNei(_ point: [Int], _ direction: [[Int]], _ rowCount: Int, _ colCount: Int) -> [[Int]] {
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

  func part2() -> Any {
    let grid = entities
    let (rowCount, colCount) = (grid.count, grid[0].count)
    func checkValid(_ point: [Int]) -> Bool {
      let (row, col) = (point[0], point[1])
      return row >= 0 && row < rowCount && col >= 0 && col < colCount
    }

    func check(_ point: [Int], _ direction: [Int], _ target: String) -> Bool {
      let target = Array(target)
      var (row, col) = (point[0], point[1])
      for i in 0..<3 {
        guard checkValid([row, col]) && grid[row][col] == target[i] else { return false }
        row += direction[0]
        col += direction[1]
      }

      return true
    }

    var res = 0
    for row in 0..<rowCount {
      for col in 0..<colCount {
        let foundStartX = check([row, col], [1, 1], "MAS") || check([row, col], [1, 1], "SAM")
        if foundStartX {
          let foundEndX = check([row, col + 2], [1, -1], "MAS") || check([row, col + 2], [1, -1], "SAM")
          res += foundEndX ? 1 : 0
        }
      }
    }
    return res
  }

}
