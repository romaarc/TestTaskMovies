//
//  NetworkTests.swift
//  TestTaskMoviesTests
//
//  Created by Roman Gorshkov on 19.11.2021.
//

import XCTest
@testable import TestTaskMovies

class NetworkTests: XCTestCase {

    var networkService: MovieNetworkProtocol?
    
    override func setUpWithError() throws {
        networkService = NetworkService()
    }

    override func tearDownWithError() throws {
        networkService = nil
    }

    func testNetworkRequestByParameters() throws {
        //Given
        let page = 1
        let parametersURL = MovieURLParametrs(page: page)
        let expectation = XCTestExpectation(description: "Perform network request movies with given parameters")
        
        //When
        networkService?.requestMovies(with: parametersURL, and: { result in
            switch result {
            case .success( _):
                print("Data received")
                expectation.fulfill()
            case .failure( _):
                break
            }
        })
        //Then
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testNetworkRequestByMethodError() {
        //Given
        let page = 0
        let parametersURL = MovieURLParametrs(page: page)
        let expectation = XCTestExpectation(description: "Test network service for error handling")
        //When
        networkService?.requestMovies(with: parametersURL, and: { result in
            switch result {
            case .success( _):
                break
            case.failure(let error):
                print(error)
                expectation.fulfill()
            }
        })
        //Then
        wait(for: [expectation], timeout: 3.0)
    }

    func testNetworkRequestByURLImg() {
        //Given
        let expectation = XCTestExpectation(description: "Test for get URL images")
        //When
        let url = networkService?.requestImgMovieURL()
        guard let url = url else { return }
        if !url.isEmpty, url.count > 0 {
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNetworkRequestByParametersDetails() throws {
        //Given
        let id = 550 //Movie "Fight Club"
        let parametersURL = MovieDetailURLParameters()
        let expectation = XCTestExpectation(description: "Perform network request movies with given detail parameters")
        
        //When
        networkService?.requestMoviesDetail(with: parametersURL, withId: id, and: { result in
            switch result {
            case .success( _):
                print("Data received")
                expectation.fulfill()
            case .failure( _):
                break
            }
        })
        //Then
        wait(for: [expectation], timeout: 3.0)
    }
}
