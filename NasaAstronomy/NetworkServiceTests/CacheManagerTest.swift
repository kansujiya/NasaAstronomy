//
//  CacheManagerTest.swift
//  NetworkServiceTests
//
//  Created by suresh kansujiya on 16/06/21.
//

import XCTest
@testable import NetworkService

class CacheManagerTest: XCTestCase {
    
    func testReadWriteCache() {
        let str = "testReadWriteCache"
        let key = "testReadWriteCacheKey"
        
        DataCache.instance.write(object:str as NSCoding, forKey: key)
        let cachedString = DataCache.instance.readString(forKey: key)
        
        XCTAssert(cachedString == str)
    }
    
    func testReadWriteCodable() {
        let pictureModel = PictureOfDayModel.init(date: "\(Data())", explanation: "Test explantions", hdurl: "www.nasa.com", mediaType: "json", serviceVersion: "v1", title: "Nasa Picture of the day", url: "")
        let key = "testReadWriteCodableKey"
        
        do {
            try DataCache.instance.write(codable: pictureModel, forKey: key)
            let picModelCache: PictureOfDayModel? = try DataCache.instance.readCodable(forKey: key)
            XCTAssert(picModelCache == pictureModel)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    func testHasDataOnDiskForKey() {
        let str = "testHasDataOnDiskForKey"
        let key = "testHasDataOnDiskForKeyKey"
        let expectation = self.expectation(description: "Write to disk is an asynchonous operation")
        
        DataCache.instance.write(object: str as NSCoding, forKey: key)
        
        // wait for write to disk successful
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            let hasDataOnDisk = DataCache.instance.hasDataOnDisk(forKey: key)
            XCTAssert(hasDataOnDisk == true)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testHasDataOnMemForKey() {
        let str = "testHasDataOnMemForKey"
        let key = "testHasDataOnMemForKeyKey"
        
        DataCache.instance.write(object: str as NSCoding, forKey: key)
        let hasDataOnMem = DataCache.instance.hasDataOnMem(forKey: key)
        
        XCTAssert(hasDataOnMem == true)
    }
    
    func testCleanCache() {
        let str = "testCleanCache"
        let key = "testCleanCacheKey"
        let expectation = self.expectation(description: "Clean is an asynchonous operation")
        
        DataCache.instance.write(object: str as NSCoding, forKey: key)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            DataCache.instance.cleanAll()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
                let cachedString = DataCache.instance.readString(forKey: key)
                XCTAssert(cachedString == nil)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

}
