//
//  JSON.swift
//  swiftz
//
//  Created by Maxwell Swadling on 5/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

public enum JSValue: Printable {
  case JSArray([JSValue])
  case JSObject(Dictionary<String, JSValue>)
  case JSNumber(Double)
  case JSString(String)
  case JSBool(Bool)
  case JSNull()

  // private
  public func values() -> NSObject {
    switch self {
    case let JSArray(xs): return NSArray(array: xs.map { $0.values() })
    case let JSObject(xs): return NSDictionary(dictionary: xs.map { (k: String, v: JSValue) -> (String, AnyObject) in
      return (NSString(string: k), v.values())
      })
    case let JSNumber(n): return NSNumber(double: n)
    case let JSString(s): return NSString(string: s)
    case let JSBool(b): return NSNumber(bool: b)
    case let JSNull(): return NSNull()
    }
  }

  // private
  // we know this is safe because of the NSJSONSerialization docs
  public static func make(a: NSObject) -> JSValue {
    switch a {
    case let xs as NSArray: return .JSArray(xs.mapToArray { self.make($0 as NSObject) })
    case let xs as NSDictionary:
      return JSValue.JSObject(xs.mapValuesToDictionary { (k: AnyObject, v: AnyObject) in
        return (String(format: k as NSString), self.make(v as NSObject))
        })
    case let xs as NSNumber:
      // TODO: number or bool?...
      return .JSNumber(Double(xs.doubleValue))
    case let xs as NSString: return .JSString(String(format: xs))
    case let xs as NSNull: return .JSNull()
    default: // TODO: what is swift's assert?
      perror("impossible"); abort()
    }
  }

  public func encode() -> NSData? {
    var e: NSError?
    let opts: NSJSONWritingOptions = nil
    // TODO: check s is a dict or array
    return NSJSONSerialization.dataWithJSONObject(self.values(), options:opts, error: &e)
  }

  // TODO: should this be optional?
  public static func decode(s: NSData) -> JSValue? {
    var e: NSError?
    let opts: NSJSONReadingOptions = nil
    let r: AnyObject? = NSJSONSerialization.JSONObjectWithData(s, options: opts, error: &e)

    if let json: AnyObject = r {
      return make(json as NSObject)
    } else {
      return .None
    }
  }

  public var description: String {
    get {
      switch self {
      case .JSNull(): return "JSNull()"
      case let .JSBool(b): return "JSBool(\(b))"
      case let .JSString(s): return "JSString(\(s))"
      case let .JSNumber(n): return "JSNumber(\(n))"
      case let .JSObject(o): return "JSObject(\(o))"
      case let .JSArray(a): return "JSArray(\(a))"

      }
    }
  }

}

// you'll have more fun if you match tuples
// Equatable
public func ==(lhs: JSValue, rhs: JSValue) -> Bool {
  switch (lhs, rhs) {
  case (.JSNull(), .JSNull()): return true
  case let (.JSBool(l), .JSBool(r)) where l == r: return true
  case let (.JSString(l), .JSString(r)) where l == r: return true
  case let (.JSNumber(l), .JSNumber(r)) where l == r: return true
  case let (.JSObject(l), .JSObject(r))
    where equal(l, r, { (v1: (String, JSValue), v2: (String, JSValue)) in v1.0 == v2.0 && v1.1 == v2.1 }):
    return true
  case let (.JSArray(l), .JSArray(r)) where equal(l, r, { $0 == $1 }):
    return true
  default: return false
  }
}

public func !=(lhs: JSValue, rhs: JSValue) -> Bool {
  return !(lhs == rhs)
}

// someday someone will ask for this
//// Comparable
//func <=(lhs: JSValue, rhs: JSValue) -> Bool {
//  return false;
//}
//
//func >(lhs: JSValue, rhs: JSValue) -> Bool {
//  return !(lhs <= rhs)
//}
//
//func >=(lhs: JSValue, rhs: JSValue) -> Bool {
//  return (lhs > rhs || lhs == rhs)
//}
//
//func <(lhs: JSValue, rhs: JSValue) -> Bool {
//  return !(lhs >= rhs)
//}

// traits

public protocol JSONDecode {
  typealias J
  class func fromJSON(x: JSValue) -> J?
}

public protocol JSONEncode {
  typealias J
  class func toJSON(x: J) -> JSValue
}

public protocol JSON: JSONDecode, JSONEncode {
  // J mate
}

// instances

public class JDouble: JSON {
  public typealias J = Double

  public class func fromJSON(x: JSValue) -> J? {
    switch x {
    case let .JSNumber(n): return n
    default: return Optional.None
    }
  }

