//
//  Base.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// the building blocks of FP

func flip<A, B, C>(f: ((A, B) -> C), b: B, a: A) -> C {
  return f(a, b)
}

func identity<A>(a: A) -> A {
  return a;
}

// Function composition
operator infix .... {
  associativity right
}

func ....<A, B, C>(f: B -> C, g: A -> B)  -> A -> C {
    return { (a: A) -> C in
        return f(g(a))
    }
}

func comp<A, B, C>(f: B -> C) -> (A -> B) -> A -> C {
  return { (g: (A -> B)) -> A -> C in
    return { (a: A) -> C in
      return f(g(a))
    }
  }
}

operator infix |> {
  associativity left
}
operator infix ▹ {
  associativity left
}
//operator infix <| {}
//operator infix ◃ {}

// Thrush
func |><A, B>(a: A, f: A -> B) -> B {
  return f(a)
}

func ▹<A, B>(a: A, f: A -> B) -> B {
  return f(a)
}

// Unsafe tap
// Warning: Unstable rdar://17109199
//func unsafeTap<A>(a: A, f: A -> Any) -> A {
//  f(a)
//  return a
//}
//
//func <|<A>(a: A, f: A -> Any) -> A {
//  f(a)
//  return a
//}
//
//func ◃<A>(a: A, f: A -> Any) -> A {
//  f(a)
//  return a
//}


operator infix <^> {
  associativity left
}

operator infix <^^> {
  associativity left
}

operator infix <!> {
  associativity left
}

operator infix <*> {
  associativity left
}

// Optional

func pure<A>(a: A) -> A? {
  return a
}

func <^><A, B>(f: A -> B, a: A?) -> B? {
  if let x = a {
    return (f(x))
  } else {
    return .None
  }
}

func <*><A, B>(f: (A -> B)?, a: A?) -> B? {
  if f && a {
    return (f!(a!))
  } else {
    return .None
  }
}

// the "if the arg is Some, apply the function that returns an optional
// value and if the arg is None, just return None" function.
func >>=<A, B>(a: A?, f: A -> B?) -> B? {
  if let x = a {
    return f(x)
  } else {
    return .None
  }
}

// array

func pure<A>(a: A) -> Array<A> {
  var v = Array<A>()
  v.append(a)
  return v
}

// Note well! This is not map! Map mutates the array, this copies it.
func <^><A, B>(f: A -> B, a: Array<A>) -> Array<B> {
  var xs = Array<B>()
  for x in a {
    xs.append(f(x))
  }
  return xs
}

func <*><A, B>(f: Array<A -> B>, a: Array<A>) -> Array<B> {
  var re = Array<B>()
  for g in f {
    for h in a {
      re.append(g(h))
    }
  }
  return re
}

func >>=<A, B>(a: Array<A>, f: A -> Array<B>) -> Array<B> {
  var re = Array<B>()
  for x in a {
    re.extend(f(x))
  }
  return re
}
