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
    
    @Published var Habits = [Habit]()
    
    
}
