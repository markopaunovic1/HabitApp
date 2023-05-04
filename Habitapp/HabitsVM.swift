//
//  HabitsVM.swift
//  Habitapp
//
//  Created by Marko Paunovic on 2023-04-21.
//

import Foundation
import Firebase

class HabitsVM : ObservableObject {
    let db = Firestore.firestore()
    let auth = Auth.auth()
    let getStreaks = CalendarTracker()
    let isDone = false
    var date = Date()
    var calendar = Calendar.current
    
    @Published var habits = [Habit]()
    
    // *MARK: Saves new habits to a list
    func saveHabits(habit: String, streak: Int) {
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits")
        
        let habit = Habit(nameOfHabit: habit, currentStreak: streak, latestDone: Date())
        do {
            try habitRef.addDocument(from: habit)
        } catch {
            print("error saving to dataBase")
        }
    }
    
    // *MARK: Updating values when toggled is pressed
    func toggle(habit : Habit) {
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits")
        
        if let id = habit.id {
            
            habitRef.document(id).updateData(["done" : !habit.done,
                                              "currentStreak" : FieldValue.increment(Int64(1)),
                                              "latestDone" :Timestamp(date: date)])
        }
    }
    
    // *MARK: Reseting toggle day after habit is completed
    func resetToggle(habit : Habit) {
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits")
        
        let today = Date()
        
        if let updateToggle = calendar.dateComponents([.day], from: habit.latestDone , to: today).day {
            
            if updateToggle >= 1 {
                if let id = habit.id {
                    habitRef.document(id).updateData(["done" : false])
                }
            }
        }
    }
    
    // *MARK: Listens to new habit changes
    func habitChanges() {
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits")
        
        habitRef.addSnapshotListener() {
            snapshot, error in
            
            guard let snapshot = snapshot else {return}
            
            if let error = error {
                print("error getting document \(error)")
            } else {
                self.habits.removeAll()
                for document in snapshot.documents {
                    do {
                        let habit = try document.data(as : Habit.self)
                        self.habits.append(habit)
                    } catch {
                        print("Error reading from dataBase")
                    }
                }
            }
        }
    }
    
    // *MARK: Deletes habit function
    func deleteHabit(index: Int) {
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits")
        
        let habit = habits[index]
        if let id = habit.id {
            habitRef.document(id).delete()
        }
    }
}
