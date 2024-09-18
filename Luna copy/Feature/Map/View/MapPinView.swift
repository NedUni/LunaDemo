//
//  MapPinView.swift
//  Luna
//
//  Created by Ned O'Rourke on 2/2/22.
//

import SwiftUI

struct MapPinView: View {
    
    @State var venue : VenueObj
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: VenueView(ven: venue)) {
                VStack {
                    Image(systemName: "mappin.circle.fill")
                      .font(.title)
                      .foregroundColor(.gray.opacity(0.3))

                    Image(systemName: "arrowtriangle.down.fill")
                      .font(.caption)
                      .foregroundColor(.gray.opacity(0.3))
                      .offset(x: 0, y: -5)
                }
                .frame(width: 20, height: 20)

            }
        }
        
    }
}

//struct MapPinView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPinView()
//    }
//}
