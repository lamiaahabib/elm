//
//  ContentView.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/2/24.
//
import SwiftUI

enum AuthenticationState {
    case login
    case otpVerification
    case incidents
    case dashboard
    case newIncident
}

struct ContentView: View {
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var otpViewModel = OTPViewModel()
    @StateObject private var incidentsViewModel = IncidentsViewModel()
    @StateObject private var dashboardViewModel = DashboardViewModel()
    @StateObject private var newIncidentViewModel = NewIncidentViewModel()
    
    @State private var authState: AuthenticationState = .login
    
    var body: some View {
        VStack {
            switch authState {
            case .login:
                LoginView(viewModel: loginViewModel)
                    .onAppear {
                        loginViewModel.otpRequired = false
                    }
                    .onChange(of: loginViewModel.otpRequired) { _ in
                        if loginViewModel.otpRequired {
                            otpViewModel.email = loginViewModel.email
                            authState = .otpVerification
                        }
                    }
            case .otpVerification:
                OTPView(viewModel: otpViewModel)
                    .onAppear {
                        otpViewModel.verificationSuccess = false
                    }
                    .onChange(of: otpViewModel.verificationSuccess) { _ in
                        if otpViewModel.verificationSuccess {
                            incidentsViewModel.fetchIncidents(token: otpViewModel.token ?? "")
                            authState = .incidents
                        }
                    }
            case .incidents:
                IncidentsView(viewModel: incidentsViewModel, token: otpViewModel.token ?? "")
                    .navigationTitle("Incidents")
            case .dashboard:
                DashboardView(viewModel: dashboardViewModel, token: otpViewModel.token ?? "", authState: $authState) // Pass the binding to authState
            case .newIncident:
                NewIncidentView(viewModel: newIncidentViewModel,token:otpViewModel.token ?? "")
                    .navigationTitle("New Incident")
                    .navigationBarItems(trailing: Button(action: {
                        authState = .dashboard
                    }) {
                        Text("Back to Dashboard")
                    })
            }
        }
    }
}

#Preview {
    ContentView()
}
