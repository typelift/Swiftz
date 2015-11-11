//
//  JSONSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

extension JSONValue : Arbitrary {
	public static var arbitrary: Gen<JSONValue> {
		return UInt.arbitrary >>- { n in
			switch n % 31 {
			case 0:
				return UInt.arbitrary >>- { b in
					if b % 2 == 0  {
						return Gen.pure(JSONValue.JSONArray([]))
					}
					return [JSONValue].arbitrary.fmap(JSONValue.JSONArray)
				}
			case 1:
				return UInt.arbitrary >>- { b in
					if b % 2 == 0  {
						return Gen.pure(JSONValue.JSONObject([:]))
					}
					return DictionaryOf<String, JSONValue>.arbitrary.fmap { JSONValue.JSONObject($0.getDictionary) }
				}
			case 2:
				return String.arbitrary.fmap(JSONValue.JSONString)
			case 3:
				return Bool.arbitrary.fmap(JSONValue.JSONNumber • NSNumber.init)
			case 4:
				return Int.arbitrary.fmap { JSONValue.JSONNumber($0 as NSNumber) }
			case 5:
				return Int8.arbitrary.fmap(JSONValue.JSONNumber • NSNumber.init)
			case 6:
				return Int16.arbitrary.fmap(JSONValue.JSONNumber • NSNumber.init)
			case 7:
				return Int32.arbitrary.fmap(JSONValue.JSONNumber • NSNumber.init)
			case 8:
				return Int64.arbitrary.fmap(JSONValue.JSONNumber • NSNumber.init)
			case 9:
				return UInt.arbitrary.fmap { JSONValue.JSONNumber($0 as NSNumber) }
			case 10:
				return UInt8.arbitrary.fmap(JSONValue.JSONNumber • NSNumber.init)
			case 11:
				return UInt16.arbitrary.fmap(JSONValue.JSONNumber • NSNumber.init)
			case 12:
				return UInt32.arbitrary.fmap(JSONValue.JSONNumber • NSNumber.init)
			case 13:
				return UInt64.arbitrary.fmap(JSONValue.JSONNumber • NSNumber.init)
			case 14:
				return Float.arbitrary.fmap(JSONValue.JSONNumber • NSNumber.init)
			case 15:
				return Double.arbitrary.fmap(JSONValue.JSONNumber • NSNumber.init)
			default:
				return Gen.pure(JSONValue.JSONNull)
			}
		}
	}
}

