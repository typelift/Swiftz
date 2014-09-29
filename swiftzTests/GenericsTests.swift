//
//  GenericsTests.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import swiftz

class GenericsTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testGenericsSYB() {
    let b = Shape.Plane(2)
    let b2 = Shape.fromRep(b.toRep())
    XCTAssert(b == b2!)

    // not sure why you would use SYB at the moment...
    // without some kind of extendable generic dispatch, it isn't very useful.
    let gJSON:Data -> JSONValue = {(d: Data) -> JSONValue in
        var r = Dictionary<String, JSONValue>()
        for (n, vs) in d.vals {
            switch vs {
            case let x as Int: r[n] = JSONValue.JSONNumber(Double(x))
            case let x as String: r[n] = JSONValue.JSONString(x)
            case let x as Bool: r[n] = JSONValue.JSONBool(x)
            case let x as Double: r[n] = JSONValue.JSONNumber(x)
            default: r[n] = JSONValue.JSONNull()
            }
        }
        return .JSONObject(r)
    }
    
      

    XCTAssert(gJSON(b.toRep()) == .JSONObject(["wingspan" : .JSONNumber(2)]))
  }
}
