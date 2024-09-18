//
//  ProfileLinkTile.swift
//  Luna
//
//  Created by Ned O'Rourke on 11/5/2022.
//

import SwiftUI

struct ProfileLinkTile: View {
    
    @State var destination : String
    @State var number : String?
    
    var body: some View {
        VStack {
            HStack {
                Text(destination)
                Spacer()
                Text(number ?? "")
                    .foregroundColor(Color.secondary)
                Image(systemName: "chevron.right")
                    .foregroundColor(.purple)
                    .font(.system(size: 20, weight: .heavy))
            }
            .padding(.vertical, 5)
            
            Divider()
        }
        .background(Color("darkBackground"))
    }
}

//struct ProfileLinkTile_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileLinkTile()
//    }
//}
