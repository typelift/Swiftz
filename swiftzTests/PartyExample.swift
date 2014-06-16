//
//  PartyExample.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation
import swiftz

// A party has a host, who is a user.
// A lens example
class Party {
  let host: User
  init(h: User) {
    host = h
  }
  
// lens
	class func lpartyHost() -> Lens<Party, Party, User, User> {
		let getter = { (party: Party) -> User in
			party.host
		}

		let setter = { (party: Party, host: User) -> Party in
			Party(h: host)
		}

		return Lens(get: getter, set: setter)
//		return { (fn: (User -> Const<User, Party>)) -> Party -> Const<User, Party> in
//			return { (a: Party) -> Const<User, Party> in
//				return fn(a.host)
//			}
//		}
	}
}
//  class func lpartyHost() -> Lens<Party, User>.LensId {
//    return { (fn: (User -> Id<User>)) -> Party -> Id<Party> in
//      return { (a: Party) -> Id<Party> in
//        let x = fn(a.host).runId()
//        return Id<Party>(Party(h: fn(a.host).runId()))
//      }
//    }
//  }

