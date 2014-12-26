//
//  Sections.swift
//  swiftz
//
//  Created by Robert Widmann on 11/18/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//


// Operators

prefix operator • {}
postfix operator • {}

prefix operator § {}
postfix operator § {}

prefix operator |> {}
postfix operator |> {}

prefix operator <| {}
postfix operator <| {}

// "fmap" like
prefix operator <^> {}
postfix operator <^> {}

// "imap" like
prefix operator <^^> {}
postfix operator <^^> {}

// "contramap" like
prefix operator <!> {}
postfix operator <!> {}

// "ap" like
prefix operator <*> {}
postfix operator <*> {}

// "extend" like
prefix operator ->> {}
postfix operator ->> {}

/// Monadic bind
prefix operator >>- {}
postfix operator >>- {}



/// MARK: functions as a monad and profunctor

// •
public func <^><I, A, B>(f: A -> B, k: I -> A) -> (I -> B) {
	return { x in f(k(x)) }
}

// flip(•)
public func <!><I, J, A>(f: J -> I, k: I -> A) -> (J -> A) {
	return { x in k(f(x)) }
}

// the S combinator
public func <*><I, A, B>(f: I -> (A -> B), k: I -> A) -> (I -> B) {
	return { x in f(x)(k(x)) }
}

// the S' combinator
public func >>-<I, A, B>(f: A -> (I -> B), k: I -> A) -> (I -> B) {
	return { x in f(k(x))(x) }
}

/// MARK: Sections

public prefix func •<A, B, C>(g : A -> B) -> (B -> C) -> A -> C {
	return { f in { a in f(g(a)) } }
}

public postfix func •<A, B, C>(f: B -> C) -> (A -> B) -> A -> C {
	return { g in { a in f(g(a)) } }
}

public prefix func §<A, B>(a: A) -> (A -> B) -> B {
	return { f in f(a) }
}

public postfix func §<A, B>(f: A -> B) -> A -> B {
	return { a in f(a) }
}

public prefix func <|<A, B>(a: A) -> (A -> B) -> B {
	return { f in f(a) }
}

public postfix func <|<A, B>(f: A -> B) -> A -> B {
	return { a in f(a) }
}

public prefix func |><A, B>(f: A -> B) -> A -> B {
	return { a in f(a) }
}

public postfix func |><A, B>(a: A) -> (A -> B) -> B {
	return { f in f(a) }
}

public prefix func <^><I, A, B>(k: I -> A) -> (A -> B) -> (I -> B) {
	return { f in { x in f(k(x)) } }
}

public postfix func <^><I, A, B>(f: A -> B) -> (I -> A) -> (I -> B) {
	return { k in { x in f(k(x)) } }
}

public prefix func <!><I, J, A>(k: I -> A) -> (J -> I) -> (J -> A) {
	return { f in { x in k(f(x)) } }
}

public postfix func <!><I, J, A>(f: J -> I) -> (I -> A) -> (J -> A) {
	return { k in { x in k(f(x)) } }
}

public prefix func <*><I, A, B>(k: I -> A) -> (I -> (A -> B)) -> (I -> B) {
	return { f in { x in f(x)(k(x)) } }
}

public postfix func <*><I, A, B>(f: I -> (A -> B)) -> (I -> A) -> (I -> B) {
	return { k in { x in f(x)(k(x)) } }
}

public prefix func >>-<I, A, B>(k: I -> A) -> (A -> (I -> B)) -> (I -> B) {
	return { f in { x in f(k(x))(x) } }
}

public postfix func >>-<I, A, B>(f: A -> (I -> B)) -> (I -> A) -> (I -> B) {
	return { k in { x in f(k(x))(x) } }
}

/// MARK: Core

prefix operator >> {}
postfix operator >> {}

public prefix func >>(rhs: UInt16) -> UInt16 -> UInt16 {
	return { lhs in lhs >> rhs }
}

public postfix func >>(lhs: UInt16) -> UInt16 -> UInt16 {
	return { rhs in lhs >> rhs }
}

public prefix func >>(rhs: UInt8) -> UInt8 -> UInt8 {
	return { lhs in lhs >> rhs }
}

public postfix func >>(lhs: UInt8) -> UInt8 -> UInt8 {
	return { rhs in lhs >> rhs }
}

public prefix func >>(rhs: Int8) -> Int8 -> Int8 {
	return { lhs in lhs >> rhs }
}

public postfix func >>(lhs: Int8) -> Int8 -> Int8 {
	return { rhs in lhs >> rhs }
}

public prefix func >>(rhs: Int16) -> Int16 -> Int16 {
	return { lhs in lhs >> rhs }
}

public postfix func >>(lhs: Int16) -> Int16 -> Int16 {
	return { rhs in lhs >> rhs }
}

public prefix func >>(rhs: UInt32) -> UInt32 -> UInt32 {
	return { lhs in lhs >> rhs }
}

public postfix func >>(lhs: UInt32) -> UInt32 -> UInt32 {
	return { rhs in lhs >> rhs }
}

public prefix func >>(rhs: Int32) -> Int32 -> Int32 {
	return { lhs in lhs >> rhs }
}

public postfix func >>(lhs: Int32) -> Int32 -> Int32 {
	return { rhs in lhs >> rhs }
}

public prefix func >>(rhs: UInt64) -> UInt64 -> UInt64 {
	return { lhs in lhs >> rhs }
}

public postfix func >>(lhs: UInt64) -> UInt64 -> UInt64 {
	return { rhs in lhs >> rhs }
}

public prefix func >>(rhs: Int64) -> Int64 -> Int64 {
	return { lhs in lhs >> rhs }
}

public postfix func >>(lhs: Int64) -> Int64 -> Int64 {
	return { rhs in lhs >> rhs }
}

public prefix func >>(rhs: UInt) -> UInt -> UInt {
	return { lhs in lhs >> rhs }
}

public postfix func >>(lhs: UInt) -> UInt -> UInt {
	return { rhs in lhs >> rhs }
}

public prefix func >>(rhs: Int) -> Int -> Int {
	return { lhs in lhs >> rhs }
}

public postfix func >>(lhs: Int) -> Int -> Int {
	return { rhs in lhs >> rhs }
}

prefix operator << {}
postfix operator << {}

public prefix func <<(rhs: UInt16) -> UInt16 -> UInt16 {
	return { lhs in lhs << rhs }
}

public postfix func <<(lhs: UInt16) -> UInt16 -> UInt16 {
	return { rhs in lhs << rhs }
}

public prefix func <<(rhs: UInt8) -> UInt8 -> UInt8 {
	return { lhs in lhs << rhs }
}

public postfix func <<(lhs: UInt8) -> UInt8 -> UInt8 {
	return { rhs in lhs << rhs }
}

public prefix func <<(rhs: Int8) -> Int8 -> Int8 {
	return { lhs in lhs << rhs }
}

public postfix func <<(lhs: Int8) -> Int8 -> Int8 {
	return { rhs in lhs << rhs }
}

public prefix func <<(rhs: Int16) -> Int16 -> Int16 {
	return { lhs in lhs << rhs }
}

public postfix func <<(lhs: Int16) -> Int16 -> Int16 {
	return { rhs in lhs << rhs }
}

public prefix func <<(rhs: UInt32) -> UInt32 -> UInt32 {
	return { lhs in lhs << rhs }
}

public postfix func <<(lhs: UInt32) -> UInt32 -> UInt32 {
	return { rhs in lhs << rhs }
}

public prefix func <<(rhs: Int32) -> Int32 -> Int32 {
	return { lhs in lhs << rhs }
}

