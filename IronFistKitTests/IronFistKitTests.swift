//
//  IronFistKitTests.swift
//  IronFistKitTests
//
//  Created by Marc Respass on 7/8/21.
//

import XCTest
@testable import IronFistKit

class IronFistKitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHasIronFists() throws {
        let it = IronFistController()
        XCTAssertNotNil(it.ironFists)
    }

    func testIronFistCountIs12() throws {
        let it = IronFistController()
        XCTAssertEqual(it.ironFists.count, 12)
    }
}
