//
//  InstagramTests.swift
//  InstagramTests
//
//  Created by Vo Thuan Nguyen on 1/19/23.
//

import XCTest

class InstagramTests: XCTestCase {

    func testNotificationIDCreation() {
        let first = "123_abcc"
        let second = "456_def"
        XCTAssertNotEqual(first, second)
    }

//    func testNotificationIDCreationFailure() {
//        let first = "123_abcc"
//        let second = "456_def"
//        XCTAssertEqual(first, second)
//    }

}
