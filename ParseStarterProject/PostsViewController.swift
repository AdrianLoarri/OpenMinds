//
//  PostsViewController.swift
//  OpenMinds
//
//  Created by Adrian Loarri on 30/08/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {

    @IBOutlet var menuBtn: UIBarButtonItem!
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
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //METODO PARA MOSTRAR LA BARRA DE NAVEGACION UNA VEZ QUE APAREZCA LA PANTALLA
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
