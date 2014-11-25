//
//  Sections.swift
//  swiftz_core
//
//  Created by Robert Widmann on 11/23/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

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

public postfix func -<T>(rhs: Int) -> UnsafePointer<T> -> UnsafePointer<T> {
	return { lhs in lhs - rhs }
}

public postfix func -<T>(rhs: Int) -> UnsafeMutablePointer<T> -> UnsafeMutablePointer<T> {
	return { lhs in lhs - rhs }
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
