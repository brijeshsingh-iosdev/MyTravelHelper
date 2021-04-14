//
//  AllStationsFetchTests.swift
//  MyTravelHelperTests
//
//  Created by Brijesh Singh on 13/04/21.
//

import XCTest
import XMLParsing
@testable import MyTravelHelper

class AllStationsFetchTests: XCTestCase, PresenterToInteractorProtocolTest {

    var presenter: InteractorToPresenterProtocol?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
        presenter = SearchTrainPresenter()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchallStations() {
        var exp: XCTestExpectation? = expectation(description: "stations")

        if Reach().isNetworkReachable() == true {
            let networkAdapter = NetworkAdapter.shared
            networkAdapter.requestAPI(with: StationAPI.allStations) { (result) in
                // Make sure we downloaded some data.
                switch result {
                case .success(let serverData):
                    guard let data = serverData else {
                        XCTAssertNil(serverData, "Data not getting from server")
                        return
                    }
                    let station = try? XMLDecoder().decode(Stations.self, from: data)
                    XCTAssertNotNil(station, "Sucessfully recives stations")
                case .failure(let error):
                    XCTAssertNotNil(error, "Service Error")
                }
                exp?.fulfill()
                exp = nil
            }
        } else {
            exp?.fulfill()
        }
        
        waitForExpectations(timeout: 30.0) { (error) in
            if let error = error {
                XCTAssertNotNil(error, error.localizedDescription)
            }
        }
    }
    
    func testFetchTrainsFromSource(sourceCode: String, destinationCode: String) {
        
    }

}
