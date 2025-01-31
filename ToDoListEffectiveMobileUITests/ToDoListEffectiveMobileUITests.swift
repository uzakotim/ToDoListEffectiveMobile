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
        let app = XCUIApplication()
        app.launch()
        // Найти text element, который содержит слово "Задачи"
        let textElement = app.staticTexts["Задачи"]
        XCTAssertTrue(textElement.exists, "The text 'Задачи' should be present on the screen")
    }
    func testNavigate() {
        let app = XCUIApplication()
        app.launch()

        // Нажать на кнопку "square.and.pencil"
        let editButton = app.buttons["square.and.pencil"]
        XCTAssertTrue(editButton.exists, "The edit button should exist on the screen")
        editButton.tap()
        
        // Нажать на кропку назад
        let backButton = app.buttons.containing(NSPredicate(format: "label CONTAINS 'Назад'")).firstMatch
        XCTAssertTrue(backButton.exists, "The back button should exist on the screen")
        backButton.tap()
        XCTAssertTrue(editButton.waitForExistence(timeout: 5), "The edit button should reappear after going back")
    }
    
    func testNavigateAndFindTextField() {
        let app = XCUIApplication()
        app.launch()
        
        // Нажать на кнопку "square.and.pencil"
        let editButton = app.buttons["square.and.pencil"]
        XCTAssertTrue(editButton.exists, "The edit button should exist on the screen")
        editButton.tap()
        
        // Найти Введите описание
        let textField = app.textFields["text.field"]
        XCTAssertTrue(textField.exists, "The title text field should be visible")
        // Проперить исчезла ли запись при нажатии
        textField.tap()
        textField.typeText("Some Text")
        XCTAssertFalse(textField.value as? String == "Введите описание",
                       "Placeholder should disappear when typing.")
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
