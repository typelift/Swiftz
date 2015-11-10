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
class User {
	let id : UInt64
	let name : String
	let age : Int
	let tweets : [String]
	let attr : String
	let balance : Double
	let admin : Bool

	init(_ i : UInt64, _ n : String, _ a : Int, _ t : [String], _ r : String, _ b : Double, _ ad : Bool) {
		id = i
		name = n
		age = a
		tweets = t
		attr = r
		balance = b
		admin = ad
	}
}

extension User: JSONDecodable {
	class func fromJSON(x : JSONValue) -> User? {
		let p1 : UInt64? = x <? "id"
		let p2 : String? = x <? "name"
		let p3 : Int? = x <? "age"
		let p4 : [String]? = x <? "tweets"
		let p5 : String? = x <? "attrs" <> "one" // A nested keypath
		let p6: Double? = x <? "balance"
		let p7: Bool? = x <? "admin"
		
		return curry(User.init)
			<^> p1
			<*> p2
			<*> p3
			<*> p4
			<*> p5
			<*> p6
			<*> p7
	}
}

func ==(lhs : User, rhs : User) -> Bool {
	return lhs.id == rhs.id
		&& lhs.name == rhs.name
		&& lhs.age == rhs.age
		&& lhs.tweets == rhs.tweets
		&& lhs.attr == rhs.attr
		&& lhs.balance == rhs.balance
		&& lhs.admin == rhs.admin
}
