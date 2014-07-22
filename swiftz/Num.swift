//
//  Num.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// Num 'typeclass'

public protocol Num {
  typealias N
  func zero() -> N
  func succ(n: N) -> N
  func add(x: N, y: N) -> N
  func multiply(x: N, y: N) -> N
}

public let nint8 = NInt8()
public class NInt8: Num {
  public typealias N = Int8
  public func zero() -> N { return 0 }
  public func succ(n: N) -> N { return n + 1 }
  public func add(x: N, y: N) -> N { return x + y }
  public func multiply(x: N, y: N) -> N { return x * y }
}

public let nint16 = NInt16()
public class NInt16: Num {
  public typealias N = Int16
  public func zero() -> N { return 0 }
  public func succ(n: N) -> N { return n + 1 }
  public func add(x: N, y: N) -> N { return x + y }
  public func multiply(x: N, y: N) -> N { return x * y }
}

public let nint32 = NInt32()
public class NInt32: Num {
  public typealias N = Int32
  public func zero() -> N { return 0 }
  public func succ(n: N) -> N { return n + 1 }
  public func add(x: N, y: N) -> N { return x + y }
  public func multiply(x: N, y: N) -> N { return x * y }
}

public let nint64 = NInt64()
public class NInt64: Num {
  public typealias N = Int64
  public func zero() -> N { return 0 }
  public func succ(n: N) -> N { return n + 1 }
  public func add(x: N, y: N) -> N { return x + y }
  public func multiply(x: N, y: N) -> N { return x * y }
}

public let nuint8 = NUInt8()
public class NUInt8: Num {
  public typealias N = UInt8
  public func zero() -> N { return 0 }
  public func succ(n: N) -> N { return n + 1 }
  public func add(x: N, y: N) -> N { return x + y }
  public func multiply(x: N, y: N) -> N { return x * y }
}

public let nuint16 = NUInt16()
public class NUInt16: Num {
  public typealias N = UInt16
  public func zero() -> N { return 0 }
  public func succ(n: N) -> N { return n + 1 }
  public func add(x: N, y: N) -> N { return x + y }
  public func multiply(x: N, y: N) -> N { return x * y }
}

public let nuint32 = NUInt32()
public class NUInt32: Num {
  public typealias N = UInt32
  public func zero() -> N { return 0 }
  public func succ(n: N) -> N { return n + 1 }
  public func add(x: N, y: N) -> N { return x + y }
  public func multiply(x: N, y: N) -> N { return x * y }
}

public let nuint64 = NUInt64()
public class NUInt64: Num {
  public typealias N = UInt64
  public func zero() -> N { return 0 }
  public func succ(n: N) -> N { return n + 1 }
  public func add(x: N, y: N) -> N { return x + y }
  public func multiply(x: N, y: N) -> N { return x * y }
}
