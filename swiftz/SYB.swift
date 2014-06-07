//
//  SYB.swift
//  swiftz
//
//  Created by Maxwell Swadling on 7/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

protocol Dataable {
  class func typeRep() -> Any.Type
  class func fromRep(r: Data) -> Self?
  func toRep() -> Data
}

struct Data {
  let con: Int
  let vals: Array<(String, Any)>
}
