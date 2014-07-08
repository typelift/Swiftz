//
//  NSArrayExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 5/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

extension NSArray {
  func mapToArray<U>(transform: AnyObject -> (U)) -> [U] {
    var xs: [U] = Array()
    self.enumerateObjectsUsingBlock({ (v: AnyObject?, _: Int, _: UnsafePointer<ObjCBool>) in
      xs.append(transform(v! as AnyObject))
    })
    return xs
  }
}