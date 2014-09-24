//
//  Operators.swift
//  swiftz
//
//  Created by Robert Widmann on 9/21/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// "imap" like
infix operator  <%%> {
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
