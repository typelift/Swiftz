//
//  DictionaryExtSpec.swift
//  Swiftz
//
//  Created by Matthew Purland on 11/22/15.
//  Copyright © 2015-2016 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

class DictionaryExtSpec : XCTestCase {
    func testProperties() {
		/*
		property("Round-tripping") <- forAll { (xs : [Int]) in
			let ll = Set(xs).sorted()
			// let rr = Dictionary(zip(xs, Array<Swiftz.Unit>(repeating: .TT, count: xs.count))).map(fst).sort()
			let rr = Dictionary<Int, Swiftz.Unit>(zip(xs, Array<Swiftz.Unit>(repeating: .TT, count: 50))).map(fst).sorted()
			return ll == rr
		}
		*/
		property("Alter changes sizes appropriately") <- forAllNoShrink(Dictionary<Int, Swiftz.Unit>.arbitrary) { (t : Dictionary<Int, Swiftz.Unit>) in
			return forAll { (k : Int) in
				let t2 = t.alter(k, alteration: { o in
					switch o {
					case .none:
						return .some(.TT)
					case .some(_):
						return .none
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