public postfix func <<(lhs: Int32) -> Int32 -> Int32 {
	return { rhs in lhs << rhs }
}

public prefix func <<(rhs: UInt64) -> UInt64 -> UInt64 {
	return { lhs in lhs << rhs }
}

public postfix func <<(lhs: UInt64) -> UInt64 -> UInt64 {
	return { rhs in lhs << rhs }
}

public prefix func <<(rhs: Int64) -> Int64 -> Int64 {
	return { lhs in lhs << rhs }
}

public postfix func <<(lhs: Int64) -> Int64 -> Int64 {
	return { rhs in lhs << rhs }
}

public prefix func <<(rhs: UInt) -> UInt -> UInt {
	return { lhs in lhs << rhs }
}

public postfix func <<(lhs: UInt) -> UInt -> UInt {
	return { rhs in lhs << rhs }
}

public prefix func <<(rhs: Int) -> Int -> Int {
	return { lhs in lhs << rhs }
}

public postfix func <<(lhs: Int) -> Int -> Int {
	return { rhs in lhs << rhs }
}

prefix operator ... {}
postfix operator ... {}

public prefix func ...<T : Comparable>(end: T) -> T -> ClosedInterval<T> {
	return { start in start...end }
}

public postfix func ...<T : Comparable>(start: T) -> T -> ClosedInterval<T> {
	return { end in start...end }
}

public prefix func ...<Pos : ForwardIndexType where Pos : Comparable>(end: Pos) -> Pos -> Range<Pos> {
	return { start in start...end }
}

public postfix func ...<Pos : ForwardIndexType where Pos : Comparable>(start: Pos) -> Pos -> Range<Pos> {
	return { end in start...end }
}

public prefix func ...<Pos : ForwardIndexType>(maximum: Pos) -> Pos -> Range<Pos> {
	return { minimum in minimum...maximum }
}

public postfix func ...<Pos : ForwardIndexType>(minimum: Pos) -> Pos -> Range<Pos> {
	return { maximum in minimum...maximum }
}

prefix operator ..< {}
postfix operator ..< {}

public prefix func ..<<Pos : ForwardIndexType where Pos : Comparable>(end: Pos) -> Pos -> Range<Pos> {
	return { start in start..<end }
}

public postfix func ..<<Pos : ForwardIndexType where Pos : Comparable>(start: Pos) -> Pos -> Range<Pos> {
	return { end in start..<end }
}

public prefix func ..<<Pos : ForwardIndexType>(maximum: Pos) -> Pos -> Range<Pos> {
	return { minimum in minimum..<maximum }
}

public postfix func ..<<Pos : ForwardIndexType>(minimum: Pos) -> Pos -> Range<Pos> {
	return { maximum in minimum..<maximum }
}

prefix operator &% {}
postfix operator &% {}

public prefix func &%<T : _IntegerArithmeticType>(rhs: T) -> T -> T {
	return { lhs in lhs &% rhs }
}

public postfix func &%<T : _IntegerArithmeticType>(lhs: T) -> T -> T {
	return { rhs in lhs &% rhs }
}

prefix operator && {}
postfix operator && {}

public prefix func &&<T : BooleanType>(rhs: @autoclosure () -> Bool) -> T -> Bool {
	return { lhs in lhs && rhs }
}

public postfix func &&<T : BooleanType>(lhs: T) -> Bool -> Bool {
	return { rhs in lhs && rhs }
}

prefix operator &* {}
postfix operator &* {}

public prefix func &*<T : _IntegerArithmeticType>(rhs: T) -> T -> T {
	return { lhs in lhs &* rhs }
}

public postfix func &*<T : _IntegerArithmeticType>(lhs: T) -> T -> T {
	return { rhs in lhs &* rhs }
}

prefix operator &+ {}
postfix operator &+ {}

public prefix func &+<T : _IntegerArithmeticType>(rhs: T) -> T -> T {
	return { lhs in lhs &+ rhs }
}

public postfix func &+<T : _IntegerArithmeticType>(lhs: T) -> T -> T {
	return { rhs in lhs &+ rhs }
}

prefix operator &- {}
postfix operator &- {}

public prefix func &-<T : _IntegerArithmeticType>(rhs: T) -> T -> T {
	return { lhs in lhs &- rhs }
}

public postfix func &-<T : _IntegerArithmeticType>(lhs: T) -> T -> T {
	return { rhs in lhs &- rhs }
}

prefix operator &/ {}
postfix operator &/ {}

public prefix func &/<T : _IntegerArithmeticType>(rhs: T) -> T -> T {
	return { lhs in lhs &/ rhs }
}

public postfix func &/<T : _IntegerArithmeticType>(lhs: T) -> T -> T {
	return { rhs in lhs &/ rhs }
}

prefix operator ^ {}
postfix operator ^ {}

public prefix func ^<T : _RawOptionSetType>(b: T) -> T -> T {
	return { a in a ^ b }
}

public postfix func ^<T : _RawOptionSetType>(a: T) -> T -> T {
	return { b in a ^ b }
}

public prefix func ^(rhs: Bool) -> Bool -> Bool {
	return { lhs in lhs ^ rhs }
}

public postfix func ^(lhs: Bool) -> Bool -> Bool {
	return { rhs in lhs ^ rhs }
}

public prefix func ^(rhs: UInt8) -> UInt8 -> UInt8 {
	return { lhs in lhs ^ rhs }
}

public postfix func ^(lhs: UInt8) -> UInt8 -> UInt8 {
	return { rhs in lhs ^ rhs }
}

public prefix func ^(rhs: Int8) -> Int8 -> Int8 {
	return { lhs in lhs ^ rhs }
}

public postfix func ^(lhs: Int8) -> Int8 -> Int8 {
	return { rhs in lhs ^ rhs }
}

public prefix func ^(rhs: UInt16) -> UInt16 -> UInt16 {
	return { lhs in lhs ^ rhs }
}

public postfix func ^(lhs: UInt16) -> UInt16 -> UInt16 {
	return { rhs in lhs ^ rhs }
}

public prefix func ^(rhs: Int16) -> Int16 -> Int16 {
	return { lhs in lhs ^ rhs }
}

public postfix func ^(lhs: Int16) -> Int16 -> Int16 {
	return { rhs in lhs ^ rhs }
}

public prefix func ^(rhs: Int) -> Int -> Int {
	return { lhs in lhs ^ rhs }
}

public postfix func ^(lhs: Int) -> Int -> Int {
	return { rhs in lhs ^ rhs }
}

public prefix func ^(rhs: UInt) -> UInt -> UInt {
	return { lhs in lhs ^ rhs }
}

public postfix func ^(lhs: UInt) -> UInt -> UInt {
	return { rhs in lhs ^ rhs }
}

public prefix func ^(rhs: Int64) -> Int64 -> Int64 {
	return { lhs in lhs ^ rhs }
}

public postfix func ^(lhs: Int64) -> Int64 -> Int64 {
	return { rhs in lhs ^ rhs }
}

public prefix func ^(rhs: UInt64) -> UInt64 -> UInt64 {
	return { lhs in lhs ^ rhs }
}

public postfix func ^(lhs: UInt64) -> UInt64 -> UInt64 {
	return { rhs in lhs ^ rhs }
}

public prefix func ^(rhs: Int32) -> Int32 -> Int32 {
	return { lhs in lhs ^ rhs }
}

public postfix func ^(lhs: Int32) -> Int32 -> Int32 {
	return { rhs in lhs ^ rhs }
}

