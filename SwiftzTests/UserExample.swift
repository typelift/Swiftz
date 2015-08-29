//
//  UserExample.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Swiftz

// A user example
// an example of why we need SYB, Generics or macros
public class User : JSONDecodable {
	let name : String
	let age : Int
	let tweets : [String]
	let attr : String

	public init(_ n : String, _ a : Int, _ t : [String], _ r : String) {
		name = n
		age = a
		tweets = t
		attr = r
	}

	// JSON
	public class func create(x : String) -> Int -> ([String] -> String -> User) {
		return { y in { z in { User(x, y, z, $0) } } }
	}

	public class func fromJSON(x : JSONValue) -> User? {
		let p1 : String? = x <? "name"
		let p2 : Int? = x <? "age"
		let p3 : [String]? = x <? "tweets"
		let p4 : String? = x <? "attrs" <> "one" // A nested keypath
		return User.create
			<^> p1
			<*> p2
			<*> p3
			<*> p4
	}
}

public func ==(lhs : User, rhs : User) -> Bool {
	return lhs.name == rhs.name && lhs.age == rhs.age && lhs.tweets == rhs.tweets && lhs.attr == rhs.attr
}
