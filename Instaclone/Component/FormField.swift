//
//  FormField.swift
//  Instaclone
//
//  Created by Nguyen Vo Thuan on 1/10/23.
//

import SwiftUI

struct FormField: View {
    @Binding var value: String
    var icon: String
    var placeholder: String
    var isSecure = false //show password or not
    var isError = false
    var body: some View {
        Group {
            HStack{
                Image(systemName: icon).padding()
                Group{
                    if isSecure {
                        SecureField(placeholder, text: $value).textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    else {
                        TextField(placeholder, text: $value).keyboardType(.emailAddress)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                .font(Font.system(size:20, design: .monospaced))
                .foregroundColor(.black)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.leading)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.none)
                
            }
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(isError ? Color.red : Color.gray, lineWidth: 4)).padding()
//            .border(isError ? Color.red : Color.clear, width: 2)
        }
    }
}


