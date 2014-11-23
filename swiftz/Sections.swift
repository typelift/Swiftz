//
//  Sections.swift
//  swiftz
//
//  Created by Robert Widmann on 11/18/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

// Operators

prefix operator • {}
postfix operator • {}

prefix operator § {}
postfix operator § {}

prefix operator |> {}
postfix operator |> {}

prefix operator <| {}
postfix operator <| {}

// "fmap" like
prefix operator <^> {}
postfix operator <^> {}

// "imap" like
prefix operator <^^> {}
postfix operator <^^> {}

// "contramap" like
prefix operator <!> {}
postfix operator <!> {}

// "ap" like
prefix operator <*> {}
postfix operator <*> {}

// "extend" like
prefix operator ->> {}
postfix operator ->> {}

/// Monadic bind
prefix operator >>- {}
postfix operator >>- {}

