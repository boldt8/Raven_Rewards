//
//  QRScanner.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 11/25/24.
//

import SwiftUI
import CodeScanner

struct QRScanner: View {
    @State var isPresentingScanner = false
    @State var scannedCode: String = "Scan a QR code to get started"
    @State var points = "\(DatabaseManager.shared.lastPointValue)"
    
    var scannerSheet : some View {
        CodeScannerView(
            codeTypes: [.qr],
            completion: { result in
                if case let .success(code) = result {
                    self.scannedCode = code.string
                    self.isPresentingScanner = false
                    DatabaseManager.shared.incrPoints(
                        username: self.scannedCode,
                        points: DatabaseManager.shared.lastPointValue
                    )
                }
                
            }
        )
    }
    
    var body: some View {
        VStack(spacing: 10){
            if #available(iOS 15.0, *) {
                TextField("Enter point value", text: $points)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .onSubmit {
                        DatabaseManager.shared.lastPointValue = Int(points) ?? 0
                    }
            } else {
                // Fallback on earlier versions
            }
            
            Text(scannedCode)

            Button("Scan QR Code") {
                self.isPresentingScanner = true
            }
            
            .sheet(isPresented: $isPresentingScanner, content: {
                self.scannerSheet
            })
        }
    }
    

}

