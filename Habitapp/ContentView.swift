//
//  ContentView.swift
//  Habitapp
//
//  Created by Marko Paunovic on 2023-04-20.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State var signeIn = false
    
    var body: some View {
        if !signeIn {
            SignInView(signedIn: $signeIn)
        } else {
            HabitsListView()
        }
    }
}

// *MARK: Sign in View for Anonymous user
struct SignInView : View {
    @Binding var signedIn : Bool
    var auth = Auth.auth()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("habitapp-blur")
                    .resizable()
                    .scaledToFill()
                    .padding(.trailing, 55)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                HStack {
                    Button {
                        auth.signInAnonymously { result, error in
                            if error != nil {
                                print("Failed to singing in")
                            } else {
                                signedIn = true
                            }
                        }
                    } label: {
                        Text("Sign In")
                            .fontWeight(.semibold)
                            .font(.title)
                            .frame(minWidth: 0, maxWidth: 150)
                            .foregroundColor(.black)
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .tint(.blue)
                    .opacity(1)
                }
            }
        }
    }
}

struct HabitsListView : View {
    
    @StateObject var habitsVM = HabitsVM()
    @State var showAddHabit = false
    @State var newHabit = ""
    @State var streak = CalendarTracker()
    @State var isChecked = false
    
    let db = Firestore.firestore()
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    ForEach(habitsVM.habits) { habit in
                        RowView(habit: habit, vm: habitsVM, calendar: streak, isChecked: $isChecked)
                            .disabled(habit.done)
                            .listRowBackground(Color(red: 146/255, green: 200/255, blue: 253/255))
                            .font(.system(size: 20))
                            .padding(10)
                            .bold()
                    }
                    // *MARK: User slides to left for a Option to delete habit
                    .onDelete() { indexSet in
                        for index in indexSet {
                            habitsVM.deleteHabit(index: index)
                        }
                    }
                    HStack {
                        Spacer()
                        HStack{
                            Button("Add habit") {
                                showAddHabit = true
                            }
                            Image(systemName: "plus.circle")
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                }
                // *MARK: pops up view for user to add a habit
                .alert("New habit", isPresented: $showAddHabit) {
                    TextField("Title", text: $newHabit)
                    Button("Add", action: {
                        habitsVM.saveHabits(habit: newHabit, streak: 0)
                        newHabit = ""
                    })
                    Button("Cancel", action: {
                        newHabit = ""
                    })
                }
            }.onAppear() {
                habitsVM.habitChanges()
            }
        }
    }
    
    struct RowView: View {
        var habit : Habit
        
        let vm : HabitsVM
        let calendar : CalendarTracker
        
        @Binding var isChecked: Bool
        
        var body: some View {
            HStack {
                if habit.nameOfHabit.count > 20 {
                    Text(habit.nameOfHabit.prefix(19) + "...")
                } else {
                    Text(habit.nameOfHabit)
                }
                Spacer()
                Button {
                } label: {
                    HStack {
                        if habit.currentStreak >= 1 {
                            Text("\(habit.currentStreak)🔥")
                                .padding(5)
                                .font(.system(size: 15))
                                .foregroundColor(.black)
                        }
                        Image(systemName: habit.done ? "checkmark.square" : "square")
                            .onTapGesture {
                                vm.toggle(habit: habit)
                            }
                    }
                }
            }
            .onAppear() {
                vm.resetToggle(habit: habit)
                calendar.checkStreak(habit: habit)
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            HabitsListView()
        }
    }
}
