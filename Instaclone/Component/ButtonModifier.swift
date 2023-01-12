//
//  ButtonModifier.swift
//  Instaclone
//
//  Created by Nguyen Vo Thuan on 1/10/23.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 20)
            .padding()
            .foregroundColor(.white)
            .font(.system(size:14, weight: .bold))
            .background(Color.black)
            .cornerRadius(5)
    }
}
