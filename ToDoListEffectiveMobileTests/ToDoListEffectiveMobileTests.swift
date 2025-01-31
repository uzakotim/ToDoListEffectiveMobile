//
//  ToDoListEffectiveMobileTests.swift
//  ToDoListEffectiveMobileTests
//
//  Created by Timur Uzakov on 28/01/25.
//

import XCTest
@testable import ToDoListEffectiveMobile

final class ToDoListEffectiveMobileTests: XCTestCase {

    func testLoadTasks() {
            // Create an expectation to wait for the completion handler
            let expectation = XCTestExpectation(description: "Tasks are fetched")

            var fetchedTasks = [Task]()
            var fetchError: Error?
            let interactor = TaskListInteractor()
            // Call the fetchTasks method
            interactor.fetchTasks { result in
                switch result {
                case .success(let tasks):
                    fetchedTasks = tasks
                case .failure(let error):
                    fetchError = error
                }

                // Fulfill the expectation to signal that the async task is done
                expectation.fulfill()
            }

            // Wait for the expectation to be fulfilled or time out after 5 seconds
            wait(for: [expectation], timeout: 10)

            // Assert that no error occurred
            XCTAssertNil(fetchError, "Error fetching tasks: \(fetchError?.localizedDescription ?? "")")

            // Assert that the number of tasks is 30
            XCTAssertEqual(fetchedTasks.count, 30, "The number of tasks should be 30.")
        }
}
