//
//  StringExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 8/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

extension String {
  public func lines() -> [String] {
    var xs: [String] = []
    var line: String = ""
    // loop school
    for x in self {
      if x == "\n" {
        xs.append(line)
        line = ""
      } else {
        line.append(x)
      }
    }
    if line != "" {
      xs.append(line)
    }
    return xs
  }

  public static func unlines(xs: [String]) -> String {
    return xs.reduce("", combine: { "\($0)\($1)\n" } )
  }

  public static func lines() -> Iso<String, String, [String], [String]> {
    return Iso(get: { $0.lines() }, inject: unlines)
  }
}
