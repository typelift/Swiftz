//
//  UserExample.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation
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
  
  // JSON
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
      // alternatively, if n && a && t... { return User(n!, a!, ...
      return (User.create <^> n <*> a <*> t <*> r)
    default:
      return .None
    }
  }
  
  // lens example
  class func luserName() -> Lens<User, String>.LensConst {
    return { (fn: (String -> Const<String, User>)) -> User -> Const<String, User> in
      return { (a: User) -> Const<String, User> in
        return fn(a.name)
      }
    }
  }
  
  class func luserName() -> Lens<User, String>.LensId {
    return { (fn: (String -> Id<String>)) -> User -> Id<User> in
      return { (a: User) -> Id<User> in
        return Id<User>(User(fn(a.name).runId(), a.age, a.tweets, a.attrs))
      }
    }
  }
}

func ==(lhs: User, rhs: User) -> Bool {
  return lhs.name == rhs.name && lhs.age == rhs.age && lhs.tweets == rhs.tweets && lhs.attrs == rhs.attrs
}
