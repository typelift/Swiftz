//
//  swiftzTests.swift
//  swiftzTests
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import swiftz

// A user example
// an example of why we need SYB, Generics or macros
class User: JSONDecode {
  typealias J = User
  let name: String
  let age: Int
  let tweets: Array<String>
  let attrs: Dictionary<String, String>
  
  init(_ n: String, _ a: Int, _ t: Array<String>, _ r: Dictionary<String, String>) {
    name = n
    age = a
    tweets = t
    attrs = r
  }
  
  class func create(x: String) -> Int -> Array<String> -> Dictionary<String, String> -> User {
    return { (y: Int) in { (z: Array<String>) in { User(x, y, z, $0) } } }
  }
  
  class func fromJSON(x: JSValue) -> User? {
    var n: String?
    var a: Int?
    var t: Array<String>?
    var r: Dictionary<String, String>?
    switch x {
      case let .JSObject(d):
        n = d["name"]   >>= JString.fromJSON
        a = d["age"]    >>= JInt.fromJSON
        t = d["tweets"] >>= JArray<String, JString>.fromJSON
        r = d["attrs"]  >>= JDictionary<String, JString>.fromJSON
        return (User.create <^> n <*> a <*> t <*> r)
      default:
        return .None
    }
  }
}


func ==(lhs: User, rhs: User) -> Bool {
  return lhs.name == rhs.name && lhs.age == rhs.age && lhs.tweets == rhs.tweets && lhs.attrs == rhs.attrs
}

// shape example for SYB
enum Shape : Dataable {
  case Boat
  case Plane(wingspan: Int)
  
  static func typeRep() -> Any.Type {
    return reflect(self).valueType
  }
  
  static func fromRep(r: Data) -> Shape? {
    switch (r.con, r.vals) {
    case let (0, xs):
      return Boat
    case let (1, xs):
      let x1 = ind(xs, 0)
      let x2 = x1 >>= { $1 as? Int }
      return { Plane(wingspan: $0) } <^> x2
    default:
      return .None
    }
  }
  
  func toRep() -> Data {
    switch self {
      case .Boat: return Data(con: 0, vals: [])
      case let .Plane(w): return Data(con: 1, vals: [("wingspan", w)])
    }
  }
}

func ==(lhs: Shape, rhs: Shape) -> Bool {
  switch lhs {
    case .Boat: switch rhs {
      case .Boat: return true
      case let .Plane(q): return false
    }
    case let .Plane(w): switch rhs {
      case let .Plane(q): return w == q
      case let .Boat: return false
    }
  }
}

class swiftzTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testConcurrentFuture() {
    var e: NSError?
    let x: Future<Int> = Future(exec: gcdExecutionContext, {
      usleep(1)
      return 4
    })
    XCTAssert(x.result() == x.result(), "future")
    XCTAssert(x.map({ $0.description }).result() == "4", "future map")
    XCTAssert(x.flatMap({ (x: Int) -> Future<Int> in
      return Future(exec: gcdExecutionContext, { usleep(1); return x + 1 })
    }).result() == 5, "future flatMap")
    
