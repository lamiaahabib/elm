//
//  NewIncidentView.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/2/24.
//


import SwiftUI

import SwiftUI

struct NewIncidentView: View {
    @ObservedObject var viewModel: NewIncidentViewModel
    var token: String
    var body: some View {
        VStack(alignment: .leading) {
            Text("Post a New Incident")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            TextField("Description", text: $viewModel.description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
            
            TextField("Latitude", text: $viewModel.latitude)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
                .keyboardType(.decimalPad)
            
            TextField("Longitude", text: $viewModel.longitude)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
                .keyboardType(.decimalPad)
            
            TextField("Type ID", text: $viewModel.typeId)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
                .keyboardType(.numberPad)
            
            TextField("Priority", text: $viewModel.priority)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
                .keyboardType(.numberPad)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.bottom, 10)
            }
            
            if let successMessage = viewModel.successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding(.bottom, 10)
            }
            
            Button(action: {
                viewModel.postNewIncident(token:self.token )
            }) {
                Text("Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 40)
                    .background(Color.blue)
                    .cornerRadius(10.0)
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .disabled(viewModel.isLoading)
        .overlay(viewModel.isLoading ? ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.black.opacity(0.5)) : nil)
    }
}
#Preview {
    NewIncidentView(viewModel: NewIncidentViewModel(), token: "")
    }

