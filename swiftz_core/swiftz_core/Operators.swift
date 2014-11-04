//
//  Operators.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 28/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

// Operators
infix operator • {
associativity right
}

infix operator § {
associativity right
precedence 0
}

infix operator |> {
associativity left
}

//operator  <| {
//  associativity right
//}

// "fmap" like
infix operator  <^> {
associativity left
}

// "imap" like
infix operator  <^^> {
associativity left
}

// "contramap" like
infix operator  <!> {
associativity left
}

// "ap" like
infix operator  <*> {
associativity left
}

// "extend" like
infix operator  ->> {
associativity left
}

/// Monadic bind operator, because >>= is already in the standard lib.
infix operator >>- {
associativity left
}
