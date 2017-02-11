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

class Building : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?) {
        self.coordinate = coordinate
        self.title = title
    }
}

class MapController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    // currently displayed annotations
    var currentBuildings: [Building] = []
    
    // parse json result
    func jsonToBuilding(json: JSON) -> Building {
        let lat = json["latitude"].doubleValue
        let long = json["longitude"].doubleValue
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let name = json["title"].string
        return Building(coordinate: coord, title: name)
    }
    
    func setRegionToBuilding(b: Building) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: b.coordinate, span: span)
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
        
        // remove current annotations
        self.mapView.removeAnnotations(currentBuildings)
        
        let params: Parameters = ["q": searchField.text ?? ""]
        Alamofire.request("https://api.pennlabs.org/buildings/search", parameters: params).responseJSON { response in
            
            guard let jsonData = response.result.value else {
                print("error")
                return
            }
            let json = JSON(jsonData)
            let buildings: [Building] = json["result_data"].arrayValue.map(self.jsonToBuilding)
            print(buildings)
            
            // update buildings list
            self.currentBuildings = buildings
            
            if (buildings.count > 0) {
                // center the map on the first building
                self.setRegionToBuilding(b: buildings.first!)
                
                // add all annotations to map
                self.mapView.addAnnotations(buildings)
            }
            
            self.mapView.addAnnotations(self.currentBuildings)
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
