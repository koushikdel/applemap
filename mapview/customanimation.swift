//
//  customanimation.swift
//  mapview
//
//  Created by Koushik Das Sharma on 20/03/21.
//  Copyright © 2021 Koushik Das Sharma. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {

    private let boxInset = CGFloat(15)
    private let interItemSpacing = CGFloat(2)
    private let maxContentWidth = CGFloat(80)
    private let contentInsets = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 20)
    
    private let blurEffect = UIBlurEffect(style: .systemMaterialLight)
    
    private lazy var backgroundMaterial: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: blurEffect)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelVibrancyView, imageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.clipsToBounds = true
        stackView.spacing = interItemSpacing
        
        return stackView
    }()
    
    private lazy var labelVibrancyView: UIView = {
        
        let vibrancyView = UIView()
        vibrancyView.clipsToBounds = true
        vibrancyView.backgroundColor = UIColor.clear
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.addSubview(self.label)
        
        return vibrancyView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.clipsToBounds = true
        label.backgroundColor = UIColor.white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.preferredMaxLayoutWidth = maxContentWidth
        
        return label
    }()
    //private lazy var labelVibrancyView1: UIView = {
        
//        let vibrancyView1 = UIView()
//        vibrancyView1.backgroundColor = UIColor.white
//        vibrancyView1.translatesAutoresizingMaskIntoConstraints = false
//        vibrancyView1.addSubview(self.imageView)
//
//        return vibrancyView1
//    }()
        
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.layer.frame.height / 2
        return imageView
    }()
    
    private var imageHeightConstraint: NSLayoutConstraint?
    private var labelHeightConstraint: NSLayoutConstraint?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        addSubview(backgroundMaterial)
        
        backgroundMaterial.contentView.addSubview(stackView)
        
        // Make the background material the size of the annotation view container
        backgroundMaterial.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundMaterial.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundMaterial.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundMaterial.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        // Anchor the top and leading edge of the stack view to let it grow to the content size.
        stackView.leadingAnchor.constraint(equalTo: backgroundMaterial.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: backgroundMaterial.trailingAnchor, constant: 10).isActive = true
        stackView.topAnchor.constraint(equalTo: backgroundMaterial.topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: backgroundMaterial.bottomAnchor, constant: 10).isActive = true
        
        label.leadingAnchor.constraint(equalTo: labelVibrancyView.leadingAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: labelVibrancyView.trailingAnchor, constant: 0).isActive = true
        label.topAnchor.constraint(equalTo: labelVibrancyView.topAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: labelVibrancyView.bottomAnchor, constant: 0).isActive = true
        // Limit how much the content is allowed to grow.
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        labelVibrancyView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        labelVibrancyView.widthAnchor.constraint(equalToConstant: maxContentWidth).isActive = true
       labelVibrancyView.heightAnchor.constraint(equalTo: label.heightAnchor , constant:  15).isActive = true
        labelVibrancyView.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        labelVibrancyView.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.text = nil
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        /*
         If using the same annotation view and reuse identifier for multiple annotations, iOS will reuse this view by calling `prepareForReuse()`
         so the view can be put into a known default state, and `prepareForDisplay()` right before the annotation view is displayed. This method is
         the view's oppurtunity to update itself to display content for the new annotation.
         */
        if let annotation = annotation as? CustomAnnotation {
            label.text = annotation.title
            label.layer.cornerRadius = label.layer.frame.height / 2
            if let imageName = annotation.imageName, let image = UIImage(named: imageName) {
                imageView.image = image
                
                /*
                 The image view has a width constraint to keep the image to a reasonable size. A height constraint to keep the aspect ratio
                 proportions of the image is required to keep the image packed into the stack view. Without this constraint, the image's height
                 will remain the intrinsic size of the image, resulting in extra height in the stack view that is not desired.
                 */
                
                if let heightConstraint = imageHeightConstraint {
                    imageView.removeConstraint(heightConstraint)
                }
                
                let ratio = image.size.height / image.size.width
                imageHeightConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: ratio, constant: 0)
                imageHeightConstraint?.isActive = true
                
            }
        }
        
        // Since the image and text sizes may have changed, require the system do a layout pass to update the size of the subviews.
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // The stack view will not have a size until a `layoutSubviews()` pass is completed. As this view's overall size is the size
        // of the stack view plus a border area, the layout system needs to know that this layout pass has invalidated this view's
        // `intrinsicContentSize`.
        invalidateIntrinsicContentSize()
        
        // Use the intrinsic content size to inform the size of the annotation view with all of the subviews.
        let contentSize = intrinsicContentSize
        frame.size = intrinsicContentSize
        imageView.layer.cornerRadius = imageView.layer.frame.height / 2
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 2
        // The annotation view's center is at the annotation's coordinate. For this annotation view, offset the center so that the
        // drawn arrow point is the annotation's coordinate.
        centerOffset = CGPoint(x: contentSize.width / 2, y: contentSize.height / 2)
        
        let shape = CAShapeLayer()
        let path = CGMutablePath()

        // Draw the pointed shape.
        let pointShape = UIBezierPath()
        pointShape.move(to: CGPoint(x: boxInset, y: 0))
        pointShape.addLine(to: CGPoint.zero)
        pointShape.addLine(to: CGPoint(x: boxInset, y: boxInset))
        path.addPath(pointShape.cgPath)

        // Draw the rounded box.
        let box = CGRect(x: boxInset, y: 0, width: self.frame.size.width - boxInset, height: self.frame.size.height)
        let roundedRect = UIBezierPath(roundedRect: box,
                                       byRoundingCorners: [.topRight, .bottomLeft, .bottomRight],
                                       cornerRadii: CGSize(width: 5, height: 5))
        path.addPath(roundedRect.cgPath)

        shape.path = path
        backgroundMaterial.layer.mask = shape
    }
    
    override var intrinsicContentSize: CGSize {
        var size = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width += contentInsets.left + contentInsets.right
        size.height += contentInsets.top + contentInsets.bottom
        return size
    }
}
