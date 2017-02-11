//
//  MapController.swift
//  PennLabs
//
//  Created by Matthew Riley on 2017-02-11.
//  Copyright © 2017 Matthew Riley. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

struct Building {
    var name: String
    var latitude: Double
    var longitude: Double
}

class MapController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    // parse json result
    func jsonToBuilding(json: JSON) -> Building {
        let lat = json["latitude"].doubleValue
        let long = json["longitude"].doubleValue
        let name = json["title"].string ?? "name not found"
        return Building(name: name, latitude: lat, longitude: long)
    }
    
    func setRegionToBuilding(b: Building) {
        let center = CLLocationCoordinate2D(latitude: b.latitude, longitude: b.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.125, longitudeDelta: 0.125)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = CLLocationCoordinate2D(latitude: 39.950199, longitude: -75.200302)
        let span = MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(_ sender: Any) {
        
        let params: Parameters = ["q": searchField.text ?? ""]
        Alamofire.request("https://api.pennlabs.org/buildings/search", parameters: params).responseJSON { response in
            
            guard let jsonData = response.result.value else {
                print("error")
                return
            }
            let json = JSON(jsonData)
            let buildings: [Building] = json["result_data"].arrayValue.map(self.jsonToBuilding)
            print(buildings)
            
            // center on the first building
            self.setRegionToBuilding(b: buildings[0])
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