public prefix func ^(rhs: UInt32) -> UInt32 -> UInt32 {
	return { lhs in lhs ^ rhs }
}

public postfix func ^(lhs: UInt32) -> UInt32 -> UInt32 {
	return { rhs in lhs ^ rhs }
}

prefix operator | {}
postfix operator | {}

public prefix func |<T : _RawOptionSetType>(b: T) -> T -> T {
	return { a in a | b }
}

public postfix func |<T : _RawOptionSetType>(a: T) -> T -> T {
	return { b in a | b }
}

public prefix func |(rhs: Bool) -> Bool -> Bool {
	return { lhs in lhs | rhs }
}

public postfix func |(lhs: Bool) -> Bool -> Bool {
	return { rhs in lhs | rhs }
}

public prefix func |(rhs: UInt8) -> UInt8 -> UInt8 {
	return { lhs in lhs | rhs }
}

public postfix func |(lhs: UInt8) -> UInt8 -> UInt8 {
	return { rhs in lhs | rhs }
}

public prefix func |(rhs: Int8) -> Int8 -> Int8 {
	return { lhs in lhs | rhs }
}

public postfix func |(lhs: Int8) -> Int8 -> Int8 {
	return { rhs in lhs | rhs }
}

public prefix func |(rhs: UInt16) -> UInt16 -> UInt16 {
	return { lhs in lhs | rhs }
}

public postfix func |(lhs: UInt16) -> UInt16 -> UInt16 {
	return { rhs in lhs | rhs }
}

public prefix func |(rhs: Int16) -> Int16 -> Int16 {
	return { lhs in lhs | rhs }
}

public postfix func |(lhs: Int16) -> Int16 -> Int16 {
	return { rhs in lhs | rhs }
}

public prefix func |(rhs: Int) -> Int -> Int {
	return { lhs in lhs | rhs }
}

public postfix func |(lhs: Int) -> Int -> Int {
	return { rhs in lhs | rhs }
}

public prefix func |(rhs: UInt) -> UInt -> UInt {
	return { lhs in lhs | rhs }
}

public postfix func |(lhs: UInt) -> UInt -> UInt {
	return { rhs in lhs | rhs }
}

public prefix func |(rhs: Int64) -> Int64 -> Int64 {
	return { lhs in lhs | rhs }
}

public postfix func |(lhs: Int64) -> Int64 -> Int64 {
	return { rhs in lhs | rhs }
}

public prefix func |(rhs: UInt64) -> UInt64 -> UInt64 {
	return { lhs in lhs | rhs }
}

public postfix func |(lhs: UInt64) -> UInt64 -> UInt64 {
	return { rhs in lhs | rhs }
}

public prefix func |(rhs: Int32) -> Int32 -> Int32 {
	return { lhs in lhs | rhs }
}

public postfix func |(lhs: Int32) -> Int32 -> Int32 {
	return { rhs in lhs | rhs }
}

public prefix func |(rhs: UInt32) -> UInt32 -> UInt32 {
	return { lhs in lhs | rhs }
}

public postfix func |(lhs: UInt32) -> UInt32 -> UInt32 {
	return { rhs in lhs | rhs }
}

prefix operator ?? {}

public prefix func ??<T>(defaultValue: T) -> T? -> T {
	return { optional in optional ?? defaultValue }
}

public prefix func ??<T>(defaultValue: T?) -> T? -> T? {
	return { optional in optional ?? defaultValue }
}

prefix operator % {}
postfix operator % {}

public prefix func %(rhs: Int64) -> Int64 -> Int64 {
	return { lhs in lhs % rhs }
}

public postfix func %(lhs: Int64) -> Int64 -> Int64 {
	return { rhs in lhs % rhs }
}

public prefix func %(rhs: UInt8) -> UInt8 -> UInt8 {
	return { lhs in lhs % rhs }
}

public postfix func %(lhs: UInt8) -> UInt8 -> UInt8 {
	return { rhs in lhs % rhs }
}

public prefix func %(rhs: Int8) -> Int8 -> Int8 {
	return { lhs in lhs % rhs }
}

public postfix func %(lhs: Int8) -> Int8 -> Int8 {
	return { rhs in lhs % rhs }
}

public prefix func %(rhs: UInt32) -> UInt32 -> UInt32 {
	return { lhs in lhs % rhs }
}

public postfix func %(lhs: UInt32) -> UInt32 -> UInt32 {
	return { rhs in lhs % rhs }
}

public prefix func %(rhs: UInt16) -> UInt16 -> UInt16 {
	return { lhs in lhs % rhs }
}

public postfix func %(lhs: UInt16) -> UInt16 -> UInt16 {
	return { rhs in lhs % rhs }
}

public prefix func %<T : _IntegerArithmeticType>(rhs: T) -> T -> T {
	return { lhs in lhs % rhs }
}

public postfix func %<T : _IntegerArithmeticType>(lhs: T) -> T -> T {
	return { rhs in lhs % rhs }
}

public prefix func %(rhs: Swift.Float80) -> Swift.Float80 -> Swift.Float80 {
	return { lhs in lhs % rhs }
}

public postfix func %(lhs: Swift.Float80) -> Swift.Float80 -> Swift.Float80 {
	return { rhs in lhs % rhs }
}

public prefix func %(rhs: Double) -> Double -> Double {
	return { lhs in lhs % rhs }
}

public postfix func %(lhs: Double) -> Double -> Double {
	return { rhs in lhs % rhs }
}

public prefix func %(rhs: Float) -> Float -> Float {
	return { lhs in lhs % rhs }
}

public postfix func %(lhs: Float) -> Float -> Float {
	return { rhs in lhs % rhs }
}

public prefix func %(rhs: Int) -> Int -> Int {
	return { lhs in lhs % rhs }
}

public postfix func %(lhs: Int) -> Int -> Int {
	return { rhs in lhs % rhs }
}

public prefix func %(rhs: Int16) -> Int16 -> Int16 {
	return { lhs in lhs % rhs }
}

public postfix func %(lhs: Int16) -> Int16 -> Int16 {
	return { rhs in lhs % rhs }
}

public prefix func %(rhs: Int32) -> Int32 -> Int32 {
	return { lhs in lhs % rhs }
}

public postfix func %(lhs: Int32) -> Int32 -> Int32 {
	return { rhs in lhs % rhs }
}

public prefix func %(rhs: UInt64) -> UInt64 -> UInt64 {
	return { lhs in lhs % rhs }
}

public postfix func %(lhs: UInt64) -> UInt64 -> UInt64 {
	return { rhs in lhs % rhs }
}

public prefix func %(rhs: UInt) -> UInt -> UInt {
	return { lhs in lhs % rhs }
}

public postfix func %(lhs: UInt) -> UInt -> UInt {
	return { rhs in lhs % rhs }
}

prefix operator * {}
postfix operator * {}

public prefix func *(rhs: Int64) -> Int64 -> Int64 {
	return { lhs in lhs * rhs }
}

public postfix func *(lhs: Int64) -> Int64 -> Int64 {
	return { rhs in lhs * rhs }
}

public prefix func *(rhs: UInt8) -> UInt8 -> UInt8 {
	return { lhs in lhs * rhs }
}

public postfix func *(lhs: UInt8) -> UInt8 -> UInt8 {
	return { rhs in lhs * rhs }
}

public prefix func *(rhs: Int8) -> Int8 -> Int8 {
	return { lhs in lhs * rhs }
}

public postfix func *(lhs: Int8) -> Int8 -> Int8 {
	return { rhs in lhs * rhs }
}

