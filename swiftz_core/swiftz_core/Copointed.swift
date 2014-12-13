//
//  Copointed.swift
//  swiftz_core
//
//  Created by Robert Widmann on 12/12/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//


public protocol Copointed : Functor {	
	func extract() -> A
}
