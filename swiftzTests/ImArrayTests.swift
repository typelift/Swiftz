//
//  ImArrayTests.swift
//  swiftz
//
//  Created by Terry Lewis II on 6/9/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import swiftz
class ImArrayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
//    func testScanl() {
//        let withArray = Array( [1,2,3,4])
//        let scanned = withArray.scanl(0, r:+)
//        
//        XCTAssert(scanned == Array([0,1,3,6,10]), "Should be equal")
//        XCTAssert(withArray == Array([1,2,3,4]), "Should be equal(immutablility test)")
//    }
//    
//    func testIntersperse() {
//        let withArray = Array([1,2,3,4])
//        let inter = withArray.intersperse(1)
//        
//        XCTAssert(inter == Array([1,1,2,1,3,1,4]), "Should be equal")
//        XCTAssert(withArray == Array([1,2,3,4]), "Should be equal(immutablility test)")
//        
//        let single = Array([1])
//        XCTAssert(single.intersperse(1) == Array([1]), "Should be equal")
//    }
//    
//    func testFind() {
//        let withArray = Array([1,2,3,4])
//        let f = {$0 == 4}
//        if let found = withArray.find(f) {
//            XCTAssert(found == 4, "Should be found")
//        }
//        
//        XCTAssert(withArray.find{$0 == 1000000} == nil, "Should be nil(none)")
//    }
//    
//    func testSplitAt() {
//        let withArray = Array([1,2,3,4])
//        
//        let tuple = withArray.splitAt(2)
//        
//        XCTAssert(tuple.0 == Array([1,2]) && tuple.1 == Array([3,4]), "Should be equal")
//        
//        XCTAssert(withArray.splitAt(0).0 == Array() && withArray.splitAt(0).1 == Array([1,2,3,4]), "Should be equal")
//        XCTAssert(withArray == Array([1,2,3,4]), "Should be equal(immutablility test)")
//    }
//    
}
