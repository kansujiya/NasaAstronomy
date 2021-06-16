//
//  ViewController.swift
//  NasaAstronomy
//
//  Created by suresh kansujiya on 15/06/21.
//

import UIKit


class PictureOfDayViewController: UIViewController {
        
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var imageData: UILabel!
    @IBOutlet weak var picOfTheDay: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    private var pictureOfDayViewModel : PictureOfDayViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate(){
        self.pictureOfDayViewModel =  PictureOfDayViewModel()
        DispatchQueue.main.async {
            self.pictureOfDayViewModel.bindResponseViewModelToController = { [weak self] in
                guard let weakSelf = self else {return}
                weakSelf.activity.isHidden = true
                weakSelf.dateLabel.text = weakSelf.pictureOfDayViewModel.pictureOfDayData?.date
                weakSelf.imageData.text = weakSelf.pictureOfDayViewModel.pictureOfDayData?.explanation
                weakSelf.imageTitle.text = weakSelf.pictureOfDayViewModel.pictureOfDayData?.title
                let url = weakSelf.pictureOfDayViewModel.pictureOfDayData?.url
                weakSelf.picOfTheDay.downloaded(from: url ?? "", weakSelf.pictureOfDayViewModel.pictureOfDayData?.date ?? "")
            }
        }
        
        self.pictureOfDayViewModel.bindAlertViewModelToController = { [weak self] in
            guard let weakSelf = self else {return}
            let alert = UIAlertController(title: AppConstant.alertTitle, message: AppConstant.alertMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: AppConstant.alertButtonTitle, style: UIAlertAction.Style.default, handler: nil))
            weakSelf.present(alert, animated: true, completion: nil)

        }
    }
}