  public class func toJSON(xs: J) -> JSValue {
    return JSValue.JSNumber(xs)
  }
}

public class JInt: JSON {
  public typealias J = Int

  public class func fromJSON(x: JSValue) -> J? {
    switch x {
    case let .JSNumber(n): return Int(n)
    default: return Optional.None
    }
  }

  public class func toJSON(xs: J) -> JSValue {
    return JSValue.JSNumber(Double(xs))
  }
}

public class JNumber: JSON {
  public typealias J = NSNumber

  public class func fromJSON(x: JSValue) -> J? {
    switch x {
    case let .JSNumber(n): return NSNumber(double: n)
    default: return Optional.None
    }
  }

  public class func toJSON(xs: J) -> JSValue {
    return JSValue.JSNumber(Double(xs))
  }
}

public class JBool: JSON {
  public typealias J = Bool

  public class func fromJSON(x: JSValue) -> J? {
    switch x {
    case let .JSBool(n): return n
    case .JSNumber(0): return false
    case .JSNumber(1): return true
    default: return Optional.None
    }
  }

  public class func toJSON(xs: J) -> JSValue {
    return JSValue.JSNumber(Double(xs))
  }
}

public class JString: JSON {
  public typealias J = String

  public class func fromJSON(x: JSValue) -> J? {
    switch x {
    case let .JSString(n): return n
    default: return Optional.None
    }
  }

  public class func toJSON(xs: J) -> JSValue {
    return JSValue.JSString(xs)
  }
}

// or unit...
public let jnull = JNull()
public class JNull: JSON {
  public typealias J = ()

  public class func fromJSON(x: JSValue) -> J? {
    switch x {
    case .JSNull(): return ()
    default: return Optional.None
    }
  }

  public class func toJSON(xs: J) -> JSValue {
    return JSValue.JSNull()
  }
}


// container types should be split
/* final */ public class JArrayFrom<A, B: JSONDecode where B.J == A>: JSONDecode {
  public typealias J = [A]

  public class func fromJSON(x: JSValue) -> J? {
    switch x {
    case let .JSArray(xs):
      let r = xs.map({ B.fromJSON($0) })
      let rp = mapFlatten(r)
      if r.count == rp.count {
        return rp
      } else {
        return nil
      }
    default: return Optional.None
    }
  }
}

/* final */ public class JArrayTo<A, B: JSONEncode where B.J == A>: JSONEncode {
  public typealias J = [A]

  public class func toJSON(xs: J) -> JSValue {
    return JSValue.JSArray(xs.map { B.toJSON($0) } )
  }
}

/* final */ public class JArray<A, B: JSON where B.J == A>: JSON {
  public typealias J = [A]

  public class func fromJSON(x: JSValue) -> J? {
    switch x {
    case let .JSArray(xs):
      let r = xs.map({ B.fromJSON($0) })
      let rp = mapFlatten(r)
      if r.count == rp.count {
        return rp
      } else {
        return nil
      }
    default: return Optional.None
    }
  }

  public class func toJSON(xs: J) -> JSValue {
    return JSValue.JSArray(xs.map { B.toJSON($0) } )
  }
}


/* final */ public class JDictionaryFrom<A, B: JSONDecode where B.J == A>: JSONDecode {
  public typealias J = Dictionary<String, A>

  public class func fromJSON(x: JSValue) -> J? {
    switch x {
    case let .JSObject(xs): return xs.map { (k: String, x: JSValue) -> (String, A) in
      return (k, B.fromJSON(x)!)
      }
    default: return Optional.None
    }
  }
}

/* final */ public class JDictionaryTo<A, B: JSONEncode where B.J == A>: JSONEncode {
  public typealias J = Dictionary<String, A>

  public class func toJSON(xs: J) -> JSValue {
    return JSValue.JSObject(xs.map { (k: String, x: A) -> (String, JSValue) in
      return (k, B.toJSON(x))
      } )
  }
}

/* final */ public class JDictionary<A, B: JSON where B.J == A>: JSON {
  public typealias J = Dictionary<String, A>

  public class func fromJSON(x: JSValue) -> J? {
    switch x {
    case let .JSObject(xs): return xs.map { (k: String, x: JSValue) -> (String, A) in
      return (k, B.fromJSON(x)!)
      }
    default: return Optional.None
    }
  }

  public class func toJSON(xs: J) -> JSValue {
    return JSValue.JSObject(xs.map { (k: String, x: A) -> (String, JSValue) in
      return (k, B.toJSON(x))
      } )
  }
}
