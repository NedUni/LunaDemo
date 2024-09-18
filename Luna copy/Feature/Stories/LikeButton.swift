//
//  LikeButton.swift
//  Luna
//
//  Created by Ned O'Rourke on 20/4/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct LikeButton: View {
    var body: some View {
        VStack {
            HStack (alignment: .top) {
                WebImage(url: URL(string: "https://scontent.fsyd6-1.fna.fbcdn.net/v/t1.6435-9/67459227_831187210597368_2736573798881951744_n.jpg?_nc_cat=104&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=XF6F-R9JdfcAX_6fiAl&_nc_ht=scontent.fsyd6-1.fna&oh=00_AT8NYnbMYRVPwzVkv7NRyXeyAbNgOmyUb1ycbGpODWvLAg&oe=628610D4"))
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
                Text("Abbey O'Donnel")
                Spacer()
            }
            
            Spacer()
            HStack (spacing: 20){
                Spacer()
                Image(systemName: "hand.thumbsup")
                Image(systemName: "hand.thumbsdown")
            }
            .font(.system(size: 30))
        }
        .padding()
    }
}

struct LikeButton_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            WebImage(url: URL(string: "https://image.tmdb.org/t/p/original//7GsM4mtM0worCtIVeiQt28HieeN.jpg"))
                .resizable()
//                .ignoresSafeArea()
                
            LikeButton()
        }
        
    }
}
