//
//  FriendsViewController.swift
//  OpenMinds
//
//  Created by Adrian Loarri on 30/08/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class FriendsViewController: UITableViewController {

    @IBOutlet var menuBtn: UIBarButtonItem!
    
    //36 SE CREA ARRAY 
    var users : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //24 METODO PARA ACTIVAR EL MENU
        if self.revealViewController() != nil{
            self.menuBtn.target = self.revealViewController()
            self.menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            // EL BOTON HACE UN SWIPE
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //37 METODO PARA HACER CONSULTAS DE LOS AMIGOS
        let query = PFUser.query()
        //ES CONVENIENTE HACER CONSULTAS EN SEGUNDO PLANO
        query?.findObjectsInBackground(block: { (objects, error) in
            if error != nil{
                print(error?.localizedDescription as Any)
            } else {
                //SI NO HAY ERROR SE CONVIERTE EN OBJETO, PRIMERO SE UTILIZA UN METODO PARA VACIAR LA INFORMACION SE HACE POR SEGURIDAD PARA EVITAR QUE SE REPITA
                self.users.removeAll()
                //EL OBJETO LO CONVIERTE EN PFUSER(USUARIO) SE PUEDEN RECUPERAR ELEMENTOS
                for object in objects! {
                    if let user = object as? PFUser{
                        
                        //38 METODO PARA ELIMINARME DE LA LISTA DE MIS AMIGOS
                        
                        if user.objectId != PFUser.current()?.objectId {
                            //EL OBJECTID AYUDA HACER REFERENCIA EN PARSE
                            let objectID = user.objectId!
                            let email = user.email
                            //SE CORTAN LOS COMPONENTES SEPARADOS POR @ Y ESE SERÁ EL NOMBRE
                            let name = user.username?.components(separatedBy: "@")[0]
                           
                            
                            //RELLENA EL ARRAY DE USUARIOS, SE UTILIZAN LAS EXCLAMACIONES PORQUE ESTAMOS SEGUROS DE QUE EXISTE ESE OBJETO. UNA VEZ QUE SE CARGUE EL VIEW CONTROLLER SE RELLENA EL ARRAY CON ESTA INFORMACIÓN.
                            let myUser = User(objectID: objectID, name: name!, email: email!)
                            
                            // 41 METODO PARA SABER SI SON MIS AMIGOS
                            let query = PFQuery(className: "UserFriends")
                            //CONFIRMA QUE EL IDUSER SEA MIO Y EL IDUSERFRIEND SEA DE MIS AMIGOS
                            query.whereKey("idUser", equalTo: PFUser.current()?.objectId! as Any)
                            
                            //METODO PARA SALVAR LA INFORMACION QUE DEVUELVE EL WHEREKEY E IDENTIFICAR A QUIENES SON MIS AMIGOS
                            query.findObjectsInBackground(block: { (objects, error) in
                                if error != nil{
                                    print(error?.localizedDescription as Any)
                                } else {
                                    if let objects = objects {
                                        if objects.count > 0 {
                                            myUser.isFriend = true
                                        }
                                        //SE FORZA A QUE SE CARGUE LA INFORMACION PORQUE SI NO SE PONE ESTE METODO LA INFORMACIÓN TARDA EN LLEGAR Y NO APARECE CUANDO CARGAMOS.
                                        self.tableView.reloadData()
                                    }
                                }
                            })
                            
                            self.users.append(myUser)

                        }
                    }
                }
                
                self.tableView.reloadData()
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //27 METODO PARA DEFINIR SECTIONS Y TABLES
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath)
        //SE MUESTRAN LOS NOMBRES EN LOS ROWS
        cell.textLabel?.text = self.users[indexPath.row].name
        
        //41 SI EL USUARIO ES AMIGO SE LE AÑADE UN CHECKMARK
        if self.users[indexPath.row].isFriend {
            cell.accessoryType = .checkmark
        } else {
            // METODO PARA QUE CUANDO LA CELDA DESAPAREZCA Y SE REUTILICE NO APAREZCA DE NUEVO EL CHECKMARK A OTRO USUARIO
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    //40 METODO PARA QUE CUANDO EL SELECCIONE LA CELDA PUEDA HACER AMIGOS
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let cell = tableView.cellForRow(at: indexPath)
        
        //41 METODO PARA DEJAR DE SER AMIGOS
        if self.users[indexPath.row].isFriend{
                // SE QUITA EL IDENTIFICADOR DEL CHECKMARK
                cell?.accessoryType = .none
            
                self.users[indexPath.row].isFriend = false
            
                // CONFIRMA QUE EL IDUSER SEA MIO Y EL IDUSERFRIEND SEA DE MIS AMIGOS
                let query = PFQuery(className: "UserFriends")
                query.whereKey("idUser", equalTo: (PFUser.current()?.objectId)!)
                query.whereKey("idUserFriend", equalTo: self.users[indexPath.row].objectID)
                // DE LA INFORMACION QUE SE DEVUELVA SEA ELIMINADA
                query.findObjectsInBackground(block: { (objects, error) in
                    if error != nil {
                        print(error?.localizedDescription as Any)
                    } else {
                        if let objects = objects {
                            for object in objects {
                                object.deleteInBackground()
                            }
                        }
                    }
                })
        } else {
        
            
            // CHECK MARK PARA IDENTIFICAR QUIENES SON AMIGOS
            cell?.accessoryType = .checkmark
            
            self.users[indexPath.row].isFriend = true
            
            let friendship = PFObject(className: "UserFriends")
            // MI IDENTIFICADOR COMO USUARIO
            friendship["idUser"] = PFUser.current()?.objectId
            // EL IDENTIFICADOR DE LOS USUARIOS QUE HARÉ MIS AMIGOS. EN LA COLUMNA IDUSERFRIEND ME QUEDARÉ CON EL OBJECTID DE LA CELDA.
            friendship["idUserFriend"] = self.users[indexPath.row].objectID
            
            //METODO ACL PARA QUE LOS OBJETOS SEAN DE ESCRITURA Y LECTURA Y PERMITA HACER CAMBIOS EN LOS DATOS
            
            let acl = PFACL()
            acl.getPublicReadAccess = true
            acl.getPublicWriteAccess = true
            
            friendship.acl = acl
            
            // UNA VEZ SELECCIONADA LA AMISTAD SE GUARDARA
            friendship.saveInBackground()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}






