//
//  Extesnions.swift
//  Music
//
//  Created by Семён Беляков on 25.09.2023.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
    
    func removeFromSuperview(_ views: UIView...) {
        views.forEach {
            $0.removeFromSuperview()
        }
    }
    
}

extension UIColor {
    
    static var commonColor: UIColor {
        return UIColor(hue: 280/360, saturation: 2.4/100, brightness: 97.3/100, alpha: 1.0)
    }
    
}
