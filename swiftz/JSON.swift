//
//  JSON.swift
//  swiftz
//
//  Created by Maxwell Swadling on 5/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

enum JSValue: Printable {
  case JSArray(Array<JSValue>)
  case JSObject(Dictionary<String, JSValue>)
  case JSNumber(Double)
  case JSString(String)
  case JSBool(Bool)
  case JSNull()
  
  // private
  func values() -> NSObject {
    switch self {
      case let JSArray(xs): return NSArray(array: xs.map { $0.values() })
      case let JSObject(xs): return NSDictionary(dictionary: xs.map { (k: String, v: JSValue) -> (String, AnyObject) in
          return (NSString(string: k), v.values())
        })
      case let JSNumber(n): return NSNumber(double: n)
      case let JSString(s): return NSString(string: s)
      case let JSBool(b): return NSNumber.numberWithBool(b)
      case let JSNull(): return NSNull()
    }
  }
  
  // private
  // we know this is safe because of the NSJSONSerialization docs
  static func make(a: NSObject) -> JSValue {
    switch a {
      case let xs as NSArray: return .JSArray(xs.mapToArray { self.make($0 as NSObject) })
      case let xs as NSDictionary:
        return JSValue.JSObject(xs.mapValuesToDictionary { switch $0 {
          case let (k, v): return (String(k as NSString), self.make(v as NSObject))
          }})
      case let xs as NSNumber:
        // TODO: number or bool?...
        return .JSNumber(Double(xs.doubleValue))
      case let xs as NSString: return .JSString(String(xs))
      case let xs as NSNull: return .JSNull()
      default: // TODO: what is swift's assert?
        perror("impossible"); abort()
    }
  }
  
  func encode() -> NSData? {
    var e: NSError?
    let opts: NSJSONWritingOptions = nil
    // TODO: check s is a dict or array
    return NSJSONSerialization.dataWithJSONObject(self.values(), options:opts, error: &e)
  }
  
  // TODO: should this be optional?
  static func decode(s: NSData) -> JSValue {
    var e: NSError?
    let opts: NSJSONReadingOptions = nil
    let r: AnyObject = NSJSONSerialization.JSONObjectWithData(s, options: opts, error: &e)
    return make(r as NSObject)
  }
  
  var description: String {
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

// this is the most un fun I have ever had
// Equatable
func ==(lhs: JSValue, rhs: JSValue) -> Bool {
  switch lhs {
    case .JSNull(): switch rhs {
      case .JSNull(): return true
      default: return false
    }
    case let .JSBool(l): switch rhs {
      case let .JSBool(r): return l == r
      default: return false
    }
    case let .JSString(l): switch rhs {
      case let .JSString(r): return l == r
      default: return false
    }
    case let .JSNumber(l): switch rhs {
      case let .JSNumber(r): return l == r
      default: return false
    }
    case let .JSObject(l): switch rhs {
      case let .JSObject(r): return equal(l, r, { (v1: (String, JSValue), v2: (String, JSValue)) in
        return v1.0 == v2.0 && v1.1 == v2.1
      })
      default: return false
    }
    case let .JSArray(l): switch rhs {
    case let .JSArray(r): return equal(l, r, { $0 == $1 })
      default: return false
    }
  }
}

func !=(lhs: JSValue, rhs: JSValue) -> Bool {
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

protocol JSONDecode {
  typealias J
  class func fromJSON(x: JSValue) -> J?
}

protocol JSONEncode {
  typealias J
  func toJSON(x: J) -> JSValue
}

protocol JSON: JSONDecode, JSONEncode {
  // J mate
}

// instances

let jdouble = JDouble()
class JDouble: JSON {
  typealias J = Double
  
  class func fromJSON(x: JSValue) -> J? {
    switch x {
    case let .JSNumber(n): return n
    default: return Optional.None
    }
  }
  
  func toJSON(xs: J) -> JSValue {
    return JSValue.JSNumber(xs)
  }
}

let jint = JInt()
class JInt: JSON {
  typealias J = Int
  
  class func fromJSON(x: JSValue) -> J? {
    switch x {
      case let .JSNumber(n): return Int(n)
      default: return Optional.None
    }
  }
  
  func toJSON(xs: J) -> JSValue {
    return JSValue.JSNumber(Double(xs))
  }
}

let jbool = JBool()
class JBool: JSON {
  typealias J = Bool
  
  class func fromJSON(x: JSValue) -> J? {
    switch x {
      case let .JSBool(n): return n
      case .JSNumber(0): return false
      case .JSNumber(1): return true
      default: return Optional.None
    }
  }
  
  func toJSON(xs: J) -> JSValue {
    return JSValue.JSNumber(Double(xs))
  }
}

let jstring = JString()
class JString: JSON {
  typealias J = String
  
  class func fromJSON(x: JSValue) -> J? {
    switch x {
      case let .JSString(n): return n
      default: return Optional.None
    }
  }
  
  func toJSON(xs: J) -> JSValue {
    return JSValue.JSString(xs)
  }
}

// or unit...
let jnull = JNull()
class JNull: JSON {
  typealias J = ()
  
  class func fromJSON(x: JSValue) -> J? {
    switch x {
      case .JSNull(): return ()
      default: return Optional.None
    }
  }
  
  func toJSON(xs: J) -> JSValue {
    return JSValue.JSNull()
  }
}


class JArray<A, B: JSON where B.J == A>: JSON {
  typealias J = Array<A>
  let inst: () -> B
  init(i: () -> B) {
    inst = i
  }
  
  class func fromJSON(x: JSValue) -> J? {
    switch x {
      // TODO: sequence / mapM
      case let .JSArray(xs): return xs.map { (x: JSValue) -> A in
        return B.fromJSON(x)!
      }
      default: return Optional.None
    }
  }
  
  func toJSON(xs: J) -> JSValue {
    return JSValue.JSArray(xs.map { self.inst().toJSON($0) } )
  }
}

class JDictionary<A, B: JSON where B.J == A>: JSON {
  typealias J = Dictionary<String, A>
  let inst: () -> B
  init(i: () -> B) {
    inst = i
  }
  
  class func fromJSON(x: JSValue) -> J? {
    switch x {
      case let .JSObject(xs): return xs.map { (k: String, x: JSValue) -> (String, A) in
        return (k, B.fromJSON(x)!)
      }
    default: return Optional.None
    }
  }
  
  func toJSON(xs: J) -> JSValue {
    return JSValue.JSObject(xs.map { (k: String, x: A) -> (String, JSValue) in
      return (k, self.inst().toJSON(x))
      } )
  }
}
