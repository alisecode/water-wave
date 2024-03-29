//
//  Main.swift
//  WaterBalance
//
//  Created by Alisa Serhiienko on 28.03.2024.
//


import SwiftUI

struct Main: View {
    
    @State var waterConsumption: Int = 0
    @State private var percent = 20.0
    @State private var waveOffset = Angle(degrees: 0)
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                
                Text("\(waterConsumption) ml")
                    .contentTransition(.numericText())
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .padding(.top, 50)
                    .zIndex(1)
                
                Spacer()
            }
            
            GeometryReader { proxy in
                let size = proxy.size
                
                ZStack {
                    
                    Image(systemName: "waterbottle.fill")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, maxHeight: 450, alignment: .center)
                        .onAppear {
                            withAnimation(.linear(duration: 1.7).repeatForever(autoreverses: false)) {
                                self.waveOffset = Angle(degrees: 360)
                            }
                        }
                        .scaleEffect(x: 1.1, y: 1)
                        .offset(y: -1)
                    
                    
                    Wave(offSet: Angle(degrees: waveOffset.degrees), percent: percent)
                        .fill(Color(red: 79/255, green: 146/255, blue: 246/255))
                    
                    
                        .overlay(content: {
                            ZStack {
                                Circle()
                                    .fill(.white.opacity(0.2))
                                    .frame(width: 16, height: 16)
                                    .offset(x: -20)
                                
                                Circle()
                                    .fill(.white.opacity(0.2))
                                    .frame(width: 16, height: 16)
                                    .offset(x: 60, y: 30)
                                
                                Circle()
                                    .fill(.white.opacity(0.2))
                                    .frame(width: 24, height: 24)
                                    .offset(x: -30, y: 100)
                                
                                
                                Circle()
                                    .fill(.white.opacity(0.2))
                                    .frame(width: 10, height: 24)
                                    .offset(x: -50, y: 130)
                                
                                Circle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 16, height: 24)
                                    .offset(x: -50, y: -30)
                                
                                Circle()
                                    .fill(.white.opacity(0.4))
                                    .frame(width: 10, height: 24)
                                    .offset(x: 50, y: -90)
                                
                            }
                        })
                        .mask {
                            Image(systemName: "waterbottle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: 450, alignment: .center)
                        }
                        .overlay(alignment: .bottom) {
                            
                            HStack {
                                
                                Button(action: {
                                    withAnimation(Animation.smooth) {
                                        
                                        increasePercentWater()
                                        
                                        
                                    }
                                }) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 24, weight: .black))
                                        .foregroundStyle(Color(red: 79/255, green: 146/255, blue: 246/255))
                                        .padding(32)
                                        .background(.white.opacity(0.9), in: Circle())
                                }
                                
                                
                                Button(action: {
                                    withAnimation(Animation.smooth) {
                                        decreasePercentWater()
                                    }
                                }) {
                                    Image(systemName: "minus")
                                        .font(.system(size: 24, weight: .black))
                                        .foregroundStyle(Color(red: 79/255, green: 146/255, blue: 246/255))
                                        .padding(40)
                                        .background(.white.opacity(0.9), in: Circle())
                                }
                            }                            
                            
                        }
                }
                .padding(.bottom, 50)
                
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color(red: 232/255, green: 235/255, blue: 239/255))
    }
    
    private func increasePercentWater() {
        waterConsumption += 200
        
        let maxValue = min(90, percent + 10)
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            
            guard self.percent <= maxValue else {
                timer.invalidate()
                
                return
            }
            withAnimation {
                self.percent += 1.0
            }
        }
    }
    
    private func decreasePercentWater() {
        waterConsumption = max(0, waterConsumption - 150)
        let minValue = max(0, percent - 10)
        
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            
            guard self.percent >= minValue else {
                timer.invalidate()
                return
            }
            withAnimation {
                self.percent -= 1.0
            }
        }
    }
}

struct Wave: Shape {
    
    var offSet: Angle
    var percent: Double
    
    var animatableData: Double {
        get { offSet.degrees }
        set { offSet = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let lowestWave = 0.02
        let highestWave = 1.00
        
        let newPercent = lowestWave + (highestWave - lowestWave) * (percent / 100)
        let waveHeight = 0.015 * rect.height
        let yOffSet = CGFloat(1 - newPercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offSet
        let endAngle = offSet + Angle(degrees: 360 + 10)
        
        p.move(to: CGPoint(x: 0, y: yOffSet + waveHeight * CGFloat(sin(offSet.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yOffSet + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}


#Preview {
    Main()
}

