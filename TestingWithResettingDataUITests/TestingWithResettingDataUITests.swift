//
//  Copyright © 2015 Onefootball GmbH. All rights reserved.
//

import XCTest

class TestingWithResettingDataUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false

        let application = XCUIApplication()
        application.launchArguments = ["--ResetData"]
        application.launch()
    }
    
    func testExample() {
        // All data before executing this test will be wipeout.
    }
}
