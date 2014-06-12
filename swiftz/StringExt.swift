//
//  StringExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 8/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

extension String {
  func lines() -> Array<String> {
    var xs: Array<String> = []
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
  
  static func unlines(xs: Array<String>) -> String {
    return xs.reduce("", combine: { "\($0)\($1)\n" } )
  }

  // actually an isomorphism
//  static func lines() -> Lens<String, String, Array<String>, Array<String>> {
//     return Lens { str in (str.lines(), self.unlines) }
//  }
}
