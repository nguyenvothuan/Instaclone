//
//  SignInView.swift
//  Instaclone
//
//  Created by Nguyen Vo Thuan on 1/10/23.
//

import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordFailed: Bool = false
    @State private var emailFailed: Bool = false
    var onSuccess: ()->()
    var onError: ()->()
    var registerCallBack: (Bool) -> ()
    var body: some View {
        NavigationView {
            VStack (spacing:20){
                Image(systemName: "camera").font(.system(size: 60, weight:.black, design: .monospaced))
                VStack(alignment: .leading) {
                    Text("Welcome Back").font(.system(size: 32, weight: .heavy))
                    Text("Sign in to continue")
                    
                }
                FormField(value: $email, icon: "envelope.fill", placeholder: "Email", isError: emailFailed)
                FormField(value: $password, icon: "lock.fill", placeholder: "Password", isSecure: true, isError: passwordFailed)
                Button(action: {
                    if email.isEmpty || !isValidEmail(email: email){
                        emailFailed = true
                        return
                    }
                    if password.isEmpty {
                        passwordFailed = true
                        return
                    }
                    emailFailed = false
                    passwordFailed = false
                    
                    AuthManager.shared.loginUser(email: email, password: password) { success in
                        DispatchQueue.main.async {
                            if success {
                                self.onSuccess()
                            }
                            else {
                                self.onError()
                                
                            }
                        }
                        
                    }
                    
                }) {
                    Text("Sign In").font(.title).modifier(ButtonModifier())
                }
                HStack {
                    Text("New?")
                    NavigationLink (destination: SignUpView(registerCallBack: registerCallBack)){
                        Text("Create an account").font(.system(size: 20, weight: .semibold)).foregroundColor(.black)
                    }
                }
            }.padding()
        }
    }
}

//
//struct SignInView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignInView()
//    }
//}
