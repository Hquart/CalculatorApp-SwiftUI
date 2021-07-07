//
//  ContentView.swift
//  CountOnMe2
//
//  Created by Naji Achkar on 08/01/2021.
//
import SwiftUI

struct ContentView: View {
    ////////////////////////////////////////////////////////////////////////////
    // MARK: Properties
    /////////////////////////////////////////////////////////////////////////////
    @StateObject var calculator: Calculator
    @State private var showAlert: Bool = false
    
    var keys = ["AC", "C", "/", "7", "8", "9", "*", "4", "5", "6","-", "1", "2", "3", "+", "0", ".", "="]

    let calculatorAlert = Alert(title: Text("Error"),
                                message: Text("Please enter a correct expression"),
                                dismissButton: .default(Text("OK")))
    
    let gridColumns = [GridItem(.fixed(80), spacing: 10, alignment: .leading),
                                  GridItem(.fixed(80), spacing: 10, alignment: .leading),
                                  GridItem(.fixed(80), spacing: 10, alignment: .leading),
                                  GridItem(.fixed(80), spacing: 10, alignment: .leading)]
    /////////////////////////////////////////////////////////////////////
    // MARK: BODY
    /////////////////////////////////////////////////////////////////////
    var body: some View {
        ZStack {
            Color.appBackground.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Count On Me 2.0 ")
                    .font(.custom("Bullpen3D", size: 30))
                    .foregroundColor(.titleFontColor)
                Spacer()
                /////////////////////////  DISPLAY ///////////////////////////////////////////////////////
                DisplayView(calculator: calculator)
                Spacer()
                /////////////////////////  BUTTONS ///////////////////////////////////////////////////////
                LazyVGrid(columns: gridColumns, spacing: 20) {
                    ForEach(0..<keys.count, id: \.self) { id in
                        Button(action: { self.buttonAction(key: keys[id]) }) {
                            Text(keys[id])
                                .font(.system(size: 30))
                                .foregroundColor(.white).bold()
                        }
                        .frame(width: id == 0 || id == 15 ? 170 : 80, height: 80)
                        .background(colorButton(id: id))
                        .cornerRadius(25)
                        if id == 0  || id == 15 { Color.clear }
                    }
                }
                Spacer()
            }
            .alert(isPresented: $showAlert) { calculatorAlert }
        }
    }
    ////////////////////////////////////////////////////////////////////////////
    // MARK: Methods
    /////////////////////////////////////////////////////////////////////////////
    func buttonAction(key: String) {
        if calculator.numbers.contains(key) {
            calculator.numberButton(number: key)
        } else if calculator.operands.contains(key) {
            calculator.operandButton(operand: key)
        } else if key == "=" {
            calculator.equalButton()
        } else if key == "." {
            calculator.decimalButton()
        } else if key == "C" {
            calculator.correctionButton()
        } else if key == "AC" {
            calculator.reset()
        }
    }
    /////////////////////////////////////////////////////////////////////////////
    // This func is used only to apply desired color to buttons
    func colorButton(id: Int) -> Color {
        if id == 0 || id == 1 || id == 16 {  return Color.appDarkGrey }
        if id == 2 { return Color.appYellow }
        if id == 6 { return Color.appRed }
        if id == 10 { return Color.blue }
        if id == 14 { return Color.appBrown}
        if id == 17 { return Color.appGreen }
        return Color.appLightGrey
    }
}

////////////////////////////////////////////////////////////////////////////
// MARK: Previews
/////////////////////////////////////////////////////////////////////////////
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(calculator: Calculator())
            .environment(\.colorScheme, .light)
    }
}

/////////////////////////  DARK MODE PREVIEW  ///////////////////////////////////////////////////////
struct ContentViewDark_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(calculator: Calculator())
            .environment(\.colorScheme, .dark)
    }
}


