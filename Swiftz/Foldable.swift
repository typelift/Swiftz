//
//  Foldable.swift
//  Swiftz
//
//  Created by Robert Widmann on 6/21/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

protocol Foldable {
	typealias A
	typealias B

	func foldr(A -> B -> B, B) -> B
	func foldl(B -> A -> B, B) -> B
	func foldMap<M : Monoid>(A -> M) -> M
}
