//
//  ControlTests.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import swiftz
import Basis
class ControlTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testLens() {
    let party = Party(h: User("max", 1, [], Dictionary()))
    let hostnameLens = Party.lpartyHost() • User.luserName()

    XCTAssert(hostnameLens.get(party) == "max")

    let updatedParty: Party = (Party.lpartyHost() • User.luserName()).set(party, "Max")
    XCTAssert(hostnameLens.get(updatedParty) == "Max")
  }
}
