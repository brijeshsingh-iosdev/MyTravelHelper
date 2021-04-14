//
//  SearchTrainPresenterTests.swift
//  MyTravelHelperTests
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import XCTest
@testable import MyTravelHelper

class SearchTrainPresenterTests: XCTestCase {
    var presenter: SearchTrainPresenterMock!
    var view = SearchTrainMockView()
    var interactor: PresenterToInteractorProtocolTest = AllStationsFetchTests()
    
    override func setUp() {
      presenter = SearchTrainPresenterMock()
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter as? InteractorToPresenterProtocol
    }

    func testfetchallStations() {
        interactor.testFetchallStations()

//        XCTAssertTrue(view.isSaveFetchedStatinsCalled)
    }

    override func tearDown() {
        presenter = nil
    }
}


class SearchTrainMockView:PresenterToViewProtocol {
    func showNoStationAlert(error: NetworkError?) {
        
    }
    
    func saveFetchedStations(stations: [Station]?) {
//        isSaveFetchedStatinsCalled = true
    }

    func showInvalidSourceOrDestinationAlert() {

    }
    
    func updateLatestTrainList(trainsList: [StationTrain]) {

    }
    
    func showNoTrainsFoundAlert() {

    }
    
    func showNoTrainAvailbilityFromSource() {

    }
    
    func showNoInterNetAvailabilityMessage() {

    }
}

class SearchTrainPresenterMock: ViewToPresenterProtocolTest  {
    var view: PresenterToViewProtocol?
    
    var interactor: PresenterToInteractorProtocolTest?
    
    var router: PresenterToRouterProtocol?
    
    func fetchallStations() {
        
    }
    
    func searchTapped(source: String, destination: String) {
        
    }
    
    func saveFavouriteStation(with stationName: String) {
        
    }
    
    func populateStationList() -> [Station] {
        return []
    }
    
    
}

class SearchTrainInteractorMock:PresenterToInteractorProtocol {
    var presenter: InteractorToPresenterProtocol?

    func fetchallStations() {
        let station = Station(desc: "Belfast Central", latitude: 54.6123, longitude: -5.91744, code: "BFSTC", stationId: 228)
        presenter?.stationListFetched(list: [station])
    }

    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {

    }
}
