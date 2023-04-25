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
    
    init() {
        UITableView.appearance().backgroundColor = .init(UIColor(red: 146/255, green: 200/255, blue: 253/255, alpha: 1))
    }
    
    let db = Firestore.firestore()
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    ForEach(habitsVM.habits) { habit in
                        RowView(habit: habit, vm: habitsVM)
                        
                            .listRowBackground(Color(red: 146/255, green: 200/255, blue: 253/255))
                            .font(.system(size: 20))
                            .padding(10)
                            .bold()
                        
                    }
                    .onDelete() { indexSet in
                        for index in indexSet {
                            habitsVM.deleteHabit(index: index)
                        }
                    }
                }
                
                // pops up so user can add a habit
                .alert("Add", isPresented: $showAddHabit) {
                    TextField("Add new habit", text: $newHabit)
                    Button("Add", action: {
                        habitsVM.saveHabits(habit: newHabit)
                        newHabit = ""
                    })
                    Button("Cancel", action: {
                        newHabit = ""
                    })
                }
                
                Button {
                    showAddHabit = true
                } label: {
                    Text("Add")
                }
            }.onAppear() {
                habitsVM.habitChanges()
            }
        }
    }
    
    struct RowView: View {
        let habit : Habit
        let vm : HabitsVM
        
        var body: some View {
            HStack {
                if habit.nameOfHabit.count > 15 {
                    Text(habit.nameOfHabit.prefix(15) + "...")
                } else {
                    Text(habit.nameOfHabit)
                }
                Spacer()
                Button {
                    vm.toggle(habit: habit)
                } label: {
                    HStack {
                        Text(" 23🔥")
                            .padding(5)
                            .font(.system(size: 15))
                        Image(systemName: habit.done ? "checkmark.square" : "square")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            HabitsListView()
        }
    }
}
