//
//  ReaderSpec.swift
//  Swiftz
//
//  Created by Matthew Purland on 11/25/15.
//  Copyright © 2015-2016 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

class ReaderSpec : XCTestCase {
    func testReader() {
        func addOne() -> Reader<Int, Int> {
			return asks { $0 + 1 }
        }
        
        func hello() -> Reader<String, String> {
            return asks { "Hello \($0)" }
        }
        
        func bye() -> Reader<String, String> {
            return asks { "Goodbye \($0)!" }
        }

        func helloAndGoodbye() -> Reader<String, String> {
            return asks { hello().runReader($0) + " and " + bye().runReader($0) }
        }
        
        XCTAssert(addOne().runReader(1) == 2)
        
        let input = "Matthew"
        let helloReader = hello()
        let modifiedHelloReader = helloReader.local({ "\($0) - Local"})
        XCTAssert(helloReader.runReader(input) == "Hello \(input)")
        XCTAssert(modifiedHelloReader.runReader(input) == "Hello \(input) - Local")
        
        let byeReader = bye()
        let modifiedByeReader = byeReader.local({ $0 + " - Local" })
        XCTAssert(byeReader.runReader(input) == "Goodbye \(input)!")
        XCTAssert(modifiedByeReader.runReader(input) == "Goodbye \(input) - Local!")
        
        let result = hello() >>- { $0.runReader(input) }
        XCTAssert(result == "Hello \(input)")
        
        let result2 = bye().runReader(input)
        XCTAssert(result2 == "Goodbye \(input)!")
        
        let helloAndGoodbyeReader = helloAndGoodbye()
        XCTAssert(helloAndGoodbyeReader.runReader(input) == "Hello \(input) and Goodbye \(input)!")
        
        let lengthResult = runReader(reader { (environment: String) -> Int in
            return environment.lengthOfBytes(using: String.Encoding.utf8)
        })("Banana")
        XCTAssert(lengthResult == 6)
        
        let length : (String) -> Int = { $0.lengthOfBytes(using: String.Encoding.utf8) }
        
        let lengthResult2 = runReader(reader(length))("Banana")
        XCTAssert(lengthResult2 == 6)
    
        // Ask        
        let lengthResult3 = (reader { 1234 } >>- runReader)?()
        XCTAssert(lengthResult3 == 1234)
        
        let lengthResult4 = hello() >>- runReader
        XCTAssert(lengthResult4?("Matthew") == "Hello Matthew")
        
        // Asks
        let lengthResult5 = runReader(asks(length))("Banana")
        XCTAssert(lengthResult5 == 6)
        
        let lengthReader = runReader(reader(asks))(length)
        let lengthResult6 = lengthReader.runReader("Banana")
        XCTAssert(lengthResult6 == 6)
        
        // >>-
        let lengthResult7 = (asks(length) >>- runReader)?("abc")
        XCTAssert(lengthResult7 == .some(3))
    }
}
