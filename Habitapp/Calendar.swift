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
    @Published var habits = [Habit]()
    var calendar = Calendar.current
    
    // *MARK: Checks if habits have daily streaks and resets daily streaks if skipped
    func checkStreak(habit: Habit) {
        guard let user = auth.currentUser else {return }
        let habitRef = db.collection("users").document(user.uid).collection("habits")
        let today = Date()
        
        var currentStreak = habit.currentStreak
        if let latestDone = calendar.dateComponents([.day], from: habit.latestDone , to: today).day {
            
            if latestDone > 1 {
                currentStreak = 0
                
                if let id = habit.id {
                    habitRef.document(id).updateData(["currentStreak" : currentStreak])
                }
            }
        }
    }
}
