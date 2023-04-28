//
//  Calendar.swift
//  Habitapp
//
//  Created by Marko Paunovic on 2023-04-25.
//

import Foundation
import Firebase


class CalendarTracker {
    
    let auth = Auth.auth()
    let db = Firestore.firestore()
    
    var currentStreak : Int = 0
    
    func currentDay() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let currentDay = calendar.component(.day, from: date)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "d"
        
         return currentDay
    }
    
    func nextDay() -> Int{
        let date = Date()
        let calendar = Calendar.current
        let nextDay = calendar.component(.day, from: date)
        
        print("\(nextDay)")
        return nextDay + 1
        
        
    }
    
    func CheckStreak() {
        
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits").document("days")

        
        if currentDay() != nextDay() {
            currentStreak += 1
//            habitRef.updateData(["days" : FieldValue.increment(Int64(1))
//                                ])
            
            
        } else {
        }
        
//        habitRef.updateData(["days" : FieldValue.increment(Int64(1))
//                            ])
        print(habitRef)
    }
}