    //    let x: Future<Int> = Future(exec: gcdExecutionContext, {
    //      return NSString.stringWithContentsOfURL(NSURL.URLWithString("http://github.com"), encoding: 0, error: nil)
    //    })
    //    let x1 = (x.result().lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    //    let x2 = (x.result().lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    //    XCTAssert(x1 == x2)
  }
  
  func testConcurrentChan() {
    var chan: Chan<Int> = Chan()
    let ft = Future<Int>(exec: gcdExecutionContext, { usleep(1); chan.write(2); return 2 })
    XCTAssert(chan.read() == ft.result(), "simple read chan")
  }
  
  func testConcurrentMVar() {
    var mvar: MVar<String> = MVar()
    let ft = Future<Void>(exec: gcdExecutionContext, { mvar.put("hello"); mvar.put("max") })
    XCTAssert(mvar.isEmpty(), "mvar is full")
    XCTAssert(mvar.take() == "hello", "mvar read")
    XCTAssert(mvar.take() == "max", "mvar read")
    XCTAssert(mvar.isEmpty(), "mvar empty")
  }
  
  func testControlBase() {
    let x = 1
    let y = 2
    XCTAssert(identity(x) == x, "identity")
    XCTAssert(curry({ (ab: (Int, Int)) -> Int in switch ab {
      case let (l, r): return (l + r)
    }}, x, y) == 3, "curry")
    XCTAssert(uncurry({
      (a: Int) -> Int -> Int in
      return ({(b: Int) -> Int in
        return (a + b)
      })
    }, (x, y)) == 3, "uncurry")
    
    XCTAssert((x |> {(a: Int) -> String in return a.description}) == "1", "thrush")
//    XCTAssert((x <| {(a: Int) -> String in return a.description}) == 1, "thrush")
    
    
    let xs = [1, 2, 3]
    func fs(x: Int) -> Array<Int> {
      return [x, x+1, x+2]
    }
    let rs = xs >>= fs
    XCTAssert(rs == [1, 2, 3, 2, 3, 4, 3, 4, 5])
  }
  
  func testThrush() {
    let x = 1 |> ({$0.advancedBy($0)}) |> ({$0.advancedBy($0)}) |> ({$0 * $0})
    XCTAssertTrue(x == 16, "Should equal 16")
  }
  
  func testDataEither() {
    func divTwoEvenly(x: Int) -> Either<String, Int> {
      if x % 2 == 0 {
        return .Left({ "\(x) was div by 2" })
      } else {
        return .Right({ x / 2 })
      }
    }
    
    let start = 17
    let first: Either<String, Int> = divTwoEvenly(start)
    let prettyPrinted: Either<String, String> = { $0.description } <^> first
    let snd = first >>= divTwoEvenly
    XCTAssert(prettyPrinted == .Right({ "8" }))
    XCTAssert(snd == .Left({ "8 was div by 2" }))
  }
  
  func testDataJSON() {
    let js: NSData = "[1,\"foo\"]".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    let lhs: JSValue = JSValue.decode(js)
    let rhs: JSValue = .JSArray([.JSNumber(1), .JSString("foo")])
    XCTAssert(lhs == rhs)
    XCTAssert(rhs.encode() == js)
    
    // user example
    let userjs: NSData = "{\"name\": \"max\", \"age\": 10, \"tweets\": [\"hello\"], \"attrs\": {\"one\": \"1\"}}"
      .dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    let user: User? = JSValue.decode(userjs) >>= User.fromJSON
    XCTAssert(user! == User("max", 10, ["hello"], ["one": "1"]))
    
    // not a user, missing age
    let notuserjs: NSData = "{\"name\": \"max\", \"tweets\": [\"hello\"], \"attrs\": {\"one\": \"1\"}}".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    let notUser: User? = JSValue.decode(notuserjs) >>= User.fromJSON
    if notUser {
      XCTFail("expected none")
    }
  }
  
  func testDataSemigroup() {
    let xs = [1, 2, 0, 3, 4]
    XCTAssert(sconcat(Min(), 2, xs) == 0, "sconcat works")
  }
  
  func testDataMonoid() {
    let xs: Array<Int8> = [1, 2, 0, 3, 4]
    XCTAssert(mconcat(Sum    <Int8, NInt8>(i: { return nint8 }), xs) == 10, "monoid sum works")
    XCTAssert(mconcat(Product<Int8, NInt8>(i: { return nint8 }), xs) == 0, "monoid product works")
  }
  
//  func testDataList() {
//    let ls: List<Int> = .Nil()
//    println(ls)
//
//    XCTAssert(true, "Pass")
//  }
  
  func testDataOptionalExt() {
    let x = Optional.Some(4)
    func f(i: Int) -> Optional<Int> {
      if i % 2 == 0 {
        return .Some(i / 2)
      } else {
        return .None
      }
    }
    // rdar://17149404
    //    XCTAssert(x.flatMap(f) == .Some(2), "optional flatMap")
    //    maybe(...)
    //    XCTAssert(Optional.None.getOrElse(1) == 1, "optional getOrElse")
  }
  
  func testMaybeOptionalExt() {
    let x = Optional.Some(4)
    let y = Optional<Int>.None

    //XCTAssert(x.maybe(0, { x in x + 1}) == 4, "maybe for Some works")
    //XCTAssert(y.maybe(0, { x in x + 1}) == 0, "maybe for None works")
  }
  
  func testDataArrayExt() {
    // segfaults. rdar://17148872
//    let xsO: Array<Optional<Int>> = [Optional.Some(1), .Some(2), .None]
//    let exO: Array<Int> = mapFlatten(xsO)
//    XCTAssert(exO == [1, 2], "mapflatten option")
//    
//    let exJ = join([[1, 2], [3, 4]])
//    XCTAssert(exJ == [1, 2, 3, 4], "mapflatten option")
  }
  
  func testGenericsSYB() {
    let b = Shape.Plane(wingspan: 2)
    let b2 = Shape.fromRep(b.toRep()) // identity?
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
  
  func testTestingSwiftCheck() {
    func prop_reverseLen(xs: Array<Int>) {
      XCTAssert(xs.reverse().count == xs.count)
    }
    
    func prop_reverseReverse(xs: Array<Int>) {
      XCTAssert(xs.reverse().reverse() == xs)
    }
    
    swiftCheck(prop_reverseLen)
    swiftCheck(prop_reverseReverse)
    
    
    // test guards work (they don't)
    func prop_linesUnlines(xs: String) {
      // guard(xs.last == "\n") { // just to test guarding, it's a bad guard
      XCTAssert((xs.lines() |> String.unlines) == xs)
      // }
    }
    
    //    swiftCheck(prop_linesUnlines) // can't explain this one!
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    
    func term(ch: Chan<CDouble>, k: CDouble) -> Void {
      ch.write(4 * pow(-1, k) / (2 * k + 1))
    }
    
    func pi(n: Int) -> CDouble {
      let ch = Chan<CDouble>()
      for k in (0..n) {
        Future<Void>(exec: gcdExecutionContext, a: { return term(ch, CDouble(k)) })
      }
      var f = 0.0
      for k in (0..n) {
        f = f + ch.read()
      }
      return f
    }
    
    self.measureBlock() {
      pi(200)
      Void()
    }
  }
}
