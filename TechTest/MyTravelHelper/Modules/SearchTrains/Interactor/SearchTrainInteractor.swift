//
//  SearchTrainInteractor.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation
import XMLParsing

class SearchTrainInteractor: PresenterToInteractorProtocol {
    var _sourceStationCode = String()
    var _destinationStationCode = String()
    var presenter: InteractorToPresenterProtocol?
    
    func fetchallStations() {
        if Reach().isNetworkReachable() == true {
            let networkAdapter = NetworkAdapter.shared
            networkAdapter.requestAPI(with: StationAPI.allStations) { (result) in
                // Make sure we downloaded some data.
                switch result {
                case .success(let data):
                    guard let data = data else {
                        DispatchQueue.main.async {
                            self.presenter!.showNoStationsPresent(error: NetworkError.clientError)
                        }
                        return
                    }
                    let station = try? XMLDecoder().decode(Stations.self, from: data)
                    self.presenter!.stationListFetched(list: station!.stationsList)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.presenter!.showNoStationsPresent(error: error)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.presenter!.showNoInterNetAvailabilityMessage()
            }
        }
    }

    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {
        _sourceStationCode = sourceCode
        _destinationStationCode = destinationCode
        if Reach().isNetworkReachable() {
            let networkAdapter = NetworkAdapter.shared
            networkAdapter.requestAPI(with: StationAPI.trainsFromSource(sourceCode: sourceCode)) { (result) in
                switch result {
                case .success(let data):
                    guard let data = data else {
                        DispatchQueue.main.async {
                            self.presenter!.showNoTrainAvailbilityFromSource()
                        }
                        return
                    }
                    let stationData = try? XMLDecoder().decode(StationData.self, from: data)
                    if let _trainsList = stationData?.trainsList {
                        self.proceesTrainListforDestinationCheck(trainsList: _trainsList)
                    } else {
                        DispatchQueue.main.async {
                            self.presenter!.showNoTrainAvailbilityFromSource()
                        }
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.presenter!.showNoTrainAvailbilityFromSource()
                    }
                }
            }
        } else {
            self.presenter!.showNoInterNetAvailabilityMessage()
        }
    }
    
    private func proceesTrainListforDestinationCheck(trainsList: [StationTrain]) {
        var _trainsList = trainsList
        let today = Date()
        let group = DispatchGroup()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateString = formatter.string(from: today)
        let networkAdapter = NetworkAdapter.shared
        
        for (index, train) in trainsList.enumerated() {
            group.enter()
            if Reach().isNetworkReachable() {
                networkAdapter.requestAPI(with: StationAPI.trainsForDestination(trainCode: train.trainCode, dateString: dateString)) { (result) in
                    switch result {
                    case .success(let data):
                        guard let data = data else {
                            group.leave()
                            return
                        }
                        let trainMovements = try? XMLDecoder().decode(TrainMovementsData.self, from: data)
                        if let _movements = trainMovements?.trainMovements {
                            let sourceIndex = _movements.firstIndex(where: {$0.locationCode.caseInsensitiveCompare(self._sourceStationCode) == .orderedSame})
                            let destinationIndex = _movements.firstIndex(where: {$0.locationCode.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame})
                            let desiredStationMoment = _movements.filter{$0.locationCode.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame}
                            let isDestinationAvailable = desiredStationMoment.count == 1

                            if isDestinationAvailable  && sourceIndex! < destinationIndex! {
                                _trainsList[index].destinationDetails = desiredStationMoment.first
                            }
                        }
                    case .failure(_):
                        break
                    }
                    group.leave()
                }
            } else {
                group.leave()
                self.presenter!.showNoInterNetAvailabilityMessage()
            }
        }

        group.notify(queue: DispatchQueue.main) {
            let sourceToDestinationTrains = _trainsList.filter{$0.destinationDetails != nil}
            self.presenter!.fetchedTrainsList(trainsList: sourceToDestinationTrains)
        }
    }
}
