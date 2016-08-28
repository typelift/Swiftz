//
//  DictionaryExtSpec.swift
//  Swiftz
//
//  Created by Matthew Purland on 11/22/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

class DictionaryExtSpec : XCTestCase {
    func testProperties() {
		property("Round-tripping") <- forAll { (xs : [Int]) in
			let ll = Set(xs).sort()
			let rr = Dictionary(zip(xs, [Unit](count: xs.count, repeatedValue: .TT))).map(fst).sort()
			return ll == rr
		}

		property("Alter changes sizes appropriately") <- forAllNoShrink(Dictionary<Int, Unit>.arbitrary) { (t : Dictionary<Int, Unit>) in
			return forAll { (k : Int) in
				let t2 = t.alter(k, alteration: { o in
					switch o {
					case .None:
						return .Some(.TT)
					case .Some(_):
						return .None
					}
				})
				if let _ = t[k] {
					return (t.count - 1 == t2.count) ^&&^ (t2[k] == nil)
				} else {
					return (t.count + 1 == t2.count) ^&&^ (t2[k] != nil)
				}
			}
		}


    }
}
