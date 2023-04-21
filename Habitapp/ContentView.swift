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
            HabitsView()
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

struct HabitsView : View {
    var body: some View {
        Text("hej")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
