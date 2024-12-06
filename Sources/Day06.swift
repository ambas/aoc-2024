import Algorithms

struct Day06: AdventDay {

  var data: String

  var entities: [[Character]] {
    data.split(separator: "\n").map { Array($0) }
  }

  func part1() -> Any {
    let (grid, direction, currentPos) = makeCleanGrid(entities)
    return findExitPath(grid: grid, direction: direction, currentPos: currentPos).count
  }

  func part2() -> Any {
    let entities = entities
    let (rowCount, colCount) = (entities.count, entities[0].count)
    let (grid, direction, currentPos) = makeCleanGrid(entities)
    let guardPath = findExitPath(grid: grid, direction: direction, currentPos: currentPos)
    var validPositions = 0

    for row in 0..<rowCount {
      for col in 0..<colCount {
        guard entities[row][col] == ".", guardPath.contains([row, col]) else { continue }

        var modifiedGrid = grid
        modifiedGrid[row][col] = "#"

        if findExitPath(grid: modifiedGrid, direction: direction, currentPos: currentPos).isEmpty {
          validPositions += 1
        }
      }
    }

    return validPositions
  }

  func findExitPath(grid: [[Character]], direction: Character, currentPos: [Int]) -> Set<[Int]> {
    var visited = Set<[Int]>()
    var walls = Set<[Int]>()
    var direction = direction
    var currentPos = currentPos

    while true {
      visited.insert(currentPos)
      let action = makeNextAction(grid, currDirection: direction, currPos: currentPos)

      switch action {
      case .change(let newDirection, let wall):
        let wallKey = wall + [mapDirection[String(newDirection)]!]
        if walls.contains(wallKey) {
          return []
        }
        walls.insert(wallKey)
        direction = newDirection

      case .next(let nextPos):
        currentPos = nextPos

      case .end:
        return visited
      }
    }
  }

  func makeNextAction(_ grid: [[Character]], currDirection: Character, currPos: [Int]) -> Action {
    let directions: [Character: (Int, Int)] = [
      "^": (-1, 0),
      "v": (1, 0),
      "<": (0, -1),
      ">": (0, 1),
    ]

    guard let movement = directions[currDirection] else {
      fatalError("Invalid direction: \(currDirection)")
    }

    let (row, col) = (currPos[0], currPos[1])
    let nextPos = [row + movement.0, col + movement.1]
    let (nextRow, nextCol) = (nextPos[0], nextPos[1])

    guard (0..<grid.count).contains(nextRow) && (0..<grid[0].count).contains(nextCol) else {
      return .end
    }

    let nextValue = grid[nextRow][nextCol]
    if nextValue == "." {
      return .next(nextPos)
    }

    guard let newDirection = mapNextDirection[currDirection] else {
      fatalError("Invalid mapping for current direction: \(currDirection)")
    }

    return .change(newDirection, nextPos)
  }

  func makeCleanGrid(_ grid: [[Character]]) -> ([[Character]], Character, [Int]) {
    var cleanedGrid = grid
    var direction: Character = "^"
    var position: [Int] = []

    outer: for (rowIndex, row) in grid.enumerated() {
      for (colIndex, value) in row.enumerated() where mapNextDirection[value] != nil {
        direction = value
        position = [rowIndex, colIndex]
        cleanedGrid[rowIndex][colIndex] = "."
        break outer
      }
    }

    return (cleanedGrid, direction, position)
  }

  enum Action {
    case next([Int])
    case change(Character, [Int])
    case end
  }

  let mapNextDirection: [Character: Character] = [
    "^": ">",
    "v": "<",
    "<": "^",
    ">": "v",
  ]

  let mapDirection: [String: Int] = [
    "^": 1,
    "v": 2,
    "<": 3,
    ">": 4,
  ]
}
