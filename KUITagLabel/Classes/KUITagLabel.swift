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
    // content
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

public class KUITagLabel: UILabel {
    
    @IBInspectable public var autoRefresh = false
    @IBInspectable public var lineSpace: CGFloat = 3.0
    public var onSelectedHandler: ((KUITag) -> Void)?
    public var onTouchEmptySpaceHandler: (() -> Void)?
    private(set) public var tags = [KUITag]()
    
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
    
    public func removeAll() {
        tags.removeAll()
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
            view.frame = CGRect(x: 0.0,
                                y: 0.0,
                                width: size.width,
                                height: size.height)
            
            if let image = view.image() {
                let attachment = NSTextAttachment()
                attachment.image = image
                attr.appendAttributedString(NSAttributedString(attachment: attachment))
            }
        }
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpace
        attr.addAttributes([NSParagraphStyleAttributeName: style], range: NSMakeRange(0, attr.length))
        attributedText = attr
    }
    
    // MARK: - Private
    private func setup() {
        backgroundColor = UIColor.clearColor()
        userInteractionEnabled = true
        numberOfLines = 0
        lineBreakMode = .ByWordWrapping
        textAlignment = .Left
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        addGestureRecognizer(singleTap)
    }
    
    private func refreshIfNeeded() {
        guard autoRefresh else { return }
        refresh()
    }
    
    private func characterIndex(location: CGPoint) -> Int? {
        guard let attr = attributedText where attr.length > 0 else { return nil }
        
        let container = NSTextContainer(size: frame.size)
        container.lineFragmentPadding = 0;
        container.lineBreakMode = lineBreakMode
        container.maximumNumberOfLines = numberOfLines
        
        let manager = NSLayoutManager()
        manager.addTextContainer(container)
        
        let storage = NSTextStorage(attributedString: attr)
        storage.addLayoutManager(manager)
        
        let glyphRange = manager.glyphRangeForTextContainer(container)
        let textBounds = manager.boundingRectForGlyphRange(glyphRange, inTextContainer: container)
        let paddingHeight = (CGRectGetHeight(bounds) - CGRectGetHeight(textBounds)) / 2.0
        var textOffset = CGPointZero
        
        if paddingHeight > 0.0 {
            textOffset.y = paddingHeight
        }
        
        // // Get the touch location and use text offset to convert to text cotainer coords
        var newLocation = location
        newLocation.x -= textOffset.x
        newLocation.y -= textOffset.y
        
        var lineRange = NSRange()
        let glyphIndex = manager.glyphIndexForPoint(newLocation, inTextContainer: container)
        var lineRect = manager.lineFragmentUsedRectForGlyphAtIndex(glyphIndex, effectiveRange: &lineRange)
        
        //Adjustment to increase tap area
        lineRect.size.height = 60.0
        
        guard CGRectContainsPoint(lineRect, newLocation) else { return nil }
        return manager.characterIndexForGlyphAtIndex(glyphIndex)
    }
    
    // MARK: - Actions
    func singleTap(gesture: UITapGestureRecognizer) {
        guard let characterIndex = characterIndex(gesture.locationInView(self)) else {
            onTouchEmptySpaceHandler?()
            return
        }
        
        onSelectedHandler?(tags[characterIndex])
    }
}
