//
//  StateSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 2/27/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz

class StateSpec : XCTestCase {
	func testStateConversion() {
		let ixState : IxState<String, String, Int> = pure(5)
		let state : State<String, Int> = State.pure(5)
		
		XCTAssertTrue(ixState.eval("") == state.eval(""), "Expected state monads to have the same value")
		XCTAssertTrue(ixState.toState(identity).eval("") == state.eval(""), "Expected conversion to succeed")
		XCTAssertTrue(state.toIndexedState().eval("") == ixState.eval(""), "Expected conversion to succeed")
	}
}
