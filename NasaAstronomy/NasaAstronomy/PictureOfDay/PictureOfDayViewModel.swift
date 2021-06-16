//
//  PictureOfDayViewModel.swift
//  NasaAstronomy
//
//  Created by suresh kansujiya on 15/06/21.
//

import Foundation
import NetworkService

class PictureOfDayViewModel {
    
    var useCase : PicureOfTheDayUseCaseProtocol!
    private(set) var pictureOfDayData : PictureOfDayModel? {
        didSet {
            self.bindResponseViewModelToController?()
        }
    }
    
    private(set) var showAlert : Bool? {
        didSet {
            self.bindAlertViewModelToController?()
        }
    }
    
    var bindResponseViewModelToController : (() -> ())?
    var bindAlertViewModelToController : (() -> ())?
    
    init() {
        self.useCase =  PicureOfTheDayUseCase()
        getPictureOfDayData()
    }
    
    func getPictureOfDayData() {
        self.useCase.getPictureOfTheDay(from: .getPictureOfDay, completion: {[weak self] result in
            switch result {
            case .success(let picOfDayData):
                self?.pictureOfDayData = picOfDayData
            case .failure:
                self?.showAlert = true
            }
        })
    }
}
