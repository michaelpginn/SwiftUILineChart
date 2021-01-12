//
//  SwiftUIView.swift
//  
//
//  Created by Michael Ginn on 1/11/21.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public struct LineChart <PointValue: GraphablePoint>: View {
    
    let data: [PointValue]
    let config: LineChartConfiguration<PointValue>
    
    private let minPoint: PointValue
    private let maxPoint: PointValue
    
    private let tickX: PointValue.XValue
    private let tickY: PointValue.YValue
    
    private let paddingX: PointValue.XValue
    private let paddingY: PointValue.YValue
    
    public init(data: [PointValue], config: LineChartConfiguration<PointValue>) {
        self.data = data.sorted() // Sort by the x axis, this will matter when drawing segments
        self.config = config
        
        guard let firstPoint = data.first else {
            self.minPoint = PointValue(x: 0, y: 0)
            self.maxPoint = PointValue(x: 0, y: 0)
            self.paddingX = 0
            self.paddingY = 0
            self.tickX = 0
            self.tickY = 0
            
            return
        }
        
        // Find min and max
        var minX = firstPoint.x
        var minY = firstPoint.y
        var maxX = firstPoint.x
        var maxY = firstPoint.y
        
        for point in data {
            minX = min(minX, point.x)
            minY = min(minY, point.y)
            maxX = max(maxX, point.x)
            maxY = max(maxY, point.y)
        }
        
        self.minPoint = PointValue(x: minX, y: minY)
        self.maxPoint = PointValue(x: maxX, y: maxY)
        
        // Determine the amount of padding in each direction
        let rangeX = maxX - minX
        let rangeY = maxY - minY
        
        self.tickX = PointValue.XValue(rangeX.doubleValue / Double(config.xNumTicks - 1))
        self.tickY = PointValue.YValue(rangeY.doubleValue / Double(config.yNumTicks - 1))
        
        // If the range is 0, we have one point
        if rangeX == 0 && rangeY == 0 {
            // Use an arbitrary %
            self.paddingX = PointValue.XValue(firstPoint.x.doubleValue * 0.10)
            self.paddingY = PointValue.YValue(firstPoint.y.doubleValue * 0.10)
            
            return
        }
        
        // Otherwise, use 10% of the range
        self.paddingX = PointValue.XValue(rangeX.doubleValue * 0.10)
        self.paddingY = PointValue.YValue(rangeY.doubleValue * 0.10)
    }
    
    public var body: some View {
        HStack {
            GeometryReader { geometry in
                // Draw axes
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                }
                .stroke(Color.black)
                
                // Points
                Path { path in
                    path.move(to: CGPoint(x: convert(data[0].x, in: geometry),y: convert(data[0].y, in: geometry)))
                    for p in data {
                        path.addLine(to: CGPoint(x: convert(p.x, in: geometry),y: convert(p.y, in: geometry)))
                    }
                }
                .stroke(config.pointColor, lineWidth: 2)
            }
            
            // Y axis labels
            GeometryReader { geometry in
                ForEach(0..<config.yNumTicks){ tickNum in
                    Text(config.yAxisFormatter(maxPoint.y - (PointValue.YValue(Double(tickNum)) * tickY)))
                        .font(.caption)
                        .offset(
                            x: 0,
                            y: convert(maxPoint.y - (PointValue.YValue(Double(tickNum)) * tickY), in: geometry) - 8
                        )
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: 40)
        }
    }
    
    func convert(_ x: PointValue.XValue, in geometry: GeometryProxy)->CGFloat {
        let range = ((maxPoint.x - minPoint.x) + (2 * paddingX)).doubleValue
        let ratio = geometry.size.width / CGFloat(range)
        return CGFloat(x.doubleValue - minPoint.x.doubleValue + paddingX.doubleValue) * ratio
    }
    
    func convert(_ y: PointValue.YValue, in geometry: GeometryProxy)->CGFloat {
        let range = ((maxPoint.y - minPoint.y) + (2 * paddingY)).doubleValue
        let ratio = geometry.size.height / CGFloat(range)
        return (CGFloat(maxPoint.y.doubleValue - y.doubleValue + paddingY.doubleValue) * ratio)
    }
}

@available(iOS 13.0, macOS 10.15, *)
struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        var config = LineChartConfiguration<DoubleDoublePoint>(xFormatter: {String(format: "%.1f", $0)}, yFormatter: {String(format: "%.1f", $0)})
        config.yNumTicks = 6
        
        return LineChart(data: [
            DoubleDoublePoint(x: 0, y: 5),
            DoubleDoublePoint(x: 1, y: 15),
            DoubleDoublePoint(x: 2, y: 20),
            DoubleDoublePoint(x: 3, y: 27)
        ], config: config)
            .frame(height: 200)
            .padding()
    }
}
