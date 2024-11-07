//
//  ImageLoader.swift
//  RickAndMortyYapDatabase
//
//  Created by Ибрагим Габибли on 04.11.2024.
//

import Foundation
import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    private init() {}

    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {

        if let imageData = StorageManager.shared.loadImage(key: urlString),
           let image = UIImage(data: imageData) {
            completion(image)
            return
        }

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let data,
               let image = UIImage(data: data) {
                StorageManager.shared.saveImage(data, key: urlString)
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}

