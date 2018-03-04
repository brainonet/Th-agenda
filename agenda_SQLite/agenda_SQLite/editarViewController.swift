//
//  editarViewController.swift
//  agenda_SQLite
//
//  Created by Mauro Silva on 3/02/2018.
//  Copyright © 2018 Brains On Netwroks. All rights reserved.
//

import UIKit
import SQLite

class editarViewController: UIViewController {
    
    @IBOutlet weak var txt_nome: UITextField!
    @IBOutlet weak var txt_telemovel: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    
    //para modificar o width dos botoes
    @IBOutlet weak var edit_constraint: NSLayoutConstraint!
    @IBOutlet weak var add_constraint: NSLayoutConstraint!
    
    var database:Connection!
    //cria a tabela e os campos
    let utilizador_Table = Table("contactos")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let email = Expression<String>("email")
    let contacto = Expression<String>("contacto")
    
    
    
    //adiciona na base de dados
    @IBAction func btn_adicionar(_ sender: Any) {
        //codigo inserçao na tabela
        let insert_user = self.utilizador_Table.insert(self.name <- self.txt_nome.text!, self.contacto <- self.txt_telemovel.text!, self.email <- self.txt_email.text!)
        do {
            //corre o codigo anterior na base de dados
            try self.database.run(insert_user)
            print("\nInsert bem sucedido")
        } catch {
            print(error)
        }
    }
    
    
    //edita contactos (update)
    @IBAction func btn_editar(_ sender: Any) {
        let alert = UIAlertController(title: "Editar Contacto", message: nil, preferredStyle: .alert)
        alert.addTextField{(tf) in tf.placeholder = "User ID"}
        alert.addTextField{(tf) in tf.placeholder = "Nome"}
        alert.addTextField{(tf) in tf.placeholder = "Email"}
        alert.addTextField{(tf) in tf.placeholder = "Contacto"}

        let action = UIAlertAction(title: "Atualizar Contacto", style: .default){(_) in
            guard let userIdString = alert.textFields![0].text,
                let userId = Int(userIdString),
                let nome = alert.textFields![1].text,
                let email = alert.textFields![2].text,
                let telemovel = alert.textFields![3].text
                else{return}
            print("\nContacto Editado com Sucesso\nID: \(userIdString)|| Nome: \(nome) || email: \(email) || Telemovel: \(telemovel)")

            let utilizador = self.utilizador_Table.filter(self.id == userId)
            let update_utilizador = utilizador.update(self.name <- nome, self.email <- email, self.contacto <- telemovel)

            do{
                try self.database.run(update_utilizador)
            }catch{
                print(error)
            }
            //    let updateUser = self.ConTable.update

        }
        alert.addAction(action)
        present(alert, animated:true, completion: nil)
    }
    
    
    //apaga utilizadores
    @IBAction func btn_apagar(_ sender: Any) {
        
        let alert = UIAlertController(title: "Apagar Contacto", message: "Na consola poderá observar os IDs e os respectivos dados", preferredStyle: .alert)
        alert.addTextField{(tf) in tf.placeholder = "User ID"}
        
        
        let action = UIAlertAction(title: "Apagar Contacto", style: .destructive){(_) in
            guard let userIdString = alert.textFields?.first?.text,
                let userId = Int(userIdString)
                else{return}
            print(userIdString)
            
            let utilizador = self.utilizador_Table.filter(self.id == userId)
            let apagar_utilizador = utilizador.delete()
            
            do{
                try self.database.run(apagar_utilizador)
            }catch{
                print(error)
            }
        }
        let action2 = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(action2)
        present(alert, animated:true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //botoes bonitos - inicio
        let screenSize = UIScreen.main.bounds
        let btn_responsive = screenSize.width/2 - 30
        
        self.edit_constraint.constant = btn_responsive;
        self.add_constraint.constant = btn_responsive;
        //botoes bonitos - fim
        
        do{
            let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            
            //cria uma ligaçao à base de dados
            let database = try Connection(fileURL.path)
            self.database = database
        } catch {
            print("Error connecting to database:\n")
            print(error)
        }
        
        
        //caso nao hajam tabelas
        let createTable = self.utilizador_Table.create{(table) in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.email)
            table.column(self.contacto)
        }
        
        do{
            try self.database.run(createTable)
            print("Tabela criada")
        }catch{
            print("\n\nTabela ja existe\n\nID  ||  Nome    ||  Nº  ||  email\n")
            for user in try! database.prepare(utilizador_Table){
                print("\(user[id])  ||  \(user[name])   ||  \(user[contacto])   ||  \(user[email])")
            }
            print("\n")
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
