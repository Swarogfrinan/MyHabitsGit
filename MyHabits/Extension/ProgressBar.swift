import UIKit

class ProgressBar : UIProgressView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: 4.0)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskLayerPath.cgPath
        self.transform = CGAffineTransformScale(self.transform, 1, 2)
        layer.mask = maskLayer
       
    }
}
