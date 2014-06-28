//
//  Operators.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 28/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

// Operators
operator infix • {
  associativity right
}

operator infix |> {
  associativity left
}

//operator infix <| {
//  associativity right
//}

// "fmap" like
operator infix <^> {
  associativity left
}

// "ap" like
operator infix <*> {
  associativity left
}

// "bind" like
// in the standard library, >>=

operator infix <^^> {
  associativity left
}

operator infix <!> {
  associativity left
}

operator infix =>> {
  associativity left
}
