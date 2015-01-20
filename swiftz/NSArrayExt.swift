//
//  NSArrayExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 5/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

extension NSArray {
	/// Maps all elements of the receiver into a Swift Array.
	public func mapToArray<U>(transform: AnyObject -> (U)) -> [U] {
		var xs: [U] = Array()
		self.enumerateObjectsUsingBlock({ (v: AnyObject?, _: Int, _: UnsafeMutablePointer<ObjCBool>) in
			xs.append(transform(v! as AnyObject))
		})
		return xs
	}
}
