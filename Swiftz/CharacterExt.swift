//
//  CharacterExt.swift
//  swiftz
//
//  Created by Robert Widmann on 1/6/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import Darwin

extension Character {
	/// Returns the unicode codepoint value for the first unicode value in the grapheme cluster.
	public func unicodeValue() -> UInt32 {
		for s in String(self).unicodeScalars {
			return s.value
		}
		return 0
	}

	/// Returns whether the receiver is a valid ASCII character.
	public func isASCII() -> Bool {
		return self < "\u{80}"
	}

	/// Returns whether the receiver is a valid Latin1 Character.
	public func isLatin1() -> Bool {
		return self <= "\u{ff}"
	}

	/// Returns wehether the receiver is an ASCII digit ([0-9]).
	public func isDigit() -> Bool {
		return self >= "0" && self <= "9"
	}

	/// Returns wehether the receiver is an ASCII octal digit ([0-7]).
	public func isOctalDigit() -> Bool {
		return self >= "0" && self <= "7"
	}

	/// Returns wehether the receiver is an ASCII hexadecimal digit ([0-9a-fA-F]).
	public func isHexadecimalDigit() -> Bool {
		return self.isDigit() || (self >= "a" && self <= "f") || (self >= "A" && self <= "F")
	}

	/// Returns whether the receiver is a valid ASCII lowercase character ([a-z])
	public func isASCIILower() -> Bool {
		return self >= "a" && self <= "z"
	}

	/// Returns whether the receiver is a valid ASCII uppercase character ([A-Z])
	public func isASCIIUpper() -> Bool {
		return self >= "A" && self <= "Z"
	}

	/// Returns whether the receiver is a valid Unicode lowercase character ([a-z])
	public func isLower() -> Bool {
		return iswlower(Int32(self.unicodeValue())) != 0
	}

	/// Returns whether the receiver is a valid Unicode uppercase character ([A-Z])
	public func isUpper() -> Bool {
		return iswupper(Int32(self.unicodeValue())) != 0
	}

	/// Returns whether the receiver is a Unicode space character.
	public func isSpace() -> Bool {
		return iswspace(Int32(self.unicodeValue())) != 0
	}

	/// Returns whether the receiver is a Latin1 control character.
	public func isControl() -> Bool {
		return iswcntrl(Int32(self.unicodeValue())) != 0
	}

	/// Returns whether the receiver is a printable Unicode character.
	public func isPrintable() -> Bool {
		return iswprint(Int32(self.unicodeValue())) != 0
	}

	/// Converts the receiver to its corresponding uppercase letter, if any.
	public func toUpper() -> Character {
		return Character(UnicodeScalar(self.unicodeValue()).toUpper())
	}

	/// Converts the receiver to its corresponding lowercase letter, if any.
	public func toLower() -> Character {
		return Character(UnicodeScalar(self.unicodeValue()).toLower())
	}
}

extension UnicodeScalar {
	/// Returns whether the receiver represents a valid ASCII character.
	public func isASCII() -> Bool {
		return self < "\u{80}"
	}

	/// Returns whether the receiver represents a valid Latin1 character.
	public func isLatin1() -> Bool {
		return self <= "\u{ff}"
	}

	/// Returns wehether the receiver is an ASCII digit ([0-9]).
	public func isDigit() -> Bool {
		return self >= "0" && self <= "9"
	}

	/// Returns wehether the receiver is an ASCII octal digit ([0-7]).
	public func isOctalDigit() -> Bool {
		return self >= "0" && self <= "7"
	}

	/// Returns wehether the receiver is an ASCII hexadecimal digit ([0-9a-fA-F]).
	public func isHexadecimalDigit() -> Bool {
		return self.isDigit() || (self >= "a" && self <= "f") || (self >= "A" && self <= "F")
	}

	/// Returns whether the receiver is a valid ASCII lowercase character ([a-z])
	public func isASCIILower() -> Bool {
		return self >= "a" && self <= "z"
	}

	/// Returns whether the receiver is a valid ASCII uppercase character ([A-Z])
	public func isASCIIUpper() -> Bool {
		return self >= "A" && self <= "Z"
	}

	/// Returns whether the receiver is a valid Unicode lowercase character ([a-z])
	public func isLower() -> Bool {
		return iswlower(Int32(self.value)) != 0
	}

	/// Returns whether the receiver is a valid Unicode uppercase character ([A-Z])
	public func isUpper() -> Bool {
		return iswupper(Int32(self.value)) != 0
	}

	/// Returns whether the receiver is a Unicode space character.
	public func isSpace() -> Bool {
		return iswspace(Int32(self.value)) != 0 || self == "\u{21A1}" || self == "\u{000B}"
	}

	/// Returns whether the receiver is a Latin1 control character.
	public func isControl() -> Bool {
		return iswcntrl(Int32(self.value)) != 0
	}

	/// Returns whether the receiver is a printable Unicode character.
	public func isPrintable() -> Bool {
		return iswprint(Int32(self.value)) != 0
	}

	/// Converts the receiver to its corresponding uppercase letter, if any.
	public func toUpper() -> UnicodeScalar {
		return UnicodeScalar(UInt32(towupper(Int32(self.value))))
	}

	/// Converts the receiver to its corresponding lowercase letter, if any.
	public func toLower() -> UnicodeScalar {
		return UnicodeScalar(UInt32(towlower(Int32(self.value))))
	}
}
