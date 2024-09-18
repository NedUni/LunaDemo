//
//  View3.swift
//  Luna
//
//  Created by Ned O'Rourke on 30/3/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct View3: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var pageManager : PageHandler
    @EnvironmentObject var homeVM : ViewModel
    @EnvironmentObject var manager : LocationManager
    
    @State var page : PageObj
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Pages like this")
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(pageManager.similarPages, id: \.self) { page in
                        MeetHostsTile(page: page)
                                .environmentObject(sessionService)
                                .environmentObject(manager)
                                .environmentObject(homeVM)
                                .environmentObject(pageManager)
                    }
                }
            }
            
        }
        .task {
            await pageManager.getSimilarPages(pageID: page.id)
        }
    }
}

//struct View3_Previews: PreviewProvider {
//    static var previews: some View {
//        View3()
//    }
//}


//VStack (alignment: .leading, spacing: 0) {
//                WebImage(url: URL(string: "https://scontent.fsyd7-1.fna.fbcdn.net/v/t39.30808-6/277303986_1065539390666797_9012158751492349810_n.jpg?_nc_cat=102&ccb=1-5&_nc_sid=340051&_nc_ohc=Xrl0t9530AQAX_bPTbD&tn=sDPDJmxWInVtQgQc&_nc_ht=scontent.fsyd7-1.fna&oh=00_AT-iRdh0Mt1NHOB1ssw-GXYCHkvGpojeSZzF5Cn8UFXESg&oe=6247FE52"))
//                    .resizable()
//                    .scaledToFill()
//                    .frame(height: 150)
//                    .clipped()
//
//                HStack (alignment: .top) {
//                    VStack (alignment: .leading) {
//                        Text("Friday April 9")
//                            .font(.system(size: 10))
//                            .fontWeight(.heavy)
//                        Text("Scope Afloat")
//                            .font(.system(size: 20))
//                            .fontWeight(.medium)
//                        Text("Sydney Harbour")
//                            .font(.system(size: 12))
//                            .fontWeight(.medium)
//                    }
//                    .foregroundColor(.black)
//                    .padding(.horizontal)
//                    .padding(.vertical, 3)
//
//                    Spacer()
//
//                    VStack (alignment: .leading, spacing: 0) {
//                        HStack {
//                            Text("473 Going")
//                                .font(.system(size: 12))
//                                .fontWeight(.medium)
//                            Image(systemName: "ticket")
//                                .font(.system(size: 14))
//                        }
//                        .padding(.trailing)
//                        .padding(.vertical, 3)
//
//                        HStack (spacing: 2){
//                            ForEach(1..<5, id: \.self) { i in
//                                  WebImage(url: URL(string: "https://cdn.psychologytoday.com/sites/default/files/styles/article-inline-half-caption/public/field_blog_entry_images/2018-09/shutterstock_648907024.jpg?itok=0hb44OrI"))
//                                      .resizable()
//                                      .scaledToFill()
//                                      .frame(width: 20, height: 20).cornerRadius(10)
//                                      .clipped()
//                              }
//                          }
//                    }
//
//                }
//
//            }
//            .background(Color.ui.xd)
//            .cornerRadius(20)
