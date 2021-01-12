//
//  File.swift
//  
//
//  Created by Michael Ginn on 1/12/21.
//

import Foundation
import CoreGraphics

// Makes common numeric types conform to Graphable Quantity so they can be used without having to manually add the extension

extension Double : GraphableQuantity {
    public var doubleValue: Double {
        self
    }
}

extension Int: GraphableQuantity {
    public var doubleValue: Double {
        Double(self)
    }
}

extension CGFloat: GraphableQuantity {
    public var doubleValue: Double {
        Double(self)
    }
}

extension Float: GraphableQuantity {
    public var doubleValue: Double {
        Double(self)
    }
}
