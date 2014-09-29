//
//  JSON.swift
//  swiftz
//
//  Created by Maxwell Swadling on 5/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

public enum JSONValue: Printable {
  case JSONArray([JSONValue])
  case JSONObject(Dictionary<String, JSONValue>)
  case JSONNumber(Double)
  case JSONString(String)
  case JSONBool(Bool)
  case JSONNull()

  // private
  public func values() -> NSObject {
    switch self {
    case let JSONArray(xs): return NSArray(array: xs.map { $0.values() })
    case let JSONObject(xs): return NSDictionary(dictionary: xs.map { (k: String, v: JSONValue) -> (String, AnyObject) in
      return (NSString(string: k), v.values())
      })
    case let JSONNumber(n): return NSNumber(double: n)
    case let JSONString(s): return NSString(string: s)
    case let JSONBool(b): return NSNumber.numberWithBool(b)
    case let JSONNull(): return NSNull()
    }
  }

  // private
  // we know this is safe because of the NSJSONSerialization docs
  public static func make(a: NSObject) -> JSONValue {
    switch a {
    case let xs as NSArray: return .JSONArray(xs.mapToArray { self.make($0 as NSObject) })
    case let xs as NSDictionary:
      return JSONValue.JSONObject(xs.mapValuesToDictionary { (k: AnyObject, v: AnyObject) in
        return (String(format: k as NSString), self.make(v as NSObject))
        })
    case let xs as NSNumber:
      // TODO: number or bool?...
      return .JSONNumber(Double(xs.doubleValue))
    case let xs as NSString: return .JSONString(String(format: xs))
    case let xs as NSNull: return .JSONNull()
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
  public static func decode(s: NSData) -> JSONValue? {
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
      case .JSONNull(): return "JSONNull()"
      case let .JSONBool(b): return "JSONBool(\(b))"
      case let .JSONString(s): return "JSONString(\(s))"
      case let .JSONNumber(n): return "JSONNumber(\(n))"
      case let .JSONObject(o): return "JSONObject(\(o))"
      case let .JSONArray(a): return "JSONArray(\(a))"

      }
    }
  }

}

// you'll have more fun if you match tuples
// Equatable
public func ==(lhs: JSONValue, rhs: JSONValue) -> Bool {
  switch (lhs, rhs) {
  case (.JSONNull(), .JSONNull()): return true
  case let (.JSONBool(l), .JSONBool(r)) where l == r: return true
  case let (.JSONString(l), .JSONString(r)) where l == r: return true
  case let (.JSONNumber(l), .JSONNumber(r)) where l == r: return true
  case let (.JSONObject(l), .JSONObject(r))
    where equal(l, r, { (v1: (String, JSONValue), v2: (String, JSONValue)) in v1.0 == v2.0 && v1.1 == v2.1 }):
    return true
  case let (.JSONArray(l), .JSONArray(r)) where equal(l, r, { $0 == $1 }):
    return true
  default: return false
  }
}

public func !=(lhs: JSONValue, rhs: JSONValue) -> Bool {
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
  class func fromJSON(x: JSONValue) -> J?
}

public protocol JSONEncode {
  typealias J
  class func toJSON(x: J) -> JSONValue
}

public protocol JSON: JSONDecode, JSONEncode {
  // J mate
}

// instances

public class JDouble: JSON {
  public typealias J = Double

  public class func fromJSON(x: JSONValue) -> J? {
    switch x {
    case let .JSONNumber(n): return n
    default: return Optional.None
    }
  }

  public class func toJSON(xs: J) -> JSONValue {
    return JSONValue.JSONNumber(xs)
  }
}

public class JInt: JSON {
  public typealias J = Int

  public class func fromJSON(x: JSONValue) -> J? {
    switch x {
    case let .JSONNumber(n): return Int(n)
    default: return Optional.None
    }
  }

  public class func toJSON(xs: J) -> JSONValue {
    return JSONValue.JSONNumber(Double(xs))
  }
}

public class JNumber: JSON {
  public typealias J = NSNumber

  public class func fromJSON(x: JSONValue) -> J? {
    switch x {
    case let .JSONNumber(n): return NSNumber(double: n)
    default: return Optional.None
    }
  }

  public class func toJSON(xs: J) -> JSONValue {
    return JSONValue.JSONNumber(Double(xs))
  }
}

public class JBool: JSON {
  public typealias J = Bool

  public class func fromJSON(x: JSONValue) -> J? {
    switch x {
    case let .JSONBool(n): return n
    case .JSONNumber(0): return false
    case .JSONNumber(1): return true
    default: return Optional.None
    }
  }

  public class func toJSON(xs: J) -> JSONValue {
    return JSONValue.JSONNumber(Double(xs))
  }
}

public class JString: JSON {
  public typealias J = String

  public class func fromJSON(x: JSONValue) -> J? {
    switch x {
    case let .JSONString(n): return n
    default: return Optional.None
    }
  }

  public class func toJSON(xs: J) -> JSONValue {
    return JSONValue.JSONString(xs)
  }
}

// or unit...
public let jnull = JNull()
public class JNull: JSON {
  public typealias J = ()

  public class func fromJSON(x: JSONValue) -> J? {
    switch x {
    case .JSONNull(): return ()
    default: return Optional.None
    }
  }

  public class func toJSON(xs: J) -> JSONValue {
    return JSONValue.JSONNull()
  }
}


// container types should be split
/* final */ public class JArrayFrom<A, B: JSONDecode where B.J == A>: JSONDecode {
  public typealias J = [A]

  public class func fromJSON(x: JSONValue) -> J? {
    switch x {
    case let .JSONArray(xs):
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

  public class func toJSON(xs: J) -> JSONValue {
    return JSONValue.JSONArray(xs.map { B.toJSON($0) } )
  }
}

/* final */ public class JArray<A, B: JSON where B.J == A>: JSON {
  public typealias J = [A]

  public class func fromJSON(x: JSONValue) -> J? {
    switch x {
    case let .JSONArray(xs):
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

  public class func toJSON(xs: J) -> JSONValue {
    return JSONValue.JSONArray(xs.map { B.toJSON($0) } )
  }
}


/* final */ public class JDictionaryFrom<A, B: JSONDecode where B.J == A>: JSONDecode {
  public typealias J = Dictionary<String, A>

  public class func fromJSON(x: JSONValue) -> J? {
    switch x {
    case let .JSONObject(xs): return xs.map { (k: String, x: JSONValue) -> (String, A) in
      return (k, B.fromJSON(x)!)
      }
    default: return Optional.None
    }
  }
}

/* final */ public class JDictionaryTo<A, B: JSONEncode where B.J == A>: JSONEncode {
  public typealias J = Dictionary<String, A>

  public class func toJSON(xs: J) -> JSONValue {
    return JSONValue.JSONObject(xs.map { (k: String, x: A) -> (String, JSONValue) in
      return (k, B.toJSON(x))
      } )
  }
}

/* final */ public class JDictionary<A, B: JSON where B.J == A>: JSON {
  public typealias J = Dictionary<String, A>

  public class func fromJSON(x: JSONValue) -> J? {
    switch x {
    case let .JSONObject(xs): return xs.map { (k: String, x: JSONValue) -> (String, A) in
      return (k, B.fromJSON(x)!)
      }
    default: return Optional.None
    }
  }

  public class func toJSON(xs: J) -> JSONValue {
    return JSONValue.JSONObject(xs.map { (k: String, x: A) -> (String, JSONValue) in
      return (k, B.toJSON(x))
      } )
  }
}
