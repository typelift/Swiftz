//
//  JSONSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz

// MARK: - Test models
/// Person
struct Person {
	let name : String
	
	init(_ n : String) {
		name = n
	}
}

extension Person : JSONDecodable {
	static func fromJSON(x : JSONValue) -> Person? {
		return Person.init <^> x <? "name"
	}
}

extension Person : Equatable {}

func ==(lhs : Person, rhs : Person) -> Bool {
	return lhs.name == rhs.name
}

/// UserPermission
struct UserPermission {
	let admin : Bool
}

extension UserPermission : JSONDecodable {
	static func fromJSON(x : JSONValue) -> UserPermission? {
		return UserPermission.init <^> x <? "admin"
	}
}

extension UserPermission : Equatable {}

func ==(lhs : UserPermission, rhs : UserPermission) -> Bool {
	return lhs.admin == rhs.admin
}

/// Coordinate
struct Coordinate {
	let x : Double
	let y : Double
}

extension Coordinate : JSONDecodable {
	static func fromJSON(x : JSONValue) -> Coordinate? {
		return curry(Coordinate.init)
			<^> x <? "map" <> "coordinates" <> "xPart"
			<*> x <? "map" <> "coordinates" <> "yPart"
	}
}

/// Rect
struct Rect {
	let origin : CGPoint
	let size : CGSize
}

func FloatToCGFloat(n : Float) -> CGFloat {
	return CGFloat(n)
}

extension Rect : JSONDecodable {
	static func fromJSON(x : JSONValue) -> Rect? {
		let pX : Float? = x <? "origin" <> "x"
		let pY : Float? = x <? "origin" <> "y"
		let pW : Float? = x <? "size" <> "width"
		let pH : Float? = x <? "size" <> "height"
		
		let p1 = pX.map(FloatToCGFloat)
		let p2 = pY.map(FloatToCGFloat)
		let p3 = pW.map(FloatToCGFloat)
		let p4 = pH.map(FloatToCGFloat)
		
		let p = curry(CGPointMake)
			<^> p1
			<*> p2
		
		let s = curry(CGSizeMake)
			<^> p3
			<*> p4
		
		return curry(Rect.init)
			<^> p
			<*> s
	}
}

/// NumberContainer
struct NumberContainer : JSONDecodable {
	let number : NSNumber
	
	static func fromJSON(x : JSONValue) -> NumberContainer? {
		return NumberContainer.init
			<^> x <? "number"
	}
}

/// IntContainer
struct IntContainer : JSONDecodable {
	let number : Int
	
	static func fromJSON(x : JSONValue) -> IntContainer? {
		return IntContainer.init
			<^> x <? "number"
	}
}

/// Int64Container
struct Int64Container : JSONDecodable {
	let number : Int64
	
	static func fromJSON(x : JSONValue) -> Int64Container? {
		return Int64Container.init
			<^> x <? "number"
	}
}

/// UInt64Container
struct UInt64Container : JSONDecodable {
	let number : UInt64
	
	static func fromJSON(x : JSONValue) -> UInt64Container? {
		return UInt64Container.init
			<^> x <? "number"
	}
}

class JSONSpec : XCTestCase {
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

/// Tests for JSON values
extension JSONSpec {
	func testString() {
		let js = "{\"name\": \"matthew\"}"
		let p = JSONValue.decode(js) >>- Person.fromJSON
		XCTAssert(p == Person("matthew"))
	}
	
	func testBool() {
		// Test for: false
		let js1 = "{\"admin\":false}"
		let up1 = JSONValue.decode(js1) >>- UserPermission.fromJSON
		XCTAssert(up1! == UserPermission(admin : false))
		
		// Test for: true
		let js2 = "{\"admin\":true}"
		let up2 = JSONValue.decode(js2) >>- UserPermission.fromJSON
		XCTAssert(up2! == UserPermission(admin : true))
		
		// Test for: 0
		let js3 = "{\"admin\":0}"
		let up3 = JSONValue.decode(js3) >>- UserPermission.fromJSON
		XCTAssert(up3! == UserPermission(admin : false))
		
		// Test for: 1
		let js4 = "{\"admin\":1}"
		let up4 = JSONValue.decode(js4) >>- UserPermission.fromJSON
		XCTAssert(up4! == UserPermission(admin : true))
	}
	
	func testDouble() {
		let js = "{ \"map\": { \"coordinates\": { \"xPart\": 1000.0, \"yPart\": 2.000 } } }"
		let coord = JSONValue.decode(js) >>- Coordinate.fromJSON
		XCTAssert(coord != nil)
		XCTAssert(coord?.x == 1000.0)
		XCTAssert(coord?.y == 2.0)
	}
	
	func testFloat() {
		let js = "{\"origin\":{\"x\":0.0,\"y\":10.5},\"size\":{\"width\":100,\"height\":20.20}}"
		let rect = JSONValue.decode(js) >>- Rect.fromJSON
		XCTAssert(rect != nil)
		XCTAssertTrue(CGPointEqualToPoint(rect!.origin, CGPointMake(0.0, 10.5)))
		XCTAssertEqualWithAccuracy(rect!.origin.x, 0.0, accuracy: 0.0)
		XCTAssertEqualWithAccuracy(rect!.origin.y, 10.5, accuracy: 0.0)
		XCTAssertEqualWithAccuracy(rect!.size.width, 100, accuracy: 0.0)
		XCTAssertEqualWithAccuracy(rect!.size.height, 20.20, accuracy: 0.01)
	}
	
