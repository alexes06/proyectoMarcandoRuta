//
//  ViewController.swift
//  proyectoMarcandoRuta
//
//  Created by web on 02/12/16.
//  Copyright © 2016 Cinco Radio. All rights reserved.
//

import UIKit
// incluyendo framework para implementar los mapas
import MapKit
// incluyendo framework para implementar ubicación
import CoreLocation

// implementacion de protocolos: location manager delegate
class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var latitudInicial = 0.0
    var longitudInicial = 0.0
    
    // outlet de nuesta vista de mapa:
    @IBOutlet weak var mapa: MKMapView!
    
    // nuestro manejador para la ubicación
    private let manejador = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // delegación del manejador (en este caso es nuesta misma vista)
        manejador.delegate = self
        // exactitud de la ubicacion
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        // solicitud de permiso
        manejador.requestWhenInUseAuthorization()
        
    }
    
    // funcion para solicitar permiso de ubicación al usuario
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
            
            // para inicializar el mapa en la ubicacion actual del usuario:
            let ubicacionActual = mapa.userLocation
            
            latitudInicial = ubicacionActual.coordinate.latitude
            longitudInicial = ubicacionActual.coordinate.longitude
            
            let span = MKCoordinateSpanMake(0.005, 0.005)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitudInicial, longitude: longitudInicial), span: span)
            mapa.setRegion(region, animated: true)
            
        } else {
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    // metodo que recibe las lecturas de la ubicacion
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let latitud = manager.location!.coordinate.latitude
        let longitud = manager.location!.coordinate.longitude
        
        var puntoRuta = CLLocationCoordinate2D()
        puntoRuta.latitude = latitud
        puntoRuta.longitude = longitud
        
        let pin = MKPointAnnotation()
        pin.title = "\(latitud)"
        pin.subtitle = "\(longitud)"
        pin.coordinate = puntoRuta
        
        // para ir centrando la vista en el punto actual recorrido por el usuario
        mapa.setCenterCoordinate(puntoRuta, animated: true)
        
        mapa.addAnnotation(pin)
        
    }

}

