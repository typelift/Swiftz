//
//  ExecutionContext.swift
//  swiftz
//
//  Created by Maxwell Swadling on 7/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// Execution Contexts dictate how work is done to produce a result for a given Future.
///
/// When a Future is created the execution context uses its `submit` function to recieve a copy of
/// the Future and its work block to produce a value.  When work concludes the Future is fulfilled
/// by calling Future.sig(_:) with the results of the work block.
public protocol ExecutionContext {
	/// Computes a value for a Future given a work block.
	///
	/// When work concludes this function must execute Future.sig(_:) to fulfill the Future.
	func submit<A>(x: Future<A>, work: () -> A)
}