public prefix func *(rhs: UInt32) -> UInt32 -> UInt32 {
	return { lhs in lhs * rhs }
}

public postfix func *(lhs: UInt32) -> UInt32 -> UInt32 {
	return { rhs in lhs * rhs }
}

public prefix func *(rhs: UInt16) -> UInt16 -> UInt16 {
	return { lhs in lhs * rhs }
}

public postfix func *(lhs: UInt16) -> UInt16 -> UInt16 {
	return { rhs in lhs * rhs }
}

public prefix func *<T : _IntegerArithmeticType>(rhs: T) -> T -> T {
	return { lhs in lhs * rhs }
}

public postfix func *<T : _IntegerArithmeticType>(lhs: T) -> T -> T {
	return { rhs in lhs * rhs }
}

public prefix func *(rhs: Swift.Float80) -> Swift.Float80 -> Swift.Float80 {
	return { lhs in lhs * rhs }
}

public postfix func *(lhs: Swift.Float80) -> Swift.Float80 -> Swift.Float80 {
	return { rhs in lhs * rhs }
}

public prefix func *(rhs: Double) -> Double -> Double {
	return { lhs in lhs * rhs }
}

public postfix func *(lhs: Double) -> Double -> Double {
	return { rhs in lhs * rhs }
}

public prefix func *(rhs: Float) -> Float -> Float {
	return { lhs in lhs * rhs }
}

public postfix func *(lhs: Float) -> Float -> Float {
	return { rhs in lhs * rhs }
}

public prefix func *(rhs: Int) -> Int -> Int {
	return { lhs in lhs * rhs }
}

public postfix func *(lhs: Int) -> Int -> Int {
	return { rhs in lhs * rhs }
}

public prefix func *(rhs: Int16) -> Int16 -> Int16 {
	return { lhs in lhs * rhs }
}

public postfix func *(lhs: Int16) -> Int16 -> Int16 {
	return { rhs in lhs * rhs }
}

public prefix func *(rhs: Int32) -> Int32 -> Int32 {
	return { lhs in lhs * rhs }
}

public postfix func *(lhs: Int32) -> Int32 -> Int32 {
	return { rhs in lhs * rhs }
}

public prefix func *(rhs: UInt64) -> UInt64 -> UInt64 {
	return { lhs in lhs * rhs }
}

public postfix func *(lhs: UInt64) -> UInt64 -> UInt64 {
	return { rhs in lhs * rhs }
}

public prefix func *(rhs: UInt) -> UInt -> UInt {
	return { lhs in lhs * rhs }
}

public postfix func *(lhs: UInt) -> UInt -> UInt {
	return { rhs in lhs * rhs }
}

prefix operator + {}
postfix operator + {}

public prefix func +(rhs: Int64) -> Int64 -> Int64 {
	return { lhs in lhs + rhs }
}

public postfix func +(lhs: Int64) -> Int64 -> Int64 {
	return { rhs in lhs + rhs }
}

public prefix func +(rhs: UInt8) -> UInt8 -> UInt8 {
	return { lhs in lhs + rhs }
}

public postfix func +(lhs: UInt8) -> UInt8 -> UInt8 {
	return { rhs in lhs + rhs }
}

public prefix func +(rhs: Int8) -> Int8 -> Int8 {
	return { lhs in lhs + rhs }
}

public postfix func +(lhs: Int8) -> Int8 -> Int8 {
	return { rhs in lhs + rhs }
}

public prefix func +(rhs: UInt32) -> UInt32 -> UInt32 {
	return { lhs in lhs + rhs }
}

public postfix func +(lhs: UInt32) -> UInt32 -> UInt32 {
	return { rhs in lhs + rhs }
}

public prefix func +(rhs: UInt16) -> UInt16 -> UInt16 {
	return { lhs in lhs + rhs }
}

public postfix func +(lhs: UInt16) -> UInt16 -> UInt16 {
	return { rhs in lhs + rhs }
}

public prefix func +<T : _IntegerArithmeticType>(rhs: T) -> T -> T {
	return { lhs in lhs + rhs }
}

public postfix func +<T : _IntegerArithmeticType>(lhs: T) -> T -> T {
	return { rhs in lhs + rhs }
}

public prefix func +(rhs: Swift.Float80) -> Swift.Float80 -> Swift.Float80 {
	return { lhs in lhs + rhs }
}

public postfix func +(lhs: Swift.Float80) -> Swift.Float80 -> Swift.Float80 {
	return { rhs in lhs + rhs }
}

public prefix func +(rhs: Double) -> Double -> Double {
	return { lhs in lhs + rhs }
}

public postfix func +(lhs: Double) -> Double -> Double {
	return { rhs in lhs + rhs }
}

public prefix func +(rhs: Float) -> Float -> Float {
	return { lhs in lhs + rhs }
}

public postfix func +(lhs: Float) -> Float -> Float {
	return { rhs in lhs + rhs }
}

public prefix func +(rhs: Int) -> Int -> Int {
	return { lhs in lhs + rhs }
}

public postfix func +(lhs: Int) -> Int -> Int {
	return { rhs in lhs + rhs }
}

public prefix func +(rhs: Int16) -> Int16 -> Int16 {
	return { lhs in lhs + rhs }
}

public postfix func +(lhs: Int16) -> Int16 -> Int16 {
	return { rhs in lhs + rhs }
}

public prefix func +(rhs: Int32) -> Int32 -> Int32 {
	return { lhs in lhs + rhs }
}

public postfix func +(lhs: Int32) -> Int32 -> Int32 {
	return { rhs in lhs + rhs }
}

public prefix func +(rhs: UInt64) -> UInt64 -> UInt64 {
	return { lhs in lhs + rhs }
}

public postfix func +(lhs: UInt64) -> UInt64 -> UInt64 {
	return { rhs in lhs + rhs }
}

public prefix func +(rhs: UInt) -> UInt -> UInt {
	return { lhs in lhs + rhs }
}

public postfix func +(lhs: UInt) -> UInt -> UInt {
	return { rhs in lhs + rhs }
}

public prefix func +<T>(rhs: UnsafePointer<T>) -> Int -> UnsafePointer<T> {
	return { lhs in lhs + rhs }
}

public postfix func +<T>(lhs: Int) -> UnsafePointer<T> -> UnsafePointer<T> {
	return { rhs in lhs + rhs }
}

public prefix func +<T>(rhs: Int) -> UnsafePointer<T> -> UnsafePointer<T> {
	return { lhs in lhs + rhs }
}

public postfix func +<T>(lhs: UnsafePointer<T>) -> Int -> UnsafePointer<T> {
	return { rhs in lhs + rhs }
}

public prefix func +<T>(rhs: UnsafeMutablePointer<T>) -> Int -> UnsafeMutablePointer<T> {
	return { lhs in lhs + rhs }
}

public postfix func +<T>(lhs: Int) -> UnsafeMutablePointer<T> -> UnsafeMutablePointer<T> {
	return { rhs in lhs + rhs }
}

public prefix func +<T>(rhs: Int) -> UnsafeMutablePointer<T> -> UnsafeMutablePointer<T> {
	return { lhs in lhs + rhs }
}

public postfix func +<T>(lhs: UnsafeMutablePointer<T>) -> Int -> UnsafeMutablePointer<T> {
	return { rhs in lhs + rhs }
}

public prefix func +<T : Strideable>(rhs: T.Stride) -> T -> T {
	return { lhs in lhs + rhs }
}

public postfix func +<T : Strideable>(lhs: T) -> T.Stride -> T {
	return { rhs in lhs + rhs }
}

