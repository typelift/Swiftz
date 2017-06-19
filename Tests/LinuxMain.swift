//
//  LinuxMain.swift
//  Swiftz
//
//  Created by Tristan Celder on 11/07/2017.
//  Copyright © 2017 TypeLift. All rights reserved.
//

import XCTest

@testable import SwiftzTests

#if !os(macOS)
XCTMain([
    EitherSpec.allTests,
    FunctionSpec.allTests,
    FunctorSpec.allTests,
    HListSpec.allTests,
    IdentitySpec.allTests,
    ListSpec.allTests,
    MonoidSpec.allTests,
    NonEmptyListSpec.allTests,
    ProxySpec.allTests,
    ReaderSpec.allTests,
//    StateSpec.allTests,
//    StreamSpec.allTests,
    ThoseSpec.allTests,
    UnitSpec.allTests,
    WriterSpec.allTests,
    ])
#endif
