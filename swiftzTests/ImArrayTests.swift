//
//  ImArrayTests.swift
//  swiftz
//
//  Created by Terry Lewis II on 6/9/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
#if TARGET_OS_MAC
import swiftz
#else
import swiftz_ios
#endif

class ImArrayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testImArrayInit() {
        let withArray = ImArray(array: [1,2,3,4,5])
        let withItems = ImArray(items: 1,2,3,4,5)
        
        XCTAssert(withArray == withItems, "Should be equal")
        
        let single = ImArray(item: 1)
        XCTAssert(single.count == 1, "Should be 1")
    }
    
    func testJoin() {
        let withArray = ImArray(array: [1,2,3,4,5])
        let joined = withArray.join([6,7,8])
        XCTAssert(joined == ImArray(items: 1,2,3,4,5,6,7,8), "Should be equal")
        XCTAssert(withArray == ImArray(items: 1,2,3,4,5), "Should be equal(immutablility test)")
    }
    
    func testAppend() {
        let withArray = ImArray(array: [1,2,3,4,5])
        let joined = withArray += 6
        XCTAssert(joined == ImArray(items: 1,2,3,4,5,6), "Should be equal")
        XCTAssert(withArray == ImArray(items: 1,2,3,4,5), "Should be equal(immutablility test)")
    }
    
    func testSort() {
        let withArray = ImArray(array: [0,5,1000,-45, 10,1])
        let sorted = withArray.sort(<)
        
        XCTAssert(sorted == ImArray(items: -45,0,1,5,10,1000), "Should be equal")
        XCTAssert(withArray == ImArray(array: [0,5,1000,-45, 10,1]), "Should be equal(immutablility test)")
    }
    
    func testScanl() {
        let withArray = ImArray(array: [1,2,3,4])
        let scanned = withArray.scanl(0, r:+)
        
        XCTAssert(scanned == ImArray(array: [0,1,3,6,10]), "Should be equal")
        XCTAssert(withArray == ImArray(array: [1,2,3,4]), "Should be equal(immutablility test)")
    }
    
    func testIntersperse() {
        let withArray = ImArray(array: [1,2,3,4])
        let inter = withArray.intersperse(1)
        
        XCTAssert(inter == ImArray(array: [1,1,2,1,3,1,4]), "Should be equal")
        XCTAssert(withArray == ImArray(array: [1,2,3,4]), "Should be equal(immutablility test)")
        
        let single = ImArray(item: 1)
        XCTAssert(single.intersperse(1) == ImArray(item: 1), "Should be equal")
    }
    
    func testFind() {
        let withArray = ImArray(array: [1,2,3,4])
        let f = {$0 == 4}
        if let found = withArray.find(f) {
            XCTAssert(found == 4, "Should be found")
        }
        
        XCTAssert(withArray.find{$0 == 1000000} == nil, "Should be nil(none)")
    }
    
    func testSplitAt() {
        let withArray = ImArray(array: [1,2,3,4])
        
        let tuple = withArray.splitAt(2)
        
        XCTAssert(tuple.0 == ImArray(items: 1,2) && tuple.1 == ImArray(items: 3,4), "Should be equal")
        
        XCTAssert(withArray.splitAt(0).0 == ImArray() && withArray.splitAt(0).1 == ImArray(items: 1,2,3,4), "Should be equal")
        XCTAssert(withArray == ImArray(array: [1,2,3,4]), "Should be equal(immutablility test)")
    }
  
    func testBuiltInArraySort() {
        var a = [3,2,1]
        var b = sort(a)
        // XCTAssert(a == [3,2,1], "Should be unalterred") // rdar://?? Currently fails (Swift bug)
        XCTAssert(a != [3,2,1], "Swift bug may be fixed. Update tests and workarounds")
        var c = [3,2,1]
        var d = sort(c.copy())
        XCTAssert(c == [3,2,1], "Should be unalterred")
        XCTAssert(d == [1,2,3], "Should be sorted")
        XCTAssert(b == [1,2,3], "Should be sorted")
    }
    
    func testImArraySort() {
        var a = ImArray(items: 3,2,1)
        var b = sort(a)
        XCTAssert(a == ImArray(items: 3,2,1), "Should be unalterred")
        XCTAssert(b == ImArray(items: 1,2,3), "Should be sorted")
    }
    
    func testImArraySortPred() {
        var a = ImArray(items: 1,2,3)
        var b = sort(a) { $0 > $1 }
        XCTAssert(a == ImArray(items: 1,2,3), "Should be unalterred")
        XCTAssert(b == ImArray(items: 3,2,1), "Should be sorted in reverse")
    }
}
