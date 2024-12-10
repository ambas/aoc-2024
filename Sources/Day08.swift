// Created by Ambas on 2024/12/09


// Created by Ambas on 2024/12/09


import Algorithms

struct Day08: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Character]] {
    data.split(separator: "\n").map {
      $0.map { $0 }
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let entities = entities
    let (rowCount , colCount) = (entities.count, entities[0].count)
    var dict = [Character: [[Int]]]()
    for row in 0..<rowCount {
      for col in 0..<colCount where entities[row][col] != "." {
        let val = entities[row][col]
        dict[val, default: []].append([row, col])
      }
    }
    var newPoints = Set<[Int]>()
    for (_, val) in dict {
      let pointCount = val.count
      for i in 0..<pointCount {
        for j in 0..<pointCount where i != j {
          let newPoint = calNewPoint(val[i], val[j])
          newPoints.insert(newPoint)
        }
      }
    }
    newPoints = newPoints.filter { checkInBoard($0, rowCount, colCount) }
    return newPoints.count
  }

  func checkInBoard(_ point: [Int], _ rowCount: Int, _ colCount: Int) -> Bool {
    let (row, col) = (point[0], point[1])
    return row >= 0 && row < rowCount && col >= 0 && col < colCount
  }

  func calNewPoint(_ point1: [Int], _ point2: [Int]) -> [Int] {
    let (row1, col1) = (point1[0], point1[1])
    let (row2, col2) = (point2[0], point2[1])

    let (newRow, newCol) = (row1 - row2, col1 - col2)
    return [(newRow * 2) + row2, (newCol * 2) + col2]
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    return 0
  }
}

//  0 1 2 3 4
//0 x
//1   x
//2
//3

/*
 ......#....#
 ...#....0...
 ....#0....#.
 ..#....0....
 ....0....#..
 .#....A.....
 ...#........
 #......#....
 ........A...
 .........A..
 ..........#.
 ..........#.


 ##....#....#
 .#.#....0...
 ..#.#0....#.
 ..##...0....
 ....0....#..
 .#...#A....#
 ...#..#.....
 #....#.#....
 ..#.....A...
 ....#....A..
 .#........#.
 ...#......##
 */
