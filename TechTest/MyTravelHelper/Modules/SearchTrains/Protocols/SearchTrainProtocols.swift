//
//  SearchTrainProtocols.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

protocol ViewToPresenterProtocol: class{
    var view: PresenterToViewProtocol? {get set}
    var interactor: PresenterToInteractorProtocol? {get set}
    var router: PresenterToRouterProtocol? {get set}
    func fetchallStations()
    func searchTapped(source:String,destination:String)
    func saveFavouriteStation(with stationName:String)
    func populateStationList() -> [Station]
}

protocol PresenterToViewProtocol: class{
    func saveFetchedStations(stations:[Station]?)
    func showInvalidSourceOrDestinationAlert()
    func updateLatestTrainList(trainsList: [StationTrain])
    func showNoTrainsFoundAlert()
    func showNoTrainAvailbilityFromSource()
    func showNoInterNetAvailabilityMessage()
    func showNoStationAlert(error: NetworkError?)
}

protocol PresenterToRouterProtocol: class {
    static func createModule()-> SearchTrainViewController
}

protocol PresenterToInteractorProtocol: class {
    var presenter:InteractorToPresenterProtocol? {get set}
    func fetchallStations()
    func fetchTrainsFromSource(sourceCode:String,destinationCode:String)
}

protocol InteractorToPresenterProtocol: class {
    func stationListFetched(list:[Station])
    func fetchedTrainsList(trainsList:[StationTrain]?)
    func showNoTrainAvailbilityFromSource()
    func showNoInterNetAvailabilityMessage()
    func showNoStationsPresent(error: NetworkError?)
}

protocol PresenterToInteractorProtocolTest: class {
    var presenter:InteractorToPresenterProtocol? {get set}
    func testFetchallStations()
    func testFetchTrainsFromSource(sourceCode:String,destinationCode:String)
}

protocol ViewToPresenterProtocolTest: class{
    var view: PresenterToViewProtocol? {get set}
    var interactor: PresenterToInteractorProtocolTest? {get set}
    var router: PresenterToRouterProtocol? {get set}
    func fetchallStations()
    func searchTapped(source:String,destination:String)
    func saveFavouriteStation(with stationName:String)
    func populateStationList() -> [Station]
}
