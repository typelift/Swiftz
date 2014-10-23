//
//  DictionaryExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 5/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

public func map<K, V, T, U>(#dict : Dictionary<K, V>) -> ((K, V) -> (T, U)) -> Dictionary<T, U> {
  return { transform in
    var d = Dictionary<T, U>(minimumCapacity: dict.count)
    for (key, value) in dict {
      switch transform(key, value) {
      case let (k, v): d.updateValue(v, forKey: k)
      }
    }
    return d
  }
}

public func filter<K, V>(#dict : Dictionary<K, V>) -> ((K, V) -> Bool) -> Dictionary<K, V> {
  return { pred in
    var f = Dictionary<K, V>()
    for (k, v) in dict {
      if pred(k, v) {
        f[k] = v
      }
    }
    return f
  }
}

public func reduce<K, V, A>(#dict : Dictionary<K, V>) -> A -> ((key:K, val:V, start:A) -> A) -> A {
  return { start in { reduce in
    var reduced:A?
    for (k,v) in dict {
      reduced = reduce(key:k, val:v, start:start)
    }
    switch reduced {
    case let .Some(a): return a
    case .None: return start
    }
  } }
}



public func mapValues<KeyType, ElementType, V>(#dict: Dictionary<KeyType, ElementType>, transform: (KeyType, ElementType) -> V) -> Dictionary<KeyType, V> {
  var d = Dictionary<KeyType, V>(minimumCapacity: dict.count)
  for (key, value) in dict {
    d.updateValue(transform(key, value), forKey: key)
  }
  return d
}
