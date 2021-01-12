//
//  File.swift
//  
//
//  Created by Michael Ginn on 1/11/21.
//

import Foundation

/// An example GraphablePoint for test code
internal struct DoubleDoublePoint: GraphablePoint {
    
    
    let x: Double
    let y: Double
    
    static var zero: DoubleDoublePoint = .init(x: 0, y: 0)

    static var xAxisFormatter: (Double) -> String = {String(format: "%.1f", $0)}
    static var yAxisFormatter: (Double) -> String = {String(format: "%.1f", $0)}

}