postfix operator - {}

public postfix func -(lhs: Int64) -> Int64 -> Int64 {
	return { rhs in lhs - rhs }
}

public postfix func -(lhs: UInt8) -> UInt8 -> UInt8 {
	return { rhs in lhs - rhs }
}

public postfix func -(lhs: Int8) -> Int8 -> Int8 {
	return { rhs in lhs - rhs }
}

public postfix func -(lhs: UInt32) -> UInt32 -> UInt32 {
	return { rhs in lhs - rhs }
}

public postfix func -(lhs: UInt16) -> UInt16 -> UInt16 {
	return { rhs in lhs - rhs }
}

public postfix func -<T : _IntegerArithmeticType>(lhs: T) -> T -> T {
	return { rhs in lhs - rhs }
}

public postfix func -(lhs: Swift.Float80) -> Swift.Float80 -> Swift.Float80 {
	return { rhs in lhs - rhs }
}

public postfix func -(lhs: Double) -> Double -> Double {
	return { rhs in lhs - rhs }
}

public postfix func -(lhs: Float) -> Float -> Float {
	return { rhs in lhs - rhs }
}

public postfix func -(lhs: Int) -> Int -> Int {
	return { rhs in lhs - rhs }
}

public postfix func -(lhs: Int16) -> Int16 -> Int16 {
	return { rhs in lhs - rhs }
}

public postfix func -(lhs: Int32) -> Int32 -> Int32 {
	return { rhs in lhs - rhs }
}

public postfix func -(lhs: UInt64) -> UInt64 -> UInt64 {
	return { rhs in lhs - rhs }
}

public postfix func -(lhs: UInt) -> UInt -> UInt {
	return { rhs in lhs - rhs }
}

public postfix func -<T>(lhs: UnsafePointer<T>) -> Int -> UnsafePointer<T> {
	return { rhs in lhs - rhs }
}

public postfix func -<T>(lhs: UnsafeMutablePointer<T>) -> Int -> UnsafeMutablePointer<T> {
	return { rhs in lhs - rhs }
}

public postfix func -<T : Strideable>(lhs: T) -> T.Stride -> T {
	return { rhs in lhs - rhs }
}

prefix operator / {}
postfix operator / {}

public prefix func /(rhs: Int64) -> Int64 -> Int64 {
	return { lhs in lhs / rhs }
}

public postfix func /(lhs: Int64) -> Int64 -> Int64 {
	return { rhs in lhs / rhs }
}

public prefix func /(rhs: UInt8) -> UInt8 -> UInt8 {
	return { lhs in lhs / rhs }
}

public postfix func /(lhs: UInt8) -> UInt8 -> UInt8 {
	return { rhs in lhs / rhs }
}

public prefix func /(rhs: Int8) -> Int8 -> Int8 {
	return { lhs in lhs / rhs }
}

public postfix func /(lhs: Int8) -> Int8 -> Int8 {
	return { rhs in lhs / rhs }
}

public prefix func /(rhs: UInt32) -> UInt32 -> UInt32 {
	return { lhs in lhs / rhs }
}

public postfix func /(lhs: UInt32) -> UInt32 -> UInt32 {
	return { rhs in lhs / rhs }
}

public prefix func /(rhs: UInt16) -> UInt16 -> UInt16 {
	return { lhs in lhs / rhs }
}

public postfix func /(lhs: UInt16) -> UInt16 -> UInt16 {
	return { rhs in lhs / rhs }
}

public prefix func /<T : _IntegerArithmeticType>(rhs: T) -> T -> T {
	return { lhs in lhs / rhs }
}

public postfix func /<T : _IntegerArithmeticType>(lhs: T) -> T -> T {
	return { rhs in lhs / rhs }
}

public prefix func /(rhs: Swift.Float80) -> Swift.Float80 -> Swift.Float80 {
	return { lhs in lhs / rhs }
}

public postfix func /(lhs: Swift.Float80) -> Swift.Float80 -> Swift.Float80 {
	return { rhs in lhs / rhs }
}

public prefix func /(rhs: Double) -> Double -> Double {
	return { lhs in lhs / rhs }
}

public postfix func /(lhs: Double) -> Double -> Double {
	return { rhs in lhs / rhs }
}

public prefix func /(rhs: Float) -> Float -> Float {
	return { lhs in lhs / rhs }
}

public postfix func /(lhs: Float) -> Float -> Float {
	return { rhs in lhs / rhs }
}

public prefix func /(rhs: Int) -> Int -> Int {
	return { lhs in lhs / rhs }
}

public postfix func /(lhs: Int) -> Int -> Int {
	return { rhs in lhs / rhs }
}

public prefix func /(rhs: Int16) -> Int16 -> Int16 {
	return { lhs in lhs / rhs }
}

public postfix func /(lhs: Int16) -> Int16 -> Int16 {
	return { rhs in lhs / rhs }
}

public prefix func /(rhs: Int32) -> Int32 -> Int32 {
	return { lhs in lhs / rhs }
}

public postfix func /(lhs: Int32) -> Int32 -> Int32 {
	return { rhs in lhs / rhs }
}

public prefix func /(rhs: UInt64) -> UInt64 -> UInt64 {
	return { lhs in lhs / rhs }
}

public postfix func /(lhs: UInt64) -> UInt64 -> UInt64 {
	return { rhs in lhs / rhs }
}

public prefix func /(rhs: UInt) -> UInt -> UInt {
	return { lhs in lhs / rhs }
}

public postfix func /(lhs: UInt) -> UInt -> UInt {
	return { rhs in lhs / rhs }
}

prefix operator === {}
postfix operator === {}

public prefix func ===(rhs: AnyObject?) -> AnyObject? -> Bool {
	return { lhs in lhs === rhs }
}

public postfix func ===(lhs: AnyObject?) -> AnyObject? -> Bool {
	return { rhs in lhs === rhs }
}

prefix operator !== {}
postfix operator !== {}

public prefix func !==(rhs: AnyObject?) -> AnyObject? -> Bool {
	return { lhs in lhs === rhs }
}

public postfix func !==(lhs: AnyObject?) -> AnyObject? -> Bool {
	return { rhs in lhs === rhs }
}

prefix operator == {}
postfix operator == {}

public postfix func ==(lhs: Int64) -> Int64 -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: Int64) -> Int64 -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==<T>(lhs: UnsafePointer<T>) -> UnsafePointer<T> -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==<T>(rhs: UnsafePointer<T>) -> UnsafePointer<T> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==(lhs: Bit) -> Bit -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: Bit) -> Bit -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==(lhs: UInt) -> UInt -> Bool {
	return { rhs in lhs == rhs }
}
public prefix func ==(rhs: UInt) -> UInt -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==(lhs: Int) -> Int -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: Int) -> Int -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==<Base : CollectionType>(lhs: FilterCollectionViewIndex<Base>) -> FilterCollectionViewIndex<Base> -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==<Base : CollectionType>(rhs: FilterCollectionViewIndex<Base>) -> FilterCollectionViewIndex<Base> -> Bool {
	return { lhs in lhs == rhs }
}

public prefix func ==(rhs: Float) -> Float -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==(lhs: Float) -> Float -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==<Key : Equatable, Value : Equatable>(rhs: [Key : Value]) -> [Key : Value] -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==<Key : Equatable, Value : Equatable>(lhs: [Key : Value]) -> [Key : Value] -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==<Key : Hashable, Value>(rhs: DictionaryIndex<Key, Value>) -> DictionaryIndex<Key, Value> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==<Key : Hashable, Value>(lhs: DictionaryIndex<Key, Value>) -> DictionaryIndex<Key, Value> -> Bool {
	return { rhs in lhs == rhs }
}

