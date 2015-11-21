//
//  ShapeExample.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import Swiftz

// shape example for SYB
enum Shape : Dataable {
	case Boat
	case Plane(Int)

	static func typeRep() -> Any.Type {
		return Mirror(reflecting: self).subjectType
	}

	static func fromRep(r: Data) -> Shape? {
		switch (r.con, r.vals) {
		case (0, _):
			return Boat
		case let (1, xs):
			let x1 = xs.safeIndex(0)
			let x2 = x1 >>- { $1 as? Int }
			return Plane <^> x2
		default:
			return .None
		}
	}

	func toRep() -> Data {
		switch self {
		case .Boat:
			return Data(con: 0, vals: [])
		case let .Plane(w):
			return Data(con: 1, vals: [("wingspan", w)])
		}
	}
}

func ==(lhs: Shape, rhs: Shape) -> Bool {
	switch (lhs, rhs) {
	case (.Boat, .Boat):
		return true
	case let (.Plane(q), .Plane(w)) where w == q:
		return true
	default:
		return false
	}
}

class GenericsSpec : XCTestCase {
	func testGenericsSYB() {
		let b = Shape.Plane(2)
		let b2 = Shape.fromRep(b.toRep())
		XCTAssert(b == b2!)
	}
}
