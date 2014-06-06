//
//  Base.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

func identity<A>(a: A) -> A {
  return a;
}

func curry<A, B, C>(f: (A, B) -> C, a: A, b: B) -> C {
  return f((a, b))
}

func uncurry<A, B, C>(f: (A -> (B -> C)), ab: (A, B)) -> C {
  switch ab {
    case let (a, b): return (f(a)(b))
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

