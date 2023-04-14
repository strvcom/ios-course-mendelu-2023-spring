//
//  ErrorView.swift
//  City Guide
//
//  Created by David Prochazka on 29.03.2023.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack{
            Image("empty")
                .resizable()
                .scaledToFit()
                .padding()
            
            Text("Sorry, something is broken 😟")
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
