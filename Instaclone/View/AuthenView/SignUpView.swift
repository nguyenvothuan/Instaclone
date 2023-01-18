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
    @State private var profileImage: Image = Image("person.circle.fill")
    @State private var pickedImage: Image = Image("person.circle.fill")
    @State private var imageData: Data = Data()
    @State private var showingActionSheet = false
    @State private var showingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var passwordFailed: Bool = false
    @State private var emailFailed: Bool = false
    @State private var usernameFailed: Bool = false
    var registerCallBack: (Bool) -> Void
    func loadImage() {
        let inputImage = pickedImage
        profileImage = inputImage
       
    }
    
    var body: some View {
        ScrollView {
            VStack (spacing:20){
                Image(systemName: "camera").font(.system(size: 60, weight:.black, design: .monospaced))
                VStack(alignment: .leading) {
                    Text("Welcome").font(.system(size: 32, weight: .heavy))
                    Text("Sign up to start")
                    
                }
                VStack {
                    Group {
                        
                        if profileImage == Image("person.circle.fill") {
                            Image(systemName: "person.circle.fill").resizable().clipShape(Circle()).frame(width:100, height: 100).padding(.top, 20).onTapGesture {
                                self.showingActionSheet = true
                            }
                        }
                        else
                        {
                            profileImage.resizable().clipShape(Circle()).frame(width:100, height: 100).padding(.top, 20).onTapGesture {
                                self.showingActionSheet = true
                            }
                        }
                    }
                    
                    Group {
                        FormField(value: $username, icon: "person.fill", placeholder: "Username")
                        FormField(value: $email, icon: "envelope.fill", placeholder: "Email")
                        FormField(value: $password, icon: "lock.fill", placeholder: "Password", isSecure: true)
                    }
                    Button(action: {
                        if email.isEmpty || !isValidEmail(email: email){
                            emailFailed = true
                            return
                        }
                        if password.isEmpty {
                            passwordFailed = true
                            return
                        }
                        if username.isEmpty {
                            usernameFailed = true
                            return
                        }
                        usernameFailed = false
                        emailFailed = false
                        passwordFailed = false
                        AuthManager.shared.registerNewUser(username: username, email: email, password: password) { registered in
                            DispatchQueue.main.async {
//                                if registered {
//                                    print("shit")
//                                } else {
//                                    print("trash")
//                                }
                                registerCallBack(registered)
                            }
                        }
                        
                        
                    }) {
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
            }.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(pickedImage: self.$pickedImage, showImagePicker: self.$showingImagePicker, imageData: self.$imageData)
            }.actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text(""), buttons: [
                    .default(Text("Choose a Photo")) {
                        self.sourceType = .photoLibrary
                        self.showingImagePicker = true
                    },
                    .default(Text("Take a Photo")) {
                        self.sourceType = .camera
                        self.showingImagePicker = true
                        
                    },.cancel()
                        
                ])
            }
        }
        
    }
    

}


