//
//  AnaSayfaVM.swift
//  EtsMobileApp
//
//  Created by Salih Erkan Sandal on 17.01.2021.
//

import Foundation
import UIKit


final class AnaSayfaVM {
    var veriler: [Veri]!
    var filtrelenmisVeriler: [Veri] = []
    
    init(){
        veriCek()
    }
    func veriCek(){
        if let cekilenVeriler = UserDefaults.standard.object(forKey: "Kisiler") as? Data {
            let decoder = JSONDecoder()
            
            if let loadedPerson = try? decoder.decode([Veri].self, from: cekilenVeriler) {
                veriler = loadedPerson
                veriler.sort(by: {$0.ad < $1.ad})
                filtrelenmisVeriler = veriler
            }else {
                veriler = []
            }
        }else {
            let olustur: [Veri] = []
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(olustur){
                UserDefaults.standard.set(encoded, forKey: "Kisiler")
            }
            
            veriler = olustur
            filtrelenmisVeriler = olustur
        }
    }
    
    func kaydet(gelen: [Veri]){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(gelen){
            UserDefaults.standard.set(encoded, forKey: "Kisiler")
            veriCek()
        }
    }
}
