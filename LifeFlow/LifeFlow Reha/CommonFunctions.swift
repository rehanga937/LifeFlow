//
//  CommonFunctions.swift
//  LifeFlow Reha
//
//  Created by Rehanga Gamage on 2023-08-16.
//

import Foundation
import UIKit

func resetTextFieldBackgroundColor(_ textFields: UITextField...){
    for each in textFields{
        each.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
}//used to de-highlight text fields that may have been highlighted from verification functions
func isStringInt (word: String)-> Bool{
    if let x = Int(word){
        return true
    }else{return false}
}//is the string an integer number?


