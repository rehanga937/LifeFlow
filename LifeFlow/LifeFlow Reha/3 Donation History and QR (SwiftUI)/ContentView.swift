//
//  ContentView.swift
//  LifeFlow_vishwa
//
//  Created by user239248 on 8/15/23.
//

import SwiftUI

struct ContentView: View {
    @State private var person: Person?
    @State var navigationLinkActive: Bool = false
    let defaultPerson = Person(name: "Vishwa Panapitiya", NIC: "973050000V")
    @State var reservations: [Reservation] = []
        
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: QRScannerView()) {
                    Text("Scan QR Code")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                NavigationLink(
                    destination: QRView(defaultPerson: defaultPerson),
                    label: {
                        Text("Generate QR Code")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                )
                .padding()
                
                

                // ...
                Button(action: {
                    insertDonorData(NIC: "973050000V") { fetchedReservations in
                        if let fetchedReservations = fetchedReservations {
                            self.reservations = fetchedReservations
                            
                            // Navigate to the DonationHistoryView
                            // Assuming you have a navigationLinkActive binding in your view
                            navigationLinkActive = true
                        }
                    }
                }) {
                    Text("Donation History")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .background(
                    NavigationLink("", destination: DonationHistoryView(reservations: reservations), isActive: $navigationLinkActive)
                        .opacity(0)
                )


                /*
                NavigationLink(destination: PersonView(person: $person)) {
                    Text("Create New Person")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                } */
                .padding()
            }
            .navigationBarTitle("QR Code Tools")
            //.modifier(NavigationBarAppearanceModifier()) // Apply the appearance modifier
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
