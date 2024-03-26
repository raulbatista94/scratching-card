//
//  ScratchingCardTests.swift
//  ScratchingCardTests
//
//  Created by Raul Batista on 26.03.2024.
//

import Foundation
import XCTest

final class ScratchingCardTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testCardStateModelStorage() {
        let defaults = UserDefaults.standard
        let testModel = CardStateModel(
            id: "testID",
            scratchedPoints: [CGPoint(x: 0, y: 0)],
            isReadyToBeActivated: true,
            isActivated: false
        )

        // Store the model
        if let encoded = try? JSONEncoder().encode(testModel) {
            defaults.set(encoded, forKey: "testModel")
        } else {
            XCTFail("Failed to encode CardStateModel")
        }

        // Retrieve the model
        if let savedModel = defaults.object(forKey: "testModel") as? Data {
            if let loadedModel = try? JSONDecoder().decode(CardStateModel.self, from: savedModel) {
                // Assert that the retrieved model is the same as the original
                XCTAssertEqual(loadedModel.id, testModel.id)
                XCTAssertEqual(loadedModel.scratchedPoints, testModel.scratchedPoints)
                XCTAssertEqual(loadedModel.isReadyToBeActivated, testModel.isReadyToBeActivated)
                XCTAssertEqual(loadedModel.isActivated, testModel.isActivated)
            } else {
                XCTFail("Failed to decode CardStateModel")
            }
        } else {
            XCTFail("Failed to load CardStateModel from UserDefaults")
        }
    }

}
