//
//  Num.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import swiftz_core

// Num 'typeclass'

public protocol Num {
  typealias N
  func zero() -> N
  func succ(n: N) -> N
  func add(x: N, y: N) -> N
  func multiply(x: N, y: N) -> N
}

public let nint8 = NInt8()
public final class NInt8: K0, Num {
  public typealias N = Int8
  public func zero() -> N { return 0 }
  public func succ(n: N) -> N { return n + 1 }
  public func add(x: N, y: N) -> N { return x + y }
  public func multiply(x: N, y: N) -> N { return x * y }
}

public let nint16 = NInt16()
public final class NInt16: K0, Num {
  public typealias N = Int16
  public func zero() -> N { return 0 }
  public func succ(n: N) -> N { return n + 1 }
  public func add(x: N, y: N) -> N { return x + y }
  public func multiply(x: N, y: N) -> N { return x * y }
}

public let nint32 = NInt32()
public final class NInt32: K0, Num {
  public typealias N = Int32
  public func zero() -> N { return 0 }
  public func succ(n: N) -> N { return n + 1 }
  public func add(x: N, y: N) -> N { return x + y }
  public func multiply(x: N, y: N) -> N { return x * y }
}

public let nint64 = NInt64()
public final class NInt64: K0, Num {
  public typealias N = Int64
  public func zero() -> N { return 0 }
  public func succ(n: N) -> N { return n + 1 }
  public func add(x: N, y: N) -> N { return x + y }
  public func multiply(x: N, y: N) -> N { return x * y }
}

public let nuint8 = NUInt8()
public final class NUInt8: K0, Num {
  public typealias N = UInt8
  public func zero() -> N { return 0 }
  public func succ(n: N) -> N { return n + 1 }
  public func add(x: N, y: N) -> N { return x + y }
  public func multiply(x: N, y: N) -> N { return x * y }
}

public let nuint16 = NUInt16()
public final class NUInt16: K0, Num {
  public typealias N = UInt16
  public func zero() -> N { return 0 }
  public func succ(n: N) -> N { return n + 1 }
  public func add(x: N, y: N) -> N { return x + y }
  public func multiply(x: N, y: N) -> N { return x * y }
}

public let nuint32 = NUInt32()
public final class NUInt32: K0, Num {
  public typealias N = UInt32
  public func zero() -> N { return 0 }
  public func succ(n: N) -> N { return n + 1 }
  public func add(x: N, y: N) -> N { return x + y }
  public func multiply(x: N, y: N) -> N { return x * y }
}

public let nuint64 = NUInt64()
public final class NUInt64: K0, Num {
  public typealias N = UInt64
  public func zero() -> N { return 0 }
  public func succ(n: N) -> N { return n + 1 }
  public func add(x: N, y: N) -> N { return x + y }
  public func multiply(x: N, y: N) -> N { return x * y }
}
