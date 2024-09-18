//
//  editGrooveDealersView.swift
//  Luna
//
//  Created by Ned O'Rourke on 29/5/2022.
//

import SwiftUI

struct editGrooveDealersView: View {
    
    @EnvironmentObject var sessionService : SessionServiceImpl
    @EnvironmentObject var handler : EventViewHandler
    
    @State var term: String = ""
    @State var currentPerformers : [UserObj]
    
    @Binding var editGrooveDealers : Bool
    @State var eventID : String
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (alignment: .leading, spacing: 5) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack (alignment: .center) {
                            ForEach(currentPerformers, id: \.self) { performer in
                                
                                ZStack (alignment: .topTrailing) {
                                    PerfromerTile(user: performer)
                                        .environmentObject(sessionService)
                                        .highPriorityGesture(
                                        TapGesture()
                                            .onEnded {
                                                currentPerformers.remove(at: currentPerformers.firstIndex(of: performer)!)
                                            }
                                        )
                                    
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)

                                }
                                                                
                            }
                        }
                    }
                    
                    Text("Add new groove dealers")
                    TextField("Search Luna", text: $term)
                        .padding(8)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                        .onChange(of: term) { newTerm in
                            
                            sessionService.searchVenues(term: term, option: 2)
                        }
                    
                    
//                    ScrollView (.horizontal, showsIndicators: false) {
                        
                    let columns = [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ]
                    
                    LazyVGrid (columns: columns) {
                        ForEach(sessionService.searchPeopleResults, id: \.self) { person in
                            if person.performer {
                                PerfromerTile(user: person)
                                    .highPriorityGesture(
                                    TapGesture()
                                        .onEnded {
                                            if !currentPerformers.contains(person) {
                                                currentPerformers.append(person)
                                            }
                                        }
                                    )
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("Edit Groove Dealers")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    if currentPerformers == handler.performers {
                        Button {
                            self.editGrooveDealers.toggle()
                        } label: {
                            Image(systemName: "xmark")
                        }

                    }
                    
                    else {
                        Button {
                            var performerIDS : [String] = []
                            
                            for performer in currentPerformers {
                                performerIDS.append(performer.uid)
                            }
                                                        
                            handler.editPerformers(eventID: eventID, performers: performerIDS == [] ? "removeALL" : performerIDS.joined(separator: ",")) {
                            handler.getPerformers(eventID: eventID)
                            self.editGrooveDealers.toggle()
                            }
                        } label: {
                            Text("confirm")
                        }
                    }
                }
            }
        }
        
    }
}
