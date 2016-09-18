//
//  DictionaryExt.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 5/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

extension Dictionary {
	/// Initialize a Dictionary from a list of Key-Value pairs.
	public init<S : Sequence>(_ seq : S) 
		where S.Iterator.Element == Element 
	{
		self.init()
		for (k, v) in seq {
			self[k] = v
		}
	}

	/// MARK: Query

	/// Returns whether the given key exists in the receiver.
	public func isMember(_ k : Key) -> Bool {
		return self[k] != nil
	}

	/// Returns whether the given key does not exist in the receiver.
	public func notMember(_ k : Key) -> Bool {
		return !self.isMember(k)
	}

	/// Looks up a value in the receiver.  If one is not found the default is 
	/// used.
	public func lookup(_ k : Key, def : Value) -> Value {
		return self[k] ?? def
	}

	/// Returns a copy of the receiver with the given key associated with the 
	/// given value.
	public func insert(_ k : Key, v : Value) -> [Key: Value] {
		var d = self
		d[k] = v
		return d
	}

	/// Returns a copy of the receiver with the given key associated with the 
	/// value returned from a combining function.  If the receiver does not 
	/// contain a value for the given key this function is equivalent to an 
	/// `insert`.
	public func insertWith(_ k : Key, v : Value, combiner : (Value) -> (Value) -> Value) -> [Key: Value] {
		return self.insertWithKey(k, v: v, combiner: { (_ : Key, newValue : Value, oldValue : Value) -> Value in
			return combiner(newValue)(oldValue)
		})
	}

	/// Returns a copy of the receiver with the given key associated with the 
	/// value returned from a combining function.  If the receiver does not 
	/// contain a value for the given key this function is equivalent to an 
	/// `insert`.
	public func insertWith(_ k : Key, v : Value, combiner : @escaping (_ new : Value, _ old : Value) -> Value) -> [Key: Value] {
		return self.insertWith(k, v: v, combiner: curry(combiner))
	}

	/// Returns a copy of the receiver with the given key associated with the 
	/// value returned from a combining function.  If the receiver does not 
	/// contain a value for the given key this function is equivalent to an 
	/// `insert`.
	public func insertWithKey(_ k : Key, v : Value, combiner : (Key) -> (Value) -> (Value) -> Value) -> [Key: Value] {
		if let oldV = self[k] {
			return self.insert(k, v: combiner(k)(v)(oldV))
		}
		return self.insert(k, v: v)
	}

	/// Returns a copy of the receiver with the given key associated with the 
	/// value returned from a combining function.  If the receiver does not 
	/// contain a value for the given key this function is equivalent to an 
	/// `insert`.
	public func insertWithKey(_ k : Key, v : Value, combiner : (_ key : Key, _ newValue : Value, _ oldValue : Value) -> Value) -> [Key: Value] {
		if let oldV = self[k] {
			return self.insert(k, v: combiner(k, v, oldV))
		}
		return self.insert(k, v: v)
	}

	/// Combines insert and retrieval of the old value if it exists.
	public func insertLookupWithKey(_ k : Key, v : Value, combiner : (_ key : Key, _ newValue : Value, _ oldValue : Value) -> Value) -> (Optional<Value>, [Key: Value]) {
		return (self[k], self.insertWithKey(k, v: v, combiner: combiner))
	}

	/// MARK: Update

	/// Returns a copy of the receiver with the value for the given key removed.
	public func delete(_ k : Key) -> [Key: Value] {
		var d = self
		d[k] = nil
		return d
	}

	/// Updates a value at the given key with the result of the function 
	/// provided.  If the key is not in the receiver this function is equivalent
	/// to `identity`.
	public func adjust(_ k : Key, adjustment : @escaping (Value) -> Value) -> [Key: Value] {
		return self.adjustWithKey(k, adjustment: { (_, x) -> Value in
			return adjustment(x)
		})
	}

	/// Updates a value at the given key with the result of the function 
	/// provided.  If the key is not in the receiver this function is equivalent
	/// to `identity`.
	public func adjustWithKey(_ k : Key, adjustment : @escaping (Key) -> (Value) -> Value) -> [Key: Value] {
		return self.updateWithKey(k, update: { (k, x) -> Optional<Value> in
			return .some(adjustment(k)(x))
		})
	}

	/// Updates a value at the given key with the result of the function 
	/// provided.  If the key is not in the receiver this function is equivalent 
	/// to `identity`.
	public func adjustWithKey(_ k : Key, adjustment : @escaping (Key, Value) -> Value) -> [Key: Value] {
		return self.adjustWithKey(k, adjustment: curry(adjustment))
	}

	/// Updates a value at the given key with the result of the function 
	/// provided.  If the result of the function is `.none`, the value 
	/// associated with the given key is removed.  If the key is not in the 
	/// receiver this function is equivalent to `identity`.
	public func update(_ k : Key, update : @escaping (Value) -> Optional<Value>) -> [Key: Value] {
		return self.updateWithKey(k, update: { (_, x) -> Optional<Value> in
			return update(x)
		})
	}

