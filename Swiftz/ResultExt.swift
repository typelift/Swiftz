//
//  ResultExt.swift
//  Swiftz
//
//  Created by Robert Widmann on 6/1/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

extension Result : Functor {
	typealias A = V
	typealias B = Any
	typealias FB = Result<B>

	/// Applies the function to the value in the receiver.
	///
	/// If the receiver is `.Error`, ignores the function and returns the receiver unmodified.  If
	/// the receiver is `.Value`, applies the function to the underlying value and returns the
	/// result in a new `.Value`.
	public func fmap<B>(f : V -> B) -> Result<B> {
		return f <^> self
	}
}

extension Result : Applicative {
	typealias FAB = Result<A -> B>

	/// Given an `Result<VA -> VB>`, applies the encapsulated function to the value in the receiver
	/// if both are present.
	///
	/// If the `f` or `a' param is an `.Error`, simply returns an `.Error` with the same value.
	/// Otherwise the function taken from `.Value(f)` is applied to the value from `.Value(a)` and a
	/// new `.Value` is returned.
	public func ap<B>(f : Result<V -> B>) -> Result<B> {
		return f <*> self
	}
}

extension Result : Monad {
	/// Given a function from `VA -> Result<VB>`, applies the function `f` if `the receiver is a
	/// `.Value`, otherwise the function is ignored and a `.Error` with the error value from the
	/// receiver is returned.
	public func bind<B>(f : A -> Result<B>) -> Result<B> {
		return self >>- f
	}

}
