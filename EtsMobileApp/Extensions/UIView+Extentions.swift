//
//  UIView+Extentions.swift
//  EtsMobileApp
//
//  Created by Salih Erkan Sandal on 15.01.2021.
//

import UIKit


extension UIView {
    
    func addGradiant() {
        let GradientLayerName = "gradientLayer"
        //Kaydet/Güncelle butonu 2 renk tanımlama, Renkler arası geçiş
        if let oldlayer = self.layer.sublayers?.filter({$0.name == GradientLayerName}).first {
            oldlayer.removeFromSuperlayer()
        }
        
        let gradientLayer = CAGradientLayer()
        let startColor = #colorLiteral(red: 0.5607843137, green: 0.4039215686, blue: 0.9098039216, alpha: 1)
        let endColor = #colorLiteral(red: 0.3882352941, green: 0.3411764706, blue: 0.8, alpha: 1)
        
        gradientLayer.colors = [startColor.cgColor,endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1 )
        gradientLayer.frame = self.bounds
        gradientLayer.name = GradientLayerName
        gradientLayer.cornerRadius = 25
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
extension UIView{
    func yuvarla(){
        self.layer.cornerRadius = 8
    }
    
}