	func testNSNumber() {
		let js = "{\"number\":100}"
		let n = JSONValue.decode(js) >>- NumberContainer.fromJSON
		XCTAssert(n != nil)
		XCTAssert(n?.number == 100)
		XCTAssert(n?.number == NSNumber(integer: 100))
		
		let js2 = "{\"number\":false}"
		let n2 = JSONValue.decode(js2) >>- NumberContainer.fromJSON
		XCTAssert(n2 != nil)
		XCTAssert(n2?.number == false)
		XCTAssert(n2?.number == NSNumber(bool: false))
		
		let js3 = "{\"number\":true}"
		let n3 = JSONValue.decode(js3) >>- NumberContainer.fromJSON
		XCTAssert(n3 != nil)
		XCTAssert(n3?.number == true)
		XCTAssert(n3?.number == NSNumber(bool: true))
		
		let js4 = "{\"number\":100.5}"
		let n4 = JSONValue.decode(js4) >>- NumberContainer.fromJSON
		XCTAssert(n4 != nil)
		XCTAssert(n4?.number == 100.5)
		XCTAssert(n4?.number == NSNumber(double: 100.5))
	}
	
	func testInt() {
		let js = "{\"number\":100}"
		let n = JSONValue.decode(js) >>- IntContainer.fromJSON
		XCTAssert(n != nil)
		XCTAssert(n?.number == 100)
		XCTAssert(n?.number == Int(100))
	}
	
	func testInt64() {
		let value = Int64.max
		let js = "{\"number\":\(value)}"
		let n = JSONValue.decode(js) >>- Int64Container.fromJSON
		XCTAssert(n != nil)
		XCTAssert(n?.number == value)
		XCTAssert(n?.number == Int64(value))
	}
	
	func testUInt64() {
		let value: UInt64 = 103622342330925644
		let js = "{\"number\":\(value)}"
		let n = JSONValue.decode(js) >>- UInt64Container.fromJSON
		XCTAssert(n != nil)
		XCTAssert(n?.number == value)
		XCTAssert(n?.number == UInt64(value))
		XCTAssert(n?.number == NSNumber(unsignedLongLong: value).unsignedLongLongValue)
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

struct TestObject: JSONDecodable {
	let required1: String
	let required2: String
	let optional1: Bool?
	let optional2: Bool?
	
	static func fromJSON(x : JSONValue) -> TestObject? {
		let p1: String? = x <? "required1"
		let p2: String? = x <? "required2"
		let p3: Bool?? = x <?? "optional1"
		let p4: Bool?? = x <?? "optional2"
		
		return curry(TestObject.init)
			<^> p1
			<*> p2
			<*> p3
			<*> p4
	}
}

extension JSONSpec {
	func testOptionalRetrieve() {
		let jsonWithOptionalValue1 = "{\"required1\":\"a\", \"required2\":\"b\",\"optional1\":false}"
		let jsonWithOptionalValue2 = "{\"required1\":\"a\", \"required2\":\"b\",\"optional2\":true}"
		let jsonWithOptionalValue3 = "{\"required1\":\"a\", \"required2\":\"b\",\"optional1\":true,\"optional2\":false}"
		let jsonWithoutOptionalValues = "{\"required1\":\"a\", \"required2\":\"b\"}"
		
		let testObject1 = JSONValue.decode(jsonWithOptionalValue1) >>- TestObject.fromJSON
		XCTAssertNotNil(testObject1)
		XCTAssert(testObject1!.required1 == "a")
		XCTAssert(testObject1!.required2 == "b")
		XCTAssert(testObject1!.optional1 == false)
		XCTAssert(testObject1!.optional2 == nil)
		
		let testObject2 = JSONValue.decode(jsonWithOptionalValue2) >>- TestObject.fromJSON
		XCTAssertNotNil(testObject2)
		XCTAssert(testObject2!.required1 == "a")
		XCTAssert(testObject2!.required2 == "b")
		XCTAssert(testObject2!.optional1 == nil)
		XCTAssert(testObject2!.optional2 == true)
		
		let testObject3 = JSONValue.decode(jsonWithOptionalValue3) >>- TestObject.fromJSON
		XCTAssertNotNil(testObject3)
		XCTAssert(testObject3!.required1 == "a")
		XCTAssert(testObject3!.required2 == "b")
		XCTAssert(testObject3!.optional1 == true)
		XCTAssert(testObject3!.optional2 == false)
		
		let testObject4 = JSONValue.decode(jsonWithoutOptionalValues) >>- TestObject.fromJSON
		XCTAssertNotNil(testObject4)
		XCTAssert(testObject4!.required1 == "a")
		XCTAssert(testObject4!.required2 == "b")
		XCTAssert(testObject4!.optional1 == nil)
		XCTAssert(testObject4!.optional2 == nil)
	}
}
