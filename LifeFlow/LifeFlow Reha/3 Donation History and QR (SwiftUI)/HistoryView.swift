//
//  HistoryView.swift
//  LifeFlow_vishwa
//
//  Created by user239248 on 8/26/23.
//

import SwiftUI

struct HistoryView: View {
    //@State private var isBottomViewVisible = false
    @State var navigationLinkActive: Bool = false
    @State var reservations: [Reservation] = []
    @State var NICInput: String

    var body: some View {
        NavigationView{
            ZStack {
                Color(#colorLiteral(red: 0.8392156863, green: 0.1215686275, blue: 0.1490196078, alpha: 1))
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                    
                    Text("View My Donation History")
                        .font(
                            .system(size: 40, weight: .bold)
                        )
                        .multilineTextAlignment(.center)
                    
                    //Spacer()
                    
                    Button(action: {
                        insertDonorData(NIC: NICInput) { fetchedReservations in
                            if let fetchedReservations = fetchedReservations {
                                self.reservations = fetchedReservations
                                
                                // Navigate to the DonationHistoryView
                                // Assuming you have a navigationLinkActive binding in your view
                                navigationLinkActive = true
                            }
                        }
                    }) {
                        Image("doner_history")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 250)
                            .overlay(Circle().stroke(Color.white, lineWidth: 5))
                            .shadow(color: .white, radius: 5)
                            .padding()
                    }
                    .background(
                        NavigationLink("", destination: DonationHistoryView(reservations: reservations), isActive: $navigationLinkActive)
                            .opacity(0)
                    )

                    /*
                    Button(action: {
                        isBottomViewVisible.toggle()
                    }) {
                        Image("qr_code")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 250)
                            .overlay(Circle().stroke(Color.white, lineWidth: 5))
                            .shadow(color: .white, radius: 5)
                            .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                     
                     */

                    Spacer()
                }
            }
            //.navigationBarTitle("QR Code Generator")
            .foregroundColor(.white)
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}
/*
let sampleReservations: [Reservation] = [
    Reservation(NIC: "973050000V",
                DonationPlace: "Colombo South Teaching Hospital (Kalubowila)",
                DonationDate: DonationDate(date: "2023-08-01 00:00:00.000000", timezone_type: 3, timezone: "Europe/Berlin"),
                BloodProgress: .received),
    
    Reservation(NIC: "973050000V",
                DonationPlace: "Colombo South Teaching Hospital (Kalubowila)",
                DonationDate: DonationDate(date: "2023-06-01 00:00:00.000000", timezone_type: 3, timezone: "Europe/Berlin"),
                BloodProgress: .storage),
    
    Reservation(NIC: "973050000V",
                DonationPlace: "National Hospital of Sri Lanka",
                DonationDate: DonationDate(date: "2023-05-01 00:00:00.000000", timezone_type: 3, timezone: "Europe/Berlin"),
                BloodProgress: .delivered)
]*/

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(NICInput: "963055555V")
    }
}
