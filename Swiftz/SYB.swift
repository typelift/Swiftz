//
//  SYB.swift
//  swiftz
//
//  Created by Maxwell Swadling on 7/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// MARK: Scrap Your Boilerplate
/// ~( http://foswiki.cs.uu.nl/foswiki/GenericProgramming/SYB )

/// Types that can serialize themselves to and from a given data format.
public protocol Dataable {
	/// The type of values of the receiver.
	static func typeRep() -> Any.Type
	/// Deserializes data into a value of the type of the receiver.
	static func fromRep(r : Data) -> Self?
	/// Serializes the receiver into data.
	func toRep() -> Data
}

/// A simple data format an object can serialize into and out of.
public struct Data {
	public let con : Int
	public let vals : [(String, Any)]

	public init(con: Int, vals: [(String, Any)]) {
		self.con = con
		self.vals = vals
	}
}
