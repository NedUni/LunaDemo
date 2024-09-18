//
//  Test.swift
//  Luna
//
//  Created by Ned O'Rourke on 2/6/2022.
//

import SwiftUI

struct Test: View {
    var body: some View {
        
        VStack {
            Text("Engagement")
            Text("1500")
            
            LineGraph(data: [1, 5, 6, 11, 15, 12, 4])
                                .frame(height: 200, alignment: .center)
            
        }
        .background(Color("darkBackground"))
        .foregroundColor(.white)
       
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
