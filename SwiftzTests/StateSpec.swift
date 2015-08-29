//
//  StateSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 2/27/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

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
}
