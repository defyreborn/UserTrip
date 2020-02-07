//
//  HomeViewController.swift
//  UserTripTask
//
//  Created by Mubashshir on 2/6/20.
//  Copyright © 2020 Mubashshir. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import CoreData

class HomeViewController: BaseViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    var speedCriteria : SpeedCriteria = .stable
    
    var locationManager = CLLocationManager()
    var currentLoc : CLLocation?
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        self.retriveData()
    }
    
    func configureMap(){
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    @IBAction func tapOnStartLocUpdate(_ sender: Any) {
        self.locationManager.startUpdatingLocation()
        let position = CLLocationCoordinate2D(latitude: (currentLoc?.coordinate.latitude)!, longitude: (currentLoc?.coordinate.longitude)!)
        let marker = GMSMarker(position: position)
        marker.icon = GMSMarker.markerImage(with: .green)
        marker.map = mapView
    }
    @IBAction func tapOnStopLocUpdate(_ sender: Any) {
        let position = CLLocationCoordinate2D(latitude: (currentLoc?.coordinate.latitude)!, longitude: (currentLoc?.coordinate.longitude)!)
        let marker = GMSMarker(position: position)
        marker.icon = GMSMarker.markerImage(with: .red)
        marker.map = mapView
        self.locationManager.stopUpdatingLocation()
    }
    
    func updateTimer(speedCrit: SpeedCriteria){
        if speedCrit == .stable {
            timer?.invalidate()
            if self.speedCriteria != .stable{
                store()
            }
        }else{
            if self.speedCriteria != speedCrit{
                timer?.invalidate()
                timer = nil
                timer = Timer.scheduledTimer(timeInterval: speedCrit.timeInterval ?? 0, target: self, selector: #selector(store), userInfo: nil, repeats: true)
            }
        }
        self.speedCriteria = speedCrit
        
    }
    
    func addMarker(_speedCrit:SpeedCriteria){
        let position = CLLocationCoordinate2D(latitude: (currentLoc?.coordinate.latitude)!, longitude: (currentLoc?.coordinate.longitude)!)
        let marker = GMSMarker(position: position)
        marker.icon = GMSMarker.markerImage(with: _speedCrit.colorCriteria)
        marker.map = mapView
    }
    
    @objc func store(){
        
        guard let _location = self.currentLoc else {return}
        let applicaion = UIApplication.shared.delegate as! AppDelegate
        let context = applicaion.persistentContainer.viewContext
        guard let location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: context) as? Location else {return}
        location.latitude = _location.coordinate.latitude
        location.longtitude = _location.coordinate.longitude
        location.speed = _location.speed
        location.time = Date()
        
        let sc = SpeedCriteria.intialize(with: _location.speed)
        self.addMarker(_speedCrit: sc)
        
        do{
            try context.save()
            print(location)
        }catch{
            print("error")
        }
    }
    
    func retriveData(){
        let applicaion = UIApplication.shared.delegate as! AppDelegate
        let context = applicaion.persistentContainer.viewContext
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        do {
            let res = try context.fetch(req)
            let logData = res as! [Location]
            self.showLogs(data: logData)
        }catch{
            print("error")
        }
    }
    
    func showLogs(data:[Location]?){
        print("============Speed vs Time Criteria=============")
        for i in data ?? [] {
            let sc = SpeedCriteria.intialize(with: i.speed)
            
            print("Speed:- \(i.speed), Stored at :- \(String(describing: i.time)), Latitude:- \(i.latitude), Longitude:- \(i.longtitude), Marker Color:- \(sc.colorCriteria), Speed Criteria :- \(sc)")
        }
    }
    
    @IBAction func tapOnViewLogs(_ sender: Any) {
        self.view.makeToast("Please check console for logs")
        self.retriveData()
    }
}

extension HomeViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let loc = locations.last {
            currentLoc = loc
            let camera = GMSCameraPosition.camera(withLatitude: (currentLoc?.coordinate.latitude)!, longitude: (currentLoc?.coordinate.longitude)!, zoom: 17.0)
            self.mapView.animate(to: camera)
            let speed = ((currentLoc?.speed ?? 0) * 1.61)
            
            let speedCrit = SpeedCriteria.intialize(with: speed)
            self.updateTimer(speedCrit: speedCrit)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error :- \(error.localizedDescription)")
    }
}
