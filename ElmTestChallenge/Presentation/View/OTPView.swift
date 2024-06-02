//
//  OTPView.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/2/24.
//

import SwiftUI

struct OTPView: View {
    @ObservedObject var viewModel: OTPViewModel
    
    var body: some View {
        VStack {
            Text("Enter OTP")
                .font(.largeTitle)
                .padding(.bottom, 40)
            
            TextField("OTP", text: $viewModel.otp)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .keyboardType(.numberPad)
            
            if viewModel.verificationFailed, let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.bottom, 20)
            }
            
            Button(action: {
                viewModel.verifyOTP()
            }) {
                Text("Verify OTP")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
            
            if viewModel.verificationSuccess {
                Text("Verification successful!")
                    .foregroundColor(.green)
                    .padding(.top, 20)
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top, 20)
            }
        }
        .padding()
    }
}





#Preview {
    OTPView(viewModel: OTPViewModel())
}
