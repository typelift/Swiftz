//
//  DictionaryExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 5/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

extension Dictionary {
	static func fromList(l : [(Key, Value)]) -> Dictionary<Key, Value> {
		var d = Dictionary<Key, Value>()
		for (k, v) in l {
			d[k] = v
		}
		return d
	}

	public func map<Value2>(f : Value -> Value2) -> Dictionary<Key, Value2> {
		var d = Dictionary<Key, Value2>()
		for (k, v) in self {
			d[k] = f(v)
		}
		return d
	}

	public func mapWithKey<Value2>(f : Key -> Value -> Value2) -> Dictionary<Key, Value2> {
		var d = Dictionary<Key, Value2>()
		for (k, v) in self {
			d[k] = f(k)(v)
		}
		return d
	}

	public func mapWithKey<Value2>(f : (Key, Value) -> Value2) -> Dictionary<Key, Value2> {
		var d = Dictionary<Key, Value2>()
		for (k, v) in self {
			d[k] = f(k, v)
		}
		return d
	}


	public func mapKeys<Key2 : Hashable>(f : Key -> Key2) -> Dictionary<Key2, Value> {
		var d = Dictionary<Key2, Value>()
		for (k, v) in self {
			d[f(k)] = v
		}
		return d
	}

	public func filter(pred : Value -> Bool) -> Dictionary<Key, Value> {
		var d = Dictionary<Key, Value>()
		for (k, v) in self {
			if pred(v) {
				d[k] = v
			}
		}

		return d
	}

	public func filterWithKey(pred : Key -> Value -> Bool) -> Dictionary<Key, Value> {
		var d = Dictionary<Key, Value>()
		for (k, v) in self {
			if pred(k)(v) {
				d[k] = v
			}
		}

		return d
	}

	public func filterWithKey(pred : (Key, Value) -> Bool) -> Dictionary<Key, Value> {
		var d = Dictionary<Key, Value>()
		for (k, v) in self {
			if pred(k, v) {
				d[k] = v
			}
		}

		return d
	}
}