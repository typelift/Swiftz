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
    let b = Shape.Plane(wingspan: 2)
    let b2 = Shape.fromRep(b.toRep())
    XCTAssert(b == b2!)
    
    // not sure why you would use SYB at the moment...
    // without some kind of extendable generic dispatch, it isn't very useful.
    func gJSON(d: Data) -> JSValue {
      var r = Dictionary<String, JSValue>()
      for (n, vs) in d.vals {
        switch vs {
        case let x as Int: r[n] = JSValue.JSNumber(Double(x))
        case let x as String: r[n] = JSValue.JSString(x)
        case let x as Bool: r[n] = JSValue.JSBool(x)
        case let x as Double: r[n] = JSValue.JSNumber(x)
        default: r[n] = JSValue.JSNull()
        }
      }
      return .JSObject(r)
    }
    
    XCTAssert(gJSON(b.toRep()) == .JSObject(["wingspan" : .JSNumber(2)]))
  }
}
