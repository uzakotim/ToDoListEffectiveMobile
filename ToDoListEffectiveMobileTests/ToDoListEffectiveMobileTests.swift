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
            // Create an expectation to wait for async task
            let expectation = XCTestExpectation(description: "Tasks are fetched")
            
            var fetchedTasks = [Task]()

            // Assuming you're testing the URLSession data task to fetch tasks
            guard let url = URL(string: "https://dummyjson.com/todos") else {
                XCTFail("Invalid URL")
                return
            }
            
            // Start the data task
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    XCTFail("Error fetching data: \(error)")
                    return
                }
                
                guard let data = data else {
                    XCTFail("No data returned")
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(TodosResponse.self, from: data)
                    fetchedTasks = decodedResponse.todos
                    print("Success")
                } catch {
                    XCTFail("Failed to decode JSON: \(error)")
                }
                
                // Fulfill the expectation to signal that the async task is done
                expectation.fulfill()
            }.resume()

            // Wait for the expectation to be fulfilled or time out after 5 seconds
            wait(for: [expectation], timeout: 10)

            // Assert that the number of tasks is 30
            XCTAssertEqual(fetchedTasks.count, 30, "The number of tasks should be 30.")
        }

}
