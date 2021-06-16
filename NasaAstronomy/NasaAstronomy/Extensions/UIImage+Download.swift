//
//  UIImage+Download.swift
//  NasaAstronomy
//
//  Created by suresh kansujiya on 15/06/21.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL?, _ cacheKey: String?, imageCache: NSCache<AnyObject, AnyObject>, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = url else {return}
        contentMode = mode
        
        if let imageFromCache = imageCache.object(forKey: cacheKey as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                imageCache.setObject(image, forKey: cacheKey as AnyObject)
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, _ cacheKey: String?, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, cacheKey, imageCache: NSCache<AnyObject, AnyObject>(), contentMode: mode)
    }
}
