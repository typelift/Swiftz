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
		let js : NSData? = "[1,\"foo\"]".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
		let lhs : JSONValue? = js >>- JSONValue.decode
		let rhs : JSONValue = .JSONArray([.JSONNumber(1), .JSONString("foo")])
		XCTAssertTrue(lhs != nil)
		XCTAssert(lhs! == rhs)
		XCTAssert(rhs.encode() == js)

		// user example
		let userjs : NSData? = "{\"name\": \"max\", \"age\": 10, \"tweets\": [\"hello\"], \"attrs\": {\"one\": \"1\"}}"
			.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
		let user : User? = userjs >>- JSONValue.decode >>- User.fromJSON
		XCTAssert(user! == User("max", 10, ["hello"], "1"))

		// not a user, missing age
		let notuserjs : NSData? = "{\"name\": \"max\", \"tweets\": [\"hello\"], \"attrs\": {\"one\": \"1\"}}"
			.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
		let notUser : User? = notuserjs >>- JSONValue.decode >>- User.fromJSON
		if (notUser != nil) {
			XCTFail("expected none")
		}
	}

	func testInvalidDataJSON() {
		let js : NSData? = "[1,foo\"]".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
		let json : JSONValue? = js >>- JSONValue.decode
		XCTAssertFalse(json != nil)
	}
}

struct Coordinate : JSONDecodable { 
	let x : Double
	let y : Double 
	
	static func create(x : Double) -> Double -> Coordinate {
		return { y in Coordinate(x: x, y: y) }
	}
	
	static func fromJSON(x: JSONValue) -> Coordinate? {
		return Coordinate.create	<^> x <! "map" <> "coordinates" <> "xPart" 
									<*> x <! "map" <> "coordinates" <> "yPart"
	}
}

extension JSONSpec {
	func testCoordinateDecode() {
		let JSON = "{ \"map\": { \"coordinates\": { \"xPart\": 1000.0, \"yPart\": 2.000 } } }"
			.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
		let badJSON = "{ \"map\": { \"coordinates\": { \"zPart\": \"0.0\", \"ePart\": \"10.0\" } } }"
			.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
		
		let coord = JSON >>- JSONValue.decode >>- Coordinate.fromJSON
		XCTAssertTrue(coord != nil)
		XCTAssertTrue(coord?.x == 1000.0)
		XCTAssertTrue(coord?.y == 2.0)
		
		let badCoord = badJSON >>- JSONValue.decode >>- Coordinate.fromJSON
		XCTAssertTrue(badCoord == nil)
	}
}
