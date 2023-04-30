//
//  Base9Differences.swift
//
//  Created by Ashwin Paudel on 2023-04-30.
//

import Foundation

// NOTE: This doesn't work half the time

// Finding the difference between the Base9 and Base10 value when doing addition:
//  Step 1: Find the sum of the top number's digits and divide them by the bottom number. If the value isn't a decimal or a one, then that is the difference.
//  Step 2: Add the digits of the top and bottom number (we'll called the value Beta) then divide that value by the bottom number and check if divisible. If yes, that is the difference. If not, add the digits of the divided number (we'll call it Lambda)
//  Step 3: Check if Lambda is equal to Beta; if true, the difference is equal to one.
//  Step 4: Divide the bottom number by two if Lambda is even, if not, leave it. Then subtract Lambda by the bottom number. That is the final value.

/**
 Description:
 This is a program created by Ashwin Paudel to see if you can convert do addition with of a base 9 number and then convert into a base 10. I decided to experiment with different bases but then I felt like there was a pattern in the adding of base 9 numbers. However, I do believe that this method can be used in other bases as well, with a few more steps maybe.
 
 Here is how you can find the base10 value when you are adding two base 9 numbers. (You will get the difference, just subtract):
 
 Example (Base 10): 50 + 4 = 54
 Example (Base 9): 55 + 4 = 60
 Difference: 60 - 54 = 6
 
 1. **Find the sum of the top number's digits and divide them by the bottom number. If the value isn't a decimal or a one, then that is the difference.**
    (5 + 5) / 4; *Is a decimal value so skip this.*
 2. **Add the digits of the top and bottom number (we'll called the value Beta) then divide that value by the bottom number and check if divisible. If yes, that is the difference. If not, add the digits of the divided number (we'll call it Lambda)**
    (5 + 5 + 4) / 4 = 3.5
    Digital Root = 8
 3. **Check if Lambda is equal to Beta; if true, the difference is equal to one.**
    8 != 3.5; **Skip this step**
 4. **Divide the bottom number by two if Lambda is even, if not, leave it. Then subtract Lambda by the bottom number. That is the final value.**
    4/2 = 2
    8 - 2 = 6
    _OR_
    8 is an even number, so no.
 */

// MARK: Get user input
print("Enter a base 10 number:")
let firstNum = Int(readLine()!)!

print("Enter a second base-9 number:")
let secondNum = Int(readLine()!) ?? 4

print("--------------------------")

// MARK: - Find the sums on each base
let base10Value = firstNum + secondNum
let base9Value = Int(convertToBase9(base10Value))!
let difference = base9Value - base10Value

print("Answer should equal to: \(difference)")
print("--------------------------")

// MARK: - Step 1: Check if sum of first number is divisible by bottom number
let firstNumBase9 = Int(convertToBase9(firstNum))!
let firstNumDigitSum = digitSum(firstNumBase9)
let dividedValue = firstNumDigitSum / secondNum
let isDivisible = (firstNumDigitSum % secondNum == 0)

displayStepOne()

if isDivisible && dividedValue != 1 {
    print("Result is: \(dividedValue) <= Because there were no decimals when dividing the sum of the first number's digits over the second number")
    exit(0)
}

// MARK: - Step 2: Check if adding all digits and dividing by bottom number is divisible
let totalDigitSum = firstNumDigitSum + secondNum
let step2isDivisible = (totalDigitSum % secondNum == 0)
let step2DividedValue_precise = (Double(totalDigitSum) / Double(secondNum))

// Remove until two decimal places
let step2DividedValue = Double(round(100 * step2DividedValue_precise) / 100)

if isDivisible {
    print("Result is: \(step2DividedValue) <= Because there were no decimals when dividing sum of all digits over the second number")
    exit(0)
}


// MARK: - Step 3: Divide all digits by the bottom number
let digitalRootOfDividedValue = digitSum(step2DividedValue)

displayStepTwo()

// Step 4: Check if digital root is equal to sum
let isEqualToSum = digitalRootOfDividedValue == totalDigitSum

displayStepThree()

if isEqualToSum {
    print("Result is: 1 <= Digital Root is equal to the sum")
    exit(0)
}

// MARK: - Step 4: Subtract the bottom number from the digital root
var subtractedValue = 0

// Check if even or odd
let digitalRootIsEven = digitalRootOfDividedValue.isEven
if digitalRootIsEven {
    subtractedValue = digitalRootOfDividedValue - (secondNum/2)
} else {
    subtractedValue = digitalRootOfDividedValue - secondNum
}

displayStepFour()

// MARK: - Show the value to the user

func displayStepOne() {
    print("Step 1: Find the sum of the top number's digits and divide them by the bottom number. If the value isn't a decimal or a one, then that is the difference.")
    print("\(firstNumDigitSum) / \(secondNum) = \(dividedValue)")
    print("--------------------------")
}

func displayStepTwo() {
    print("Step 2: Add the digits of the top and bottom number (we'll called the value Beta) then divide that value by the bottom number and check if divisible. If yes, that is the difference. If not, add the digits of the divided number (we'll call it Lambda)")
    print("\(displayAddDigits(firstNumBase9)) + \(secondNum) = \(totalDigitSum)")
    print("\(totalDigitSum) / \(secondNum) = \(step2DividedValue)")
    print("\(displayAddDigits(step2DividedValue)) = \(digitalRootOfDividedValue)")
    print("--------------------------")
}

func displayStepThree() {
    print("Step 3: Check if Lambda is equal to Beta; if true, the difference is equal to one.")
    print("\(digitalRootOfDividedValue) == \(totalDigitSum) = \(isEqualToSum)")
    print("--------------------------")
}

func displayStepFour() {
    print("Step 4: Divide the bottom number by two if Lambda is even, if not, leave it. Then subtract Lambda by the bottom number. That is the final value.")
    print("\(digitalRootOfDividedValue) is Even = \(digitalRootIsEven)")
    if digitalRootIsEven {
        print("\(digitalRootOfDividedValue) - \(secondNum) / 2 = \(subtractedValue)")
    } else {
        print("\(digitalRootOfDividedValue) - \(secondNum) = \(subtractedValue)")
    }
    
    print("--------------------------")
    print("The difference is: \(subtractedValue)")
}

// MARK: - Functions

// Convert a decimal number to base 9
func convertToBase9(_ decimalNumber: Int) -> String {
    var quotient = decimalNumber
    var result = ""
    
    while quotient > 0 {
        let remainder = quotient % 9
        result = String(remainder) + result
        quotient /= 9
    }
    
    return result.isEmpty ? "0" : result
}

// Get the sum of digits
func digitSum<T: Numeric>(_ number: T) -> Int {
    let digitString = String(describing: number)
    return digitString.compactMap { Int(String($0)) }.reduce(0, +)
}

// Display the digits of a number as an addition operation
func displayAddDigits<T: Numeric>(_ number: T) -> String {
    let digitString = String(describing: number)
    var digits = ""
    
    for c in digitString {
        if c == "." { continue }
        
        digits.append(c)
        digits.append(" + ")
    }
    
    digits.removeLast()
    digits.removeLast()
    digits.removeLast()
    
    return digits
}


// Check if an integer is even or odd
extension BinaryInteger {
    var isEven: Bool { isMultiple(of: 2) }
    var isOdd:  Bool { !isEven }
}
