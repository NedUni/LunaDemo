//
//  CastVoteView.swift
//  Luna
//
//  Created by Ned O'Rourke on 7/6/2022.
//

import SwiftUI

struct CastVoteView: View {
    
    @EnvironmentObject var sessionService : SessionServiceImpl
    @State var dummyData : Dictionary<String, Double>
    
    
    @State var searhTerm = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(dummyData.sorted(by: >), id: \.key) { key, value in
                        HStack {
                            Text(key)
                            Spacer()
                            Text("\(value)%")
//                            Circle()
//                                .fill(.red)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.horizontal)
                    }
                    HStack {
                        TextField("Search Luna", text: $searhTerm)
                            .padding(8)
                            .cornerRadius(5)
                            .disableAutocorrection(true)
                            .onChange(of: searhTerm) { newTerm in
                                sessionService.searchVenues(term: searhTerm, option: 1)
                            }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    if sessionService.searchVenueResults != [] {
                        HStack {
                            ScrollView (.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(sessionService.searchVenueResults, id: \.self) { venue in
                                        VenueTileView(ven: venue)
                                            .highPriorityGesture(TapGesture().onEnded({
//                                                if !vm.pollData.keys.contains(venue.id) {
//
//                                                }
                                            }))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                
                Spacer()
                
                Button {
                    print("submit")
                } label: {
                    VStack {
                        Text("Submit")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, idealHeight: 40, maxHeight: 40, alignment: .center)
                    .background(.purple.opacity(0.7))
                    .cornerRadius(5)
                    .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.bottom)

                
            }
            .navigationTitle("Where Should We Go?")
        }
    }
}

//struct CastVoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        CastVoteView()
//    }
//}
