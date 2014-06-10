//
//  SetTests.swift
//  swiftz
//
//  Created by Terry Lewis II on 6/7/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import swiftz
class SetTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testInit() {
        let set = Set(array:[1,2,3,4,4,4,5,5,5])
        XCTAssert(set.count == 5, "Should be 5 items")
        
        let newSet = Set(items: 1,2,3,4,4,4,5,5,5)
        XCTAssert(set.count == 5, "Should be 5 items")
    }
    
    func testEquality() {
        var set1 = Set(array:[1,2,3,4,4,4,5,5,5])
        var set2 = Set(array:[1,2,3,4,4,4,5,5,5])
        XCTAssert(set1 == set2, "Should be equal")
        
        var set3 = Set(array:[1,2,5,5,5])
        XCTAssert(set1 != set3, "Not equal")
    }
    
    func testIterator() {
        let set = Set(array:[1,2,3,4,4,4,5,5,5])
        var iterations = 0
        for x in set {
            iterations++
        }
        XCTAssert(iterations == set.count, "should be equal")
    }
    
    func testAny() {
        let set = Set(array:[1,2,3,4,4,4,5,5,5])
        for i in 0...3000 {
            var any = set.any()!
            XCTAssert(any >= 1 && any <= 5, "should always be in range")
        }
        let setEmpty = Set<Int>()
        XCTAssert(setEmpty.any() == nil, "should return nil on empty")
    }
    
    func testUnion() {
        let set = Set(array: [1,2,3,4,5,5,4,4,5,5])
        let otherSet = Set(items: 6,7,8,9,10,10,1000,5600)
        
        let newSet = set.union(otherSet)
        XCTAssert(newSet == Set(items: 1000, 5600, 6,7,8,9,10,1,2,3,4,5), "Should be equal")
        
    }
    
    func testFilterMap() {
        let set = Set(array: [1,2,3,4,5,5,4,4,5,5])
        let newSet = set.filter{$0 > 2}.map{$0 + 1}
        XCTAssert(newSet == Set(array: [4,5,6]), "Should be equal")
    }
    
    func testIntersectsSet() {
        let set = Set(array: [1,2,3,4,5,5,4,4,5,5])
        XCTAssert(set.interectsSet(Set(items: 9,0,5)), "Should be true")
    }
    
    func testMember() {
        let set = Set(array: [1,2,3,4,5,5,4,4,5,5])
        let known = set.member(4)
        let unknown = set.member(45765)
        
        XCTAssert(known == Optional.Some(4), "Should be equal")
        XCTAssert(unknown == nil, "Should be nil")
    }
    
    func testMinus() {
        let set = Set(array: [1,2,3,4,5,5,4,4,5,5])
        let minus = set.minus(Set(items: 8,9,0,3,5))
        
        XCTAssert(minus == Set(items: 1,2,4), "Should be equal")
    }
    
    func testIntersect() {
        let set = Set(array: [1,2,3,4,5,5,4,4,5,5])
        let intersection = set.intersect(Set(items: 8,9,0,3,5))
        
        XCTAssert(intersection == Set(items: 3,5), "Should be equal")
    }
}
