//
//  DictionaryExtSpec.swift
//  Swiftz
//
//  Created by Matthew Purland on 11/22/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

import XCTest
import Swiftz
import SwiftCheck

class DictionaryExtSpec : XCTestCase {
    func testProperties() {
        property("Dictionary init maps key-value pairs from a sequence of that type") <- forAll { (xs : [Int]) in
            return forAll { (f : ArrowOf<Int, String>) in
                let pairs: [(String, Int)] = xs.map { (f.getArrow($0), $0) }
                let dictionary = Dictionary<String, Int>(pairs)
                return xs.all { dictionary[f.getArrow($0)] == $0 }
            }
        }
    }
}