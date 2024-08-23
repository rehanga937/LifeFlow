///
//  QRScannerView.swift
//  LifeFlow_vishwa
//
//  Created by user239248 on 8/15/23.
//

import SwiftUI
import CodeScanner

struct QRScannerView: View {
    @State var isPresentingScanner = false
    @State var scannedCode: String = ""
    @State var scannedPerson: Person?
    
    var scannersheet : some View {
        CodeScannerView(
            codeTypes: [.qr],
            completion: { result in
                if case let .success(code) = result {
                    self.scannedCode = code.string
                    self.scannedPerson = decodePerson(from: scannedCode)
                    
                    self.isPresentingScanner = false
                    
                }
                
            })
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                Color(#colorLiteral(red: 0.8392156863, green: 0.1215686275, blue: 0.1490196078, alpha: 1))
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Scan a QR Code to register a person")
                        .font(
                            .system(size: 36, weight: .bold)
                        )
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        self.isPresentingScanner = true
                    }) {
                        Image("qr_scanner")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                            .overlay(Circle().stroke(Color.white, lineWidth: 5))
                            .shadow(color: .white, radius: 5)
                            .padding()
                    }
                    .sheet(isPresented: $isPresentingScanner) {
                        self.scannersheet
                    }
                    
                }
                .foregroundColor(.white)
            }
            //.navigationBarTitle("QR Scanner")
        }
    }
    
}

struct QRScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QRScannerView()
    }
}

func decodePerson(from jsonString: String) -> Person? {
    guard let jsonData = jsonString.data(using: .utf8) else {
        return nil
    }
    
    do {
        let decoder = JSONDecoder()
        let person = try decoder.decode(Person.self, from: jsonData)
        return person
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}

