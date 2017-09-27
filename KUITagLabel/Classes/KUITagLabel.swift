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
    var accessibilityElement: KUITagAccessibilityElement?
    
    public init(title: String,
                userInfo: [NSObject: AnyObject]? = nil,
                config: KUITagConfig,
                accessibilityElement: KUITagAccessibilityElement? = nil) {
        self.title = title
        self.userInfo = userInfo
        self.config = config
        self.accessibilityElement = accessibilityElement
    }
}

public struct KUITagAccessibilityElement {
    public var title: String
    public var traits: UIAccessibilityTraits
    
    public init(title: String,
                traits: UIAccessibilityTraits = UIAccessibilityTraitButton) {
        self.title = title
        self.traits = traits
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
    
    public init(insets: UIEdgeInsets = UIEdgeInsets.zero,
                titleColor: UIColor,
                titleFont: UIFont,
                titleInsets: UIEdgeInsets = UIEdgeInsets.zero,
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

open class KUITagLabel: UILabel {
    
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
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        setupAccessibility()
    }
    
    // MARK: - Public
    open func add(tag: KUITag) {
        tags.append(tag)
        refreshIfNeeded()
    }
    
    open func remove(tag: KUITag) {
        guard let index = tags.index(of: tag) else { return }
        remove(at: index)
    }
    
    open func remove(at index: Int) {
        tags.remove(at: index)
        refreshIfNeeded()
    }
    
    open func removeAll() {
        tags.removeAll()
        refreshIfNeeded()
    }
    
    open func refresh() {
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
                attr.append(NSAttributedString(attachment: attachment))
            }
        }
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpace
        attr.addAttributes([NSAttributedStringKey.paragraphStyle: style], range: NSMakeRange(0, attr.length))
        attributedText = attr
    }
    
    // MARK: - Private
    fileprivate func setup() {
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = true
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        textAlignment = .left
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        addGestureRecognizer(singleTap)
    }
    
    fileprivate func refreshIfNeeded() {
        guard autoRefresh else { return }
        refresh()
    }
    
    fileprivate func generateContext() -> (NSTextContainer, NSLayoutManager, NSTextStorage)? {
        guard let attr = attributedText, attr.length > 0 else { return nil }
        
        let container = NSTextContainer(size: frame.size)
        container.lineFragmentPadding = 0;
        container.lineBreakMode = lineBreakMode
        container.maximumNumberOfLines = numberOfLines
        
        let manager = NSLayoutManager()
        manager.addTextContainer(container)
        
        let storage = NSTextStorage(attributedString: attr)
        storage.addLayoutManager(manager)
        
        return (container, manager, storage)
    }
    
    fileprivate func setupAccessibility() {
        guard let attr = attributedText, attr.length > 0 && !tags.isEmpty else { return }
        guard let context = generateContext() else { return }
        
        let container = context.0
        let manager = context.1
        
        var elements = [UIAccessibilityElement]()
        attr.enumerateAttributes(in: NSRange(location: 0, length: attr.length), options: []) { (attribute, range, stop) in
            guard let _ = attribute[NSAttributedStringKey.attachment] as? NSTextAttachment else { return }
            let boundingRect = manager.boundingRect(forGlyphRange: range, in: container)
            let boundingRectInWindowCoordinates = convert(boundingRect, to: nil)
            var boundingRectInScreenCoordinates = window?.convert(boundingRectInWindowCoordinates, to: nil) ?? boundingRectInWindowCoordinates
            let tag = tags[range.location]
            let insets = tag.config.insets
            
            // fix bounding rect
            boundingRectInScreenCoordinates.origin.x -= insets.left
            boundingRectInScreenCoordinates.size.width -= insets.right
            boundingRectInScreenCoordinates.origin.y -= insets.top
            boundingRectInScreenCoordinates.size.height -= (insets.bottom + lineSpace)
            
            let element = UIAccessibilityElement(accessibilityContainer: self)
            element.accessibilityFrame = boundingRectInScreenCoordinates
            element.accessibilityLabel = tag.accessibilityElement?.title ?? tag.title
            element.accessibilityTraits = tag.accessibilityElement?.traits ?? UIAccessibilityTraitButton
            elements.append(element)
        }
        
        isAccessibilityElement = false
        accessibilityElements = elements
    }
    
    fileprivate func characterIndex(location: CGPoint) -> Int? {
        guard let context = generateContext() else { return nil }
        
        let container = context.0
        let manager = context.1
        
        let glyphRange = manager.glyphRange(for: container)
        let textBounds = manager.boundingRect(forGlyphRange: glyphRange, in: container)
        let paddingHeight = (bounds.size.height - textBounds.size.height) / 2.0
        var textOffset = CGPoint.zero
        
        if paddingHeight > 0.0 {
            textOffset.y = paddingHeight
        }
        
        // // Get the touch location and use text offset to convert to text cotainer coords
        var newLocation = location
        newLocation.x -= textOffset.x
        newLocation.y -= textOffset.y
        
        var lineRange = NSRange()
        let glyphIndex = manager.glyphIndex(for: newLocation, in: container)
        var lineRect = manager.lineFragmentUsedRect(forGlyphAt: glyphIndex, effectiveRange: &lineRange)
        
        //Adjustment to increase tap area
        lineRect.size.height = 60.0
        
        guard lineRect.contains(newLocation) else { return nil }
        return manager.characterIndexForGlyph(at: glyphIndex)
    }
    
    // MARK: - Actions
    @objc func singleTap(_ gesture: UITapGestureRecognizer) {
        guard let characterIndex = characterIndex(location: gesture.location(in: self)) else {
            onTouchEmptySpaceHandler?()
            return
        }
        
        onSelectedHandler?(tags[characterIndex])
    }
}
