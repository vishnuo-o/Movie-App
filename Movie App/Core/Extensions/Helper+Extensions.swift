//
//  Helper+Extensions.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 05/10/25.
//

import UIKit

extension UIDevice {
    public static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
}

extension UIScreen {
    public static var width: CGFloat {
        UIScreen.main.bounds.width
    }
    
    public static var height: CGFloat {
        UIScreen.main.bounds.height
    }
}
