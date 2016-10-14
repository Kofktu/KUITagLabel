//
//  KUITagView.swift
//  KUITagListView
//
//  Created by Kofktu on 2016. 9. 21..
//  Copyright © 2016년 Kofktu. All rights reserved.
//

import UIKit

public class KUITagView: UIView {
    
    private lazy var contentView: UIView = {
        let contentView = UIView(frame: self.bounds)
        contentView.clipsToBounds = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: self.bounds)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.userInteractionEnabled = false
        label.backgroundColor = UIColor.clearColor()
        return label
    }()
    
    private lazy var backgroundImgView: UIImageView = {
        let imgView = UIImageView(frame: self.bounds)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = UIColor.clearColor()
        return imgView
    }()
    
    // MARK: - Public
    public func configure(tag: KUITag) {
        backgroundColor = UIColor.clearColor()
        
        backgroundImgView.removeFromSuperview()
        label.removeFromSuperview()
        contentView.removeFromSuperview()
        
        contentView.backgroundColor = tag.config.backgroundColor ?? UIColor.whiteColor()
        contentView.layer.cornerRadius = tag.config.cornerRadius
        contentView.layer.borderColor = tag.config.borderColor?.CGColor
        contentView.layer.borderWidth = tag.config.borderWidth
        addSubview(contentView)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(tag.config.insets.left)-[view]-\(tag.config.insets.right)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": contentView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(tag.config.insets.top)-[view]-\(tag.config.insets.bottom)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": contentView]))
        
        if let backgroundImage = tag.config.backgroundImage {
            backgroundImgView.image = backgroundImage
            contentView.addSubview(backgroundImgView)
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[view]-0-|",
                options: .DirectionLeadingToTrailing,
                metrics: nil,
                views: ["view": backgroundImgView]))
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[view]-0-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: ["view": backgroundImgView]))
        }
        
        contentView.addSubview(label)
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-\(tag.config.titleInsets.left)-[label]-\(tag.config.titleInsets.right)-|",
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: ["label": label]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-\(tag.config.titleInsets.top)-[label]-\(tag.config.titleInsets.bottom)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["label": label]))
        
        if let style = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as? NSMutableParagraphStyle {
            style.alignment = .Center
            
            let attr = NSAttributedString(string: tag.title,
                                          attributes: [NSParagraphStyleAttributeName: style, NSFontAttributeName: tag.config.titleFont, NSForegroundColorAttributeName: tag.config.titleColor])
            label.attributedText = attr
        } else {
            label.attributedText = nil
        }
    }
    
    public func fittingSize() -> CGSize {
        return systemLayoutSizeFittingSize(CGSizeMake(CGFloat.max, CGFloat.max),
                                           withHorizontalFittingPriority: UILayoutPriorityFittingSizeLevel,
                                           verticalFittingPriority: UILayoutPriorityFittingSizeLevel)
    }
    
    public func image() -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }
        layer.renderInContext(contextRef)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
