//
//  DictionaryExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 5/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

extension Dictionary {
  func map<U, V>(transform: Element -> (U, V)) -> Dictionary<U, V> {
    var d = Dictionary<U, V>()
    for (key, value) in self {
      switch transform(key, value) {
      case let (k, v): d.updateValue(v, forKey: k)
      }
    }
    return d
  }
}
