import UIKit
import MapKit

class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureView()
    }
    
    fileprivate func configureView() {
        
        let mapView: MKMapView = {
            let mapView = MKMapView(frame: UIScreen.main.bounds)
            
            mapView.delegate = self
            return mapView
        }()
        
        view.addSubview(mapView)
    }
}

extension MapViewController: MKMapViewDelegate {
    
}
