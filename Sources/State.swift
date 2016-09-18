//
//  State.swift
//  Swiftz
//
//  Created by Robert Widmann on 2/21/15.
//  Copyright (c) 2015-2016 TypeLift. All rights reserved.
//

#if !XCODE_BUILD
	import Operadics
	import Swiftx
#endif

/// The State Monad represents a computation that threads a piece of state 
/// through each step.
public struct State<S, A> {
	public let runState : (S) -> (A, S)

	/// Creates a new State Monad given a function from a piece of state to a 
	/// value and an updated state.
	public init(_ runState : @escaping (S) -> (A, S)) {
		self.runState = runState
	}

	/// Evaluates the computation given an initial state then returns a final 
	/// value after running each step.
	public func eval(s : S) -> A {
		return self.runState(s).0
	}

	/// Evaluates the computation given an initial state then returns the final 
	/// state after running each step.
	public func exec(s : S) -> S {
		return self.runState(s).1
	}

	/// Executes an action that can modify the inner state.
	public func withState(_ f : @escaping (S) -> S) -> State<S, A> {
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
public func gets<S, A>(_ f : @escaping (S) -> A) -> State<S, A> {
	return State { s in (f(s), s) }
}

/// Updates the state with the result of executing the given function.
public func modify<S>(_ f : @escaping (S) -> S) -> State<S, ()> {
	return State<S, ()> { s in ((), f(s)) }
}


extension State /*: Functor*/ {
	public typealias B = Any
	public typealias FB = State<S, B>

	public func fmap<B>(_ f : @escaping (A) -> B) -> State<S, B> {
		return State<S, B> { s in
			let (val, st2) = self.runState(s)
			return (f(val), st2)
		}
	}
}

public func <^> <S, A, B>(_ f : @escaping (A) -> B, s : State<S, A>) -> State<S, B> {
	return s.fmap(f)
}

extension State /*: Pointed*/ {
	public static func pure(_ x : A) -> State<S, A> {
		return State { s in (x, s) }
	}
}

extension State /*: Applicative*/ {
	public typealias FAB = State<S, (A) -> B>

	public func ap<B>(_ stfn : State<S, (A) -> B>) -> State<S, B> {
		return stfn.bind { f in
			return self.bind { a in
				return State<S, B>.pure(f(a))
			}
		}
	}
}

public func <*> <S, A, B>(_ f : State<S, (A) -> B> , s : State<S, A>) -> State<S, B> {
	return s.ap(f)
}

extension State /*: Cartesian*/ {
	public typealias FTOP = State<S, ()>
	public typealias FTAB = State<S, (A, B)>
	public typealias FTABC = State<S, (A, B, C)>
	public typealias FTABCD = State<S, (A, B, C, D)>

	public static var unit : State<S, ()> { return State<S, ()> { s in ((), s) } }
	public func product<B>(r : State<S, B>) -> State<S, (A, B)> {
		return State<S, (A, B)> { c in
			let (d, _) = r.runState(c)
			let (e, f) = self.runState(c)
			return ((e, d), f)
		}
	}
	
	public func product<B, C>(r : State<S, B>, _ s : State<S, C>) -> State<S, (A, B, C)> {
		return State<S, (A, B, C)> { c in
			let (d, _) = s.runState(c)
			let (e, _) = r.runState(c)
			let (f, g) = self.runState(c)
			return ((f, e, d), g)
		}
	}
	
	public func product<B, C, D>(r : State<S, B>, _ s : State<S, C>, _ t : State<S, D>) -> State<S, (A, B, C, D)> {
		return State<S, (A, B, C, D)> { c in
			let (d, _) = t.runState(c)
			let (e, _) = s.runState(c)
			let (f, _) = r.runState(c)
			let (g, h) = self.runState(c)
			return ((g, f, e, d), h)
		}
	}
}

extension State /*: ApplicativeOps*/ {
	public typealias C = Any
	public typealias FC = State<S, C>
	public typealias D = Any
	public typealias FD = State<S, D>

	public static func liftA<B>(_ f : @escaping (A) -> B) -> (State<S, A>) -> State<S, B> {
		return { (a : State<S, A>) -> State<S, B> in State<S, (A) -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (State<S, A>) -> (State<S, B>) -> State<S, C> {
		return { (a : State<S, A>) -> (State<S, B>) -> State<S, C> in { (b : State<S, B>) -> State<S, C> in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (State<S, A>) -> (State<S, B>) -> (State<S, C>) -> State<S, D> {
		return { (a : State<S, A>) -> (State<S, B>) -> (State<S, C>) -> State<S, D> in { (b : State<S, B>) -> (State<S, C>) -> State<S, D> in { (c : State<S, C>) -> State<S, D> in f <^> a <*> b <*> c } } }
	}
}

extension State /*: Monad*/ {
	public func bind<B>(_ f : @escaping (A) -> State<S, B>) -> State<S, B> {
		return State<S, B> { s in
			let (a, s2) = self.runState(s)
			return f(a).runState(s2)
		}
	}
}

public func >>- <S, A, B>(xs : State<S, A>, f : @escaping (A) -> State<S, B>) -> State<S, B> {
	return xs.bind(f)
}

extension State /*: MonadOps*/ {
	public static func liftM<B>(_ f : @escaping (A) -> B) -> (State<S, A>) -> State<S, B> {
		return { (m1 : State<S, A>) -> State<S, B> in m1 >>- { (x1 : A) in State<S, B>.pure(f(x1)) } }
	}

	public static func liftM2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (State<S, A>) -> (State<S, B>) -> State<S, C> {
		return { (m1 : State<S, A>) -> (State<S, B>) -> State<S, C> in { (m2 : State<S, B>) -> State<S, C> in m1 >>- { (x1 : A) in m2 >>- { (x2 : B) in State<S, C>.pure(f(x1)(x2)) } } } }
	}

	public static func liftM3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (State<S, A>) -> (State<S, B>) -> (State<S, C>) -> State<S, D> {
		return { (m1 : State<S, A>) -> (State<S, B>) -> (State<S, C>) -> State<S, D> in { (m2 : State<S, B>) -> (State<S, C>) -> State<S, D> in { (m3 : State<S, C>) -> State<S, D> in m1 >>- { (x1 : A) in m2 >>- { (x2 : B) in m3 >>- { (x3 : C) in State<S, D>.pure(f(x1)(x2)(x3)) } } } } } }
	}
}

public func >>->> <S, A, B, C>(_ f : @escaping (A) -> State<S, B>, g : @escaping (B) -> State<S, C>) -> ((A) -> State<S, C>) {
	return { x in f(x) >>- g }
}

public func <<-<< <S, A, B, C>(g : @escaping (B) -> State<S, C>, f : @escaping (A) -> State<S, B>) -> ((A) -> State<S, C>) {
	return f >>->> g
}

public func sequence<S, A>(_ ms : [State<S, A>]) -> State<S, [A]> {
	return ms.reduce(State<S, [A]>.pure([]), { n, m in
		return n.bind { xs in
			return m.bind { x in
				return State<S, [A]>.pure(xs + [x])
			}
		}
	})
}
