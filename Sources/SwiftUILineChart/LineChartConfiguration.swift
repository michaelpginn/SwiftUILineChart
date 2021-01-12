//
//  LineChartConfiguration.swift
//  
//
//  Created by Michael Ginn on 1/11/21.
//

import Foundation
import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public struct LineChartConfiguration <PointValue: GraphablePoint> {
    // Required properties
    
    let xAxisFormatter: (PointValue.XValue) -> String
    let yAxisFormatter: (PointValue.YValue) -> String
    
    init(
        xFormatter: @escaping (PointValue.XValue) -> String,
        yFormatter: @escaping (PointValue.YValue) -> String) {
        self.xAxisFormatter = xFormatter
        self.yAxisFormatter = yFormatter
    }
    
    // Other configurable properties
    
    /// The color of the points. Default is blue.
    public var pointColor: Color = .blue
    
    public var xNumTicks: Int = 5
    public var yNumTicks: Int = 5
}