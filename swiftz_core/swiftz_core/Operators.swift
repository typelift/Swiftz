//
//  Operators.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 28/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

// Operators
public operator infix • {
  associativity right
}

public operator infix |> {
  associativity left
}

//operator infix <| {
//  associativity right
//}

// "fmap" like
public operator infix <^> {
  associativity left
}

// "imap" like
public operator infix <^^> {
associativity left
}

// "contramap" like
public operator infix <!> {
associativity left
}

// "ap" like
public operator infix <*> {
  associativity left
}

// "bind" like
// in the standard library, >>=

// "extend" like
public operator infix =>> {
  associativity left
}
