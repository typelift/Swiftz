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


extension State : Functor {
	public typealias B = Swift.Any
	public typealias FB = State<S, B>

	public func fmap<B>(f : A -> B) -> State<S, B> {
		return State<S, B> { s in
			let (val, st2) = self.runState(s)
			return (f(val), st2)
		}
	}
}

public func <^> <S, A, B>(f : A -> B, s : State<S, A>) -> State<S, B> {
	return s.fmap(f)
}

extension State : Pointed {
	public static func pure(x : A) -> State<S, A> {
		return State { s in (x, s) }
	}
}

extension State : Applicative {
	public typealias FAB = State<S, A -> B>

	public func ap<B>(stfn : State<S, A -> B>) -> State<S, B> {
		return stfn.bind { f in
			return self.bind { a in
				return State<S, B>.pure(f(a))
			}
		}
	}
}

public func <*> <S, A, B>(f : State<S, A -> B> , s : State<S, A>) -> State<S, B> {
	return s.ap(f)
}

extension State : ApplicativeOps {
	public typealias C = Any
	public typealias FC = State<S, C>
	public typealias D = Any
	public typealias FD = State<S, D>

	public static func liftA<B>(f : A -> B) -> State<S, A> -> State<S, B> {
		return { a in State<S, A -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(f : A -> B -> C) -> State<S, A> -> State<S, B> -> State<S, C> {
		return { a in { b in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(f : A -> B -> C -> D) -> State<S, A> -> State<S, B> -> State<S, C> -> State<S, D> {
		return { a in { b in { c in f <^> a <*> b <*> c } } }
	}
}

extension State : Monad {
	public func bind<B>(f : A -> State<S, B>) -> State<S, B> {
		return State<S, B> { s in
			let (a, s2) = self.runState(s)
			return f(a).runState(s2)
		}
	}
}

public func >>- <S, A, B>(xs : State<S, A>, f : A -> State<S, B>) -> State<S, B> {
	return xs.bind(f)
}

extension State : MonadOps {
	public static func liftM<B>(f : A -> B) -> State<S, A> -> State<S, B> {
		return { m1 in m1 >>- { x1 in State<S, B>.pure(f(x1)) } }
	}

	public static func liftM2<B, C>(f : A -> B -> C) -> State<S, A> -> State<S, B> -> State<S, C> {
		return { m1 in { m2 in m1 >>- { x1 in m2 >>- { x2 in State<S, C>.pure(f(x1)(x2)) } } } }
	}

	public static func liftM3<B, C, D>(f : A -> B -> C -> D) -> State<S, A> -> State<S, B> -> State<S, C> -> State<S, D> {
		return { m1 in { m2 in { m3 in m1 >>- { x1 in m2 >>- { x2 in m3 >>- { x3 in State<S, D>.pure(f(x1)(x2)(x3)) } } } } } }
	}
}

public func >>->> <S, A, B, C>(f : A -> State<S, B>, g : B -> State<S, C>) -> (A -> State<S, C>) {
	return { x in f(x) >>- g }
}

public func <<-<< <S, A, B, C>(g : B -> State<S, C>, f : A -> State<S, B>) -> (A -> State<S, C>) {
	return f >>->> g
}
