//
//  KUITagListView.swift
//  KUITagListView
//
//  Created by Kofktu on 2016. 9. 21..
//  Copyright © 2016년 Kofktu. All rights reserved.
//

import UIKit

public func == (lhs: KUITag, rhs: KUITag) -> Bool {
    return lhs.title == rhs.title
}

public struct KUITag: Equatable {
    
    public var title: String
    public var userInfo: [NSObject: AnyObject]?
    var config: KUITagConfig
    
    public init(title: String,
                userInfo: [NSObject: AnyObject]? = nil,
                config: KUITagConfig) {
        self.title = title
        self.userInfo = userInfo
        self.config = config
    }
}

public struct KUITagConfig {
    // common
    var insets: UIEdgeInsets
    
    // title
    var titleColor: UIColor
    var titleFont: UIFont
    var titleInsets: UIEdgeInsets
    
    // background
    var backgroundColor: UIColor?
    var cornerRadius: CGFloat
    var borderWidth: CGFloat
    var borderColor: UIColor?
    var backgroundImage: UIImage?
    
    public init(insets: UIEdgeInsets = UIEdgeInsetsZero,
                titleColor: UIColor,
                titleFont: UIFont,
                titleInsets: UIEdgeInsets = UIEdgeInsetsZero,
                backgroundColor: UIColor? = nil,
                cornerRadius: CGFloat = 0.0,
                borderWidth: CGFloat = 0.0,
                borderColor: UIColor? = nil,
                backgroundImage: UIImage? = nil) {
        self.insets = insets
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.titleInsets = titleInsets
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.backgroundImage = backgroundImage
    }
}

public class KUITagListView: UIView {

    public var autoRefresh = false
    public var lineSpacing: CGFloat = 3.0
    public var onSelectedHandler: ((KUITag) -> Void)?
    
    private(set) var tags = [KUITag]()
    private lazy var tagLabel: UILabel = {
        let label = UILabel(frame: self.bounds)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.textAlignment = .Left
        label.backgroundColor = UIColor.clearColor()
        label.userInteractionEnabled = false
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Public
    public func add(tag: KUITag) {
        tags.append(tag)
        refreshIfNeeded()
    }
    
    public func remove(tag: KUITag) {
        guard let index = tags.indexOf(tag) else { return }
        remove(at: index)
    }
    
    public func remove(at index: Int) {
        tags.removeAtIndex(index)
        refreshIfNeeded()
    }
    
    public func refresh() {
        let attr = NSMutableAttributedString()
        let cell = UITableViewCell()
        
        for tag in tags {
            let view = KUITagView()
            view.configure(tag)
            
            cell.contentView.addSubview(view)
            cell.contentView.setNeedsLayout()
            cell.contentView.layoutIfNeeded()
            
            let size = view.fittingSize()
            view.frame = CGRect(x: tag.config.insets.left,
                                y: tag.config.insets.top,
                                width: size.width + (tag.config.insets.left + tag.config.insets.right),
                                height: size.height + (tag.config.insets.top + tag.config.insets.bottom))
            
            if let image = view.image() {
                let attachment = NSTextAttachment()
                attachment.image = image
                attr.appendAttributedString(NSAttributedString(attachment: attachment))
            }
            
            view.removeFromSuperview()
        }
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        attr.addAttributes([NSParagraphStyleAttributeName: style], range: NSMakeRange(0, attr.length))
        tagLabel.attributedText = attr
    }
    
    // MARK: - Private
    private func setup() {
        userInteractionEnabled = true
        
        addSubview(tagLabel)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[label]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["label": tagLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[label]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["label": tagLabel]))
        
        tagLabel.layer.borderWidth = 1.0
        tagLabel.layer.borderColor = UIColor.blueColor().CGColor
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        addGestureRecognizer(singleTap)
    }
    
    private func refreshIfNeeded() {
        guard autoRefresh else { return }
        refresh()
    }
    
    // MARK: - Actions
    func singleTap(gesture: UITapGestureRecognizer) {
        guard let attr = tagLabel.attributedText else { return }
        let container = NSTextContainer(size: tagLabel.frame.size)
        container.lineFragmentPadding = 0.0
        container.lineBreakMode = tagLabel.lineBreakMode
        container.maximumNumberOfLines = tagLabel.numberOfLines
        
        let manager = NSLayoutManager()
        manager.addTextContainer(container)
        
        let storage = NSTextStorage(attributedString: attr)
        storage.addLayoutManager(manager)
        
        let location = gesture.locationInView(self)
        let index = manager.characterIndexForPoint(location,
                                                   inTextContainer: container,
                                                   fractionOfDistanceBetweenInsertionPoints: nil)
        
        guard index > 0 && index < storage.length else { return }
        
        let glyphRange = manager.glyphRangeForCharacterRange(NSMakeRange(index, 1), actualCharacterRange: nil)
        let boundingRect = manager.boundingRectForGlyphRange(glyphRange, inTextContainer: container)
        
        guard CGRectContainsPoint(boundingRect, location) else { return }
        
        let selectedTag = tags[index]
        onSelectedHandler?(selectedTag)
    }
}
