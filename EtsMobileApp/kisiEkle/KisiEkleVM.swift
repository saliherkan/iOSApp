//
//  KisiEkleVM.swift
//  EtsMobileApp
//
//  Created by Salih Erkan Sandal on 17.01.2021.
//

import Foundation
import UIKit


final class KisiEkleVM {
    var guncelVeri: Veri?
    var sira: Int = 0
    
    
    func veriEkle(cek: Veri){
        if let cekilenVeriler = UserDefaults.standard.object(forKey: "Kisiler") as? Data {
            let decoder = JSONDecoder()
            
            if let loadedPerson = try? decoder.decode([Veri].self, from: cekilenVeriler) {
                
                var veriler = loadedPerson
                veriler.append(cek)
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(veriler){
                    UserDefaults.standard.set(encoded, forKey: "Kisiler")
                }
            }
            
        }
    }
        func update(cek: Veri){
            if let cekilenVeriler = UserDefaults.standard.object(forKey: "Kisiler") as? Data {
                let decoder = JSONDecoder()
                
                if let loadedPerson = try? decoder.decode([Veri].self, from: cekilenVeriler) {
                    
                    var veriler = loadedPerson
                    var guncelData: [Veri] = []
                    let count = veriler.count - 1
                    
                    for i in 0...count{
                        if i != sira{
                            guncelData.append(veriler[i])
                            
                        }else {
                            guncelData.append(cek)
                        }
                    }
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(guncelData){
                        UserDefaults.standard.set(encoded, forKey: "Kisiler")
                    }
                }
                
            }
            
            
        }
        
        
        
        
        
    }

