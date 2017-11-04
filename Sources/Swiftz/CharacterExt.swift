//
//  CharacterExt.swift
//  Swiftz
//
//  Created by Robert Widmann on 1/6/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

extension Character {
	/// Returns the unicode codepoint value for the first unicode value in the 
	/// grapheme cluster.
	public var unicodeValue : UInt32 {
		for s in String(self).unicodeScalars {
			return s.value
		}
		return 0
	}

	/// Returns whether the receiver is a valid ASCII character.
	public var isASCII : Bool {
		return self < "\u{80}"
	}

	/// Returns whether the receiver is a valid Latin1 Character.
	public var isLatin1 : Bool {
		return self <= "\u{ff}"
	}

	/// Returns wehether the receiver is an ASCII digit ([0-9]).
	public var isDigit : Bool {
		return self >= "0" && self <= "9"
	}

	/// Returns wehether the receiver is an ASCII octal digit ([0-7]).
	public var isOctalDigit : Bool {
		return self >= "0" && self <= "7"
	}

	/// Returns wehether the receiver is an ASCII hexadecimal digit ([0-9a-fA-F]).
	public var isHexadecimalDigit : Bool {
		return self.isDigit || (self >= "a" && self <= "f") || (self >= "A" && self <= "F")
	}

	/// Returns whether the receiver is a valid ASCII lowercase character ([a-z])
	public var isASCIILower : Bool {
		return self >= "a" && self <= "z"
	}

	/// Returns whether the receiver is a valid ASCII uppercase character ([A-Z])
	public var isASCIIUpper : Bool {
		return self >= "A" && self <= "Z"
	}

	/// Returns whether the receiver is a valid Unicode lowercase character ([a-z])
	public var isLower : Bool {
		#if os(Linux)
			return islower(Int32(self.unicodeValue)) != 0
		#else
			return iswlower(Int32(self.unicodeValue)) != 0
		#endif
	}

	/// Returns whether the receiver is a valid Unicode uppercase character ([A-Z])
	public var isUpper : Bool {
		#if os(Linux)
			return isupper(Int32(self.unicodeValue)) != 0
		#else
			return iswupper(Int32(self.unicodeValue)) != 0
		#endif
	}

	/// Returns whether the receiver is a Unicode space character.
	public var isSpace : Bool {
		#if os(Linux)
			return isspace(Int32(self.unicodeValue)) != 0
		#else
			return iswspace(Int32(self.unicodeValue)) != 0
		#endif
	}

	/// Returns whether the receiver is a Latin1 control character.
	public var isControl : Bool {
		#if os(Linux)
			return iscntrl(Int32(self.unicodeValue)) != 0
		#else
			return iswcntrl(Int32(self.unicodeValue)) != 0
		#endif
	}

	/// Returns whether the receiver is a printable Unicode character.
	public var isPrintable : Bool {
		#if os(Linux)
			return isprint(Int32(self.unicodeValue)) != 0
		#else
			return iswprint(Int32(self.unicodeValue)) != 0
		#endif
	}

	/// Converts the receiver to its corresponding uppercase letter, if any.
	public var toUpper : Character {
		return Character(UnicodeScalar(self.unicodeValue)!.toUpper)
	}

	/// Converts the receiver to its corresponding lowercase letter, if any.
	public var toLower : Character {
		return Character(UnicodeScalar(self.unicodeValue)!.toLower)
	}
}

extension UnicodeScalar {
	/// Returns whether the receiver represents a valid ASCII character.
	public var isASCII : Bool {
		return self < "\u{80}"
	}

	/// Returns whether the receiver represents a valid Latin1 character.
	public var isLatin1 : Bool {
		return self <= "\u{ff}"
	}

	/// Returns wehether the receiver is an ASCII digit ([0-9]).
	public var isDigit : Bool {
		return self >= "0" && self <= "9"
	}

	/// Returns wehether the receiver is an ASCII octal digit ([0-7]).
	public var isOctalDigit : Bool {
		return self >= "0" && self <= "7"
	}

	/// Returns wehether the receiver is an ASCII hexadecimal digit ([0-9a-fA-F]).
	public var isHexadecimalDigit : Bool {
		return self.isDigit || (self >= "a" && self <= "f") || (self >= "A" && self <= "F")
	}

	/// Returns whether the receiver is a valid ASCII lowercase character ([a-z])
	public var isASCIILower : Bool {
		return self >= "a" && self <= "z"
	}

	/// Returns whether the receiver is a valid ASCII uppercase character ([A-Z])
	public var isASCIIUpper : Bool {
		return self >= "A" && self <= "Z"
	}

	/// Returns whether the receiver is a valid Unicode lowercase character ([a-z])
	public var isLower : Bool {
		#if os(Linux)
			return islower(Int32(self.value)) != 0
		#else
			return iswlower(Int32(self.value)) != 0
		#endif
	}

	/// Returns whether the receiver is a valid Unicode uppercase character ([A-Z])
	public var isUpper : Bool {
		#if os(Linux)
			return isupper(Int32(self.value)) != 0
		#else
			return iswupper(Int32(self.value)) != 0
		#endif
	}

	/// Returns whether the receiver is a Unicode space character.
	public var isSpace : Bool {
		#if os(Linux)
			return isspace(Int32(self.value)) != 0 || self == "\u{21A1}" || self == "\u{000B}"
		#else
			return iswspace(Int32(self.value)) != 0 || self == "\u{21A1}" || self == "\u{000B}"
		#endif
	}

	/// Returns whether the receiver is a Latin1 control character.
	public var isControl : Bool {
		#if os(Linux)
			return iscntrl(Int32(self.value)) != 0
		#else
			return iswcntrl(Int32(self.value)) != 0
		#endif
	}

	/// Returns whether the receiver is a printable Unicode character.
	public var isPrintable : Bool {
		#if os(Linux)
			return isprint(Int32(self.value)) != 0
		#else
			return iswprint(Int32(self.value)) != 0
		#endif
	}

	/// Converts the receiver to its corresponding uppercase letter, if any.
	public var toUpper : UnicodeScalar {
		#if os(Linux)
			return UnicodeScalar(UInt32(toupper(Int32(self.value))))!
		#else
			return UnicodeScalar(UInt32(towupper(Int32(self.value))))!
		#endif
	}

	/// Converts the receiver to its corresponding lowercase letter, if any.
	public var toLower : UnicodeScalar {
		#if os(Linux)
			return UnicodeScalar(UInt32(tolower(Int32(self.value))))!
		#else
			return UnicodeScalar(UInt32(towlower(Int32(self.value))))!
		#endif
	}
}
