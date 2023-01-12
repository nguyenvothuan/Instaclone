//
//  ContentView.swift
//  Instaclone
//
//  Created by Nguyen Vo Thuan on 1/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var mail = ""
    @State private var password = ""
    var body: some View {
        VStack {
            FormField(value: $mail, icon: "mail", placeholder: "Email")
            FormField(value: $password, icon: "lock", placeholder: "Password")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
