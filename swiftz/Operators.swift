//
//  Operators.swift
//  swiftz
//
//  Created by Robert Widmann on 11/18/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

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
precedence 0
}

infix operator <| {
associativity right
precedence 0
}

// "fmap" like
infix operator <^> {
associativity left
}

// "imap" like
infix operator <^^> {
associativity left
}

// "contramap" like
infix operator <!> {
associativity left
}

// "ap" like
infix operator <*> {
associativity left
}

// "extend" like
infix operator ->> {
associativity left
}

/// Monadic bind operator, because >>= is already in the standard lib.
infix operator >>- {
associativity left
}

/// "From" for Results.
infix operator !! {
associativity none
}


/// MARK: Data.Chan

infix operator  <- {}
prefix operator <- {}

/// MARK: Data.Set

infix operator ∩ {}
infix operator ∪ {}


