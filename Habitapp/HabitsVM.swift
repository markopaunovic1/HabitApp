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
    
    @Published var habits = [Habit]()
    
    func saveHabits(habit: String, streak: Int) {
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits")
        
        let habit = Habit(nameOfHabit: habit, days: streak)
        do {
            try habitRef.addDocument(from: habit)
        } catch {
            print("error saving to dataBase")
        }
    }
    
    func toggle(habit : Habit) {
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits")
        
        if let id = habit.id {
            habitRef.document(id).updateData(["done" : !habit.done])
        }
    }
    
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
    
    func getStreaks(streak: Habit) {
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits")
        
        
    }
    
    func deleteHabit(index: Int) {
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits")
        
        let habit = habits[index]
        if let id = habit.id {
            habitRef.document(id).delete()
        }
    }
}
