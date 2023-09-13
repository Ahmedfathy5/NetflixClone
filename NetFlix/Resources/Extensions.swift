//
//  Extenions.swift
//  NetFlix
//
//  Created by Ahmed Fathi on 06/09/2023.
//

import Foundation
extension String{
    
    func capitalizeFirtLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
