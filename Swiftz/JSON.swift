//
//  JSON.swift
//  swiftz
//
//  Created by Maxwell Swadling on 5/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

public enum JSONValue : Printable {
	case JSONArray([JSONValue])
	case JSONObject(Dictionary<String, JSONValue>)
	case JSONNumber(Double)
	case JSONString(String)
	case JSONBool(Bool)
	case JSONNull()
	
	private func values() -> NSObject {
		switch self {
		case let JSONArray(xs): 
			return NSArray(array: xs.map { $0.values() })
		case let JSONObject(xs): 
			return NSDictionary(dictionary: map(dict: xs)({ (k: String, v: JSONValue) -> (String, AnyObject) in
				return (NSString(string: k), v.values())
			}))
		case let JSONNumber(n): 
			return NSNumber(double: n)
		case let JSONString(s): 
			return NSString(string: s)
		case let JSONBool(b): 
			return NSNumber(bool: b)
		case let JSONNull(): 
			return NSNull()
		}
	}
	
	// we know this is safe because of the NSJSONSerialization docs
	private static func make(a : NSObject) -> JSONValue {
		switch a {
		case let xs as NSArray:
			return .JSONArray(xs.mapToArray { self.make($0 as NSObject) })
		case let xs as NSDictionary:
			return JSONValue.JSONObject(xs.mapValuesToDictionary { (k: AnyObject, v: AnyObject) in
				return (String(k as NSString), self.make(v as NSObject))
			})
		case let xs as NSNumber: // TODO: number or bool?...
			return .JSONNumber(Double(xs.doubleValue))
		case let xs as NSString: 
			return .JSONString(String(xs))
		case let xs as NSNull: 
			return .JSONNull()
		default:
			return error("Non-exhaustive pattern match performed.");
		}
	}
	
	public func encode() -> NSData? {
		var e: NSError?
		let opts: NSJSONWritingOptions = nil
		// TODO: check s is a dict or array
		return NSJSONSerialization.dataWithJSONObject(self.values(), options:opts, error: &e)
	}
	
	// TODO: should this be optional?
	public static func decode(s : NSData) -> JSONValue? {
		var e: NSError?
		let opts: NSJSONReadingOptions = nil
		let r: AnyObject? = NSJSONSerialization.JSONObjectWithData(s, options: opts, error: &e)
		
		if let json: AnyObject = r {
			return make(json as NSObject)
		} else {
			return .None
		}
	}
	
