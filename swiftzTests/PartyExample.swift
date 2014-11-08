//
//  PartyExample.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import swiftz

// A party has a host, who is a user.
// A lens example
public class Party {
  let host: User
  public init(h: User) {
    host = h
  }

  class func lpartyHost() -> Lens<Party, Party, User, User> {
    let getter = { (party: Party) -> User in
      party.host
    }

    let setter = { (party: Party, host: User) -> Party in
      Party(h: host)
    }

    return Lens(get: getter, set: setter)
  }
}
