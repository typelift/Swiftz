//
//  SYB.swift
//  swiftz
//
//  Created by Maxwell Swadling on 7/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

public protocol Dataable {
  class func typeRep() -> Any.Type
  class func fromRep(r: Data) -> Self?
  func toRep() -> Data
}

public struct Data {
  public let con: Int
  public let vals: [(String, Any)]
    
    public init(con: Int, vals: [(String, Any)]) {
        self.con = con
        self.vals = vals
    }
}
