//
//  AstronomyTests.swift
//  AstronomyTests
//
//  Created by Marissa Gonzales on 6/14/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest
@testable import Astronomy

class RoverClientTest: XCTestCase {

    func testFetchMarsRover() {
        let mock = MockLoader()
        mock.data = validRoverJSON

        var rover: MarsRover? = nil
        let client = MarsRoverClient(networkLoader: mock)

        let resultsExpectation = expectation(description: "Waiting for results")

        client.fetchMarsRover(named: "Curiosity") { (aRover, error) in
            if let aRover = aRover {
                resultsExpectation.fulfill()
                rover = aRover
            }
        }

        wait(for: [resultsExpectation], timeout: 2)

        XCTAssertNotNil(rover)
        XCTAssertEqual(rover?.name, "Curiosity")
    }

    func testFetchingPhotos() {
        let mock = MockLoader()
        mock.data = validSol1JSON
        let client = MarsRoverClient(networkLoader: mock)

        let expectation = self.expectation(description: "Photo Fetch Expectation")
        let jsonDecoder = MarsPhotoReference.jsonDecoder
        let rover = (try! jsonDecoder.decode([String : MarsRover].self, from: validRoverJSON))["photo_manifest"]!
        client.fetchPhotos(from: rover, onSol: 1) { (photos, error) in
            defer { expectation.fulfill() }
            XCTAssertNotNil(photos)
            XCTAssertNil(error)

            XCTAssertEqual(photos?.count, 16)
            let firstPhoto = photos![0]
            XCTAssertEqual(firstPhoto.sol, 1)
            XCTAssertEqual(firstPhoto.camera.name, "MAST")
            XCTAssertNotNil(firstPhoto.imageURL)
        }
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
