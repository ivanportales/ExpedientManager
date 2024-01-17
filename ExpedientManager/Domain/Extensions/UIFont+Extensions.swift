//
//  Extension+UIFont.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 22/11/24.
//

import UIKit

extension UIFont {
    static func poppinsRegularOf(size: CGFloat) -> UIFont {
      guard let customFont = UIFont(name: "Poppins-Regular", size: size) else {
        return UIFont.systemFont(ofSize: size)
      }
      return customFont
    }
    
    static func poppinsSemiboldOf(size: CGFloat) -> UIFont {
      guard let customFont = UIFont(name: "Poppins-SemiBold", size: size) else {
        return UIFont.systemFont(ofSize: size)
      }
      return customFont
    }
    
    static func poppinsMediumOf(size: CGFloat) -> UIFont {
      guard let customFont = UIFont(name: "Poppins-Medium", size: size) else {
        return UIFont.systemFont(ofSize: size)
      }
      return customFont
    }
    
    static func poppinsLightOf(size: CGFloat) -> UIFont {
      guard let customFont = UIFont(name: "Poppins-Light", size: size) else {
        return UIFont.systemFont(ofSize: size)
      }
      return customFont
    }
}
