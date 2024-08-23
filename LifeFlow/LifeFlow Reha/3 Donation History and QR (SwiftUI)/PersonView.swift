//
//  PersonView.swift
//  LifeFlow_vishwa
//
//  Created by user239248 on 8/15/23.
//

import Foundation

struct Person: Codable {
    var name: String
    var NIC: String
}

import SwiftUI

struct PersonView: View {
    @Binding var person: Person?
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var id: String = ""
    
    var body: some View {
        VStack {
            if let existingPerson = person {
                Text("Name: \(existingPerson.name)")
                Text("ID: \(existingPerson.NIC)")
                
                NavigationLink(destination: QRGeneratorView(person: existingPerson)) {
                    Text("Generate QR Code")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            } else {
                TextField("Name", text: $name)
                    .padding()
                TextField("Address", text: $address)
                    .padding()
                TextField("ID", text: $id)
                    .padding()
                
                Button("Create Person") {
                    person = Person(name: name, NIC: id)
                }
                .padding()
            }
        }
        .navigationBarTitle("Person Details")
    }
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        PersonView(person: .constant(nil))
    }
}
