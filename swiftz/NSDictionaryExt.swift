//
//  NSDictionaryExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 5/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

extension NSDictionary {
  func mapValuesToDictionary<K, V>(transform: (AnyObject, AnyObject) -> (K, V)) -> Dictionary<K, V> {
    var d = Dictionary<K, V>()
    for (key : AnyObject, value : AnyObject) in self {
      switch transform(key, value) {
        case let (k, v): d.updateValue(v, forKey: k)
      }
    }
    return d
  }
}
