//
//  UIImage+Download.swift
//  NasaAstronomy
//
//  Created by suresh kansujiya on 15/06/21.
//

import Foundation
import UIKit
import NetworkService
let mime = "image"

extension UIImageView {
    func downloaded(from url: String?, _ cacheKey: String?, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        guard let urlValue = url, let url = URL(string: urlValue) else { return }
        
        let key = (shortStringValueInYYYYMMDDAsDate(Date()) ?? "") + mime
        
        if DataCache.instance.hasData(forKey: key) {
            let cacheImage = DataCache.instance.readImageForKey(key: key)
            DispatchQueue.main.async {
                self.image = cacheImage
            }
            
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix(mime),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                else { return }
                DataCache.instance.write(image: image, forKey: key)
                DispatchQueue.main.async {
                    self.image = image
                }
            }.resume()
        }
    }
}
