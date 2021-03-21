//
//  ViewController.swift
//  mapview
//
//  Created by Koushik Das Sharma on 20/03/21.
//  Copyright © 2021 Koushik Das Sharma. All rights reserved.
//

import UIKit
import MapKit

struct MapData {
    var subject: String?
    var lat: CLLocationDegrees?
    var long: CLLocationDegrees?
    var details: String?
    var isclick: Bool?
    
    
    init(subject: String? ,lat: CLLocationDegrees? ,long: CLLocationDegrees? ,details: String? ,isclick: Bool?) {
        self.subject = subject
        self.lat = lat
        self.long = long
        self.details = details
        self.isclick  = isclick
    }
}
class ImageAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var tag: String?
    var image: UIImage?
    var colour: UIColor?

    override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.title = nil
        self.subtitle = nil
        self.image = nil
        self.tag = nil
        self.colour = UIColor.white
    }
}
class ViewController: UIViewController , MKMapViewDelegate,  CLLocationManagerDelegate {

   @IBOutlet weak var pokemonMap: MKMapView!
    
    private var displayedAnnotations: [MKAnnotation]? {
        willSet {
            if let currentAnnotations = displayedAnnotations {
                pokemonMap.removeAnnotations(currentAnnotations)
            }
        }
        didSet {
            if let newAnnotations = displayedAnnotations {
                pokemonMap.addAnnotations(newAnnotations)
            }
            centerMapOnSanFrancisco()
        }
    }
    
    let locationManager = CLLocationManager()
    var pointAnnotation:CustomAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    let regionInMeters: Double = 10000
    var maparray = [MapData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        maparray.append(MapData(subject: "koushik", lat: 22.5726, long: 88.3639, details: "IOS Devloper", isclick: false))
        maparray.append(MapData(subject: "Rohit", lat: 28.7041, long: 77.1025, details: "PHP Devloper", isclick: false))
         maparray.append(MapData(subject: "Bikas", lat: 12.9716, long: 77.5946, details: ".NET Devloper", isclick: false))
        maparray.append(MapData(subject: "Milon", lat: 25.4358, long: 81.8463, details: "Web Devloper", isclick: false))
        maparray.append(MapData(subject: "Suman", lat: 21.1458, long: 79.0882, details: "Android Devloper", isclick: false))
//        maparray.append(MapData(subject: "Suman", lat: 22.5726, long: 88.3639, details: "IOs Devloper", isclick: false))
//        maparray.append(MapData(subject: "Debu", lat: 22.5726, long: 88.3639, details: "IOs Devloper", isclick: false))
//        maparray.append(MapData(subject: "Snumt", lat: 22.5726, long: 88.3639, details: "IOs Devloper", isclick: false))
        checkLocationServices()
        //Mark: - Authorization
        

    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func centerMapOnSanFrancisco() {
        let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        let center = CLLocationCoordinate2D(latitude: 37.786_996, longitude: -122.440_100)
        pokemonMap.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
    }
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()

            pokemonMap.delegate = self
            pokemonMap.mapType = MKMapType.mutedStandard
            pokemonMap.showsUserLocation = true
        }
    }
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            pokemonMap.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
    private func registerMapAnnotationViews() {
        for i in 0..<maparray.count{
            let annotation = ImageAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(maparray[i].lat!, maparray[i].long!)
            annotation.tag = "\(i)"
            annotation.image = UIImage(named: "Bullet")
            annotation.title = "\(maparray[i].subject ?? "")"
            annotation.subtitle = "\(maparray[i].details ?? "")"
            pokemonMap.addAnnotation(annotation)
        }
//        let annotation = ImageAnnotation()
//        annotation.coordinate = CLLocationCoordinate2DMake(43.761539, -79.411079)
//        annotation.image = UIImage(named: "location")
//        annotation.title = "Toronto"
//        annotation.subtitle = "Yonge & Bloor"
//
//        let annotation1 = ImageAnnotation()
//        annotation1.coordinate = CLLocationCoordinate2DMake(22.761539, 88.411079)
//        annotation1.image = UIImage(named: "location")
//        annotation1.title = "Toronto"
//        annotation1.subtitle = "Yonge & Bloor"
//
//        pokemonMap.addAnnotations([annotation , annotation1])
        //pokemonMap.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
       
        //pokemonMap.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(FerryBuildingAnnotation.self))
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.annotation?.coordinate.latitude)
        for i in 0..<maparray.count{
            if view.annotation!.coordinate.latitude == maparray[i].lat{
                if maparray[i].isclick!{
                    //mapView.removeAnnotation()
                }else{
                    maparray[i].isclick! = !maparray[i].isclick!
                    let images = CustomAnnotation(coordinate: CLLocationCoordinate2DMake(maparray[i].lat!, maparray[i].long!))
                    images.title = "\(maparray[i].details!)"
                    images.imageName = "demo3"
                    mapView.addAnnotation(images)
                }
                
            }
        }
        
       mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
        
        mapView.reloadInputViews()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        registerMapAnnotationViews()
       
    }

    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        

       
        if annotation.isKind(of: MKUserLocation.self) {  //Handle user location annotation..
            return nil  //Default is to let the system handle it.
        }

        var annotationView: MKAnnotationView?
        if let annotation = annotation as? CustomAnnotation {
            annotationView = setupCustomAnnotationView(for: annotation, on: mapView)
        }else if annotation.isKind(of: ImageAnnotation.self) {
            var view: ImageAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "imageAnnotation") as? ImageAnnotationView
            if view == nil {
                view = ImageAnnotationView(annotation: annotation, reuseIdentifier: "imageAnnotation")
            }

            let annotation = annotation as! ImageAnnotation
            view?.image = annotation.image
            view?.annotation = annotation
            return view
        }
        

        return annotationView
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    private func setupCustomAnnotationView(for annotation: CustomAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        
        return mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(CustomAnnotation.self), for: annotation)
    }

}

//
class ImageAnnotationView: MKAnnotationView {
    private var imageView: UIImageView!

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        self.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.addSubview(self.imageView)

        self.imageView.layer.cornerRadius = 5.0
        self.imageView.layer.masksToBounds = true
    }

    override var image: UIImage? {
        get {
            return self.imageView.image
        }

        set {
            self.imageView.image = newValue
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

