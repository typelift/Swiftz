//
//  Sections.swift
//  swiftz
//
//  Created by Robert Widmann on 11/18/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import swiftz_core

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



/// MARK: functions as a monad and profunctor

// •
public func <^><I, A, B>(f: A -> B, k: I -> A) -> (I -> B) {
	return { x in f(k(x)) }
}

// flip(•)
public func <!><I, J, A>(f: J -> I, k: I -> A) -> (J -> A) {
	return { x in k(f(x)) }
}

// the S combinator
public func <*><I, A, B>(f: I -> (A -> B), k: I -> A) -> (I -> B) {
	return { x in f(x)(k(x)) }
}

// the S' combinator
public func >>-<I, A, B>(f: A -> (I -> B), k: I -> A) -> (I -> B) {
	return { x in f(k(x))(x) }
}

/// MARK: Sections

prefix public func •<A, B, C>(g : A -> B) -> (B -> C) -> A -> C {
	return { f in { a in f(g(a)) } }
}

postfix public func •<A, B, C>(f: B -> C) -> (A -> B) -> A -> C {
	return { g in { a in f(g(a)) } }
}

prefix public func §<A, B>(a: A) -> (A -> B) -> B {
	return { f in f(a) }
}

postfix public func §<A, B>(f: A -> B) -> A -> B {
	return { a in f(a) }
}

prefix public func <|<A, B>(a: A) -> (A -> B) -> B {
	return { f in f(a) }
}

postfix public func <|<A, B>(f: A -> B) -> A -> B {
	return { a in f(a) }
}

prefix public func |><A, B>(f: A -> B) -> A -> B {
	return { a in f(a) }
}

postfix public func |><A, B>(a: A) -> (A -> B) -> B {
	return { f in f(a) }
}

prefix public func <^><I, A, B>(k: I -> A) -> (A -> B) -> (I -> B) {
	return { f in { x in f(k(x)) } }
}

postfix public func <^><I, A, B>(f: A -> B) -> (I -> A) -> (I -> B) {
	return { k in { x in f(k(x)) } }
}

prefix public func <!><I, J, A>(k: I -> A) -> (J -> I) -> (J -> A) {
	return { f in { x in k(f(x)) } }
}

postfix public func <!><I, J, A>(f: J -> I) -> (I -> A) -> (J -> A) {
	return { k in { x in k(f(x)) } }
}

prefix public func <*><I, A, B>(k: I -> A) -> (I -> (A -> B)) -> (I -> B) {
	return { f in { x in f(x)(k(x)) } }
}

postfix public func <*><I, A, B>(f: I -> (A -> B)) -> (I -> A) -> (I -> B) {
	return { k in { x in f(x)(k(x)) } }
}

prefix public func >>-<I, A, B>(k: I -> A) -> (A -> (I -> B)) -> (I -> B) {
	return { f in { x in f(k(x))(x) } }
}

postfix public func >>-<I, A, B>(f: A -> (I -> B)) -> (I -> A) -> (I -> B) {
	return { k in { x in f(k(x))(x) } }
}


