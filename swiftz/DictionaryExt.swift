//
//  DictionaryExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 5/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

extension Dictionary {
  public func map<U, V>(transform: Element -> (U, V)) -> Dictionary<U, V> {
    var d = Dictionary<U, V>(minimumCapacity: self.count)
    for (key, value) in self {
      switch transform(key, value) {
      case let (k, v): d.updateValue(v, forKey: k)
      }
    }
    return d
  }

  // Linker bug
  //    func mapValues<V>(transform: Element -> V) -> Dictionary<KeyType, V> {
  //      var d = Dictionary<KeyType, V>(minimumCapacity: self.count)
  //      for (key, value) in self {
  //         d.updateValue(transform(key, value), forKey: key)
  //      }
  //      return d
  //    }

  public func filter(filter: Element -> Bool) -> Dictionary {
    var f = Dictionary()
    for (k, v) in self {
      if filter(k, v) {
        f[k] = v
      }
    }
    return f
  }

  public func reduce<A>(start:A, reduce:(key:Key, val:Value, start:A) -> A) -> A {
    var reduced:A?
    for (k,v) in self {
      reduced = reduce(key:k, val:v, start:start)
    }

    switch reduced {
    case let .Some(a): return a
    case .None: return start
    }
  }
}


public func mapValues<KeyType, ElementType, V>(dict: Dictionary<KeyType, ElementType>, transform: (KeyType, ElementType) -> V) -> Dictionary<KeyType, V> {
  var d = Dictionary<KeyType, V>(minimumCapacity: dict.count)
  for (key, value) in dict {
    d.updateValue(transform(key, value), forKey: key)
  }
  return d
}
