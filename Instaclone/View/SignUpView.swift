//
//  SignUpView.swift
//  Instaclone
//
//  Created by Nguyen Vo Thuan on 1/10/23.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    var body: some View {
        VStack (spacing:20){
            Image(systemName: "camera").font(.system(size: 60, weight:.black, design: .monospaced))
            VStack(alignment: .leading) {
                Text("Welcome").font(.system(size: 32, weight: .heavy))
                Text("Sign up to start")
                
            }
            FormField(value: $username, icon: "person.fill", placeholder: "Username")
            FormField(value: $email, icon: "envelope.fill", placeholder: "Email")
            FormField(value: $password, icon: "lock.fill", placeholder: "Password", isSecure: true)
            Button(action: {}) {
                Text("Sign Up").font(.title).modifier(ButtonModifier())
            }
            HStack {
                Text("Got an account?")
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text("Sign In").font(.system(size: 20, weight: .semibold)).foregroundColor(.black)
                }
            }
        }.padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
