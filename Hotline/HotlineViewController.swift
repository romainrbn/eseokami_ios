//
//  HotlineViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 01/01/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit
import MapKit
import PassKit
import FirebaseDatabase

class HotlineViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var location: CLLocation!
    var aReserver = Restaurant(nom: "", coordinates: CLLocationCoordinate2D(), numero: [""], path: "", livreurs:["", ""])
    let calendar = Calendar.current
    let now = Date()
    var nbreCommandes: Int = 0
    
    
    
    let PAULIN_GABRIEL = ["0633043856", "0614788798"]
    
    let RICO_MARIE = ["0630452688", "0670036852"]
    
    let XAVIER_ERIKA = ["0781928573", "0629215048"]
    
    let THEO_ANDY = ["063212264", "0786760162"]
    
    
    var isCommandePossible: Bool = false
    
    
    let center = CLLocationCoordinate2D(latitude: 47.481539, longitude: -0.554895)
    
    let circle = MKCircle(center: CLLocationCoordinate2D(latitude: 47.481539, longitude: -0.554895), radius: CLLocationDistance(1720))
    
    var annotations: [MKPointAnnotation] = []

    // Restaurants Data
    let restaurants: [Restaurant] = [
        Restaurant(nom: "O'classic", coordinates: CLLocationCoordinate2D(latitude: 47.477481, longitude: -0.558136), numero: ["0633043856", "0614788798"], path: "O_classic", livreurs:["Paulin", "Gabriel"]), // Paulin Gabriel
        Restaurant(nom: "Le régal de la doutre", coordinates: CLLocationCoordinate2D(latitude: 47.474004, longitude: -0.559594), numero: ["0633043856", "0614788798"], path: "regal_doutre", livreurs:["Paulin", "Gabriel"]), // Paulin Gabriel
        Restaurant(nom: "Chicken Wrap", coordinates: CLLocationCoordinate2D(latitude: 47.471977, longitude: -0.556270), numero: ["0781928573", "0629215048"], path: "chicken_wrap", livreurs:["Xavier", "Erika"]),
        Restaurant(nom: "La Mie Câline", coordinates: CLLocationCoordinate2D(latitude: 47.469004, longitude: -0.550062), numero: ["063212264", "0786760162"], path: "mie_caline", livreurs:["Théo", "Andy"]),
        Restaurant(nom: "Restaurant Vf", coordinates: CLLocationCoordinate2D(latitude: 47.468175, longitude: -0.550454), numero: ["063212264", "0786760162"], path: "restaurant_vf", livreurs:["Théo", "Andy"]),
        Restaurant(nom: "Subway Fleur d'Eau", coordinates: CLLocationCoordinate2D(latitude: 47.471387, longitude: -0.554010), numero: ["0781928573", "0629215048"], path: "subway_fleur", livreurs:["Xavier", "Erika"]),
        Restaurant(nom: "Le Tam'", coordinates: CLLocationCoordinate2D(latitude: 47.475239, longitude: -0.549160), numero: ["0630452688", "0670036852"], path: "tam", livreurs:["Rico", "Marie"]),
        Restaurant(nom: "Subway Saint-Serge", coordinates: CLLocationCoordinate2D(latitude: 47.476849, longitude: -0.550371), numero: ["0630452688", "0670036852"], path: "subway_saint_serge", livreurs:["Rico", "Marie"]),
        Restaurant(nom: "Le lézard vert", coordinates: CLLocationCoordinate2D(latitude: 47.472398, longitude: -0.551090), numero: ["0781928573", "0629215048"], path: "lezard_vert", livreurs:["Xavier", "Erika"]),
        Restaurant(nom: "McDonald's Boulevard Foch", coordinates: CLLocationCoordinate2D(latitude: 47.470011, longitude: -0.548717), numero: ["063212264", "0786760162"], path: "mcdo_foch", livreurs:["Théo", "Andy"]),
        Restaurant(nom: "Pizza Tempo", coordinates: CLLocationCoordinate2D(latitude: 47.474063, longitude: -0.553576), numero: ["0630452688", "0670036852"], path: "pizza_tempo", livreurs:["Rico", "Marie"]),
        Restaurant(nom: "Speed Burger", coordinates: CLLocationCoordinate2D(latitude: 47.474275, longitude: -0.553573), numero: ["0630452688", "0670036852"], path: "speed_burger", livreurs:["Rico", "Marie"]),
        Restaurant(nom: "Le Punjab", coordinates: CLLocationCoordinate2D(latitude: 47.473104, longitude: -0.549077), numero: ["0781928573", "0629215048"], path: "punjab", livreurs:["Xavier", "Erika"]),
        Restaurant(nom: "Domino's Pizza", coordinates: CLLocationCoordinate2D(latitude: 47.467546, longitude: -0.558897), numero: ["0633043856", "0614788798"], path: "dominos", livreurs:["Paulin", "Gabriel"]),
        Restaurant(nom: "L'Oriflamme", coordinates: CLLocationCoordinate2D(latitude: 47.466914, longitude: -0.556845), numero: ["0633043856", "0614788798"], path: "oriflamme", livreurs:["Paulin", "Gabriel"]),
        Restaurant(nom: "Vite & Frais", coordinates: CLLocationCoordinate2D(latitude: 47.466793, longitude: -0.548401), numero: ["063212264", "0786760162"], path: "vite_frais", livreurs:["Théo", "Andy"]),
        Restaurant(nom: "Chez Minh", coordinates: CLLocationCoordinate2D(latitude: 47.466149, longitude: -0.547023), numero: ["063212264", "0786760162"], path: "minh", livreurs:["Théo", "Andy"]),
        Restaurant(nom: "La Boîte à Pizzas", coordinates: CLLocationCoordinate2D(latitude: 47.473704, longitude: -0.571082), numero: ["0633043856", "0614788798"], path: "boite_pizzas", livreurs:["Paulin", "Gabriel"]),
        Restaurant(nom: "Orient'Halles", coordinates: CLLocationCoordinate2D(latitude: 47.472054, longitude: -0.556430), numero: ["0781928573", "0629215048"], path: "orient_halles", livreurs:["Xavier", "Erika"]),
        Restaurant(nom: "Le Quai Bab d'Aladin", coordinates: CLLocationCoordinate2D(latitude: 47.474637, longitude: -0.560500), numero: ["0633043856", "0614788798"], path: "quai_bab", livreurs:["Paulin", "Gabriel"]),
        Restaurant(nom: "Point Chicken", coordinates: CLLocationCoordinate2D(latitude: 47.4758, longitude: -0.551149), numero: ["0630452688", "0670036852"], path: "point_chicken", livreurs:["Rico", "Marie"]),
        Restaurant(nom: "McDoner", coordinates: CLLocationCoordinate2D(latitude: 47.467431, longitude: -0.549907), numero: ["063212264", "0786760162"], path: "mcdoner", livreurs:["Théo", "Andy"]),
        Restaurant(nom: "Ylios Arhadia", coordinates: CLLocationCoordinate2D(latitude: 47.470998, longitude: -0.550602), numero: ["0781928573", "0629215048"], path: "ylios", livreurs:["Xavier", "Erika"]),
        Restaurant(nom: "Ashiq Muhammad", coordinates: CLLocationCoordinate2D(latitude: 47.467763, longitude: -0.550561), numero: ["063212264", "0786760162"], path: "ashiq", livreurs:["Théo", "Andy"]),
        Restaurant(nom: "O'Tacos Angers", coordinates: CLLocationCoordinate2D(latitude: 47.474184, longitude: -0.554118), numero: ["0630452688", "0670036852"], path: "otacos", livreurs:["Rico", "Marie"]),
        Restaurant(nom: "Takos King", coordinates: CLLocationCoordinate2D(latitude: 47.470176, longitude: -0.548473), numero: ["0781928573", "0629215048"], path: "takos_king", livreurs:["Xavier", "Erika"])]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        mapView.addAnnotations(annotations)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        // mapView is delegate
        mapView.delegate = self
        
        // Create the span for the region and the region itself
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        
        // Set the region for the map
        mapView.setRegion(region, animated: true)
        
        // Add the red circle
        mapView.addOverlay(circle)
        
        // Load the data into the map, and create the annotations
        for rest in 0...(restaurants.count - 1) {
            let annotat = MyAnnotation(phoneToCall: restaurants[rest].numero, path: restaurants[rest].path, livreurs: restaurants[rest].livreurs)
            annotat.title = restaurants[rest].nom
            annotat.coordinate = CLLocationCoordinate2D(latitude: restaurants[rest].coordinates.latitude, longitude: restaurants[rest].coordinates.longitude)
            
            annotations.append(annotat)
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        
        location = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let circleRadius = CLLocationDistance(1720)
        let circleCenter = CLLocationCoordinate2D(latitude: 47.481539, longitude: -0.554895)
        let locCircleCenter = CLLocation(latitude: circleCenter.latitude, longitude: circleCenter.longitude)
        
        if location.distance(from: locCircleCenter) > circleRadius {
            print("Trop loin")
            isCommandePossible = false
            
        } else {
            print("OK Pour la commande")
            isCommandePossible = true
        }
        
        
        mapView.reloadInputViews()
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.fillColor = UIColor.red.withAlphaComponent(0.1)
        circleRenderer.strokeColor = UIColor.red
        circleRenderer.lineWidth = 1
        return circleRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MyAnnotation else { return nil }
        let identifier = "annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            
            let btn = UIButton()
            btn.setImage(UIImage(named:"shoppingBag")?.withRenderingMode(.alwaysTemplate), for: .normal)
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
   
            annotationView?.rightCalloutAccessoryView = btn

            
        } else {
            annotationView!.annotation = annotation
        }
        
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let monAnnot = view.annotation as! MyAnnotation
        
        let dix_huit = self.calendar.date(bySettingHour: 18, minute: 00, second: 0, of: self.now)!
        let dix_neuf = self.calendar.date(bySettingHour: 19, minute: 00, second: 00, of: self.now)!
        
        let nbreDeCommandesBranch = Database.database().reference().child("Commandes")
        
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value) { (snapshot) in
           if let connected = snapshot.value as? Bool, connected {
                DispatchQueue.main.async {
                    nbreDeCommandesBranch.observe(.value, with: { (snapshot) in
                        self.nbreCommandes = Int(snapshot.childrenCount)
                    })
                }
                
                
                
            //    if self.now > dix_huit && self.now < dix_neuf {
                    print("Commande possible")
                    if self.isCommandePossible {
                        if self.nbreCommandes < 100 { // 100 Commandes maximum
                            self.aReserver = Restaurant(nom: monAnnot.title!, coordinates: monAnnot.coordinate, numero: monAnnot.phoneToCall as! [String], path: monAnnot.path, livreurs: monAnnot.livreurs)
                            
                            self.performSegue(withIdentifier: "showReservationRestaurants", sender: self)
                        } else {
                            let alertController = UIAlertController(title: "Impossible de réserver pour le moment", message: "Nous avons trop de commandes pour l'instant, nous ne pouvons pas accepter ta réservation...", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                        
                    } else {
                        let alertController = UIAlertController(title: "Impossible de commander", message: "Tu ne semble pas être dans la zone où nous pouvons te livrer...", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
//                } else {
//                    let alertController = UIAlertController(title: "Impossible de commander", message: "Les commandes commencent à 18h et se terminent à 19h. Les livraisons se poursuiveront jusqu'à 21h.", preferredStyle: .alert)
//                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//                    self.present(alertController, animated: true, completion: nil)
//                }

            } else {
                let alertController = UIAlertController(title: "Impossible de commander", message: "Tu ne sembles pas être connecté à internet...", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func unwindToHotline(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationViewController = segue.destination as! UINavigationController
        if segue.identifier == "showReservationRestaurants" {
            let targetController = destinationViewController.topViewController as! RestaurantReservationViewController
            targetController.restaurantReservation = aReserver
        }
        

        
    }
    


}

class MyAnnotation: MKPointAnnotation {
    var phoneToCall: [String!]
    var path: String
    var livreurs: [String]
    
    init(phoneToCall: [String], path: String, livreurs: [String]) {
        self.phoneToCall = phoneToCall
        self.path = path
        self.livreurs = livreurs
    }
}
