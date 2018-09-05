import UIKit
import MapKit

enum BottomViewState {
    case expanded, minimized
}

class MapViewController: UIViewController {
    
    var runningAnimators = [Int: UIViewPropertyAnimator]()
    var progressWhenInterrupted: CGFloat = 0
    
    lazy var width: CGFloat = { return self.view.frame.width - 12}()
    lazy var topFrame: CGRect = { return CGRect(x: 6, y: 400, width: self.width, height: self.view.frame.height) }()
    lazy var bottomFrame: CGRect = { return CGRect(x: 6, y: self.view.frame.height, width: self.width, height: self.view.frame.height) }()
    lazy var totalVerticalDistance: CGFloat = { self.bottomFrame.minY - self.topFrame.minY }()
    
    var viewState: BottomViewState = .minimized
    
    lazy var bottomView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        return view
    }()
    
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
        
        bottomView.frame = bottomFrame

        bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bottomViewTapped)))
        bottomView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(bottomViewPanned)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkLocationServices()
        view.addSubview(bottomView)
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
    
    func animateTransitionIfNeeded(state: BottomViewState, duration: TimeInterval) {
        if runningAnimators.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .minimized:
                    self.bottomView.frame = self.topFrame
                case .expanded:
                    self.bottomView.frame = self.bottomFrame
                }
            }
            
            let identifier = frameAnimator.hash
            frameAnimator.addCompletion { position in
                self.cleanup(animatorWithId: identifier, at: position)
            }
            
            frameAnimator.startAnimation()
            runningAnimators[identifier] = frameAnimator
        }
    }
    
    @objc func bottomViewPanned(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: bottomView)
        let verticalTranslation = viewState == .minimized ? -translation.y : translation.y
        let fraction = (verticalTranslation / totalVerticalDistance) + progressWhenInterrupted
        
        switch gesture.state {
        case .began:
            animateTransitionIfNeeded(state: viewState, duration: 0.5)
            
            runningAnimators.forEach { $1.pauseAnimation() }
            progressWhenInterrupted = runningAnimators.first?.value.fractionComplete ?? 0
        case .changed:
            runningAnimators.forEach { $1.fractionComplete = fraction }
        case .ended:
            let velocity = gesture.velocity(in: bottomView)
            
            switch viewState {
            case .minimized:
                if velocity.y > -500 && fraction < 0.5 {
                    runningAnimators.forEach { $1.isReversed = !$1.isReversed }
                }
            case .expanded:
                if velocity.y < 500 && fraction < 0.5 {
                    runningAnimators.forEach { $1.isReversed = !$1.isReversed }
                }
            }
            
            runningAnimators.forEach { $1.continueAnimation(withTimingParameters: nil, durationFactor: 1) }
        default:
            break
        }
    }
    
    @objc func bottomViewTapped(gesture: UITapGestureRecognizer) {
        let imageController = ModalViewController()
        imageController.modalPresentationStyle = .overCurrentContext
        present(imageController, animated: true, completion: nil)
    }
    
    private func annotationTapped() {
        if runningAnimators.isEmpty {
            animateTransitionIfNeeded(state: viewState, duration: 0.5)
        } else {
            runningAnimators.forEach { $1.isReversed = !$1.isReversed }
        }
    }
    
    func cleanup(animatorWithId identifier: Int, at position: UIViewAnimatingPosition) {
        if position == .end {
            switch self.bottomView.frame {
            case self.bottomFrame:
                self.viewState = .minimized
            case self.topFrame:
                self.viewState = .expanded
            default:
                break
            }
        }
        self.runningAnimators.removeValue(forKey: identifier)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        annotationTapped()
    }
    
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
