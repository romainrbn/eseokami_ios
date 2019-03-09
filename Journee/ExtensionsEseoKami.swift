//
//  Extensions.swift
//  EseoKami
//
//  Created by Romain Rabouan on 02/01/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit
import MapKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Composant rouge invalide")
        assert(green >= 0 && green <= 255, "Composant vert invalide")
        assert(blue >= 0 && blue <= 255, "Composant bleu invalide")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


extension TodayViewController {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SmallActivityCollectionViewCell
        
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
        let activite: Activite
        activite = activityList[indexPath.item]
        
        cell.backgroundColor = UIColor.flatWatermelonColorDark()
        cell.nameLabel.text = activite.nom
        return cell
    }
}

extension MaCommandeViewController {
    func showRouteOnMap() {
        let request = MKDirections.Request()
        let loc = location
        var restCoord = UserDefaults.standard.object(forKey: "commandeHotlineReserveeRestCoordinates") as! Dictionary<String, Double>
        
        
        let restaurantLocation = CLLocationCoordinate2D(latitude: restCoord["lat"]!, longitude: restCoord["long"]!)
      //  let restLocation = CLLocationCoordinate2D(latitude: 47.470011, longitude: -0.548717)
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: restaurantLocation))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: loc!))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard let unwrappedResponse = response else { return }
            
            if (unwrappedResponse.routes.count > 0) {
                self.mapView.addOverlay(unwrappedResponse.routes[0].polyline)
                self.mapView.setVisibleMapRect(unwrappedResponse.routes[0].polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.red
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
    //        /** Degrees to Radian **/
    func degreeToRadian(angle:CLLocationDegrees) -> CGFloat {
        return (  (CGFloat(angle)) / 180.0 * CGFloat(M_PI)  )
    }
    
    //        /** Radians to Degrees **/
    func radianToDegree(radian:CGFloat) -> CLLocationDegrees {
        return CLLocationDegrees(  radian * CGFloat(180.0 / M_PI)  )
    }
    
    func middlePointOfListMarkers(listCoords: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        
        var x = 0.0 as CGFloat
        var y = 0.0 as CGFloat
        var z = 0.0 as CGFloat
        
        for coordinate in listCoords{
            let lat:CGFloat = degreeToRadian(angle: coordinate.latitude)
            let lon:CGFloat = degreeToRadian(angle: coordinate.longitude)
            x = x + cos(lat) * cos(lon)
            y = y + cos(lat) * sin(lon)
            z = z + sin(lat)
        }
        
        x = x/CGFloat(listCoords.count)
        y = y/CGFloat(listCoords.count)
        z = z/CGFloat(listCoords.count)
        
        let resultLon: CGFloat = atan2(y, x)
        let resultHyp: CGFloat = sqrt(x*x+y*y)
        let resultLat:CGFloat = atan2(z, resultHyp)
        
        let newLat = radianToDegree(radian: resultLat)
        let newLon = radianToDegree(radian: resultLon)
        let result:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: newLat, longitude: newLon)
        
        return result
        
    }
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc: CLLocation = locations[0]
        let userLocation = loc.coordinate
        location = userLocation
       
        var restCoord = UserDefaults.standard.object(forKey: "commandeHotlineReserveeRestCoordinates") as! Dictionary<String, Double>
      
        
        let restaurantLocation = CLLocationCoordinate2D(latitude: restCoord["lat"]!, longitude: restCoord["long"]!)
        //   let distanceMeters = userLocation.distance(from: mcDoLocation)
        let center = middlePointOfListMarkers(listCoords: [userLocation, restaurantLocation])
        mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
        showRouteOnMap()
    }
}

extension BinaryInteger {
    var numberOfDigits: Int {
        return self != 0 ? Int(log10(abs(Double(self)))) + 1 : 1
    }
}

extension Collection where Element: BinaryInteger {
    var digitsSum: Int { return reduce(0, { $0 + $1.numberOfDigits }) }
    func joined() -> Int? {
        guard digitsSum <= Int.max.numberOfDigits else { return nil }
        //             (total multiplied by 10 powered to number of digits) + value
        return reduce(0) { $0 * Int(pow(10, Double($1.numberOfDigits))) + Int($1) }
    }
}
