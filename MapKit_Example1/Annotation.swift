import MapKit

final class Annotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        super.init()
    }
    
    init?(json: [Any]) {
        if let latitude = Double(json[0] as! String),
            let longitude = Double(json[1] as! String) {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
        self.title = json[2] as? String ?? "No Title"
        self.subtitle = json[3] as? String ?? "No Subtitle"
    }
}
