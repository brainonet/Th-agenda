//
//  infoViewController.swift
//  agenda_SQLite
//
//  Created by Mauro Silva on 3/02/2018.
//  Copyright © 2018 Brains On Netwroks. All rights reserved.
//

import UIKit
import SQLite

class infoViewController: UIViewController {

    var cor_red = Float()
    var cor_green = Float()
    var cor_blue = Float()
    
    
    var database:Connection!
    let utilizador_Table = Table("contactos")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let email = Expression<String>("email")
    let contacto = Expression<String>("contacto")
    
    var aux = String()
    
    @IBOutlet weak var lbl_nome: UILabel!
    @IBOutlet weak var lbl_telemovel: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            //cria uma ligaçao à base de dados
            let database = try Connection(fileURL.path)
            self.database = database
        } catch {
            print("Error connecting to database:\n")
            print(error)
        }
        
        //define a informaçao a ser mostrada
        print("Herw comes aux\n")
        print("This is aux: \(aux)\n")
        let filtro = utilizador_Table.filter(name == aux)
        for user in try! database.prepare(filtro) {
            print("ID: \(user[id]), Nome: \(user[name]), email: \(user[email])")
            lbl_nome.text = user[name]
            lbl_telemovel.text = user[contacto]
            lbl_email.text = user[email]
        }
        
        //para selecionar a cor guardada no plist e usar como background
        let fm = FileManager.default
        let basePath = fm.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.allDomainsMask)
        let path = basePath[0].appendingPathComponent("cores.plist")
        
        //o ficheiro demo.plist tem key-value pairs. As 'key' sao R/G/B e os
        //'value' sao numeros. Cada slider receberá o valor correspondente para depois
        //se modificar a background color de acordo com a posiçao dos sliders
        let info_cor = NSMutableDictionary(contentsOf: path)
        if (info_cor == nil) {
            print("Cor Default a ser utilizada")
        } else {
            self.cor_red = info_cor?.value(forKey: "R") as! Float
            self.cor_green = info_cor?.value(forKey: "G") as! Float
            self.cor_blue = info_cor?.value(forKey: "B") as! Float
        }
        
        self.view.backgroundColor = UIColor(red:CGFloat(cor_red)/255, green:CGFloat(cor_green)/255, blue:CGFloat(cor_blue)/255, alpha: 1)
    }

    
    
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
