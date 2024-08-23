//
//  CreateAppointmentViewController.swift
//  LifeFlow Reha
//
//  Created by Rehanga Gamage on 2023-08-24.
//

import UIKit

class CreateAppointmentViewController: UIViewController {

    var NIC: String = ""
    var password: String = ""
    
    var locationName: String = ""
    var FW : Character = "n"
    var UWL : Character = "n"
    var RD : Character = "n"
    var SG : Character = "n"
    var answered: Bool = false
    
    var responseStringMessage: String = "hasnt been edited"
    var passMessage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LocationTV.text = locationName
    }
    
    @IBOutlet weak var LocationTV: UITextView!
    @IBOutlet weak var ErrorTV: UITextView!
    @IBOutlet weak var DatePicker: UIDatePicker!
    
    @IBOutlet weak var FWPOutlet: UISegmentedControl!
    @IBOutlet weak var UWLOutlet: UISegmentedControl!
    @IBOutlet weak var RDOutlet: UISegmentedControl!
    @IBOutlet weak var SGOutlet: UISegmentedControl!
    @IBOutlet weak var FilledQuestionnaireOutlet: UISwitch!
    
    @IBAction func FWPSwitch(_ sender: Any) {
        switch FWPOutlet.selectedSegmentIndex{
            case 0: FW = "n"
            case 1: FW = "y"
            default: break
        }
    }
    @IBAction func UWLSwitch(_ sender: Any) {
        switch UWLOutlet.selectedSegmentIndex{
            case 0: UWL = "n"
            case 1: UWL = "y"
            default: break
        }
    }
    @IBAction func RDSwitch(_ sender: Any) {
        switch RDOutlet.selectedSegmentIndex{
            case 0: RD = "n"
            case 1: RD = "y"
            default: break
        }
    }
    @IBAction func SGSwitch(_ sender: Any) {
        switch SGOutlet.selectedSegmentIndex{
            case 0: SG = "n"
            case 1: SG = "y"
            default: break
        }
    }
    @IBAction func FilledQuestionnaireSwitch(_ sender: Any) {
        if (FilledQuestionnaireOutlet.isOn) { answered = true }
        else { answered = false }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        switch (segue.identifier ?? ""){
        case "serverErrorAppointment":
            let destVC = segue.destination as! CreateAppointmentLandingVCViewController
            destVC.label = "Server Error"
            destVC.message = "Please show this message to our help desk: \n\n" + passMessage
        case "createSuccessAppointment":
            let destVC = segue.destination as! CreateAppointmentLandingVCViewController
            destVC.label = "Submission Successful"
            destVC.message = "You will be notified when your account is approved."
        case "createFailAppointment":
            let destVC = segue.destination as! CreateAppointmentLandingVCViewController
            destVC.label = "Submission Failed"
            destVC.message = "Please show this message to our help desk: \n\n" + passMessage
        default: fatalError("Unexpected Segue identifier: \(segue.identifier ?? "unidentified segue") ")
        }
    }//for data transfer to create appointment landing page
    
    
    @IBAction func TapReserve(_ sender: Any) {
        //validate and create reservation
        
        var errorCount = 0
        ErrorTV.text = ""
        
        //validate date and time of reservation:
        var reservationDateTime = DatePicker.date
        if (DatePicker.date < Date()){
            errorCount += 1
            ErrorTV.text += "Appointment must be in the future. \n "
        }
        
        //check if questionnaire has been answered:
        if (answered == false) {
            errorCount += 1
            ErrorTV.text += "Questionnaire must be answered."
        }
        
        if (errorCount == 0) {
            //create appointment
            print("can create appointment")
            
            //alert view while waiting for data to upload to server
            let alert = UIAlertController(title: "Uploading to Server", message: "Please Wait",
            preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
            
            let calendar = Calendar.current
            let year = calendar.component(.year, from: DatePicker.date)
            let month = calendar.component(.month, from: DatePicker.date)
            let day = calendar.component(.day, from: DatePicker.date)
            let hour = calendar.component(.hour, from: DatePicker.date)
            let minute = calendar.component(.minute, from: DatePicker.date)
            let appointmentDateTimeString : String = "\(year)-\(month)-\(day) \(hour):\(minute)"
            
            let urlPath: String = "http://112.135.192.229/insertBloodAppointment.php" //need to update, we currently don't have a static public IP
            let insertURL = URL(string: urlPath)!
            var urlRequest = URLRequest(url: insertURL)
            urlRequest.httpMethod = "POST"
            
            let postString = "NIC=\(NIC)&password=\(password)&locationName=\(locationName)&FW=\(FW)&UWL=\(UWL)&RD=\(RD)&SG=\(SG)&appointmentDateTime=\(appointmentDateTimeString)"
            urlRequest.httpBody = postString.data(using: .utf8)
            urlRequest.timeoutInterval = 30
            

            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                
                
                //error connecting to server
                if error != nil {
                    
                    print("URLSession Error. Error = \(error!)")
                    self.passMessage = error!.localizedDescription
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true) { [weak self] in
                            guard let self = self else { return }
                            self.performSegue(withIdentifier: "serverErrorAppointment", sender: self)
                        }
                    }
                    return
                }
                
                //no issue in connecting to server
                print("response - \(response!)")
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("response string - \(responseString!)")
                self.responseStringMessage = responseString! as String
                
                if (self.responseStringMessage == "success") {
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true) { [weak self] in
                            guard let self = self else { return }
                            self.performSegue(withIdentifier: "createSuccessAppointment", sender: self)
                        }
                    }
                } else {
                    print(self.responseStringMessage)
                    self.passMessage = self.responseStringMessage
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true) { [weak self] in
                            guard let self = self else { return }
                            self.performSegue(withIdentifier: "createFailAppointment", sender: self)
                        }
                    }
                }
                
            }
            task.resume()
            
            
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
