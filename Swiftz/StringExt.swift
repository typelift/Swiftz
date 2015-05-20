//
//  StringExt.swift
//  swiftz
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
		return self.componentsSeparatedByString("\n")
	}

	/// Concatenates an array of strings into a single string containing newlines between each
	/// element.
	public static func unlines(xs : [String]) -> String {
		return xs.reduce("", combine: { "\($0)\($1)\n" })
	}

	/// Returns a Lens that targets the newline-seperated sections of a String
	public static func lines() -> Iso<String, String, [String], [String]> {
		return Iso(get: { $0.lines() }, inject: unlines)
	}

	/// Appends an element onto the front of a list.
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
		if count(self) == 0 {
			return .Nil
		} else if count(self) == 1 {
			return .Cons(self[self.startIndex], "")
		}
		return .Cons(self[self.startIndex], self[advance(self.startIndex, 1)..<self.endIndex])
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
				return [String.cons(y, tail: head(x)!)] + x
			}, initial: [""])
		}

		return any(tails(r), { self.isPrefixOf($0) })
	}

	/// Takes two strings and drops items in the first from the second.  If the first string is not a
	/// prefix of the second string this function returns Nothing.
	public func stripPrefix(r : String) -> Maybe<String> {
		switch (self.match(), r.match()) {
		case (.Nil, _):
			return Maybe.just(r)
		case (.Cons(let x, let xs), .Cons(let y, let ys)) where x == y:
			return xs.stripPrefix(xs)
		default:
			return Maybe.none()
		}
	}

	/// Takes two strings and drops items in the first from the end of the second.  If the first 
	/// string is not a suffix of the second string this function returns nothing.
	public func stripSuffix(r : String) -> Maybe<String> {
		return self.reverse().stripPrefix(r.reverse()).fmap({ $0.reverse() })
	}
}