	/// Updates a value at the given key with the result of the function 
	/// provided.  If the result of the function is `.none`, the value 
	/// associated with the given key is removed.  If the key is not in the 
	/// receiver this function is equivalent to `identity`.
	public func updateWithKey(_ k : Key, update : (Key) -> (Value) -> Optional<Value>) -> [Key: Value] {
		if let oldV = self[k], let newV = update(k)(oldV) {
			return self.insert(k, v: newV)
		}
		return self.delete(k)
	}

	/// Updates a value at the given key with the result of the function 
	/// provided.  If the result of the function is `.none`, the value 
	/// associated with the given key is removed.  If the key is not in the 
	/// receiver this function is equivalent to `identity`.
	public func updateWithKey(_ k : Key, update : @escaping (Key, Value) -> Optional<Value>) -> [Key: Value] {
		return self.updateWithKey(k, update: curry(update))
	}

	/// Alters the value (if any) for a given key with the result of the 
	/// function provided.  If the result of the function is `.none`, the value 
	/// associated with the given key is removed.
	public func alter(_ k : Key, alteration : (Optional<Value>) -> Optional<Value>) -> [Key: Value] {
		if let newV = alteration(self[k]) {
			return self.insert(k, v: newV)
		}
		return self.delete(k)
	}

	/// MARK: Map

	/// Maps a function over all values in the receiver.
	public func map<Value2>(_ f : @escaping (Value) -> Value2) -> [Key: Value2] {
		return self.mapWithKey { (_, x) -> Value2 in
			return f(x)
		}
	}

	/// Maps a function over all keys and values in the receiver.
	public func mapWithKey<Value2>(_ f : (Key) -> (Value) -> Value2) -> [Key: Value2] {
		var d = [Key: Value2]()
		self.forEach { (k, v) in
			d[k] = f(k)(v)
		}
		return d
	}

	/// Maps a function over all keys and values in the receiver.
	public func mapWithKey<Value2>(_ f : @escaping (Key, Value) -> Value2) -> [Key: Value2] {
		return self.mapWithKey(curry(f))
	}

	/// Maps a function over all keys in the receiver.
	public func mapKeys<Key2 : Hashable>(_ f : (Key) -> Key2) -> [Key2: Value] {
		var d = [Key2: Value]()
		self.forEach { (k, v) in
			d[f(k)] = v
		}
		return d
	}

	/// Map values and collect the '.Some' results.
	public func mapMaybe<Value2>(_ f : @escaping (Value) -> Value2?) -> [Key : Value2] {
		return self.mapMaybeWithKey { (_, x) -> Value2? in
			return f(x)
		}
	}

	/// Map a function over all keys and values and collect the '.Some' results.
	public func mapMaybeWithKey<B>(_ f : @escaping (Key, Value) -> B?) -> [Key : B] {
		return self.mapMaybeWithKey(curry(f))
	}

	/// Map a function over all keys and values and collect the '.Some' results.
	public func mapMaybeWithKey<B>(_ f : (Key) -> (Value) -> B?) -> [Key : B] {
		var b = [Key : B]()

		for (k, v) in self.mapWithKey(f) {
			if let v = v {
				b[k] = v
			}
		}
		return b
	}

	/// MARK: Partition

	/// Filters all values that do not satisfy a given predicate from the 
	/// receiver.
	public func filter(_ pred : @escaping (Value) -> Bool) -> [Key: Value] {
		return self.filterWithKey({ (_, x) -> Bool in
			return pred(x)
		})
	}

	/// Filters all keys and values that do not satisfy a given predicate from 
	/// the receiver.
	public func filterWithKey(_ pred : (Key) -> (Value) -> Bool) -> [Key: Value] {
		var d = [Key: Value]()
		self.forEach { (k, v) in
			if pred(k)(v) {
				d[k] = v
			}
		}

		return d
	}

	/// Filters all keys and values that do not satisfy a given predicate from 
	/// the receiver.
	public func filterWithKey(_ pred : @escaping (Key, Value) -> Bool) -> [Key: Value] {
		return self.filterWithKey(curry(pred))
	}

	/// Partitions the receiver into a Dictionary of values that passed the 
	/// given predicate and a Dictionary of values that failed the given 
	/// predicate.
	public func partition(_ pred : @escaping (Value) -> Bool) -> (passed : [Key: Value], failed : [Key: Value]) {
		return self.partitionWithKey({ (_, x) -> Bool in
			return pred(x)
		})
	}

	/// Partitions the receiver into a Dictionary of values that passed the 
	/// given predicate and a Dictionary of values that failed the given 
	/// predicate.
	public func partitionWithKey(_ pred : (Key) -> (Value) -> Bool) -> (passed : [Key: Value], failed : [Key: Value]) {
		var pass = [Key: Value]()
		var fail = [Key: Value]()
		self.forEach { (k, v) in
			if pred(k)(v) {
				pass[k] = v
			} else {
				fail[k] = v
			}
		}

		return (pass, fail)
	}

	/// Partitions the receiver into a Dictionary of values that passed the 
	/// given predicate and a Dictionary of values that failed the given 
	/// predicate.
	public func partitionWithKey(_ pred : @escaping (Key, Value) -> Bool) -> (passed : [Key: Value], failed : [Key: Value]) {
		return self.partitionWithKey(curry(pred))
	}
}
