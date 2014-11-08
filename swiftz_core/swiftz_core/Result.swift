//
//  Result.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

/// Result is similar to an Either, except specialized to have an Error case that can
/// only contain an NSError.
public enum Result<V> {
  case Error(NSError)
  case Value(Box<V>)

  public init(_ e: NSError?, _ v: V) {
    if let ex = e {
      self = Result.Error(ex)
    } else {
      self = Result.Value(Box(v))
    }
  }
  
  /// Converts a Result to a more general Either type.
  public func toEither() -> Either<NSError, V> {
    switch self {
    case let Error(e): return .Left(Box(e))
    case let Value(v): return Either.Right(Box(v.value))
    }
  }

  /// Much like the ?? operator for Optional types, takes a value and a function,
  /// and if the Result is Error, returns the error, otherwise maps the function over
  /// the value in Value and returns that value.
  public func fold<B>(value: B, f: V -> B) -> B {
    switch self {
    case Error(_): return value
    case let Value(v): return f(v.value)
    }
  }
  
  /// Named function for `>>-`. If the Result is Error, simply returns
  /// a New Error with the value of the receiver. If Value, applies the function `f`
  /// and returns the result.
  public func flatMap<S>(f: V -> Result<S>) -> Result<S> {
    return self >>- f
  }

  /// Creates an Error with the given value.
  public static func error(e: NSError) -> Result<V> {
    return .Error(e)
  }

  /// Creates a Value with the given value.
  public static func value(v: V) -> Result<V> {
    return .Value(Box(v))
  }
}

// Equatable
public func ==<V: Equatable>(lhs: Result<V>, rhs: Result<V>) -> Bool {
  switch (lhs, rhs) {
    case let (.Error(l), .Error(r)) where l == r: return true
    case let (.Value(l), .Value(r)) where l.value == r.value: return true
    default: return false
  }
}

public func !=<V: Equatable>(lhs: Result<V>, rhs: Result<V>) -> Bool {
  return !(lhs == rhs)
}

/// Applicative `pure` function, lifts a value into a Value.
public func pure<V>(a: V) -> Result<V> {
    return .Value(Box(a))
}

/// Functor `fmap`. If the Result is Error, ignores the function and returns the Error.
/// If the Result is Value, applies the function to the Right value and returns the result
/// in a new Value.
public func <^><VA, VB>(f: VA -> VB, a: Result<VA>) -> Result<VB> {
  switch a {
  case let .Error(l): return .Error(l)
  case let .Value(r): return Result.Value(Box(f(r.value)))
  }
}

/// Applicative Functor `apply`. Given an Result<VA -> VB> and an Result<VA>,
/// returns a Result<VB>. If the `f` or `a' param is an Error, simply returns an Error with the
/// same value. Otherwise the function taken from Value(f) is applied to the value from Value(a)
/// And a Value is returned.
public func <*><VA, VB>(f: Result<VA -> VB>, a: Result<VA>) -> Result<VB> {
  switch (a, f) {
  case let (.Error(l), _): return .Error(l)
  case let (.Value(r), .Error(m)): return .Error(m)
  case let (.Value(r), .Value(g)): return Result<VB>.Value(Box(g.value(r.value)))
  }
}

/// Monadic `bind`. Given an Result<VA>, and a function from VA -> Result<VB>,
/// applies the function `f` if `a` is Value, otherwise the function is ignored and an Error
/// with the Error value from `a` is returned.
public func >>-<VA, VB>(a: Result<VA>, f: VA -> Result<VB>) -> Result<VB> {
  switch a {
  case let .Error(l): return .Error(l)
  case let .Value(r): return f(r.value)
  }
}
