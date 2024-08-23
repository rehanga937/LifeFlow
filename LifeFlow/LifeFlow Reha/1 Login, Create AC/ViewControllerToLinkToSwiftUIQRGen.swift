//
//  ViewControllerToLinkToSwiftUI.swift
//  LifeFlow Reha
//
//  Created by Rehanga Gamage on 2023-08-26.
//

import UIKit
import SwiftUI

class ViewControllerToLinkToSwiftUIQRGen
: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = tabBarController as! TabBarController
        let NIC = tabBar.NIC
        let password = tabBar.password

        let person = Person(name: "Donor", NIC: NIC)
        
        let vc = UIHostingController(rootView: QRView(defaultPerson: person))
        vc.modalPresentationStyle = .currentContext
        present(vc, animated:false)
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
