//
//  Foldable.swift
//  Swiftz
//
//  Created by Robert Widmann on 6/21/15.
//  Copyright © 2015-2016 TypeLift. All rights reserved.
//

/// A `Foldable` type admits a way of "summarizing" its entire structure.
public protocol Foldable {
	associatedtype A
	associatedtype B

	/// Summarizes the receiver right-associatively.
	func foldr(_ folder : (A) -> (B) -> B, _ initial : B) -> B

	/// Summarizes the receiver left-associatively.
	func foldl(_ folder : (B) -> (A) -> B, _ initial : B) -> B

	/// Map each element of the receiver to a monoid, and combine the results.
	func foldMap<M : Monoid>(_ map : (A) -> M) -> M
}
