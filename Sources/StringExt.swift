//
//  StringExt.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 8/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

#if !XCODE_BUILD
	import Operadics
	import Swiftx
#endif

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
	
	public func componentsSeparatedByString(_ token: Character) -> [String] {
		return characters.split(maxSplits: Int.max, omittingEmptySubsequences: false) { $0 == token }.map { String($0) }
	}

	/// Concatenates an array of strings into a single string containing 
	/// newlines between each element.
	public static func unlines(_ xs : [String]) -> String {
		return xs.reduce("", { "\($0)\($1)\n" })
	}

	/// Appends a character onto the front of a string.
	public static func cons(head : Character, tail : String) -> String {
		return String(head) + tail
	}

	/// Creates a string of n repeating characters.
	public static func replicate(_ n : UInt, value : Character) -> String {
		var l = ""
		for _ in 0..<n {
			l = String.cons(head: value, tail: l)
		}
		return l
	}

	/// Destructures a string.  If the string is empty the result is .Nil, 
	/// otherwise the result is .Cons(head, tail).
	public var match : StringMatcher {
		if self.characters.count == 0 {
			return .Nil
		} else if self.characters.count == 1 {
			return .Cons(self[self.startIndex], "")
		}
		return .Cons(self[self.startIndex], self[self.index(after: self.startIndex)..<self.endIndex])
	}

	/// Returns a string containing the characters of the receiver in reverse 
	/// order.
	public func reverse() -> String {
		return self.reduce(flip(curry(String.cons)), initial: "")
	}

	/// Maps a function over the characters of a string and returns a new string
	/// of those values.
	public func map(_ f : (Character) -> Character) -> String {
		switch self.match {
		case .Nil:
			return ""
		case let .Cons(hd, tl):
			return String(f(hd)) + tl.map(f)
		}
	}

	/// Removes characters from the receiver that do not satisfy a given predicate.
	public func filter(_ p : (Character) -> Bool) -> String {
		switch self.match {
		case .Nil:
			return ""
		case let .Cons(x, xs):
			return p(x) ? (String(x) + xs.filter(p)) : xs.filter(p)
		}
	}

	/// Applies a binary operator to reduce the characters of the receiver to a 
	/// single value.
	public func reduce<B>(_ f : (B) -> (Character) -> B, initial : B) -> B {
		switch self.match {
		case .Nil:
			return initial
		case let .Cons(x, xs):
			return xs.reduce(f, initial: f(initial)(x))
		}
	}

	/// Applies a binary operator to reduce the characters of the receiver to a 
	/// single value.
	public func reduce<B>(_ f : (B, Character) -> B, initial : B) -> B {
		switch self.match {
		case .Nil:
			return initial
		case let .Cons(x, xs):
			return xs.reduce(f, initial: f(initial, x))
		}
	}

	/// Takes two lists and returns true if the first string is a prefix of the 
	/// second string.
	public func isPrefixOf(_ r : String) -> Bool {
		switch (self.match, r.match) {
		case (.Cons(let x, let xs), .Cons(let y, let ys)) where (x == y):
			return xs.isPrefixOf(ys)
		case (.Nil, _):
			return true
		default:
			return false
		}
	}

	/// Takes two lists and returns true if the first string is a suffix of the 
	/// second string.
	public func isSuffixOf(_ r : String) -> Bool {
		return self.reverse().isPrefixOf(r.reverse())
	}

	/// Takes two lists and returns true if the first string is contained 
	/// entirely anywhere in the second string.
	public func isInfixOf(_ r : String) -> Bool {
		func tails(_ l : String) -> [String] {
			return l.reduce({ x, y in
				return [String.cons(head: y, tail: x.first!)] + x
			}, initial: [""])
		}

		if let _ = tails(r).first(where: self.isPrefixOf) {
			return true
		}
		return false
	}

	/// Takes two strings and drops items in the first from the second.  If the 
	/// first string is not a prefix of the second string this function returns 
	/// `.none`.
	public func stripPrefix(_ r : String) -> Optional<String> {
		switch (self.match, r.match) {
		case (.Nil, _):
			return .some(r)
		case (.Cons(let x, let xs), .Cons(let y, _)) where x == y:
			return xs.stripPrefix(xs)
		default:
			return .none
		}
	}

	/// Takes two strings and drops items in the first from the end of the 
	/// second.  If the first string is not a suffix of the second string this 
	/// function returns `.none`.
	public func stripSuffix(_ r : String) -> Optional<String> {
		return self.reverse().stripPrefix(r.reverse()).map({ $0.reverse() })
	}
}

extension String : Monoid {
	public typealias M = String

	public static var mempty : String {
		return ""
	}

	public func op(_ other : String) -> String {
		return self + other
	}
}

public func <>(l : String, r : String) -> String {
	return l + r
}

extension String /*: Functor*/ {
	public typealias A = Character
	public typealias B = Character
	public typealias FB = String

	public func fmap(_ f : (Character) -> Character) -> String {
		return self.map(f)
	}
}

public func <^> (_ f : (Character) -> Character, l : String) -> String {
	return l.fmap(f)
}

extension String /*: Pointed*/ {
	public static func pure(_ x : Character) -> String {
		return String(x)
	}
}

extension String /*: Applicative*/ {
	public typealias FAB = [(Character) -> Character]

	public func ap(_ a : [(Character) -> Character]) -> String {
		return a.map(self.map).reduce("", +)
	}
}

public func <*> (_ f : [((Character) -> Character)], l : String) -> String {
	return l.ap(f)
}

extension String /*: Monad*/ {
	public func bind(_ f : (Character) -> String) -> String {
		return Array(self.characters).map(f).reduce("", +)
	}
}

public func >>- (l : String, f : (Character) -> String) -> String {
	return l.bind(f)
}

public func sequence(_ ms: [String]) -> [String] {
	return sequence(ms.map { m in Array(m.characters) }).map(String.init(describing:))
}

