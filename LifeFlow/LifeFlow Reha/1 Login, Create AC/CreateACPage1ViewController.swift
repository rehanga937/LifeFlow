//
//  CreateACPage1ViewController.swift
//  LifeFlow Reha
//
//  Created by Rehanga Gamage on 2023-08-15.
//

import UIKit

class CreateACPage1ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var readyForNext = false
    var sex = false //true - female, false - male
    var DOBEntry: Date?
    

    override func viewDidLoad() {
        super.viewDidLoad()



        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        DP.layer.cornerRadius = DP.frame.height/2
        DP.layer.borderWidth = 2.0
        DP.layer.borderColor = UIColor.black.cgColor
    }//to make DP(Display Picture) a circle
    
    @IBOutlet weak var DOB: UIDatePicker!
    @IBOutlet weak var Sex: UISegmentedControl!
    @IBOutlet weak var DP: UIImageView!
    
    @IBOutlet weak var ErrorText: UITextView!
    
    @IBOutlet weak var FullName: UITextField!
    @IBOutlet weak var ConfirmPasswordTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var NICTextField: UITextField!
    @IBOutlet weak var EmailAddress: UITextField!
    
    @IBAction func TapAddDP(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }//to pick DP from gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else {
                print("No image found")
                return
        }
        DP.image = image
    }//to pick DP from gallery
    
    
    func isEmail(_email: String)-> Bool{
        let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
        let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)
        
        return __emailPredicate.evaluate(with: _email)
    }//valid email address or not
    func extractString (word: String, firstLetter: Int, lastLetter: Int)-> String{
        var newString = ""
        var count = 0
        
        for ch in word{
            count += 1
            if (count < firstLetter){ continue }
            if (count > lastLetter){ break }
            newString += String(ch)
        }
        
        return newString
    }//extract designated part of a string
    func isLeapYearUsingDaysInFebruary(_ targetYear: Int) -> Bool {
        let targetYearFebruary = Calendar.current.range(of: .day, in: .month,
            for: DateComponents(calendar: .current, year: targetYear, month: 2).date!)
        return targetYearFebruary!.count == 29
    }
    func isValidNIC(NIC: String, sex: Bool, dayOfYear:Int, year:Int)->Bool{
        
        if (NIC.count == 10 || NIC.count == 12){
            
            let numberPart = extractString(word: NIC, firstLetter: 1, lastLetter: NIC.count - 1)
            let letterPart = extractString(word: NIC, firstLetter: NIC.count, lastLetter: NIC.count)
            let numberPartUntilDays = extractString(word: NIC, firstLetter: 1, lastLetter: NIC.count - 5)
            var leap = 0 //because in Sri Lanka NIC system, Feb 29th is always counted as the 60th day regardless of if it exists that year or not.
            
            //print("number part: \(numberPart)")
            //print("letter part: \(letterPart)")
            
            if (isStringInt(word: numberPart)){
                var firstDigits: Int = 0
                if ((!isLeapYearUsingDaysInFebruary(year)) && (dayOfYear > 59)){
                    leap = 1
                }
                if (NIC.count == 10){
                    firstDigits = (year%100)*1000 + dayOfYear + leap
                }else{
                    firstDigits = year*1000 + dayOfYear + leap
                }
                if (sex){firstDigits += 500}
                
                //print("number part until days: \(numberPartUntilDays)")
                //print("firstDigits: \(firstDigits)")
                
                if (Int(numberPartUntilDays) == firstDigits){
                    if (isStringInt(word: letterPart)){
                        return false
                    }//final character should always be a letter (usually 'V')
                    return true
                }else{return false}
                
            }else{return false}
            
            
        }else { return false}
        
        //Sri Lankan NICs are either 10 or 13 digits long (NICs issued after 2016 have the full year) and contain the day of the year born to which 500 is added if the holder if female. eg: a person born on Feb 2nd 1997 will have a NIC of 97002... if male and 97502... is female.  A person born on Feb 2nd 2001 will have NIC of 2001002... if male and 2001502... if female
        

        
    }
    

    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch (identifier){
        case "CreateACPg1ToPg2":
            if readyForNext { return true}
            else{return false}
        default: return false
        }
    }//disables segue to to next page if current page input is not valid
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        switch (segue.identifier ?? ""){
        case "CreateACPg1ToPg2":
            let destVC = segue.destination as! CreateACPage2ViewController
            destVC.DOBEntry = DOBEntry!
            destVC.fullName = FullName.text!
            destVC.emailAddress = EmailAddress.text!
            destVC.NIC = NICTextField.text!
            destVC.sex = sex
            destVC.password = PasswordTextField.text!
        default: fatalError("Unexpected Segue identifier: \(segue.identifier ?? "unidentified segue") ")
        }
    }//for data transfer to page 2 of create account
    
    @IBAction func PressNext(_ sender: Any) {
        
        //initialize
        resetTextFieldBackgroundColor(FullName,ConfirmPasswordTextField,PasswordTextField,NICTextField,EmailAddress)
        readyForNext = false
        ErrorText.text = ""
        var errorCount = 0
        
        //date validation
        DOBEntry = DOB.date
        let calendar = Calendar.current
        let year = calendar.component(.year, from: DOB.date)
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: DOB.date)
        let now = Date()
        let age = calendar.dateComponents([.year], from: DOB.date, to: now)
        if ((age.year ?? 0) < 18){
            errorCount += 1
            ErrorText.text = "Age too young. "
        }
        
        //validation of other fields
        switch Sex.selectedSegmentIndex{
            case 0: sex = false
            case 1: sex = true
            default: break
        }
        
        if (FullName.text == ""){
            errorCount += 1
            FullName.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.3)
        }
        
        if (!isEmail(_email: (EmailAddress.text ?? ""))){
            errorCount += 1
            EmailAddress.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.3)
            ErrorText.text += "Invalid Email "
        }
        
        if(!isValidNIC(NIC: (NICTextField.text ?? ""), sex: sex, dayOfYear: dayOfYear!, year: year)){
            errorCount += 1
            NICTextField.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.3)
            ErrorText.text += "Invalid NIC or mismatch with sex/date-of-birth "
        }
        
        if((PasswordTextField.text ?? "").count < 9){
            errorCount += 1
            PasswordTextField.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.3)
            ConfirmPasswordTextField.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.3)
            ErrorText.text += "Password too short "
        }
        if (PasswordTextField.text != ConfirmPasswordTextField.text){
            errorCount += 1
            PasswordTextField.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.3)
            ConfirmPasswordTextField.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.3)
            ErrorText.text += "Passwords don't match "
        }
        
        
        if (errorCount == 0) {
            readyForNext = true
        }
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
