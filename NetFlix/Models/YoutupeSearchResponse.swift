//
//  YoutupeSearchResponse.swift
//  NetFlix
//
//  Created by Ahmed Fathi on 09/09/2023.
//

import Foundation


struct YoutupeSearchResponse :Codable {
    let items : [VideoElement]
    
}


struct VideoElement : Codable {
    let id : IdVideoElement
}

struct IdVideoElement : Codable {
    let kind : String
    let videoId : String
}
