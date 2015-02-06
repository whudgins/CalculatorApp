//
//  ViewController.swift
//  Calculator
//
//  Created by Will Hudgins on 1/28/15.
//  Copyright (c) 2015 Will Hudgins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var brain = CalculatorBrain()
    var userIsInTheMiddleOfTypingANumber: Bool = false
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }

    }
    
    @IBAction func clearDisplay() {
        display.text = "0"
        userIsInTheMiddleOfTypingANumber = false
        println("Screen cleared")
    }

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        var displayIsZero: Bool = false
        if display.text! == "0" {
            displayIsZero = true
        }
        
        if userIsInTheMiddleOfTypingANumber && !displayIsZero{
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
}

