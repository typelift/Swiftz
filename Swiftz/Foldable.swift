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

	func foldr(_ : A -> B -> B, _ : B) -> B
	func foldl(_ : B -> A -> B, _ : B) -> B
	func foldMap<M : Monoid>(_ : A -> M) -> M
}