class JSONSpec : XCTestCase {
	let frequentFliers : [Property] = [
		forAll { (x : JSONValue) in if let xs = String.fromJSON(x).map(String.toJSON) { return xs == .Some(x) }; return Discard() },
		forAll { (x : JSONValue) in if let xs = Bool.fromJSON(x).map(Bool.toJSON) { return xs == .Some(x) }; return Discard() },
		forAll { (x : JSONValue) in if let xs = Int.fromJSON(x).map(Int.toJSON) { return xs == .Some(x) }; return Discard() },
		forAll { (x : JSONValue) in if let xs = Int8.fromJSON(x).map(Int8.toJSON) { return xs == .Some(x) }; return Discard() },
		forAll { (x : JSONValue) in if let xs = Int16.fromJSON(x).map(Int16.toJSON) { return xs == .Some(x) }; return Discard() },
		forAll { (x : JSONValue) in if let xs = Int32.fromJSON(x).map(Int32.toJSON) { return xs == .Some(x) }; return Discard() },
		forAll { (x : JSONValue) in if let xs = Int64.fromJSON(x).map(Int64.toJSON) { return xs == .Some(x) }; return Discard() },
		forAll { (x : JSONValue) in if let xs = UInt.fromJSON(x).map(UInt.toJSON) { return xs == .Some(x) }; return Discard() },
		forAll { (x : JSONValue) in if let xs = UInt8.fromJSON(x).map(UInt8.toJSON) { return xs == .Some(x) }; return Discard() },
		forAll { (x : JSONValue) in if let xs = UInt16.fromJSON(x).map(UInt16.toJSON) { return xs == .Some(x) }; return Discard() },
		forAll { (x : JSONValue) in if let xs = UInt32.fromJSON(x).map(UInt32.toJSON) { return xs == .Some(x) }; return Discard() },
		forAll { (x : JSONValue) in if let xs = UInt64.fromJSON(x).map(UInt64.toJSON) { return xs == .Some(x) }; return Discard() },
		forAll { (x : JSONValue) in if let xs = Float.fromJSON(x).map(Float.toJSON) { return xs == .Some(x) }; return Discard() },
		forAll { (x : JSONValue) in if let xs = Double.fromJSON(x).map(Double.toJSON) { return xs == .Some(x) }; return Discard() },

		forAll { (x : String) in String.fromJSON(String.toJSON(x))! ==== x },
		forAll { (x : Bool) in Bool.fromJSON(Bool.toJSON(x))! ==== x },
		forAll { (x : Int) in Int.fromJSON(Int.toJSON(x))! ==== x },
		forAll { (x : Int8) in Int8.fromJSON(Int8.toJSON(x))! ==== x },
		forAll { (x : Int16) in Int16.fromJSON(Int16.toJSON(x))! ==== x },
		forAll { (x : Int32) in Int32.fromJSON(Int32.toJSON(x))! ==== x },
		forAll { (x : Int64) in Int64.fromJSON(Int64.toJSON(x))! ==== x },
		forAll { (x : UInt) in UInt.fromJSON(UInt.toJSON(x))! ==== x },
		forAll { (x : UInt8) in UInt8.fromJSON(UInt8.toJSON(x))! ==== x },
		forAll { (x : UInt16) in UInt16.fromJSON(UInt16.toJSON(x))! ==== x },
		forAll { (x : UInt32) in UInt32.fromJSON(UInt32.toJSON(x))! ==== x },
		forAll { (x : UInt64) in UInt64.fromJSON(UInt64.toJSON(x))! ==== x },
		forAll { (x : Double) in Double.fromJSON(Double.toJSON(x))! ==== x },
		forAll { (x : Float) in Float.fromJSON(Float.toJSON(x))! ==== x },
	]

	func testProperties() {
		self.frequentFliers.forEach { property("Round trip behaves") <- $0 }
	}

	func testDataJSON() {
		let js = "[1,\"foo\"]"
		let lhs = JSONValue.decode(js)
		let rhs : JSONValue = .JSONArray([.JSONNumber(1), .JSONString("foo")])
		XCTAssertTrue(lhs != nil)
		XCTAssert(lhs! == rhs)
		XCTAssert(rhs.encode() == js.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))

		// user example
		let id: UInt64 = 103622342330925644
		let userjs = "{\"id\": \(id), \"name\": \"max\", \"age\": 10, \"tweets\": [\"hello\"], \"attrs\": {\"one\": \"1\"}, \"balance\": 235.13, \"admin\": false}"
		let user : User? = JSONValue.decode(userjs) >>- User.fromJSON
		XCTAssert(user! == User(id, "max", 10, ["hello"], "1", 235.13, false))
		XCTAssert(user!.id == id)
		
		// not a user, missing age
		let notuserjs = "{\"name\": \"max\", \"tweets\": [\"hello\"], \"attrs\": {\"one\": \"1\"}}"
		let notUser : User? = JSONValue.decode(notuserjs) >>- User.fromJSON
		XCTAssertTrue(notUser == nil)
	}

	func testInvalidDataJSON() {
		let js : NSData? = "[1,foo\"]".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
		let json : JSONValue? = js >>- JSONValue.decode
		XCTAssertFalse(json != nil)
	}

	func testJSONKeypath() {
		let keypath : JSONKeypath = "this" <> "is" <> "a" <> "deeply" <> "nested" <> "bit" <> "of" <> "json" <> "mkay"
		let path = ["this", "is", "a", "deeply", "nested", "bit", "of", "json", "mkay"]

		XCTAssertTrue(keypath.path == path, "Expected keypath and path to match")
		XCTAssertTrue((JSONKeypath.mempty <> keypath).path == keypath.path, "Expected left identity to hold")
		XCTAssertTrue((keypath <> JSONKeypath.mempty).path == keypath.path, "Expected right identity to hold")
	}
}
