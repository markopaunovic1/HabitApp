//
//  File.swift
//  Habitapp
//
//  Created by Marko Paunovic on 2023-04-21.
//

import Foundation
import FirebaseFirestoreSwift

struct Habit : Codable, Identifiable {
    
    // *MARK:
    
    @DocumentID var id : String?
    var nameOfHabit : String
    var currentStreak : Int = 0
    var weeks : Int = 0
    var done : Bool = false
    var latestDone : Date
}
