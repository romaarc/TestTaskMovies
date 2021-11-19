//
//  PersistentTest.swift
//  TestTaskMoviesTests
//
//  Created by Roman Gorshkov on 19.11.2021.
//

import XCTest
@testable import TestTaskMovies

class PersistentTest: XCTestCase {

    var persistentProvider: PersistentProviderProtocol?
    
    override func setUpWithError() throws {
        persistentProvider = PersistentProvider()
    }

    override func tearDownWithError() throws {
        persistentProvider = nil
    }
    
    func testPersistentRequestModels() throws {
        //Given
        let expectation = XCTestExpectation(description: "Get all cd models from storage")
        //When
        let cdModels = persistentProvider?.requestModels()
        guard let cdModels = cdModels else { return }
        print(cdModels)
        expectation.fulfill()
        //Then
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testPersistentRequestModelWithID() throws {
        //Given
        let id = 550
        let expectation = XCTestExpectation(description: "Get id cd model from storage")
        //When
        let cdModels = persistentProvider?.requestModels(withId: id)
        guard let cdModels = cdModels else { return }
        print(cdModels)
        expectation.fulfill()
        //Then
        wait(for: [expectation], timeout: 2.0)
    }
}
                              

