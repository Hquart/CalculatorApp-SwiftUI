//
//  DisplayView.swift
//  CountOnMe2
//
//  Created by Naji Achkar on 18/02/2021.
//

import SwiftUI

struct DisplayView: View {
    
    @ObservedObject var calculator: Calculator
    
    var text: String {
        if calculator.elements.isEmpty {
            return "0"
        } else {
            return calculator.elements.joined()
                .replacingOccurrences(of: ".0", with: "")
        }
    }
    ///////////////////////////////// /BODY ///////////////////////////////////////////
    var body: some View {
        Text("\(text)")
            .bold()
            .padding(.trailing)
            .frame(minWidth: 250, idealWidth: 300, maxWidth: 350, minHeight: 100, idealHeight: 130, maxHeight: 150, alignment: .trailing)
            .background(Color.appGreen)
            .cornerRadius(25)
            .foregroundColor(.white)
            .font(.title)
    }
}
/////////////////////////////////////////// PREVIEW //////////////////////////////////
struct DisplayView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayView(calculator: Calculator())
            .environmentObject(Calculator())
    }
}
