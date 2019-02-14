//
//  Codable.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 13/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

struct SearchCodable: Codable {
  let hits: [HitCodable]
}

struct HitCodable: Codable {
  let largeImageURL: String
  let webformatURL: String
  let pageURL: String
  let user: String
  
  let likes: Int
  let favorites: Int
  let views: Int
}