public postfix func ==(lhs: Double) -> Double -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: Double) -> Double -> Bool {
	return { lhs in lhs == rhs }
}

public prefix func ==<T : _RawOptionSetType>(b: T) -> T -> Bool {
	return { a in a == b }
}

public postfix func ==<T : _RawOptionSetType>(a: T) -> T -> Bool {
	return { b in a == b }
}

public postfix func ==(lhs: Character) -> Character -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: Character) -> Character -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==(lhs: Swift.Float80) -> Swift.Float80 -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: Swift.Float80) -> Swift.Float80 -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==(lhs: FloatingPointClassification) -> FloatingPointClassification -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: FloatingPointClassification) -> FloatingPointClassification -> Bool {
	return { lhs in lhs == rhs }
}

public prefix func ==<Value, Element>(lhs: HeapBuffer<Value, Element>) -> HeapBuffer<Value, Element> -> Bool {
	return { rhs in lhs == rhs }
}

public postfix func ==<Value, Element>(lhs: HeapBuffer<Value, Element>) -> HeapBuffer<Value, Element> -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==<T>(rhs: CFunctionPointer<T>) -> CFunctionPointer<T> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==<T>(lhs: CFunctionPointer<T>) -> CFunctionPointer<T> -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==<T : Comparable>(rhs: HalfOpenInterval<T>) -> HalfOpenInterval<T> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==<T : Comparable>(lhs: HalfOpenInterval<T>) -> HalfOpenInterval<T> -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==<T : Comparable>(rhs: ClosedInterval<T>) -> ClosedInterval<T> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==<T : Comparable>(lhs: ClosedInterval<T>) -> ClosedInterval<T> -> Bool {
	return { rhs in lhs == rhs }
}

public postfix func ==(lhs: COpaquePointer) -> COpaquePointer -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: COpaquePointer) -> COpaquePointer -> Bool {
	return { lhs in lhs == rhs }
}

public prefix func ==<T : Equatable>(rhs: T?) -> T? -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==<T : Equatable>(lhs: T?) -> T? -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==<T>(rhs: AutoreleasingUnsafeMutablePointer<T>) -> AutoreleasingUnsafeMutablePointer<T> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==<T>(lhs: AutoreleasingUnsafeMutablePointer<T>) -> AutoreleasingUnsafeMutablePointer<T> -> Bool {
	return { rhs in lhs == rhs }
}

public postfix func ==(lhs: Bool) -> Bool -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: Bool) -> Bool -> Bool {
	return { lhs in lhs == rhs }
}

public prefix func ==<T : Equatable>(rhs: [T]) -> [T] -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==<T : Equatable>(lhs: [T]) -> [T] -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==<T : Equatable>(rhs: Slice<T>) -> Slice<T> -> Bool{
	return { lhs in lhs == rhs }
}

public postfix func ==<T : Equatable>(lhs: Slice<T>) -> Slice<T> -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==<T : Equatable>(rhs: ContiguousArray<T>) -> ContiguousArray<T> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==<T : Equatable>(lhs: ContiguousArray<T>) -> ContiguousArray<T> -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==<T>(rhs: _OptionalNilComparisonType) -> T? -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==<T>(lhs: T?) -> _OptionalNilComparisonType -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==<T>(rhs: T?) -> _OptionalNilComparisonType -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==<T>(lhs: _OptionalNilComparisonType) -> T? -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==<T>(lhs: Range<T>) -> Range<T> -> Bool {
	return { rhs in lhs == rhs }
}

public postfix func ==<T>(lhs: Range<T>) -> Range<T> -> Bool {
	return { rhs in lhs == rhs }
}

public postfix func ==(lhs: UInt64) -> UInt64 -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: UInt64) -> UInt64 -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==(lhs: Int32) -> Int32 -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: Int32) -> Int32 -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==(lhs: UInt32) -> UInt32 -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: UInt32) -> UInt32 -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==(lhs: Int16) -> Int16 -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: Int16) -> Int16 -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==(lhs: UInt16) -> UInt16 -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: UInt16) -> UInt16 -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==(lhs: Int8) -> Int8 -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: Int8) -> Int8 -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==(lhs: UInt8) -> UInt8 -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: UInt8) -> UInt8 -> Bool {
	return { lhs in lhs == rhs }
}

public prefix func ==(y: ObjectIdentifier) -> ObjectIdentifier -> Bool {
	return { x in x == y }
}

public postfix func ==(x: ObjectIdentifier) -> ObjectIdentifier -> Bool {
	return { y in x == y }
}

public prefix func ==<I>(rhs: ReverseBidirectionalIndex<I>) -> ReverseBidirectionalIndex<I> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==<I>(lhs: ReverseBidirectionalIndex<I>) -> ReverseBidirectionalIndex<I> -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==<I>(rhs: ReverseRandomAccessIndex<I>) -> ReverseRandomAccessIndex<I> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==<I>(lhs: ReverseRandomAccessIndex<I>) -> ReverseRandomAccessIndex<I> -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==<T : _Strideable>(y: T) -> T -> Bool {
	return { x in x == y }
}

public postfix func ==<T : _Strideable>(x: T) -> T -> Bool {
	return { y in x == y }
}

public postfix func ==(lhs: String) -> String -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: String) -> String -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==(lhs: String.Index) -> String.Index -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: String.Index) -> String.Index -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==(lhs: String.UTF8View.Index) -> String.UTF8View.Index -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: String.UTF8View.Index) -> String.UTF8View.Index -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==(lhs: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==(lhs: UnicodeScalar) -> UnicodeScalar -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func ==(rhs: UnicodeScalar) -> UnicodeScalar -> Bool {
	return { lhs in lhs == rhs }
}

public prefix func ==<T>(rhs: UnsafeMutablePointer<T>) -> UnsafeMutablePointer<T> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func ==<T>(lhs: UnsafeMutablePointer<T>) -> UnsafeMutablePointer<T> -> Bool {
	return { rhs in lhs == rhs }
}

prefix operator != {}
postfix operator != {}

public postfix func !=(lhs: Int64) -> Int64 -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: Int64) -> Int64 -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=<T>(lhs: UnsafePointer<T>) -> UnsafePointer<T> -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=<T>(rhs: UnsafePointer<T>) -> UnsafePointer<T> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=(lhs: Bit) -> Bit -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: Bit) -> Bit -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=(lhs: UInt) -> UInt -> Bool {
	return { rhs in lhs == rhs }
}
public prefix func !=(rhs: UInt) -> UInt -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=(lhs: Int) -> Int -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: Int) -> Int -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=<Base : CollectionType>(lhs: FilterCollectionViewIndex<Base>) -> FilterCollectionViewIndex<Base> -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=<Base : CollectionType>(rhs: FilterCollectionViewIndex<Base>) -> FilterCollectionViewIndex<Base> -> Bool {
	return { lhs in lhs == rhs }
}

public prefix func !=(rhs: Float) -> Float -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=(lhs: Float) -> Float -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=<Key : Equatable, Value : Equatable>(rhs: [Key : Value]) -> [Key : Value] -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=<Key : Equatable, Value : Equatable>(lhs: [Key : Value]) -> [Key : Value] -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=<Key : Hashable, Value>(rhs: DictionaryIndex<Key, Value>) -> DictionaryIndex<Key, Value> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=<Key : Hashable, Value>(lhs: DictionaryIndex<Key, Value>) -> DictionaryIndex<Key, Value> -> Bool {
	return { rhs in lhs == rhs }
}

