//
//  HListSpec.swift
//  Swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015-2016 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

#if SWIFT_PACKAGE
	import Operadics
	import Swiftx
#endif

class HListSpec : XCTestCase {
	func testHList() {
		typealias AList = HCons<Int, HCons<String, HNil>>
		typealias BList = HCons<Bool, HNil>

		property("The attributes of an HList are statically known") <- forAll { (x : Bool) in
			let list : BList = HCons(false, HNil())
			return (list.head == false) ^&&^ (BList.length == 1)
		}

		property("The attributes of an HList are statically known") <- forAll { (x : Int, s : String) in
			let list : AList = HCons(x, HCons(s, HNil()))
			return (list.head == x) ^&&^ (list.tail.head == s) ^&&^ (AList.length == 2)
		}

		typealias Zero = HAppend<HNil, AList, AList>
		typealias One = HAppend<BList, AList, HCons<Bool, HCons<Int, HCons<String, HNil>>>>

		typealias FList = HCons<(Int) -> Int, HCons<(Int) -> Int, HCons<(Int) -> Int, HNil>>>
		typealias FComp = HMap<(), ((Int) -> Int, (Int) -> Int), (Int) -> Int>
		typealias FBegin = HFold<(), (Int) -> Int, FList, (Int) -> Int>
		typealias FEnd = HFold<(), (Int) -> Int, HNil, (Int) -> Int>

		property("A static fold can be modelled by a dynamic one") <- forAll { (_ f : ArrowOf<Int, Int>, g : ArrowOf<Int, Int>, h : ArrowOf<Int, Int>) in
			let listf : FList = HCons(f.getArrow, HCons(g.getArrow, HCons(h.getArrow, HNil())))
			let comp : FComp = HMap<(), (), ()>.compose()
			let foldEnd : FEnd = HFold<(), (), (), ()>.makeFold()
			let fullFold = FBegin.makeFold(comp, HFold<(), (), (), ()>.makeFold(comp, HFold<(), (), (), ()>.makeFold(comp, foldEnd)))
			return forAll { (x : Int) in
				return fullFold.fold((), identity, listf)(x) == [f.getArrow, g.getArrow, h.getArrow].reversed().reduce(identity, •)(x)
			}
		}
	}

	#if !(os(macOS) || os(iOS) || os(watchOS) || os(tvOS))
	static var allTests = testCase([
		("testHList", testHList),
	])
	#endif
}
