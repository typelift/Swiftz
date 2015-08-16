//
//  State.swift
//  Swiftz
//
//  Created by Robert Widmann on 2/21/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

/// The State Monad represents a computation that threads a piece of state through each step.
public struct State<S, A> {
	public let runState : S -> (A, S)
	
	/// Creates a new State Monad given a function from a piece of state to a value and an updated
	/// state.
	public init(_ runState : S -> (A, S)) {
		self.runState = runState
	}
	
	/// Evaluates the computation given an initial state then returns a final value after running
	/// each step.
	public func eval(s : S) -> A {
		return self.runState(s).0
	}
	
	/// Evaluates the computation given an initial state then returns the final state after running
	/// each step.
	public func exec(s : S) -> S {
		return self.runState(s).1
	}
	
	/// Executes an action that can modify the inner state.
	public func withState(f : S -> S) -> State<S, A> {
		return State(self.runState • f)
	}
}

extension State : Functor {
	public typealias B = Swift.Any
	public typealias FB = State<S, B>
	
	public func fmap<B>(f : A -> B) -> State<S, B> {
		return State<S, B>({ s in
			let (val, st2) = self.runState(s)
			return (f(val), st2)
		})
	}
}

/// Fetches the current value of the state.
public func get<S>() -> State<S, S> {
	return State<S, S> { ($0, $0) }
}

/// Sets the state.
public func put<S>(s : S) -> State<S, ()> {
	return State<S, ()> { _ in ((), s) }
}

/// Gets a specific component of the state using a projection function.
public func gets<S, A>(f : S -> A) -> State<S, A> {
	return State { s in (f(s), s) }
}

/// Updates the state with the result of executing the given function. 
public func modify<S>(f : S -> S) -> State<S, ()> {
	return State<S, ()> { s in ((), f(s)) }
}

extension State : Pointed {
	public static func pure(x : A) -> State<S, A> {
		return State({ s in (x, s) })
	}
}

extension State : Applicative {
	public typealias FAB = State<S, A -> B>
	
	public func ap<B>(stfn : State<S, A -> B>) -> State<S, B> {
		return stfn.bind({ f in
			return self.bind({ a in
				return State<S, B>.pure(f(a))
			})
		})
	}
}

extension State : Monad {
	public func bind<B>(f : A -> State<S, B>) -> State<S, B> {
		return State<S, B>({ s in
			let (a, s2) = self.runState(s)
			return f(a).runState(s2)
		})
	}
}
