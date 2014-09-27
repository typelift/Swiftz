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
  class func zero() -> N
  class func succ(n: N) -> N
  class func add(x: N, y: N) -> N
  class func multiply(x: N, y: N) -> N
}

public let nint8 = NInt8()
public final class NInt8: Num {
  public typealias N = Int8
  public class func zero() -> N { return 0 }
  public class func succ(n: N) -> N { return n + 1 }
  public class func add(x: N, y: N) -> N { return x + y }
  public class func multiply(x: N, y: N) -> N { return x * y }
}

public let nint16 = NInt16()
public final class NInt16: Num {
  public typealias N = Int16
  public class func zero() -> N { return 0 }
  public class func succ(n: N) -> N { return n + 1 }
  public class func add(x: N, y: N) -> N { return x + y }
  public class func multiply(x: N, y: N) -> N { return x * y }
}

public let nint32 = NInt32()
public final class NInt32: Num {
  public typealias N = Int32
  public class func zero() -> N { return 0 }
  public class func succ(n: N) -> N { return n + 1 }
  public class func add(x: N, y: N) -> N { return x + y }
  public class func multiply(x: N, y: N) -> N { return x * y }
}

public let nint64 = NInt64()
public final class NInt64: Num {
  public typealias N = Int64
  public class func zero() -> N { return 0 }
  public class func succ(n: N) -> N { return n + 1 }
  public class func add(x: N, y: N) -> N { return x + y }
  public class func multiply(x: N, y: N) -> N { return x * y }
}

public let nuint8 = NUInt8()
public final class NUInt8: Num {
  public typealias N = UInt8
  public class func zero() -> N { return 0 }
  public class func succ(n: N) -> N { return n + 1 }
  public class func add(x: N, y: N) -> N { return x + y }
  public class func multiply(x: N, y: N) -> N { return x * y }
}

public let nuint16 = NUInt16()
public final class NUInt16: Num {
  public typealias N = UInt16
  public class func zero() -> N { return 0 }
  public class func succ(n: N) -> N { return n + 1 }
  public class func add(x: N, y: N) -> N { return x + y }
  public class func multiply(x: N, y: N) -> N { return x * y }
}

public let nuint32 = NUInt32()
public final class NUInt32: Num {
  public typealias N = UInt32
  public class func zero() -> N { return 0 }
  public class func succ(n: N) -> N { return n + 1 }
  public class func add(x: N, y: N) -> N { return x + y }
  public class func multiply(x: N, y: N) -> N { return x * y }
}

public let nuint64 = NUInt64()
public final class NUInt64: Num {
  public typealias N = UInt64
  public class func zero() -> N { return 0 }
  public class func succ(n: N) -> N { return n + 1 }
  public class func add(x: N, y: N) -> N { return x + y }
  public class func multiply(x: N, y: N) -> N { return x * y }
}
