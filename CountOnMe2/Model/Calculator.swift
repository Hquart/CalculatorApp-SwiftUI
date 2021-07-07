//
//  Model.swift
//  CountOnMe2
//
//  Created by Naji Achkar on 08/01/2021.
//

import Foundation

final class Calculator: ObservableObject {
    ////////////////////////////////////////////////////////////////////////////
    // MARK: Properties
    /////////////////////////////////////////////////////////////////////////////
    
    @Published var elements: [String] = [] // Array storing elements of the expression
    @Published var showAlert: Bool = false
  
    // Following sets will be used to identify numbers and operands in the calculator's expression
    var operands: Set = ["+", "-", "*", "/"]
    var numbers: Set = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    ////////////////////////////////////////////////////////////////////////////
    // MARK: Computed Properties
    /////////////////////////////////////////////////////////////////////////////
    var expressionIsCorrect: Bool {
        guard elements.last != nil else {
            return false
        }
        return elements.count >= 3 && expressionHasOperand && !(lastElementIsOperand) && elements.last != "."
            && !(elements.joined().contains("/0"))
    }
    /////////////////////////////////////////////////////////////////////////////
    var expressionHasOperand: Bool {
        return elements.contains("+") || elements.contains("-") || elements.contains("*")
            || elements.contains("/")
    }
    /////////////////////////////////////////////////////////////////////////////
    var canAddOperator: Bool {
        guard elements.last != nil else {
            return false
        }
        return elements.count != 0 && !operands.contains(elements.last!)
            && elements.last != "."
    }
    /////////////////////////////////////////////////////////////////////////////
    var expressionHasResult: Bool {
        return elements.contains("=")
    }
    /////////////////////////////////////////////////////////////////////////////
    var lastElementIsNumber: Bool {
        guard elements.last != nil else {
            return false
        }
        if numbers.contains(elements.last!) {
            return true
        } else {
            return false
        }
    }
    /////////////////////////////////////////////////////////////////////////////
    var lastElementIsOperand: Bool {
        guard elements.last != nil else {
            return false
        }
        if operands.contains(elements.last!) {
            return true
        } else {
            return false
        }
    }
    /////////////////////////////////////////////////////////////////////////////
    // currentNumber = elements after last operand (if one) in expression
    var currentNumber: String {
        var currentNumberArray: [String] = elements
        var operandIndices = [Int]()
        for element in currentNumberArray {
            if operands.contains(element) {
                operandIndices.append(currentNumberArray.lastIndex(of: element)!)
            }
        }
        if let operandIndex = operandIndices.max() {
            currentNumberArray.removeSubrange(0...operandIndex)
        }
        return currentNumberArray.joined()
    }
    // current number is used to avoid two decimals in the same number:
    var currentNumberHasDecimal: Bool {
        if currentNumber.contains(".") {
            return true
        } else {
            return false
        }
    }
    ////////////////////////////////////////////////////////////////////////////
    // MARK: Methods
    /////////////////////////////////////////////////////////////////////////////
    func reset() {
        elements.removeAll()
    }
    // If a number is not decimal, this func will make it decimal to provide Doubles to the NSExpression for correct results
    func makeCurrentNumberDecimal() {
        guard lastElementIsNumber else {
            return
        }
        if currentNumberHasDecimal == false {
            elements.append(".")
            elements.append("0")
        }
    }
    /////////////////////////////////////////////////////////////////////////////
    func performCalcul() {
        let mathExpression = NSExpression(format: "\(elements.joined())")
        var result = mathExpression.expressionValue(with: nil, context: nil) as? Double
        result = round(100 * result!)/100
        elements.append("=")
        elements.append("\(result!)")
    }
    /////////////////////////////////////////////////////////////////////////////
    func correctionButton() {
        // if a result is displayed, expression can't be corrected:
        if expressionHasResult == false {
            if elements.isEmpty == false {
                elements.removeLast()
            }
        }
    }
    /////////////////////////////////////////////////////////////////////////////
    func numberButton(number: String) {
        //If a result is displayed, tapping a number starts a new expression:
        if expressionHasResult {
            elements.removeAll()
            elements.append(number)
        } else if !(elements.isEmpty && number == "0") {
            // a number can't start with zero
            elements.append(number)
        }
    }
    /////////////////////////////////////////////////////////////////////////////
    func decimalButton() {
        // if the user enters a decimal at first, we provide the zero with it:
        if elements.isEmpty {
            elements.append("0")
            elements.append(".")
        } else if lastElementIsNumber && !(currentNumberHasDecimal) {
            elements.append(".")
        }
    }
    /////////////////////////////////////////////////////////////////////////////
    func operandButton(operand: String) {
        makeCurrentNumberDecimal()
        // if there is already a result displayed, we will start a new expression with it:
        if expressionHasResult {
            if let result = elements.last {
                elements.removeAll()
                elements.append("\(result)")
                elements.append("\(operand)")
            }
        } else {
            if canAddOperator {
                elements.append("\(operand)")
            }
        }
    }
    /////////////////////////////////////////////////////////////////////////////
    func equalButton() {
        makeCurrentNumberDecimal()
        if expressionHasResult == false {
            if expressionIsCorrect {
                performCalcul()
            } else {
                showAlert.toggle()
            }
        }
    }
}
