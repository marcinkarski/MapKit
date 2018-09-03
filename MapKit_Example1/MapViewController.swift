import UIKit
import MapKit

class MapViewController: UIViewController {
    
    lazy var mapView = MKMapView(frame: UIScreen.main.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "MapKit 1.0"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.addSubview(mapView)
        configureView()
    }
    
    fileprivate func configureView() {
        
    }

}

extension MapViewController: MKMapViewDelegate {
    
}
