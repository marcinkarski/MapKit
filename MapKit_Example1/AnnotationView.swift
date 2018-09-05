import MapKit

class AnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let place = newValue as? Annotation else { return }
            markerTintColor = place.markerTintColour
//            glyphText = String((place.type?.first!)!)
        }
    }
}
