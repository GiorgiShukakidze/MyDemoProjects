//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Giorgi Shukakidze on 3/18/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    private var number: Double?
    private var interimCalculation: (calcMethod: String, num: Double)?
    var isClear = true
    
    mutating func setNumber(_ value: Double){
        self.number = value
    }
    
    mutating func calculate(with operation: String) -> Double? {
        if let numValue = number {
            switch operation {
            case "AC":
                interimCalculation = nil
                return 0
            case "+/-":
                return numValue * -1
            case "%":
                return numValue * 0.01
            case "=":
                return multiStepCalculations(on: numValue)
            case "C":
                isClear = true
                return 0
            default:
                if interimCalculation == nil {
                    interimCalculation = (calcMethod: operation, num: numValue)
                }else {
                    if let result = multiStepCalculations(on: numValue) {
                        interimCalculation = (calcMethod: operation, num: result)
                        return result
                    }
                }
            }
        }
        return nil
    }
    
    private func multiStepCalculations(on number: Double) -> Double? {
        if let savedCalculation = interimCalculation {
            switch savedCalculation.calcMethod {
            case "×":
                return savedCalculation.num * number
            case "÷":
                if number != 0 {
                    return savedCalculation.num / number
                }
            case "-":
                return savedCalculation.num - number
            case "+":
                return savedCalculation.num + number
            default:
                return nil
            }
        }
        return nil
    }
}
