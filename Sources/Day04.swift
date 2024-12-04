
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
//        print(row,col,res)
        res += dfs([row, col], 0, [[0, 1]])
        res += dfs([row, col], 0, [[1, 0]])
        res += dfs([row, col], 0, [[0, -1]])
        res += dfs([row, col], 0, [[-1, 0]])
        res += dfs([row, col], 0, [[1, 1]])
        res += dfs([row, col], 0, [[-1, -1]])
        res += dfs([row, col], 0, [[-1, 1]])
        res += dfs([row, col], 0, [[1, -1]])

//        print(res)
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
    let grid = entities
    let (rowCount, colCount) = (grid.count, grid[0].count)
    func checkValid(_ point:[Int]) -> Bool {
      let (row, col) = (point[0], point[1])
      return row >= 0 && row < rowCount && col >= 0 && col < colCount
    }
    func checkIsMAS(_ point: [Int], _ direction: [Int]) -> Bool {
      var (row, col) = (point[0], point[1])
      if !checkValid([row, col]) { return false }
      if grid[row][col] != "M" { return false }
      row += direction[0]
      col += direction[1]
      if !checkValid([row, col]) { return false }
      if grid[row][col] != "A" { return false }
      row += direction[0]
      col += direction[1]
      if !checkValid([row, col]) { return false }
      if grid[row][col] != "S" { return false }
      return true
    }

    func checkIsSAM(_ point: [Int], _ direction: [Int]) -> Bool {
      var (row, col) = (point[0], point[1])
      if !checkValid([row, col]) { return false }
      if grid[row][col] != "S" { return false }
      row += direction[0]
      col += direction[1]
      if !checkValid([row, col]) { return false }
      if grid[row][col] != "A" { return false }
      row += direction[0]
      col += direction[1]
      if !checkValid([row, col]) { return false }
      if grid[row][col] != "M" { return false }
      return true
    }

    var res = 0
    for row in 0..<rowCount {
      for col in 0..<colCount {
        if checkIsMAS([row,col], [1,1]) || checkIsSAM([row,col], [1,1]) {
          if checkIsMAS([row,col + 2], [1,-1]) || checkIsSAM([row,col + 2], [1,-1]) {
            res += 1
          }
        }
      }
    }
    return res
  }


}
