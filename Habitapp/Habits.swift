//
//  File.swift
//  Habitapp
//
//  Created by Marko Paunovic on 2023-04-21.
//

import Foundation
import FirebaseFirestoreSwift

struct Habit : Codable, Identifiable {
    
    @DocumentID var id : String?
    var nameOfHabit : String
    var days : Int = 0
    //var dates : [Date]
    var weeks : Int = 0
    var done : Bool = false
}
