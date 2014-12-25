//
//  ShapeExample.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import swiftz

// shape example for SYB
enum Shape : Dataable {
	case Boat
	case Plane(Int)
	
	static func typeRep() -> Any.Type {
		return reflect(self).valueType
	}
	
	static func fromRep(r: Data) -> Shape? {
		switch (r.con, r.vals) {
		case let (0, xs):
			return Boat
		case let (1, xs):
			let x1 = indexArray(xs, 0)
			let x2 = x1 >>- { $1 as? Int }
			return { Plane($0) } <^> x2
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
