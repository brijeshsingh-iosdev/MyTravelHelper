//
//  SearchTrainPresenter.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

class SearchTrainPresenter:ViewToPresenterProtocol {
    var stationsList:[Station] = [Station]()
    var favourite: [Station] = [Station]()

    func searchTapped(source: String, destination: String) {
        let sourceStationCode = getStationCode(stationName: source)
        let destinationStationCode = getStationCode(stationName: destination)
        interactor?.fetchTrainsFromSource(sourceCode: sourceStationCode, destinationCode: destinationStationCode)
    }
    
    var interactor: PresenterToInteractorProtocol?
    var router: PresenterToRouterProtocol?
    var view:PresenterToViewProtocol?

    func fetchallStations() {
        interactor?.fetchallStations()
    }

    private func getStationCode(stationName:String)->String {
        let stationCode = stationsList.filter{$0.stationDesc == stationName}.first
        return stationCode?.stationCode.lowercased() ?? ""
    }
}

extension SearchTrainPresenter: InteractorToPresenterProtocol {
    func showNoStationsPresent(error: NetworkError?) {
        view!.showNoStationAlert(error: error)
    }
    
    func showNoInterNetAvailabilityMessage() {
        view!.showNoInterNetAvailabilityMessage()
    }

    func showNoTrainAvailbilityFromSource() {
        view!.showNoTrainAvailbilityFromSource()
    }

    func fetchedTrainsList(trainsList: [StationTrain]?) {
        if let _trainsList = trainsList {
            view!.updateLatestTrainList(trainsList: _trainsList)
        }else {
            view!.showNoTrainsFoundAlert()
        }
    }
    
    func stationListFetched(list: [Station]) {
        stationsList = list
        view!.saveFetchedStations(stations: list)
    }
}

extension SearchTrainPresenter {
    func saveFavouriteStation(with stationName:String) {
        if let station = stationsList.filter({$0.stationDesc == stationName}).first, self.favourite.contains(where: { $0.stationDesc == stationName }) == false {
            self.favourite.append(station)
        }
    }
    
    func populateStationList() -> [Station] {
        var totalStations = [Station]()
        if self.favourite.isEmpty == false {
            totalStations.append(contentsOf: self.favourite.reversed())
        }
        if self.stationsList.isEmpty == false {
            totalStations.append(contentsOf: self.stationsList)
        }
        return totalStations
    }
}
