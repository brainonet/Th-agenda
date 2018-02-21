//
//  corViewController.swift
//  Th-agenda
//
//  Created by Mauro Silva on 16/02/2018.
//  Copyright © 2018 Brains On Networks. All rights reserved.
//

import UIKit

class corViewController: UIViewController {

    @IBOutlet weak var sld_Red: UISlider!
    @IBOutlet weak var sld_Green: UISlider!
    @IBOutlet weak var sld_Blue: UISlider!
    
    var color:UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fm = FileManager.default
        let basePath = fm.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.allDomainsMask)
        let path = basePath[0].appendingPathComponent("cores.plist")
        
        //o ficheiro demo.plist tem key-value pairs. As 'key' sao R/G/B e os
        //'value' sao numeros. Cada slider receberá o valor correspondente para depois
        //se modificar a background color de acordo com a posiçao dos sliders
        let info_cor = NSMutableDictionary(contentsOf: path)
        if (info_cor == nil) {
            //cria um dicionario e escreve-o no ficheiro plist
            let dic: NSMutableDictionary = ["R": self.sld_Red.value, "G": self.sld_Green.value, "B": self.sld_Blue.value]
            try! dic.write(to: path)
        } else {
            sld_Red.value = info_cor?.value(forKey: "R") as! Float
            sld_Green.value = info_cor?.value(forKey: "G") as! Float
            sld_Blue.value = info_cor?.value(forKey: "B") as! Float
        }
        
        self.view.backgroundColor = UIColor(red:CGFloat(sld_Red.value)/255, green:CGFloat(sld_Green.value)/255, blue:CGFloat(sld_Blue.value)/255, alpha: 1)
    }

    
    
    //altera a cor de fundo quando se movimenta os sliders
    @IBAction func sld_change(_ sender: UISlider) {
        self.view.backgroundColor = UIColor(red:CGFloat(sld_Red.value)/255, green:CGFloat(sld_Green.value)/255, blue:CGFloat(sld_Blue.value)/255, alpha:1)
    }
    
    
    
    //grava no ficheiro 3 keys e 3 values correspondentes(o numero de cada slider sera o "value")
    @IBAction func btn_cor(_ sender: Any) {
        //acede ao ficheiro
        let fm = FileManager.default
        let basePath = fm.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.allDomainsMask)
        let path = basePath[0].appendingPathComponent("cores.plist")
        
        //reescreve o ficheiro com novas keys e novos values
        let dic: NSMutableDictionary = ["R":self.sld_Red.value, "G":self.sld_Green.value, "B":self.sld_Blue.value]
        try! dic.write(to: path)
    }
    
}
