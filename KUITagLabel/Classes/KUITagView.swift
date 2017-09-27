//
//  KUITagView.swift
//  KUITagListView
//
//  Created by Kofktu on 2016. 9. 21..
//  Copyright © 2016년 Kofktu. All rights reserved.
//

import UIKit

open class KUITagView: UIView {
    
    fileprivate lazy var contentView: UIView = {
        let contentView = UIView(frame: self.bounds)
        contentView.clipsToBounds = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    fileprivate lazy var label: UILabel = {
        let label = UILabel(frame: self.bounds)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    fileprivate lazy var backgroundImgView: UIImageView = {
        let imgView = UIImageView(frame: self.bounds)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = UIColor.clear
        return imgView
    }()
    
    // MARK: - Public
    open func configure(_ tag: KUITag) {
        backgroundColor = UIColor.clear
        
        backgroundImgView.removeFromSuperview()
        label.removeFromSuperview()
        contentView.removeFromSuperview()
        
        contentView.backgroundColor = tag.config.backgroundColor ?? UIColor.white
        contentView.layer.cornerRadius = tag.config.cornerRadius
        contentView.layer.borderColor = tag.config.borderColor?.cgColor
        contentView.layer.borderWidth = tag.config.borderWidth
        addSubview(contentView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(tag.config.insets.left)-[view]-\(tag.config.insets.right)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": contentView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(tag.config.insets.top)-[view]-\(tag.config.insets.bottom)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": contentView]))
        
        if let backgroundImage = tag.config.backgroundImage {
            backgroundImgView.image = backgroundImage
            contentView.addSubview(backgroundImgView)
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": backgroundImgView]))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": backgroundImgView]))
        }
        
        contentView.addSubview(label)
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(tag.config.titleInsets.left)-[label]-\(tag.config.titleInsets.right)-|", options: .directionLeadingToTrailing, metrics: nil, views: ["label": label]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(tag.config.titleInsets.top)-[label]-\(tag.config.titleInsets.bottom)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["label": label]))
        
        if let style = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle {
            style.alignment = .center
            
            let attr = NSAttributedString(string: tag.title,
                                          attributes: [
                                            NSAttributedStringKey.paragraphStyle: style,
                                            NSAttributedStringKey.font: tag.config.titleFont,
                                            NSAttributedStringKey.foregroundColor: tag.config.titleColor])
            label.attributedText = attr
        } else {
            label.attributedText = nil
        }
    }
    
    open func fittingSize() -> CGSize {
        return systemLayoutSizeFitting(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), withHorizontalFittingPriority: UILayoutPriority.fittingSizeLevel, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
    }
    
    open func image() -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: contextRef)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
