//
//  HListSpec.swift
//  swiftz
//
//  Created by Robert Widmann on 1/19/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz

class HListSpec : XCTestCase {
	func testHList() {
		typealias AList = HCons<Int, HCons<String, HNil>>
		typealias BList = HCons<Bool, HNil>

		let list1 : AList = HCons(h: 10, t: HCons(h: "banana", t: HNil()))
		let list2 : BList = HCons(h: false, t: HNil())

		XCTAssert(list1.head == 10)
		XCTAssert(list1.tail.head == "banana")
		XCTAssert(AList.length == 2)

		XCTAssert(list2.head == false)
		XCTAssert(BList.length == 1)

		typealias Zero = HAppend<HNil, AList, AList>
		typealias One = HAppend<BList, AList, HCons<Bool, HCons<Int, HCons<String, HNil>>>>

		typealias FList = HCons<Int -> Int, HCons<Int -> Int, HCons<Int -> Int, HNil>>>
		typealias FComp = HMap<(), (Int -> Int, Int -> Int), Int -> Int>
		typealias FBegin = HFold<(), Int -> Int, FList, Int -> Int>
		typealias FEnd = HFold<(), Int -> Int, HNil, Int -> Int>

		let listf : FList = HCons(h: +10, t: HCons(h: %5, t: HCons(h: *3, t: HNil())))
		let comp : FComp = HMap<(), (), ()>.compose()
		let foldEnd : FEnd = HFold<(), (), (), ()>.makeFold()
		let fullFold = FBegin.makeFold(comp, h: HFold<(), (), (), ()>.makeFold(comp, h: HFold<(), (), (), ()>.makeFold(comp, h: foldEnd)))
		XCTAssert(fullFold.fold((), identity, listf)(5) == 0)
	}
}
