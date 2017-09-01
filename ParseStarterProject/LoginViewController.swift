/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    //6 ASIGNAR OUTLETS PARA LOS TEXTFIELDS
    @IBOutlet var emailTextfield: UITextField!
    
    @IBOutlet var passwordTextfield: UITextField!
    
    //9 METODO PARA QUE EL USUARIO RECIBA FEEDBACK DE EVENTOS QUE PUEDEN SUCEDER DURANTE EL REGISTRO. USUARIOS EXISTENTES, ERRORES, ETC.
    var activityIndicator : UIActivityIndicatorView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        /*let user = PFObject(className: "Users")
        user["name"] = "Adrian"
        //METODO PARA SALVARLO EN PARSE
        user.saveInBackground() { (success, error) in
            if success {
                print("EL USUARIO SE HA GUARDADO CORRECTAMENTE")
            } else {
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    print("ERROR DESCONOCIDO")
                }
            }*/
            
        /*METODO PARA RECUPERAR-CONSULTAR EN PARSE
        
            let query = PFQuery(className: "Users")
            query.getObjectInBackground(withId: "gKYWdfA5pb") { (object, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else{
                    if let user = object {
                        print(user)
                        print(user ["name"])
                    }
                }
            }
        }*/
        
    
        /*METODO PARA CAMBIAR NOMBRE DE USER
        
        let query = PFQuery(className: "Users")
        query.getObjectInBackground(withId: "umBEkg1agd") { (object, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else{
                if let user = object {
                    user ["name"] = "Loarri"
                    user.saveInBackground(block: { (success, error) in
                        if success {
                            print("HEMOS MODIFICADO EL USUARIO")
                        } else {
                            print(error)
                }
            })
         }
      }
            
    }*/

    
        //Descomenta esta linea para probar que Parse funciona correctamente
    /*self.testParseSave()
    }
    
    func testParseSave() {
        let testObject = PFObject(className: "MyTestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackground { (success, error) -> Void in
            if success {
                print("El objeto se ha guardado en Parse correctamente.")
            } else {
                if error != nil {
                    print (error)
                } else {
                    print ("Error")
                }
            }
        }*/
   
    
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        //SI EL USUARIO ESTA AUN LOGEADO EN SESION
        if PFUser.current() != nil{
            //14 REFERENCIAR EL SEGUE
            self.performSegue(withIdentifier: "goToMainVC", sender: nil)
            
        }
        
        //32 METODO PARA OCULTAR BARRA DE NAVEGACION
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    //6 ASIGNAR OUTLETS PARA LOS BOTONES
    @IBAction func signupPressed(_ sender: UIButton) {
        
        //DESACTIVA TOQUES DE PANTALLA HASTA NUEVA ORDEN
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        if infoCompleted() {
            
            self.startActivityIndicator()
            
            // SI LA INFORMACION ESTA COMPLETA PROCEDEMOS A REGISTRAR USUARIO
            // 8 REGISTRAR USUARIO
            let user = PFUser()
            user.username = self.emailTextfield.text
            user.email = self.emailTextfield.text
            user.password = self.passwordTextfield.text
            user.signUpInBackground(block: { (success, error) in
        
                self.stopActivityIndicator()
                
                if error != nil {
                    var errorMessage = "Try again, an error has ocurred with register"
                    
                    if let parseError = error?.localizedDescription {
                        errorMessage = parseError
                    }
                    
                    self.createAlert(title: "Register Error", message: errorMessage)
                
                } else {
                    print("USUARIO REGISTRADO CORRECTAMENTE")
                    //14 REFERENCIAR EL SEGUE
                    self.performSegue(withIdentifier: "goToMainVC", sender: nil)
                }
                
            })
            
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if infoCompleted() {
            // SI LA INFORMACION ESTA COMPLETA PROCEDEMOS A LOGGEAR USUARIO
            
            self.startActivityIndicator()
            
            // 10 METODO LOGIN USUARIO
            PFUser.logInWithUsername(inBackground: self.emailTextfield.text!, password: self.passwordTextfield.text!, block: { (user, error) in
                
                self.stopActivityIndicator()
                
                if error != nil {
                    var errorMessage = "Try again, an error has ocurred with login"
                    
                    if let parseError = error?.localizedDescription {
                        errorMessage = parseError
                    }
                    
                    self.createAlert(title: "Login Error", message: errorMessage)
                } else {
                    print("WE HAVE BEEN LOGIN SUCCESSFULY")
                    //14 REFERENCIAR EL SEGUE
                    self.performSegue(withIdentifier: "goToMainVC", sender: nil)
                }
                
            })
        }
    }
    
    @IBAction func recoverPassword(_ sender: UIButton) {
        //11 RECUPERAR CONTRASEÑA 
        // METODO ALERT CONTROLLER AL QUE SE LE AÑADE UN TEXTFIELD PARA QUE EL USUARIO ESCRIBA SU EMAIL.
        
        let alertController = UIAlertController(title: "Recover password", message: "Introduce the email have you registered in OpenMinds", preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "introduce here your email"
        }
        let okAction = UIAlertAction(title: "Recover password", style: .default) { (action) in
            let theEmailTextfield = alertController.textFields![0] as UITextField
            
            PFUser.requestPasswordResetForEmail(inBackground: theEmailTextfield.text!, block: { (success, error) in
                
                
                if error != nil {
                    var errorMessage = "Try again, an error has ocurred with recover your password"
                    
                    if let parseError = error?.localizedDescription {
                        errorMessage = parseError
                    }
                    
                    self.createAlert(title: "Recover Password Error", message: errorMessage)
                //METODO PARA MOSTRAR AL USUARIO QUE SU CONTRASEÑA SE RECUPERO SATISFACTORIAMENTE
                } else {
                    self.createAlert(title: "Password Recovered", message: "An email has been sent to you at \(theEmailTextfield.text!) and follow the instructions")
                }

            })
        }
        
        let cancelAction = UIAlertAction(title: "Not now", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    
    }
    
    //7 COMPROBAR QUE LOS TEXTFIELDS NO ESTEN VACIOS
    
    func infoCompleted() -> Bool {
        var infoCompleted = true
        
        if self.emailTextfield.text == "" || self.passwordTextfield.text == "" {
            infoCompleted = false
            
            self.createAlert(title: "Verify your information", message: "Please introduce a valid email and valid password")
        
        }
        
        return infoCompleted
    }
    
    // 7 METODO GENERAL DE ALERTAS
    func createAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    
    }
    //9 METODO PARA QUE EL USUARIO RECIBA FEEDBACK DE EVENTOS QUE PUEDEN SUCEDER DURANTE EL REGISTRO. USUARIOS EXISTENTES, ERRORES, ETC.
    func startActivityIndicator(){
        
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(self.activityIndicator)
        // SE INICIALIZA
        self.activityIndicator.startAnimating()
  }
    // 9 SI HA SIDO EXITOSO EL REGISTRO SE DETIENE EL ACTIVITY INDICATOR
    func stopActivityIndicator(){
        
        self.activityIndicator.stopAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// OCULTAR TECLADO DESPUES ENTER
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        textfield.resignFirstResponder()
        return true
    }
}


