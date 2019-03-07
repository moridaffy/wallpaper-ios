//
//  APIManager.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 07/03/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import Alamofire

class APIManager {
  
  private static let manager: SessionManager = {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    return SessionManager(configuration: configuration)
  }()
  
  private struct URLs {
    static let baseUrl: String = "https://pixabay.com/api/?key="
  }
  
  static var pixabayApiKey: String {
    // Your Pixabay API key should go here
    return hiddenApiKey
  }
  
  class func loadImages(search: String?, page: Int = 1, completion result: @escaping (SearchCodable?, Error?) -> Void) {
    // Constructing and checking request url
    var urlString = URLs.baseUrl + pixabayApiKey + "&min_width=750&min_height=1334"
    if let search = search {
      urlString += "&q=\(search)"
    } else {
      urlString += "&editors_choice=true"
    }
    urlString += "&page=\(page)"
    urlString += "&per_page=\(SettingsManager.shared.perPage.value)"
    
    guard let url = URL(string: urlString) else {
      result(nil, nil)
      return
    }
    
    // Making a request and returning error OR array of image urls
    manager.request(url).responseData { (response) in
      if let data = response.data {
        let searchCodable = try? JSONDecoder().decode(SearchCodable.self, from: data)
        result(searchCodable, response.error)
      } else {
        result(nil, response.error)
      }
    }
  }
  
  class func loadImage(urlString: String, result: @escaping (Data?) -> Void) {
    guard let url = URL(string: urlString) else {
      print("🔥 wrong url: \(urlString)")
      result(nil)
      return
    }
    
    manager.request(url).responseData { (response) in
      result(response.data)
    }
  }
}
