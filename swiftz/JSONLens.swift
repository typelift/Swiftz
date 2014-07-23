//
//  JSONLens.swift
//  swiftz
//
//  Created by Terry Lewis II on 7/22/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation
import swiftz_core

extension JSValue {
    public static func _String() -> Lens<JSValue?, JSValue?, String?, String> {
        return Lens { str in IxStore(str >>= JString.fromJSON) { JSValue.JSString($0) }}
    }
    
    public static func _Integer() -> Lens<JSValue?, JSValue?, Int?, Int> {
        return Lens { str in IxStore(str >>= JInt.fromJSON) { JSValue.JSNumber(Double($0)) }}
    }
    
    public static func _Double() -> Lens<JSValue?, JSValue?, Double?, Double> {
        return Lens { str in IxStore(str >>= JDouble.fromJSON) { JSValue.JSNumber($0) }}
    }
    
    public static func _Bool() -> Lens<JSValue?, JSValue?, Bool?, Bool> {
        return Lens { str in IxStore(str >>= JBool.fromJSON) { JSValue.JSBool($0) }}
    }
    
    public static func nth(idx:Int) -> Lens<JSValue?, JSValue?, JSValue?, JSValue?> {
        let getter = { (value:JSValue?) -> JSValue? in
            
            if value {
                switch value! {
                case let .JSArray(arr):
                    if idx < arr.count {
                        return arr[idx]
                    } else {
                        return .None
                    }
                    
                default: return .None
                }
            } else {
                return .None
            }
        }
        
        let setter = { (value:JSValue?, val:JSValue?) -> JSValue? in
            if value {
                switch value! {
                case let .JSArray(arr):
                    var temp = arr
                    if val && idx < arr.count {
                        temp[idx] = val!
                    }
                    return JSValue.JSArray(temp)
                default: return .None
                }
            } else {
                return .None
            }
        }
        return Lens(get:getter, set:setter)
    }
    
    public static func key(key:String) -> Lens<JSValue?, JSValue?, JSValue?, JSValue?> {
        let getter = { (value:JSValue?) -> JSValue? in
            if value {
                switch value! {
                case let .JSObject(d):
                    return d[key]
                default: return .None
                }
            } else {
                return nil
            }
        }
        
        let setter = { (value:JSValue?, val:JSValue?) -> JSValue? in
            if value {
                switch value! {
                case let .JSObject(d):
                    var temp = d
                    if val {
                        temp.updateValue(val!, forKey: key)
                    }
                    return JSValue.JSObject(temp)
                default: return .None
                }
            } else {
                return .None
            }
        }
        
        return Lens(getter, setter)
    }
}