//
//  StringExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 8/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

extension String {
  func lines() -> String[] {
    var xs: String[] = []
    var line: String = ""
    // loop school
    for x in self {
      if x == "\n" {
        xs.append(line)
        line = ""
      } else {
        line += x
      }
    }
    if line != "" {
      xs.append(line)
    }
    return xs
  }
  
  static func unlines(xs: String[]) -> String {
    return xs.reduce("", combine: { "\($0)\($1)\n" } )
  }

  // actually an isomorphism
  static func lines() -> Lens<String, String, String[], String[]> {
     return Lens { str in IxStore(str.lines(), self.unlines) }
  }
}
