// Playground - noun: a place where people can play

import Cocoa

enum List<T> {
    case Nil
    case Cons(T, List<T>)
}

let l1: List<Int> = List.Cons(0, List.Nil)

println(l1)

