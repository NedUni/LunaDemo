//
//  LineGraph.swift
//  Luna
//
//  Created by Ned O'Rourke on 2/6/2022.
//

import SwiftUI

struct LineGraph: View {
    
    var data : [CGFloat]
    
    @State var currentPlot = ""
    
    @State var offset: CGSize = .zero
    
    @State var showPlot = false
    
    @State var translation : CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            
            let height = proxy.size.height
            let width = proxy.size.width / CGFloat(data.count - 1)
            
            let maxPoint = data.max() ?? 0 + 100
            
            let points = data.enumerated().compactMap { item -> CGPoint in
                
                let progress = item.element / maxPoint
                
                let pathHeight = progress * height
                
                let pathWidth = width * CGFloat(item.offset)
                
                return CGPoint(x: pathWidth, y: -pathHeight + height)
            }
            
            ZStack {
                
                Path { path in
                    
                    path.move(to: CGPoint(x: 0, y: 0))
                    
                    path.addLines(points)
                }
                .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                .fill(
                    LinearGradient(colors: [.purple], startPoint: .leading, endPoint: .trailing)
                    )
                fillBG()
                
                    .clipShape( Path { path in
                        
                        path.move(to: CGPoint(x: 0, y: 0))
                        
                        path.addLines(points)
                        
                        path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                        
                        path.addLine(to: CGPoint(x: 0, y: height))
                    })
            }
            .overlay (
                
                VStack(spacing: 0) {
                    
                    if showPlot {
                        Text(currentPlot)
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(.purple, in: Capsule())
                            .offset(x: translation < 10 ? 30 : 0)
                            .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                        
                        Rectangle()
                            .fill(.purple)
                            .frame(width: 1, height: 40)
                            .padding(.top)
                        
                        Circle()
                            .fill(.purple)
                            .frame(width: 22, height: 22)
                            .overlay(
                                
                                Circle()
                                    .fill(.white)
                                    .frame(width: 10, height: 10)
                            )
                        
                        Rectangle()
                            .fill(.purple)
                            .frame(width: 1, height: 40)
                    }
                    
                }
                    .frame(width: 80, height: 170)
                    .offset(y: 70)
                    .offset(offset),
//                    .opacity(showPlot ? 1 : 0),
                    
                    
                
                alignment: .bottomLeading
                    
            )
            .contentShape(Rectangle())
            .gesture(DragGesture().onChanged({ value in
                
                withAnimation {
                    showPlot = true
                }
                
                let translation = value.location.x - 40
                
                let index = max(min(Int((translation / width).rounded() + 1), data.count - 1), 0)
                
                currentPlot = "$ \(data[index])"
                
                self.translation = translation
                
                offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
            }).onEnded({ value in
                withAnimation {
                    showPlot = false
                }
            }))
        }
        .overlay (
        
            VStack (alignment: .leading) {
                
                let max = data.max() ?? 0
                
                Text("\(Int(max))")
                    .font(.caption)
                
                Spacer()
                
                Text("$ 0")
                    .font(.caption.bold())
            }
                .frame(maxWidth: .infinity, alignment: .leading)
        )
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func fillBG()->some View {
        LinearGradient(colors: [.purple.opacity(0.4), .purple.opacity(0.2), .purple.opacity(0.1)], startPoint: .top, endPoint: .bottom)
    }
}

struct LineGraph_Previews: PreviewProvider {
    static var previews: some View {
        LineGraph(data: [15, 23, 18, 35, 17, 26, 30])
    }
}
