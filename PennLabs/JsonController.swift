//
//  JsonController.swift
//  PennLabs
//
//  Created by Matthew Riley on 2017-02-11.
//  Copyright © 2017 Matthew Riley. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

class JsonController: UIViewController {

    @IBOutlet weak var entryField: UITextField!
    @IBOutlet weak var displayField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayField.text = "welcome!"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submit(_ sender: Any) {
        
        let params: Parameters = ["q": entryField.text ?? ""]
        Alamofire.request("https://api.pennlabs.org/buildings/search", parameters: params).responseJSON { response in
            if let json = response.result.value {
                print("\(json)")
                self.displayField.text = "\(json)"
            }
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
