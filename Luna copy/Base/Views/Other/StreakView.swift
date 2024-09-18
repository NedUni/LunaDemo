//
//  StreakView.swift
//  Luna
//
//  Created by Will Polich on 20/2/2022.
//

import SwiftUI

struct StreakView: View {
    
    @State var streak : Int
    
    var body: some View {
        ZStack {
            Image(systemName: "flame.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.red)
        }
    }
}