	public static func decode(s : String) -> JSONValue? {
		return JSONValue.decode(s.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
	}
	
	public var description: String {
		get {
			switch self {
			case .JSONNull(): 
				return "JSONNull()"
			case let .JSONBool(b): 
				return "JSONBool(\(b))"
			case let .JSONString(s): 
				return "JSONString(\(s))"
			case let .JSONNumber(n): 
				return "JSONNumber(\(n))"
			case let .JSONObject(o): 
				return "JSONObject(\(o))"
			case let .JSONArray(a): 
				return "JSONArray(\(a))"
			}
		}
	}
}

// you'll have more fun if you match tuples
// Equatable
public func ==(lhs: JSONValue, rhs: JSONValue) -> Bool {
	switch (lhs, rhs) {
	case (.JSONNull(), .JSONNull()): 
		return true
	case let (.JSONBool(l), .JSONBool(r)) where l == r: 
		return true
	case let (.JSONString(l), .JSONString(r)) where l == r: 
		return true
	case let (.JSONNumber(l), .JSONNumber(r)) where l == r: 
		return true
	case let (.JSONObject(l), .JSONObject(r))
		where equal(l, r, { (v1: (String, JSONValue), v2: (String, JSONValue)) in v1.0 == v2.0 && v1.1 == v2.1 }):
		return true
	case let (.JSONArray(l), .JSONArray(r)) where equal(l, r, { $0 == $1 }):
		return true
	default: 
		return false
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

public func <! <A : JSONDecodable where A == A.J>(lhs : JSONValue, rhs : JSONKeypath) -> A? {
	switch lhs {
	case let .JSONObject(d):
		return resolveKeypath(d, rhs) >>- { A.fromJSON($0) }
	default:
		return .None
	}
}

public func <! <A : JSONDecodable where A == A.J>(lhs : JSONValue, rhs : JSONKeypath) -> [A]? {
	switch lhs {
	case let .JSONObject(d):
		return resolveKeypath(d, rhs) >>- JArrayFrom<A, A>.fromJSON
	default:
		return .None
	}
}

public func <! <A : JSONDecodable where A == A.J>(lhs : JSONValue, rhs : JSONKeypath) -> [String:A]? {
	switch lhs {
	case let .JSONObject(d):
		return resolveKeypath(d, rhs) >>- JDictionaryFrom<A, A>.fromJSON
	default:
		return .None
	}
}

// traits

public protocol JSONDecodable {
	typealias J = Self
	class func fromJSON(x: JSONValue) -> J?
}

public protocol JSONEncodable {
	typealias J
	class func toJSON(x: J) -> JSONValue
}

// J mate
public protocol JSON : JSONDecodable, JSONEncodable { }

// instances

extension Bool : JSON {	
	public static func fromJSON(x : JSONValue) -> Bool? {
		switch x {
		case let .JSONBool(n): 
			return n
		case .JSONNumber(0): 
			return false
		case .JSONNumber(1): 
			return true
		default: 
			return Optional.None
		}
	}
	
	public static func toJSON(xs : Bool) -> JSONValue {
		return JSONValue.JSONNumber(Double(xs))
	}
}

extension Int : JSON {	
	public static func fromJSON(x : JSONValue) -> Int? {
		switch x {
		case let .JSONNumber(n): 
			return Int(n)
		default: 
			return Optional.None
		}
	}
	
	public static func toJSON(xs : Int) -> JSONValue {
		return JSONValue.JSONNumber(Double(xs))
	}
}

extension Double : JSON {	
	public static func fromJSON(x : JSONValue) -> Double? {
		switch x {
		case let .JSONNumber(n): 
			return n
		default: 
			return Optional.None
		}
	}
	
	public static func toJSON(xs : Double) -> JSONValue {
		return JSONValue.JSONNumber(xs)
	}
}

extension NSNumber : JSON {	
	public class func fromJSON(x : JSONValue) -> NSNumber? {
		switch x {
		case let .JSONNumber(n): 
			return NSNumber(double: n)
		default: 
			return Optional.None
		}
	}
	
	public class func toJSON(xs : NSNumber) -> JSONValue {
		return JSONValue.JSONNumber(Double(xs))
	}
}

extension String : JSON {	
	public static func fromJSON(x : JSONValue) -> String? {
		switch x {
		case let .JSONString(n): 
			return n
		default: 
			return Optional.None
		}
	}
	
	public static func toJSON(xs : String) -> JSONValue {
		return JSONValue.JSONString(xs)
	}
}

// or unit...
extension NSNull : JSON {	
	public class func fromJSON(x : JSONValue) -> NSNull? {
		switch x {
		case .JSONNull():
			return NSNull()
		default: 
			return Optional.None
		}
	}
	
	public class func toJSON(xs : NSNull) -> JSONValue {
		return JSONValue.JSONNull()
	}
}

// container types should be split
public struct JArrayFrom<A, B : JSONDecodable where B.J == A> : JSONDecodable {
	public typealias J = [A]
	
	public static func fromJSON(x : JSONValue) -> J? {
		switch x {
		case let .JSONArray(xs):
			let r = xs.map({ B.fromJSON($0) })
			let rp = mapFlatten(r)
			if r.count == rp.count {
				return rp
			} else {
				return nil
			}
		default: 
			return Optional.None
		}
	}
}

public struct JArrayTo<A, B : JSONEncodable where B.J == A> : JSONEncodable {
	public typealias J = [A]
	
	public static func toJSON(xs: J) -> JSONValue {
		return JSONValue.JSONArray(xs.map { B.toJSON($0) } )
	}
}

public struct JArray<A, B : JSON where B.J == A> : JSON {
	public typealias J = [A]
	
	public static func fromJSON(x : JSONValue) -> J? {
		switch x {
		case let .JSONArray(xs):
			let r = xs.map({ B.fromJSON($0) })
			let rp = mapFlatten(r)
			if r.count == rp.count {
				return rp
			} else {
				return nil
			}
		default: 
			return Optional.None
		}
	}
	
	public static func toJSON(xs: J) -> JSONValue {
		return JSONValue.JSONArray(xs.map { B.toJSON($0) } )
	}
}


public struct JDictionaryFrom<A, B : JSONDecodable where B.J == A> : JSONDecodable {
	public typealias J = Dictionary<String, A>
	
	public static func fromJSON(x : JSONValue) -> J? {
		switch x {
		case let .JSONObject(xs): 
			return map(dict: xs)({ (k: String, x: JSONValue) -> (String, A) in
				return (k, B.fromJSON(x)!)
			})
		default: 
			return Optional.None
		}
	}
}

public struct JDictionaryTo<A, B : JSONEncodable where B.J == A> : JSONEncodable {
	public typealias J = Dictionary<String, A>
	
	public static func toJSON(xs : J) -> JSONValue {
		return JSONValue.JSONObject(map(dict: xs)({ (k: String, x: A) -> (String, JSONValue) in
			return (k, B.toJSON(x))
		}))
	}
}

public struct JDictionary<A, B : JSON where B.J == A> : JSON {
	public typealias J = Dictionary<String, A>
	
	public static func fromJSON(x : JSONValue) -> J? {
		switch x {
		case let .JSONObject(xs): 
			return map(dict: xs)({ (k: String, x: JSONValue) -> (String, A) in
				return (k, B.fromJSON(x)!)
			})
		default: 
			return Optional.None
		}
	}
	
	public static func toJSON(xs : J) -> JSONValue {
		return JSONValue.JSONObject(map(dict: xs)({ (k: String, x: A) -> (String, JSONValue) in
			return (k, B.toJSON(x))
		}))
	}
}


/// MARK: Implementation Details

private func resolveKeypath(lhs : Dictionary<String, JSONValue>, rhs : JSONKeypath) -> JSONValue? {
	if rhs.path.isEmpty {
		return .None
	}
	
	if let o = lhs[rhs.path.first!] {
		switch o {
		case let .JSONObject(d) where rhs.path.count > 1:
			let tail = Array(rhs.path[1..<rhs.path.count])
			return resolveKeypath(d, JSONKeypath(tail))
		default:
			return o
		}
	}
	
	return .None
}

