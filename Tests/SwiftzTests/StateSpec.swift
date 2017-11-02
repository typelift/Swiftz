//
//  StateSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 2/27/15.
//  Copyright (c) 2015-2016 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

#if SWIFT_PACKAGE
    import Operadics
    import Swiftx
#endif

struct StateOf<S, A : Arbitrary> : Arbitrary, CustomStringConvertible {
	let getState : State<S, A>

	init(_ state : State<S, A>) {
		self.getState = state
	}

	var description : String {
		return "\(self.getState)"
	}

	static var arbitrary : Gen<StateOf<S, A>> {
		fatalError()
	}
}

class StateSpec : XCTestCase {
	func testProperties() {
		property("sequence occurs in order") <- forAll { (xs : [String]) in
			let seq = sequence(xs.map(State<String, String>.pure))
			return forAllNoShrink(Gen<State<String, [String]>>.pure(seq)) { ss in
				return ss.eval("") == xs
			}
		}
	}

	#if !(os(macOS) || os(iOS) || os(watchOS) || os(tvOS))
	static var allTests = testCase([
		("testProperties", testProperties)
	])
	#endif
}

