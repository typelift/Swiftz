//
//  Curry.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 7/06/2014.
//  Copyright (c) 2014-2016 Maxwell Swadling. All rights reserved.
//

/// Converts an uncurried function to a curried function.
///
/// A curried function is a function that always returns another function or a 
/// value when applied as opposed to an uncurried function which may take tuples.


public func curry<A, B, C>(_ f : @escaping (A, B) -> C) -> (A) -> (B) -> C {
    
    return { (a : A) -> (B) -> C in
        { (b : B) -> C in
            
            f(a, b)
        }
    }
    
}




public func curry<A, B, C, D>(_ f : @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    
    return { (a : A) -> (B) -> (C) -> D in
        { (b : B) -> (C) -> D in
            { (c : C) -> D in
                
                f(a, b, c)
            }
        }
    }
    
}




public func curry<A, B, C, D, E>(_ f : @escaping (A, B, C, D) -> E) -> (A) -> (B) -> (C) -> (D) -> E {
    
    return { (a : A) -> (B) -> (C) -> (D) -> E in
        { (b : B) -> (C) -> (D) -> E in
            { (c : C) -> (D) -> E in
                { (d : D) -> E in
                    
                    f(a, b, c, d)
                }
            }
        }
    }
    
}




public func curry<A, B, C, D, E, F>(_ f : @escaping (A, B, C, D, E) -> F) -> (A) -> (B) -> (C) -> (D) -> (E) -> F {
    
    return { (a : A) -> (B) -> (C) -> (D) -> (E) -> F in
        { (b : B) -> (C) -> (D) -> (E) -> F in
            { (c : C) -> (D) -> (E) -> F in
                { (d : D) -> (E) -> F in
                    { (e : E) -> F in
                        
                        f(a, b, c, d, e)
                    }
                }
            }
        }
    }
    
}




public func curry<A, B, C, D, E, F, G>(_ f : @escaping (A, B, C, D, E, F) -> G) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> G {
    
    return { (a : A) -> (B) -> (C) -> (D) -> (E) -> (F) -> G in
        { (b : B) -> (C) -> (D) -> (E) -> (F) -> G in
            { (c : C) -> (D) -> (E) -> (F) -> G in
                { (d : D) -> (E) -> (F) -> G in
                    { (e : E) -> (F) -> G in
                        { (ff : F) -> G in
                            
                            f(a, b, c, d, e, ff)
                        }
                    }
                }
            }
        }
    }
    
}




