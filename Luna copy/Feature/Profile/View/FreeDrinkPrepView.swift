//
//  FreeDrinkPrepView.swift
//  Luna
//
//  Created by Ned O'Rourke on 16/5/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct FreeDrinkPrepView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var homeVM : ViewModel
    
    
    @State var confirmDrink = false
    @State var showDrink = false
    
    var body: some View {
        VStack (alignment: .center, spacing: 10) {
            
            Text("Free Drink!")
                .font(.system(size: 40, weight: .heavy))
                .foregroundColor(.primary).opacity(0.8)
                .multilineTextAlignment(.center)
            
            Text("Once you have 15 friends you are eligible for one free drink at one of the venues below")
                .font(.system(size: 20, weight: .heavy))
                .foregroundColor(Color("darkSecondaryText")).opacity(0.7)
                .multilineTextAlignment(.center)
            
            Text("We have something for everyone so get your mates together and have a cheeky one on us")
                .font(.system(size: 20, weight: .heavy))
                .foregroundColor(Color("darkSecondaryText")).opacity(0.7)
                .multilineTextAlignment(.center)
            
            
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(homeVM.venueFreeDrinks, id: \.self) { venue in
                       VenueTileView(ven: venue)
                            .environmentObject(sessionService)
                            .environmentObject(manager)
                            .environmentObject(homeVM)
                    }
                }
            }

            
            
                
            
            
            Spacer()
            
            Button {
                if sessionService.drinkEligibility && sessionService.userDetails.friends.count >= 15 {
                    confirmDrink = true
                }
                
            } label: {
                VStack {
                    Text("Claim Now!")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(width: UIScreen.main.bounds.width*0.9, height: 55)
                .background(sessionService.drinkEligibility && sessionService.userDetails.friends.count >= 15 ? .purple.opacity(0.8) : Color("Error"))
                .cornerRadius(20)
                .padding(.bottom)
            }
            
            

        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonView())
        .navigationBarTitle("", displayMode: .inline)
        .padding(.horizontal)
        .alert("Are you sure you want to claim drink now?", isPresented: $confirmDrink, actions: {
              Button("Cancel", role: .cancel, action: {})
                
            Button(role: .none) {
                confirmDrink.toggle()
                showDrink = true
            } label: {
                Text("I'm Sure")
            }
            .buttonStyle(.plain)
            }, message: {
              Text("You must order drink within 2 minutes of pressing this button")
            })
        
        .sheet(isPresented: $showDrink) {
            ReferFriendView(name: "\(sessionService.userDetails.firstName) \(sessionService.userDetails.lastName)", showDrink: $showDrink)
                .environmentObject(sessionService)
                .interactiveDismissDisabled(true)
        }
        .background(Color("darkBackground"))
    }
}

struct FreeDrinkPrepView_Previews: PreviewProvider {
    static var previews: some View {
        FreeDrinkPrepView()
    }
}