public postfix func !=(lhs: Double) -> Double -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: Double) -> Double -> Bool {
	return { lhs in lhs == rhs }
}

public prefix func !=<T : _RawOptionSetType>(b: T) -> T -> Bool {
	return { a in a == b }
}

public postfix func !=<T : _RawOptionSetType>(a: T) -> T -> Bool {
	return { b in a == b }
}

public postfix func !=(lhs: Character) -> Character -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: Character) -> Character -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=(lhs: Swift.Float80) -> Swift.Float80 -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: Swift.Float80) -> Swift.Float80 -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=(lhs: FloatingPointClassification) -> FloatingPointClassification -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: FloatingPointClassification) -> FloatingPointClassification -> Bool {
	return { lhs in lhs == rhs }
}

public prefix func !=<Value, Element>(lhs: HeapBuffer<Value, Element>) -> HeapBuffer<Value, Element> -> Bool {
	return { rhs in lhs == rhs }
}

public postfix func !=<Value, Element>(lhs: HeapBuffer<Value, Element>) -> HeapBuffer<Value, Element> -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=<T>(rhs: CFunctionPointer<T>) -> CFunctionPointer<T> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=<T>(lhs: CFunctionPointer<T>) -> CFunctionPointer<T> -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=<T : Comparable>(rhs: HalfOpenInterval<T>) -> HalfOpenInterval<T> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=<T : Comparable>(lhs: HalfOpenInterval<T>) -> HalfOpenInterval<T> -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=<T : Comparable>(rhs: ClosedInterval<T>) -> ClosedInterval<T> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=<T : Comparable>(lhs: ClosedInterval<T>) -> ClosedInterval<T> -> Bool {
	return { rhs in lhs == rhs }
}

public postfix func !=(lhs: COpaquePointer) -> COpaquePointer -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: COpaquePointer) -> COpaquePointer -> Bool {
	return { lhs in lhs == rhs }
}

public prefix func !=<T : Equatable>(rhs: T?) -> T? -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=<T : Equatable>(lhs: T?) -> T? -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=<T>(rhs: AutoreleasingUnsafeMutablePointer<T>) -> AutoreleasingUnsafeMutablePointer<T> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=<T>(lhs: AutoreleasingUnsafeMutablePointer<T>) -> AutoreleasingUnsafeMutablePointer<T> -> Bool {
	return { rhs in lhs == rhs }
}

public postfix func !=(lhs: Bool) -> Bool -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: Bool) -> Bool -> Bool {
	return { lhs in lhs == rhs }
}

public prefix func !=<T : Equatable>(rhs: [T]) -> [T] -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=<T : Equatable>(lhs: [T]) -> [T] -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=<T : Equatable>(rhs: Slice<T>) -> Slice<T> -> Bool{
	return { lhs in lhs == rhs }
}

public postfix func !=<T : Equatable>(lhs: Slice<T>) -> Slice<T> -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=<T : Equatable>(rhs: ContiguousArray<T>) -> ContiguousArray<T> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=<T : Equatable>(lhs: ContiguousArray<T>) -> ContiguousArray<T> -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=<T>(rhs: _OptionalNilComparisonType) -> T? -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=<T>(lhs: T?) -> _OptionalNilComparisonType -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=<T>(rhs: T?) -> _OptionalNilComparisonType -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=<T>(lhs: _OptionalNilComparisonType) -> T? -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=<T>(lhs: Range<T>) -> Range<T> -> Bool {
	return { rhs in lhs == rhs }
}

public postfix func !=<T>(lhs: Range<T>) -> Range<T> -> Bool {
	return { rhs in lhs == rhs }
}

public postfix func !=(lhs: UInt64) -> UInt64 -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: UInt64) -> UInt64 -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=(lhs: Int32) -> Int32 -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: Int32) -> Int32 -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=(lhs: UInt32) -> UInt32 -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: UInt32) -> UInt32 -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=(lhs: Int16) -> Int16 -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: Int16) -> Int16 -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=(lhs: UInt16) -> UInt16 -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: UInt16) -> UInt16 -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=(lhs: Int8) -> Int8 -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: Int8) -> Int8 -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=(lhs: UInt8) -> UInt8 -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: UInt8) -> UInt8 -> Bool {
	return { lhs in lhs == rhs }
}

public prefix func !=(y: ObjectIdentifier) -> ObjectIdentifier -> Bool {
	return { x in x == y }
}

public postfix func !=(x: ObjectIdentifier) -> ObjectIdentifier -> Bool {
	return { y in x == y }
}

public prefix func !=<I>(rhs: ReverseBidirectionalIndex<I>) -> ReverseBidirectionalIndex<I> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=<I>(lhs: ReverseBidirectionalIndex<I>) -> ReverseBidirectionalIndex<I> -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=<I>(rhs: ReverseRandomAccessIndex<I>) -> ReverseRandomAccessIndex<I> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=<I>(lhs: ReverseRandomAccessIndex<I>) -> ReverseRandomAccessIndex<I> -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=<T : _Strideable>(y: T) -> T -> Bool {
	return { x in x == y }
}

public postfix func !=<T : _Strideable>(x: T) -> T -> Bool {
	return { y in x == y }
}

