////
////  QRScanner.swift
////  Raven Rewards
////
////  Created by Alexander Boldt on 11/25/24.
////
//
//import SwiftUI
//import CodeScanner
//
//struct QRScanner: View {
//    @State var isPresentingScanner = false
//    @State var scannedCode: String = "Scan a QR code to get Started"
//    
//    var scannerSheet : some View {
//        CodeScannerView(
//            codeTypes: [.qr],
//            completion: { result in
//                if case let .success(code) = result {
//                    self.scannedCode = code.string
//                    self.isPresentingScanner = false
//                    DatabaseManager.shared.incrPoints(uid: self.scannedCode)
//                }
//                
//            }
//        )
//    }
//    var body: some View {
//        VStack(spacing: 10){
//            Text(scannedCode)
//
//            Button("Scan QR Code") {
//                self.isPresentingScanner = true
//            }
//            
//            .sheet(isPresented: $isPresentingScanner, content: {
//                self.scannerSheet
//            })
//        }
//    }
//    
//
//}
//
