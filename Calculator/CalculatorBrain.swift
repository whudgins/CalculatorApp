//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Will Hudgins on 2/5/15.
//  Copyright (c) 2015 Will Hudgins. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    /* notes:
        visibility: public is default. private is specified. if you specify public its more for framework etc.
        functions: classes are passed by reference, structs are passed by value.
    */
    
    // enum can be more than just a string!
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    // can also be [Op]()
    private var opStack = Array<Op>()
    
    // can also be [String:Op]()
    private var knownOps = Dictionary<String, Op>();
    
    init() {
        // closures: can take already written functions. infers arguments
        // multiply & add built into swift
        // can't do divide & minus bc order is backwards
        
        func addOp(op: Op) {
            knownOps[op.description] = op
        }
        
        addOp(Op.BinaryOperation("×", *))
        addOp(Op.BinaryOperation("÷") {$1 / $0})
        addOp(Op.BinaryOperation("+", +))
        addOp(Op.BinaryOperation("−") {$1 - $0})
        addOp(Op.UnaryOperation("√", sqrt))
    }
    
    // name your tuples, best practice
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double?  {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if  let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}