//
//  DictionaryExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 5/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

extension Dictionary {

	/// Returns a dictionary consisting of all the key-value pairs satisfying a predicate.
	public func filter<K, V>(dict dict : Dictionary<K, V>) -> ((K, V) -> Bool) -> Dictionary<K, V> {
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

	/// Folds a reducing function over all the key-value pairs in a dictionary.
	public func reduce<K, V, A>(dict dict : Dictionary<K, V>) -> A -> ((key : K, val : V, start : A) -> A) -> A {
		return { start in { reduce in
			var reduced:A?
			for (k,v) in dict {
				reduced = reduce(key:k, val:v, start:start)
			}
			switch reduced {
			case let .Some(a):
				return a
			case .None:
				return start
			}
		} }
	}

}