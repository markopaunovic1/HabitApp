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
    
    func currentDay() -> String {
        let date = Date()
        let calendar = Calendar.current
        let currentDay = calendar.component(.day, from: date)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        print("\(dateFormatter.string(from: Date())) : TODAY")
        
       // let today = Calendar.current.dateComponents([.day], from: date))
        
        return dateFormatter.string(from: Date())
        
    }
    
    func yesterDay() -> String {
        let date = Date()
        let calendar = Calendar.current
        //let nextDay = calendar.component(.day, from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        
        
        let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())
         print("\(dateFormatter.string(from: yesterDay!)) : YESTERDAY")
        return dateFormatter.string(from: yesterDay!)
        
        
    }
    
    func CheckStreak(habit: Habit) {
        
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits")

        
        if currentDay() != yesterDay() {
            if let id = habit.id {
                habitRef.document(id).updateData(["currentStreak" : FieldValue.increment(Int64(1))
                                                  ])
            }
        } else {
            print("error adding streak")
        }
        
//        habitRef.updateData(["days" : FieldValue.increment(Int64(1))
//                            ])
        //print(yesterDay())
    }
}
