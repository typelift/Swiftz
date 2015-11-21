//
//  StringExt.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 8/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// An enum representing the possible values a string can match against.
public enum StringMatcher {
	/// The empty string.
	case Nil
	/// A cons cell.
	case Cons(Character, String)
}

extension String {
	/// Returns an array of strings at newlines.
	public func lines() -> [String] {
		return componentsSeparatedByString("\n")
	}
	
	public func componentsSeparatedByString(token: Character) -> [String] {
		return characters.split(Int.max, allowEmptySlices: true) { $0 == token }.map { String($0) }
	}

	/// Concatenates an array of strings into a single string containing newlines between each
	/// element.
	public static func unlines(xs : [String]) -> String {
		return xs.reduce("", combine: { "\($0)\($1)\n" })
	}

	/// Appends a character onto the front of a string.
	public static func cons(head : Character, tail : String) -> String {
		return String(head) + tail
	}

	/// Creates a string of n repeating characters.
	public static func replicate(n : UInt, value : Character) -> String {
		var l = ""
		for _ in 0..<n {
			l = String.cons(value, tail: l)
		}
		return l
	}

	/// Destructures a string.  If the string is empty the result is .Nil, otherwise the result is
	/// .Cons(head, tail).
	public func match() -> StringMatcher {
		if self.characters.count == 0 {
			return .Nil
		} else if self.characters.count == 1 {
			return .Cons(self[self.startIndex], "")
		}
		return .Cons(self[self.startIndex], self[self.startIndex.successor()..<self.endIndex])
	}

	/// Returns a string containing the characters of the receiver in reverse order.
	public func reverse() -> String {
		return self.reduce(flip(String.cons), initial: "")
	}

	/// Maps a function over the characters of a string and returns a new string of those values.
	public func map(f : Character -> Character) -> String {
		switch self.match() {
		case .Nil:
			return ""
		case let .Cons(hd, tl):
			return String(f(hd)) + tl.map(f)
		}
	}

	/// Removes characters from the receiver that do not satisfy a given predicate.
	public func filter(p : Character -> Bool) -> String {
		switch self.match() {
		case .Nil:
			return ""
		case let .Cons(x, xs):
			return p(x) ? (String(x) + xs.filter(p)) : xs.filter(p)
		}
	}

	/// Applies a binary operator to reduce the characters of the receiver to a single value.
	public func reduce<B>(f : B -> Character -> B, initial : B) -> B {
		switch self.match() {
		case .Nil:
			return initial
		case let .Cons(x, xs):
			return xs.reduce(f, initial: f(initial)(x))
		}
	}

	/// Applies a binary operator to reduce the characters of the receiver to a single value.
	public func reduce<B>(f : (B, Character) -> B, initial : B) -> B {
		switch self.match() {
		case .Nil:
			return initial
		case let .Cons(x, xs):
			return xs.reduce(f, initial: f(initial, x))
		}
	}

	/// Takes two lists and returns true if the first string is a prefix of the second string.
	public func isPrefixOf(r : String) -> Bool {
		switch (self.match(), r.match()) {
		case (.Cons(let x, let xs), .Cons(let y, let ys)) where (x == y):
			return xs.isPrefixOf(ys)
		case (.Nil, _):
			return true
		default:
			return false
		}
	}

	/// Takes two lists and returns true if the first string is a suffix of the second string.
	public func isSuffixOf(r : String) -> Bool {
		return self.reverse().isPrefixOf(r.reverse())
	}

	/// Takes two lists and returns true if the first string is contained entirely anywhere in the
	/// second string.
	public func isInfixOf(r : String) -> Bool {
		func tails(l : String) -> [String] {
			return l.reduce({ x, y in
				return [String.cons(y, tail: x.first!)] + x
			}, initial: [""])
		}

		return tails(r).any(self.isPrefixOf)
	}

	/// Takes two strings and drops items in the first from the second.  If the first string is not a
	/// prefix of the second string this function returns Nothing.
	public func stripPrefix(r : String) -> Optional<String> {
		switch (self.match(), r.match()) {
		case (.Nil, _):
			return .Some(r)
		case (.Cons(let x, let xs), .Cons(let y, _)) where x == y:
			return xs.stripPrefix(xs)
		default:
			return .None
		}
	}

	/// Takes two strings and drops items in the first from the end of the second.  If the first
	/// string is not a suffix of the second string this function returns nothing.
	public func stripSuffix(r : String) -> Optional<String> {
		return self.reverse().stripPrefix(r.reverse()).map({ $0.reverse() })
	}
}

extension String : Monoid {
	public typealias M = String

	public static var mempty : String {
		return ""
	}

	public func op(other : String) -> String {
		return self + other
	}
}

public func <>(l : String, r : String) -> String {
	return l + r
}

extension String : Functor {
	public typealias A = Character
	public typealias B = Character
	public typealias FB = String

	public func fmap(f : Character -> Character) -> String {
		return self.map(f)
	}
}

public func <^> (f : Character -> Character, l : String) -> String {
	return l.fmap(f)
}

extension String : Pointed {
	public static func pure(x : Character) -> String {
		return String(x)
	}
}

extension String : Applicative {
	public typealias FAB = [Character -> Character]

	public func ap(a : [Character -> Character]) -> String {
		return a.map(self.map).reduce("", combine: +)
	}
}

public func <*> (f : [(Character -> Character)], l : String) -> String {
	return l.ap(f)
}

extension String : Monad {
	public func bind(f : Character -> String) -> String {
		return Array(self.characters).map(f).reduce("", combine: +)
	}
}

public func >>- (l : String, f : Character -> String) -> String {
	return l.bind(f)
}
