//
//  PictureOfDayViewModelTest.swift
//  NasaAstronomyTests
//
//  Created by suresh kansujiya on 16/06/21.
//

import XCTest
@testable import NasaAstronomy
@testable import NetworkService

class PictureOfDayViewModelTest: XCTestCase {
    
    var useCase: PicureOfTheDayUseCaseProtocol!
    var viewModel: PictureOfDayViewModel!
    
    override func setUp() {
        super.setUp()
        useCase = MockService()
        viewModel = PictureOfDayViewModel()
        viewModel.useCase = useCase
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        useCase = nil
    }
    
    func testAPICall() {
        let expectation = self.expectation(description: "API response successfull")
        viewModel.getPictureOfDayData()
        // wait for write to disk successful
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            XCTAssertNotNil(self.viewModel.pictureOfDayData)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }

}