public func curry<A, B, C, D, E, F, G, H>(_ f : @escaping (A, B, C, D, E, F, G) -> H) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> H {
    
    return { (a : A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> H in
        { (b : B) -> (C) -> (D) -> (E) -> (F) -> (G) -> H in
            { (c : C) -> (D) -> (E) -> (F) -> (G) -> H in
                { (d : D) -> (E) -> (F) -> (G) -> H in
                    { (e : E) -> (F) -> (G) -> H in
                        { (ff : F) -> (G) -> H in
                            { (g : G) -> H in
                                
                                f(a, b, c, d, e, ff, g)
                            }
                        }
                    }
                }
            }
        }
    }
    
}




public func curry<A, B, C, D, E, F, G, H, I>(_ f : @escaping (A, B, C, D, E, F, G, H) -> I) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> I {
    
    return { (a : A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> I in
        { (b : B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> I in
            { (c : C) -> (D) -> (E) -> (F) -> (G) -> (H) -> I in
                { (d : D) -> (E) -> (F) -> (G) -> (H) -> I in
                    { (e : E) -> (F) -> (G) -> (H) -> I in
                        { (ff : F) -> (G) -> (H) -> I in
                            { (g : G) -> (H) -> I in
                                { (h : H) -> I in
                                    
                                    f(a, b, c, d, e, ff, g, h)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}




public func curry<A, B, C, D, E, F, G, H, I, J>(_ f : @escaping (A, B, C, D, E, F, G, H, I) -> J) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> J {
    
    return { (a : A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> J in
        { (b : B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> J in
            { (c : C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> J in
                { (d : D) -> (E) -> (F) -> (G) -> (H) -> (I) -> J in
                    { (e : E) -> (F) -> (G) -> (H) -> (I) -> J in
                        { (ff : F) -> (G) -> (H) -> (I) -> J in
                            { (g : G) -> (H) -> (I) -> J in
                                { (h : H) -> (I) -> J in
                                    { (i : I) -> J in
                                        
                                        f(a, b, c, d, e, ff, g, h, i)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}




public func curry<A, B, C, D, E, F, G, H, I, J, K>(_ f : @escaping (A, B, C, D, E, F, G, H, I, J) -> K) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K {
    
    return { (a : A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K in
        { (b : B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K in
            { (c : C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K in
                { (d : D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K in
                    { (e : E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K in
                        { (ff : F) -> (G) -> (H) -> (I) -> (J) -> K in
                            { (g : G) -> (H) -> (I) -> (J) -> K in
                                { (h : H) -> (I) -> (J) -> K in
                                    { (i : I) -> (J) -> K in
                                        { (j : J) -> K in
                                            
                                            f(a, b, c, d, e, ff, g, h, i, j)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}




public func curry<A, B, C, D, E, F, G, H, I, J, K, L>(_ f : @escaping (A, B, C, D, E, F, G, H, I, J, K) -> L) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L {
    
    return { (a : A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L in
        { (b : B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L in
            { (c : C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L in
                { (d : D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L in
                    { (e : E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L in
                        { (ff : F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L in
                            { (g : G) -> (H) -> (I) -> (J) -> (K) -> L in
                                { (h : H) -> (I) -> (J) -> (K) -> L in
                                    { (i : I) -> (J) -> (K) -> L in
                                        { (j : J) -> (K) -> L in
                                            { (k : K) -> L in
                                                
                                                f(a, b, c, d, e, ff, g, h, i, j, k)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}




public func curry<A, B, C, D, E, F, G, H, I, J, K, L, M>(_ f : @escaping (A, B, C, D, E, F, G, H, I, J, K, L) -> M) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> M {
    
    return { (a : A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> M in
        { (b : B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> M in
            { (c : C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> M in
                { (d : D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> M in
                    { (e : E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> M in
                        { (ff : F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> M in
                            { (g : G) -> (H) -> (I) -> (J) -> (K) -> (L) -> M in
                                { (h : H) -> (I) -> (J) -> (K) -> (L) -> M in
                                    { (i : I) -> (J) -> (K) -> (L) -> M in
                                        { (j : J) -> (K) -> (L) -> M in
                                            { (k : K) -> (L) -> M in
                                                { (l : L) -> M in
                                                    
                                                    f(a, b, c, d, e, ff, g, h, i, j, k, l)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}




public func curry<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(_ f : @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M) -> N) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> N {
    
    return { (a : A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> N in
        { (b : B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> N in
            { (c : C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> N in
                { (d : D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> N in
                    { (e : E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> N in
                        { (ff : F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> N in
                            { (g : G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> N in
                                { (h : H) -> (I) -> (J) -> (K) -> (L) -> (M) -> N in
                                    { (i : I) -> (J) -> (K) -> (L) -> (M) -> N in
                                        { (j : J) -> (K) -> (L) -> (M) -> N in
                                            { (k : K) -> (L) -> (M) -> N in
                                                { (l : L) -> (M) -> N in
                                                    { (m : M) -> N in
                                                        
                                                        f(a, b, c, d, e, ff, g, h, i, j, k, l, m)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}




public func curry<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(_ f : @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N) -> O) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> O {
    
    return { (a : A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> O in
        { (b : B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> O in
            { (c : C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> O in
                { (d : D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> O in
                    { (e : E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> O in
                        { (ff : F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> O in
                            { (g : G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> O in
                                { (h : H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> O in
                                    { (i : I) -> (J) -> (K) -> (L) -> (M) -> (N) -> O in
                                        { (j : J) -> (K) -> (L) -> (M) -> (N) -> O in
                                            { (k : K) -> (L) -> (M) -> (N) -> O in
                                                { (l : L) -> (M) -> (N) -> O in
                                                    { (m : M) -> (N) -> O in
                                                        { (n : N) -> O in
                                                            
                                                            f(a, b, c, d, e, ff, g, h, i, j, k, l, m, n)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}




public func curry<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(_ f : @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) -> P) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> (O) -> P {
    
    return { (a : A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> (O) -> P in
        { (b : B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> (O) -> P in
            { (c : C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> (O) -> P in
                { (d : D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> (O) -> P in
                    { (e : E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> (O) -> P in
                        { (ff : F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> (O) -> P in
                            { (g : G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> (O) -> P in
                                { (h : H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> (O) -> P in
                                    { (i : I) -> (J) -> (K) -> (L) -> (M) -> (N) -> (O) -> P in
                                        { (j : J) -> (K) -> (L) -> (M) -> (N) -> (O) -> P in
                                            { (k : K) -> (L) -> (M) -> (N) -> (O) -> P in
                                                { (l : L) -> (M) -> (N) -> (O) -> P in
                                                    { (m : M) -> (N) -> (O) -> P in
                                                        { (n : N) -> (O) -> P in
                                                            { (o : O) -> P in
                                                                
                                                                f(a, b, c, d, e, ff, g, h, i, j, k, l, m, n, o)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}

/// Converts a curried function to an uncurried function.
///
/// An uncurried function may take tuples as opposed to a curried function which must take a single
/// value and return a single value or function.
public func uncurry<A, B, C>(_ f : @escaping (A) -> (B) -> C) -> (A, B) -> C {
	return { t in f(t.0)(t.1) }
}

public func uncurry<A, B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (A, B, C) -> D {
	return { a, b, c in f(a)(b)(c) }
}

public func uncurry<A, B, C, D, E>(_ f : @escaping (A) -> (B) -> (C) -> (D) -> E) -> (A, B, C, D) -> E {
	return { a, b, c, d in f(a)(b)(c)(d) }
}

public func uncurry<A, B, C, D, E, F>(_ f : @escaping (A) -> (B) -> (C) -> (D) -> (E) -> F) -> (A, B, C, D, E) -> F {
	return { a, b, c, d, e in f(a)(b)(c)(d)(e) }
}

public func uncurry<A, B, C, D, E, F, G>(_ f : @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> G) -> (A, B, C, D, E, F) -> G {
	return { a, b, c, d, e, ff in f(a)(b)(c)(d)(e)(ff) }
}

public func uncurry<A, B, C, D, E, F, G, H>(_ f : @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> H) -> (A, B, C, D, E, F, G) -> H {
	return { a, b, c, d, e, ff, g in f(a)(b)(c)(d)(e)(ff)(g) }
}

public func uncurry<A, B, C, D, E, F, G, H, I>(_ f : @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> I) -> (A, B, C, D, E, F, G, H) -> I {
	return { a, b, c, d, e, ff, g, h in f(a)(b)(c)(d)(e)(ff)(g)(h) }
}

public func uncurry<A, B, C, D, E, F, G, H, I, J>(_ f : @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> J) -> (A, B, C, D, E, F, G, H, I) -> J {
	return { a, b, c, d, e, ff, g, h, i in f(a)(b)(c)(d)(e)(ff)(g)(h)(i) }
}

public func uncurry<A, B, C, D, E, F, G, H, I, J, K>(_ f : @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K) -> (A, B, C, D, E, F, G, H, I, J) -> K {
	return { a, b, c, d, e, ff, g, h, i, j in f(a)(b)(c)(d)(e)(ff)(g)(h)(i)(j) }
}

public func uncurry<A, B, C, D, E, F, G, H, I, J, K, L>(_ f : @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L) -> (A, B, C, D, E, F, G, H, I, J, K) -> L {
	return { a, b, c, d, e, ff, g, h, i, j, k in f(a)(b)(c)(d)(e)(ff)(g)(h)(i)(j)(k) }
}

public func uncurry<A, B, C, D, E, F, G, H, I, J, K, L, M>(_ f : @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> M) -> (A, B, C, D, E, F, G, H, I, J, K, L) -> M {
	return { a, b, c, d, e, ff, g, h, i, j, k, l in f(a)(b)(c)(d)(e)(ff)(g)(h)(i)(j)(k)(l) }
}

public func uncurry<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(_ f : @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> N) -> (A, B, C, D, E, F, G, H, I, J, K, L, M) -> N {
	return { a, b, c, d, e, ff, g, h, i, j, k, l, m in f(a)(b)(c)(d)(e)(ff)(g)(h)(i)(j)(k)(l)(m) }
}

public func uncurry<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(_ f : @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> O) -> (A, B, C, D, E, F, G, H, I, J, K, L, M, N) -> O {
	return { a, b, c, d, e, ff, g, h, i, j, k, l, m, n in f(a)(b)(c)(d)(e)(ff)(g)(h)(i)(j)(k)(l)(m)(n) }
}

public func uncurry<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(_ f : @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> (M) -> (N) -> (O) -> P) -> (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) -> P {
	return { a, b, c, d, e, ff, g, h, i, j, k, l, m, n, o in f(a)(b)(c)(d)(e)(ff)(g)(h)(i)(j)(k)(l)(m)(n)(o) }
}
