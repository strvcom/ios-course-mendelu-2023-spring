//
//  Button.swift
//  City Guide
//
//  Created by David Prochazka on 29.03.2023.
//

import SwiftUI

struct CapsuleBlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.all, 10)
            .background(Color(.systemBlue))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

struct Button_Previews: PreviewProvider {
    static var previews: some View {
        Button("Press me"){
            
        }.buttonStyle(CapsuleBlueButton())
    }
}
