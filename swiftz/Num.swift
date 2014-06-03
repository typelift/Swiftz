//
//  Num.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// Num 'typeclass'

protocol Num {
  typealias N
  func zero() -> N
  func succ(n: N) -> N
  func add(x: N, y: N) -> N
  func multiply(x: N, y: N) -> N
}

class NInt8: Num {
  typealias N = Int8
  func zero() -> N { return 0 }
  func succ(n: N) -> N { return n + 1 }
  func add(x: N, y: N) -> N { return x + y }
  func multiply(x: N, y: N) -> N { return x * y }
}

class NInt16: Num {
  typealias N = Int16
  func zero() -> N { return 0 }
  func succ(n: N) -> N { return n + 1 }
  func add(x: N, y: N) -> N { return x + y }
  func multiply(x: N, y: N) -> N { return x * y }
}

class NInt32: Num {
  typealias N = Int32
  func zero() -> N { return 0 }
  func succ(n: N) -> N { return n + 1 }
  func add(x: N, y: N) -> N { return x + y }
  func multiply(x: N, y: N) -> N { return x * y }
}

class NInt64: Num {
  typealias N = Int64
  func zero() -> N { return 0 }
  func succ(n: N) -> N { return n + 1 }
  func add(x: N, y: N) -> N { return x + y }
  func multiply(x: N, y: N) -> N { return x * y }
}

class NUInt8: Num {
  typealias N = UInt8
  func zero() -> N { return 0 }
  func succ(n: N) -> N { return n + 1 }
  func add(x: N, y: N) -> N { return x + y }
  func multiply(x: N, y: N) -> N { return x * y }
}

class NUInt16: Num {
  typealias N = UInt16
  func zero() -> N { return 0 }
  func succ(n: N) -> N { return n + 1 }
  func add(x: N, y: N) -> N { return x + y }
  func multiply(x: N, y: N) -> N { return x * y }
}

class NUInt32: Num {
  typealias N = UInt32
  func zero() -> N { return 0 }
  func succ(n: N) -> N { return n + 1 }
  func add(x: N, y: N) -> N { return x + y }
  func multiply(x: N, y: N) -> N { return x * y }
}

class NUInt64: Num {
  typealias N = UInt64
  func zero() -> N { return 0 }
  func succ(n: N) -> N { return n + 1 }
  func add(x: N, y: N) -> N { return x + y }
  func multiply(x: N, y: N) -> N { return x * y }
}
