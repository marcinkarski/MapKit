import MapKit

final class Annotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var type: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, type: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.type = type
        
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
        self.type = json[4] as? String ?? "No type"
    }
    
    var markerTintColour: UIColor {
        switch type {
        case "Eat":
            return .red
        case "See":
            return .cyan
        case "Shop":
            return .blue
        default:
            return .orange
        }
    }
}
