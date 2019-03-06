//
//  APIManager.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 13/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import Alamofire

class APIManager {
  
  private struct URLs {
    static let baseUrl: String = "https://pixabay.com/api/?key="
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
    
    guard let url = URL(string: urlString) else {
      result(nil, nil)
      return
    }
    
    // Making a request and returning error OR array of image urls
    Alamofire.request(url).responseData { (response) in
      if let responseData = response.data {
        do {
          let searchCodable = try JSONDecoder().decode(SearchCodable.self, from: responseData)
          result(searchCodable, nil)
        } catch let error {
          result(nil, error)
        }
      } else {
        result(nil, response.error)
      }
    }
  }
  
}
