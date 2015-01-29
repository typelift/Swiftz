//
//  UserExample.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Swiftz

// A user example
// an example of why we need SYB, Generics or macros
public class User: JSONDecode {
	typealias J = User
	let name: String
	let age: Int
	let tweets: [String]
	let attrs: Dictionary<String, String>
	
	public init(_ n: String, _ a: Int, _ t: [String], _ r: Dictionary<String, String>) {
		name = n
		age = a
		tweets = t
		attrs = r
	}
	
	// JSON
	public class func create(x: String) -> (Int) -> (([String]) -> ((Dictionary<String, String>) -> User)) {
		return { (y: Int) in { (z: [String]) in { User(x, y, z, $0) } } }
	}
	
	public class func fromJSON(x: JSONValue) -> User? {
		switch x {
		case let .JSONObject(d):
			let n = d["name"]   >>- JString.fromJSON
			let a = d["age"]    >>- JInt.fromJSON
			let t = d["tweets"] >>- JArray<String, JString>.fromJSON
			let r = d["attrs"]  >>- JDictionary<String, JString>.fromJSON
			// alternatively, if n && a && t... { return User(n!, a!, ...
			return (User.create <^> n <*> a <*> t <*> r)
		default:
			return .None
		}
	}
	
	// lens example
	public class func luserName() -> Lens<User, User, String, String> {
		return Lens { user in IxStore(user.name) { User($0, user.age, user.tweets, user.attrs) } }
	}
}

public func ==(lhs: User, rhs: User) -> Bool {
	return lhs.name == rhs.name && lhs.age == rhs.age && lhs.tweets == rhs.tweets && lhs.attrs == rhs.attrs
}
