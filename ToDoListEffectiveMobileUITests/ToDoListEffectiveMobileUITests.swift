//
//  ToDoListEffectiveMobileUITests.swift
//  ToDoListEffectiveMobileUITests
//
//  Created by Timur Uzakov on 28/01/25.
//

import XCTest

final class ToDoListEffectiveMobileUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    
    @MainActor
    func testDidLoad() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        // Find the text element that contains the word "Задачи"
        let textElement = app.staticTexts["Задачи"]

        // Assert that the element exists
        XCTAssertTrue(textElement.exists, "The text 'Задачи' should be present on the screen")
    }

//    @MainActor
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
