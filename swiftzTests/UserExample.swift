//
//  UserExample.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation
import swiftz
import swiftz_core

// A user example
// an example of why we need SYB, Generics or macros
public class User: JSONDecode {
  typealias J = User
  let name: String
  let age: Int
  let tweets: [String]
  let attrs: Dictionary<String, String>

  public init(_ n: String, _ a: Int, _ t: [String], _ r: Dictionary<String, String>) {
    name = n
    age = a
    tweets = t
    attrs = r
  }

  // JSON
  public class func create(x: String) -> (Int) -> (([String]) -> ((Dictionary<String, String>) -> User)) {
    return { (y: Int) in { (z: [String]) in { User(x, y, z, $0) } } }
  }

  public class func fromJSON(x: JSONValue) -> User? {
    var n: String?
    var a: Int?
    var t: [String]?
    var r: Dictionary<String, String>?
    switch x {
    case let .JSONObject(d):
      n = d["name"]   >>- JString.fromJSON
      a = d["age"]    >>- JInt.fromJSON
      t = d["tweets"] >>- JArray<String, JString>.fromJSON
      r = d["attrs"]  >>- JDictionary<String, JString>.fromJSON
      // alternatively, if n && a && t... { return User(n!, a!, ...
      return (User.create <^> n <*> a <*> t <*> r)
    default:
      return .None
    }
  }

  // lens example
  public class func luserName() -> Lens<User, User, String, String> {
    return Lens { user in IxStore(user.name) { User($0, user.age, user.tweets, user.attrs) } }
  }
}

public func ==(lhs: User, rhs: User) -> Bool {
  return lhs.name == rhs.name && lhs.age == rhs.age && lhs.tweets == rhs.tweets && lhs.attrs == rhs.attrs
}
