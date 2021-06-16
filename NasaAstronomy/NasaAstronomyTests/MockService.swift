//
//  MockService.swift
//  NasaAstronomyTests
//
//  Created by suresh kansujiya on 16/06/21.
//

import XCTest
@testable import NetworkService

public class MockService: XCTestCase, PicureOfTheDayUseCaseProtocol {
                    
    var completeClosure: ((PictureOfDayModel, APIError?) -> ())!
    
    func fetchSuccess() -> PictureOfDayModel {
        return PictureOfDayModel.init(date: "\(Data())", explanation: "Test explantions", hdurl: "www.nasa.com", mediaType: "json", serviceVersion: "v1", title: "Nasa Picture of the day", url: "")
    }
    
    public func getPictureOfTheDay(from pictureType: PictureOfDayEndpoints, completion: @escaping (Result<PictureOfDayModel?, APIError>) -> Void) {
        completion(.success(fetchSuccess()))
    }
    
    public func getPictureOfTheDayWithError(from pictureType: PictureOfDayEndpoints, completion: @escaping (Result<PictureOfDayModel?, APIError>) -> Void) {
        completion(.failure(.invalidData))
    }
}
