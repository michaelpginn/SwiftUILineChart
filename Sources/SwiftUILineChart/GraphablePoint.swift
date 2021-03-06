//
//  GraphableValue.swift
//  
//
//  Created by Michael Ginn on 1/11/21.
//

import Foundation

/// Defines a type that can be graphed, with numeric X and Y values
public protocol GraphablePoint : Comparable {
    associatedtype XValue : GraphableQuantity
    associatedtype YValue : GraphableQuantity
    
    /// The x value of a point
    var x: XValue {get}
    
    /// The y value of a point
    var y: YValue {get}
    
    /// Used to format the x value
    static var xAxisFormatter: (XValue) -> String {get}
    
    /// Used to format the y value
    static var yAxisFormatter: (YValue) -> String {get}
}

// Comparable conformance
extension GraphablePoint {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.x < rhs.x
    }
}

public protocol GraphableQuantity: Numeric, Comparable {
    
    /// The value cast to a double
    var doubleValue: Double {get}
    
    /// Initializes the quantity from a double
    init(_ d: Double)
}
