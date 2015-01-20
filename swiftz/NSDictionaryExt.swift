//
//  NSDictionaryExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 5/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import class Foundation.NSDictionary

extension NSDictionary {
	/// Maps all object key-value pairs in the receiver into a Swift Dictionary.
	public func mapValuesToDictionary<K, V>(transform: (AnyObject, AnyObject) -> (K, V)) -> Dictionary<K, V> {
		var d = Dictionary<K, V>()
		for (key : AnyObject, value : AnyObject) in self {
			switch transform(key, value) {
			case let (k, v): 
				d.updateValue(v, forKey: k)
			}
		}
		return d
	}
}
