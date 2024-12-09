import Algorithms

struct Day07: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [(Int, [Int])] {
    let lines = data.split(separator: "\n")
    let components = lines.map {
      let a = $0.split(separator: ":")
      return (String(a.first!), String(a.last!))
    }
    return components.map {
      (Int($0)!, $1.split(separator: " ").map { Int($0)! })
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let entities = self.entities

    let filtered = entities.filter {
      let target = $0.0
      let cans = backtrack(0, Array($0.1.reversed()))
      return cans.contains(target)
    }
    // Calculate the sum of the first set of input data
    return filtered.reduce(0) { $0 + $1.0 }
  }

  func backtrack(_ i: Int, _ nums: [Int], _ concatMode: Bool = false) -> [Int] {
    let count = nums.count
    if i == count - 1 {
      return  [nums[i]]
    }

    let candidates = backtrack(i + 1, nums)

    var result: [Int] = []
    for can in candidates {
      result.append(can + nums[i])
      result.append(can * nums[i])
      if concatMode {
        result.append(Int("\(can)\(nums[i])")!)
      }
    }
    return result
  }

  func generator(_ s: [Int]) -> [[String]] {
    let s = Array(s)
    var res = [["\(s.first!)"]]
    for c in s.dropFirst() {
      var newRes = [[String]]()
      for curr in res {
        newRes.append((curr + ["*"] + [String(c)]))
        newRes.append((curr + ["+"] + [String(c)]))
        newRes.append((curr + ["|"] + [String(c)]))

      }
      res = newRes
    }
    return res
  }

  func calculator(_ input: [String]) -> Int {
    var stack = [String]()
    for c in input {
      if stack.isEmpty { stack.append(c); continue}
      if stack.last! == "*" || stack.last! == "+" || stack.last! == "|" {
        let op = stack.popLast()
        let left = Int(stack.popLast()!)!
        let right = Int(c)!
        if op == "*" {
          stack.append(String(left * right))
        } else if op == "+" {
          stack.append(String(left + right))
        } else {
          stack.append("\(left)\(right)")
        }
      } else {
        stack.append(c)
      }
    }
    return Int(stack.last!)!
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let entities = self.entities
    print(entities.count)

    var counter = 0
    let filtered = entities.filter {
      counter += 1
      print(counter)
      let target = $0.0
      let nums = $0.1
      let a = generator(nums)
      let pos = a.map(calculator)


      return pos.contains(target)
    }

    return filtered.reduce(0) { $0 + $1.0 }
  }
}
