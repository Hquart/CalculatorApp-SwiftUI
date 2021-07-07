//
//  CountOnMe2App.swift
//  CountOnMe2
//
//  Created by Naji Achkar on 08/01/2021.
//


import Combine
import SwiftUI

@main
struct CountOnMe2App: App {
    
    var expression = Calculator()
    
    var body: some Scene {
        WindowGroup {
            ContentView(calculator: expression)
        }
    }
}
