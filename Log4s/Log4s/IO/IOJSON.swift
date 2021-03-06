//
//  IOJSON.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-02.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


class JSONInputter : Inputter{
    func read(from path:URL, completion:@escaping InputCompletion) {
        do{
            let data = try Data(contentsOf: path)
            read(from:data, completion: completion)
        }catch{
            completion(nil, error)
        }
    }
    
    func read(from string:String,completion:@escaping InputCompletion){
        guard let data = string.data(using: String.Encoding.utf8) else {
            completion(nil,LogError.invalid(path: string, decodedAs: "UTF8"))
            return
        }
        read(from:data, completion: completion)
    }
    
    func read(from data:Data,completion:@escaping InputCompletion){
        do{
            let obj = try JSONSerialization.jsonObject(with: data as Data, options: [])
            completion(obj,nil)
        }catch{
            completion(nil, error)
        }
        
    }
}

class JSONOutputter : Outputter{
    
    func write(stringFrom source:IOValue,completion: @escaping (String?,Error?)->()){
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: source, options: JSONSerialization.WritingOptions())
            let r = String(data:jsonData,encoding: String.Encoding.utf8)
            if let r = r {
                completion(r,nil)
            }
            else{
                completion(nil,LogError.invalid(path: String(describing:jsonData), decodedAs: "UTF8"))
            }
            
        }catch{
            completion(nil,error)
        }
    }
}
