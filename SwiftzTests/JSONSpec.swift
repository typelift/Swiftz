//
//  JSONSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz

class JSONSpec : XCTestCase {
	func testDataJSON() {
		let js = "[1,\"foo\"]"
		let lhs = JSONValue.decode(js)
		let rhs : JSONValue = .JSONArray([.JSONNumber(1), .JSONString("foo")])
		XCTAssertTrue(lhs != nil)
		XCTAssert(lhs! == rhs)
		XCTAssert(rhs.encode() == js.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))

		// user example
		let userjs = "{\"name\": \"max\", \"age\": 10, \"tweets\": [\"hello\"], \"attrs\": {\"one\": \"1\"}}"
		let user : User? = JSONValue.decode(userjs) >>- User.fromJSON
		XCTAssert(user! == User("max", 10, ["hello"], "1"))

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
		let JSON = "{\"this\":{\"is\":{\"a\":{\"deeply\":{\"nested\":{\"bit\":{\"of\":{\"json\":{\"mkay\":true}}}}}}}}}"
		let keypath : JSONKeypath = "this" <> "is" <> "a" <> "deeply" <> "nested" <> "bit" <> "of" <> "json" <> "mkay"
		let path = ["this", "is", "a", "deeply", "nested", "bit", "of", "json", "mkay"]
		
		XCTAssertTrue(keypath.path == path, "Expected keypath and path to match")
		XCTAssertTrue((JSONKeypath.mzero <> keypath).path == keypath.path, "Expected left identity to hold")
		XCTAssertTrue((keypath <> JSONKeypath.mzero).path == keypath.path, "Expected right identity to hold")
	}
}

struct Coordinate : JSONDecodable { 
	let x : Double
	let y : Double 
	
	static func create(x : Double) -> Double -> Coordinate {
		return { y in Coordinate(x: x, y: y) }
	}
	
	static func fromJSON(x: JSONValue) -> Coordinate? {
		return Coordinate.create	
			<^> x <! "map" <> "coordinates" <> "xPart" 
			<*> x <! "map" <> "coordinates" <> "yPart"
	}
}

extension JSONSpec {
	func testCoordinateDecode() {
		let JSON = "{ \"map\": { \"coordinates\": { \"xPart\": 1000.0, \"yPart\": 2.000 } } }"
		let badJSON = "{ \"map\": { \"coordinates\": { \"zPart\": \"0.0\", \"ePart\": \"10.0\" } } }"
		
		let coord = JSONValue.decode(JSON) >>- Coordinate.fromJSON
		XCTAssertTrue(coord != nil)
		XCTAssertTrue(coord?.x == 1000.0)
		XCTAssertTrue(coord?.y == 2.0)
		
		let badCoord = JSONValue.decode(badJSON) >>- Coordinate.fromJSON
		XCTAssertTrue(badCoord == nil)
	}
}
