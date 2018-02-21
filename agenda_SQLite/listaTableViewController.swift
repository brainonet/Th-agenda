//
//  listaTableViewController.swift
//  Th-agenda
//
//  Created by Mauro Silva on 16/02/2018.
//  Copyright © 2018 Brains On Networks. All rights reserved.
//

import UIKit
import SQLite

class listaTableViewController: UITableViewController {
    
    var database:Connection!
   //cria a tabela e os campos
    let utilizador_Table = Table("contactos")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let email = Expression<String>("email")
    let contacto = Expression<String>("contacto")
    var nome:String?
    
    //para mostrar o nome e o contacto nas cells. Um para cada label
    var nome_select:[String]?
    var tlm_select:[String]?

    @IBOutlet var tabela: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load_informacao()
        tabela.reloadData()
    }


    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return nome_select!.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = self.nome_select?[indexPath.row]
        cell?.detailTextLabel?.text = self.tlm_select?[indexPath.row]
        return cell!
    }

    
    // MARK - Navigation
    //segues e etc para passar alguma informação
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "info_segue", sender: nome_select![indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let dest = segue.destination as? infoViewController {
            if let seg = sender as? String {
                dest.aux = seg
            }
        }
    }

    
    
    //para atualizar a informaçao sempre que se voltar a esta view
    override func viewDidAppear(_ animated: Bool) {
        load_informacao()
        tabela.reloadData()
    }
    
    
    //acede/cria a base de dados/tabelas etc
    //está numa funcao propria para faciltar o load da informaçao ao abrir a app e ao utilizar o viewDidAppear, evitando repetiçao de codigo desnecessari
    private func load_informacao() {
        //ligação à base de dados
        do{
            let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            
            //cria uma ligaçao à base de dados
            let database = try Connection(fileURL.path)
            self.database = database
            print(fileURL)
        } catch {
            print("Error connecting to database:\n")
            print(error)
        }
        
        //cria uma tabela 'contactos'
        let createTable = self.utilizador_Table.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.email)
            table.column(self.contacto)
        }
        
        do {
            try self.database.run(createTable)
            print("\nTabela Criada\n")
        } catch {
            print("\n\nTabela já existente:  \(error)\n")
        }
        
        //a query popula um array cujo index sera lido pela tableview
        nome_select = [String]()
        for row in try! database.prepare("SELECT name FROM contactos ORDER BY name") {
            nome_select?.append(row[0] as! String)
        }
        tlm_select = [String]()
        for row in try! database.prepare("SELECT contacto FROM contactos"){
            tlm_select?.append(row[0] as! String)
        }
        
        //apenas para verificar a informaçao da tabela
        for user in try! database.prepare(utilizador_Table){
            print("ID: \(user[id]) || Nome: \(user[name]) || Nº: \(user[contacto]) || email: \(user[email])")
        }
    }
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
    
//    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }


}
