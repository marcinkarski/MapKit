import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private lazy var mapView = MKMapView(frame: view.bounds)
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        return manager
    }()
    
    var annotations: [Annotation] = []
    
    fileprivate func loadInitialData() {
        guard let jsonFile = Bundle.main.path(forResource: "Locations", ofType: "json") else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: jsonFile))
        guard let data = optionalData,
            let json = try? JSONSerialization.jsonObject(with: data),
            let dictionary = json as? [String: Any],
            let places = dictionary["places"] as? [[Any]] else { return }
        let validPlaces = places.compactMap { Annotation(json: $0) }
        annotations.append(contentsOf: validPlaces)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialData()
        mapView.addAnnotations(annotations)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkLocationServices()
    }
    
    fileprivate func configureMapView() {
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        mapView.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        view.addSubview(mapView)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    fileprivate func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 400, longitudinalMeters: 400)
            mapView.setRegion(region, animated: true)
        }
    }
    
    fileprivate func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            requestLocationAccess()
        } else {
            print("Show alert")
        }
    }
    
    fileprivate func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            centerViewOnUserLocation()
        case .denied:
            print("I can't show location. User has not authorized it")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Access denied - likely parental controls are restricting use in this app.")
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? { guard annotation is Annotation else { return nil }
//        let identifier = "marker"
//        var view: MKMarkerAnnotationView
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//            as? MKMarkerAnnotationView {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//        }
//        return view
//    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        requestLocationAccess()
    }
}
