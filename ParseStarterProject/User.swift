//
//  User.swift
//  OpenMinds
//
//  Created by Adrian Loarri on 31/08/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class User: NSObject {
    
    // 35 SE CREA MODELO DE DATOS CON VARIABLES
    var objectID: String!
    var name: String!
    var email: String!
    // 41 VARIABLE PARA SABER SI SON MIS AMIGOS
    var isFriend: Bool = false

    init(objectID:String, name:String, email:String){
        self.objectID = objectID
        self.name = name
        self.email = email
        
    }
    
}
