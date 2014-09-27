//
//  Monoid.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Basis

public final class Sum<N : Num> : K1<N>, Monoid {
	public typealias M = N.N

	public override init() { }

	public class func mempty() -> M {
		return N.zero()
	}

	public class func mappend(x: M) -> M -> M {
		return { y in N.add(x, y: y) }
	}
}

public final class Product<N : Num> : K1<N>, Monoid {
	typealias M = N.N

	public override init() { }

	public class func mempty() -> M {
		return N.succ(N.zero())
	}

	public class func mappend(x: M) -> M -> M {
		return { y in N.multiply(x, y: y) }
	}
}