public postfix func !=(lhs: String) -> String -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: String) -> String -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=(lhs: String.Index) -> String.Index -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: String.Index) -> String.Index -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=(lhs: String.UTF8View.Index) -> String.UTF8View.Index -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: String.UTF8View.Index) -> String.UTF8View.Index -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=(lhs: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=(lhs: UnicodeScalar) -> UnicodeScalar -> Bool {
	return { rhs in lhs == rhs }
}

public prefix func !=(rhs: UnicodeScalar) -> UnicodeScalar -> Bool {
	return { lhs in lhs == rhs }
}

public prefix func !=<T>(rhs: UnsafeMutablePointer<T>) -> UnsafeMutablePointer<T> -> Bool {
	return { lhs in lhs == rhs }
}

public postfix func !=<T>(lhs: UnsafeMutablePointer<T>) -> UnsafeMutablePointer<T> -> Bool {
	return { rhs in lhs == rhs }
}

prefix operator <= {}
postfix operator <= {}

public prefix func <=(rhs: UInt16) -> UInt16 -> Bool {
	return { lhs in lhs <= rhs }
}

public postfix func <=(lhs: UInt16) -> UInt16 -> Bool {
	return { rhs in lhs <= rhs }
}

public prefix func <=(rhs: UInt8) -> UInt8 -> Bool {
	return { lhs in lhs <= rhs }
}

public postfix func <=(lhs: UInt8) -> UInt8 -> Bool {
	return { rhs in lhs <= rhs }
}

public prefix func <=<T : _Comparable>(rhs: T) -> T -> Bool {
	return { lhs in lhs <= rhs }
}

public postfix func <=<T : _Comparable>(lhs: T) -> T -> Bool {
	return { rhs in lhs <= rhs }
}

public prefix func <=<T : _Comparable>(rhs: T?) -> T? -> Bool {
	return { lhs in lhs <= rhs }
}

public postfix func <=<T : _Comparable>(lhs: T?) -> T? -> Bool {
	return { rhs in lhs <= rhs }
}

public prefix func <=(rhs: Int) -> Int -> Bool {
	return { lhs in lhs <= rhs }
}

public postfix func <=(lhs: Int) -> Int -> Bool {
	return { rhs in lhs <= rhs }
}

public prefix func <=(rhs: UInt) -> UInt -> Bool {
	return { lhs in lhs <= rhs }
}

public postfix func <=(lhs: UInt) -> UInt -> Bool {
	return { rhs in lhs <= rhs }
}

public prefix func <=(rhs: Int64) -> Int64 -> Bool {
	return { lhs in lhs <= rhs }
}

public postfix func <=(lhs: Int64) -> Int64 -> Bool {
	return { rhs in lhs <= rhs }
}

public prefix func <=(rhs: Int8) -> Int8 -> Bool {
	return { lhs in lhs <= rhs }
}

public postfix func <=(lhs: Int8) -> Int8 -> Bool {
	return { rhs in lhs <= rhs }
}

public prefix func <=(rhs: Int32) -> Int32 -> Bool {
	return { lhs in lhs <= rhs }
}

public postfix func <=(lhs: Int32) -> Int32 -> Bool {
	return { rhs in lhs <= rhs }
}

public prefix func <=(rhs: UInt32) -> UInt32 -> Bool {
	return { lhs in lhs <= rhs }
}

public postfix func <=(lhs: UInt32) -> UInt32 -> Bool {
	return { rhs in lhs <= rhs }
}

public prefix func <=(rhs: Int16) -> (lhs: Int16) -> Bool {
	return { lhs in lhs <= rhs }
}

public postfix func <=(lhs: Int16) -> (lhs: Int16) -> Bool {
	return { rhs in lhs <= rhs }
}

public prefix func <=(rhs: UInt64) -> UInt64 -> Bool {
	return { lhs in lhs <= rhs }
}

public postfix func <=(lhs: UInt64) -> UInt64 -> Bool {
	return { rhs in lhs <= rhs }
}

prefix operator >= {}
postfix operator >= {}

public prefix func >=(rhs: UInt16) -> UInt16 -> Bool {
	return { lhs in lhs >= rhs }
}

public postfix func >=(lhs: UInt16) -> UInt16 -> Bool {
	return { rhs in lhs >= rhs }
}

public prefix func >=(rhs: UInt8) -> UInt8 -> Bool {
	return { lhs in lhs >= rhs }
}

public postfix func >=(lhs: UInt8) -> UInt8 -> Bool {
	return { rhs in lhs >= rhs }
}

public prefix func >=<T : _Comparable>(rhs: T) -> T -> Bool {
	return { lhs in lhs >= rhs }
}

public postfix func >=<T : _Comparable>(lhs: T) -> T -> Bool {
	return { rhs in lhs >= rhs }
}

public prefix func >=<T : _Comparable>(rhs: T?) -> T? -> Bool {
	return { lhs in lhs >= rhs }
}

public postfix func >=<T : _Comparable>(lhs: T?) -> T? -> Bool {
	return { rhs in lhs >= rhs }
}

public prefix func >=(rhs: Int) -> Int -> Bool {
	return { lhs in lhs >= rhs }
}

public postfix func >=(lhs: Int) -> Int -> Bool {
	return { rhs in lhs >= rhs }
}

public prefix func >=(rhs: UInt) -> UInt -> Bool {
	return { lhs in lhs >= rhs }
}

public postfix func >=(lhs: UInt) -> UInt -> Bool {
	return { rhs in lhs >= rhs }
}

public prefix func >=(rhs: Int64) -> Int64 -> Bool {
	return { lhs in lhs >= rhs }
}

public postfix func >=(lhs: Int64) -> Int64 -> Bool {
	return { rhs in lhs >= rhs }
}

public prefix func >=(rhs: Int8) -> Int8 -> Bool {
	return { lhs in lhs >= rhs }
}

public postfix func >=(lhs: Int8) -> Int8 -> Bool {
	return { rhs in lhs >= rhs }
}

public prefix func >=(rhs: Int32) -> Int32 -> Bool {
	return { lhs in lhs >= rhs }
}

public postfix func >=(lhs: Int32) -> Int32 -> Bool {
	return { rhs in lhs >= rhs }
}

public prefix func >=(rhs: UInt32) -> UInt32 -> Bool {
	return { lhs in lhs >= rhs }
}

public postfix func >=(lhs: UInt32) -> UInt32 -> Bool {
	return { rhs in lhs >= rhs }
}

public prefix func >=(rhs: Int16) -> (lhs: Int16) -> Bool {
	return { lhs in lhs >= rhs }
}

public postfix func >=(lhs: Int16) -> (lhs: Int16) -> Bool {
	return { rhs in lhs >= rhs }
}

public prefix func >=(rhs: UInt64) -> UInt64 -> Bool {
	return { lhs in lhs >= rhs }
}

public postfix func >=(lhs: UInt64) -> UInt64 -> Bool {
	return { rhs in lhs >= rhs }
}

prefix operator > {}
// postfix operator > {}

public prefix func >(rhs: Int64) -> Int64 -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func >(rhs: Character) -> Character -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func >(rhs: UInt8) -> UInt8 -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func >(rhs: Int8) -> Int8 -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func >(rhs: UInt16) -> UInt16 -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func >(rhs: Int16) -> Int16 -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func >(rhs: UInt32) -> UInt32 -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func >(rhs: Int32) -> Int32 -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func >(rhs: UInt64) -> UInt64 -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func >(rhs: Bit) -> Bit -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func ><T>(rhs: UnsafePointer<T>) -> UnsafePointer<T> -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func ><T>(rhs: UnsafeMutablePointer<T>) -> UnsafeMutablePointer<T> -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func >(rhs: UnicodeScalar) -> UnicodeScalar -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func >(rhs: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func >(rhs: String.Index) -> String.Index -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func >(rhs: String) -> String -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func ><T : _Comparable>(rhs: T?) -> T? -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func >(rhs: Swift.Float80) -> Swift.Float80 -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func >(rhs: Double) -> Double -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func >(rhs: Float) -> Float -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func >(rhs: Int) -> Int -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func >(rhs: UInt) -> UInt -> Bool {
	return { lhs in lhs > rhs }
}

public prefix func ><Key : Hashable, Value>(rhs: DictionaryIndex<Key, Value>) -> DictionaryIndex<Key, Value> -> Bool {
	return { lhs in lhs > rhs }
}

// prefix operator < {}
postfix operator < {}

public postfix func <(lhs: Int64) -> Int64 -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <(lhs: Character) -> Character -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <(lhs: UInt8) -> UInt8 -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <(lhs: Int8) -> Int8 -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <(lhs: UInt16) -> UInt16 -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <(lhs: Int16) -> Int16 -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <(lhs: UInt32) -> UInt32 -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <(lhs: Int32) -> Int32 -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <(lhs: UInt64) -> UInt64 -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <(lhs: Bit) -> Bit -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <<T>(lhs: UnsafePointer<T>) -> UnsafePointer<T> -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <<T>(lhs: UnsafeMutablePointer<T>) -> UnsafeMutablePointer<T> -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <(lhs: UnicodeScalar) -> UnicodeScalar -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <(lhs: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <(lhs: String.Index) -> String.Index -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <(lhs: String) -> String -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <<T : _Comparable>(lhs: T?) -> T? -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <(lhs: Swift.Float80) -> Swift.Float80 -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <(lhs: Double) -> Double -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <(lhs: Float) -> Float -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <(lhs: Int) -> Int -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <(lhs: UInt) -> UInt -> Bool {
	return { rhs in lhs < rhs }
}

public postfix func <<Key : Hashable, Value>(lhs: DictionaryIndex<Key, Value>) -> DictionaryIndex<Key, Value> -> Bool {
	return { rhs in lhs < rhs }
}


