
import Foundation
import UIKit
import AVFoundation

class CustomImageView: UIImageView {
    
    
    
    @IBInspectable var cornerRadius:CGFloat = 0
    @IBInspectable var borderWidth:CGFloat = 0
    @IBInspectable var borderColour:UIColor = UIColor.clear
    @IBInspectable var shadowColour:UIColor = UIColor.clear
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = borderColour.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColour.cgColor;
        self.layer.shadowOffset = CGSize(width: 2, height: 2);
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.1;
        self.clipsToBounds = true
    }
}

class CustomButton: UIButton {
    
    @IBInspectable var cornerRadius:CGFloat = 0
    @IBInspectable var borderWidth:CGFloat = 0
    @IBInspectable var borderColour:UIColor = UIColor.clear
    @IBInspectable var shadowColour:UIColor = UIColor.clear
    @IBInspectable var letterSapcing:CGFloat = 0.5
    @IBInspectable var applyLetterSpacing:Bool = false
    @IBInspectable var addUnderline:Bool = false
    @IBInspectable var isIncreasedHitAreaEnabled:Bool = false
    @IBInspectable var minimumHitArea:CGFloat = 130
    @IBInspectable var numberOfLines:Int = 0
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        if applyLetterSpacing
        {
            if titleLabel?.text?.length == 0 || titleLabel?.text == nil
            {
                return
            }
            titleLabel?.numberOfLines = numberOfLines
            
            let attributedString = NSMutableAttributedString(string: (titleLabel?.text!)!)
            
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: (titleLabel?.textColor)!, range: NSRange(location:0,length:(titleLabel?.text?.length)!))
            attributedString.addAttribute(NSAttributedString.Key.font, value: (titleLabel?.font)!, range: NSRange(location:0,length:(titleLabel?.text?.length)!))
            attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSapcing, range: NSRange(location: 0, length: attributedString.length))
            
            if addUnderline
            {
                attributedString.addAttribute(NSAttributedString.Key.underlineStyle,value:NSUnderlineStyle.single.rawValue,range: NSRange(location: 0, length: attributedString.length))
                
            }
            
            
            self.setAttributedTitle(attributedString, for: .normal)
            
        }else if addUnderline {
            
            if titleLabel?.text?.length == 0 || titleLabel?.text == nil
            {
                return
            }
            titleLabel?.numberOfLines = numberOfLines
            
            let attributedString = NSMutableAttributedString(string: (titleLabel?.text!)!)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,value:NSUnderlineStyle.single.rawValue,range: NSRange(location: 0, length: attributedString.length))
            
            
            self.setAttributedTitle(attributedString, for: .normal)
            
        }
    }
    
    func updateTitle(with string:String, textColour:UIColor, font:UIFont)
    {
        let attributedString = NSMutableAttributedString(string:string)
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:textColour, range: NSRange(location:0,length:string.length))
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location:0,length:string.length))
        attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSapcing, range: NSRange(location: 0, length: attributedString.length))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = borderColour.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColour.cgColor;
        self.layer.shadowOffset = CGSize(width: 2, height: 2);
        self.layer.shadowRadius = 4;
        self.layer.shadowOpacity = 0.5;
        titleLabel?.numberOfLines = numberOfLines
        
        self.clipsToBounds = true
        
        
    }
    
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 { return nil }
        
        if isIncreasedHitAreaEnabled {
            
            let buttonSize = self.bounds.size
            let widthToAdd = max(minimumHitArea - buttonSize.width, 0)
            let heightToAdd = max(minimumHitArea - buttonSize.height, 0)
            let largerFrame = self.bounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
            
            
            return (largerFrame.contains(point)) ? self : nil
        }
        return super.hitTest(point, with: event)
    }
    
}

class CustomTextView: UITextView {
    
    @IBInspectable var cornerRadius:CGFloat = 0
    @IBInspectable var borderWidth:CGFloat = 0
    @IBInspectable var borderColour:UIColor = UIColor.clear
    @IBInspectable var letterSapcing:CGFloat = 0.5
    @IBInspectable var lineHeight:CGFloat = 0.01
    @IBInspectable var lineHeightMultiple:CGFloat = 0.8
    @IBInspectable var baseline:CGFloat = -1
    @IBInspectable var applyLineHeight:Bool = false
    @IBInspectable var applyLetterSpacing:Bool = false
    
    
    override open var text:String?
        {
        
        didSet
        {
            applyAttributes()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = borderColour.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    private func applyAttributes()
    {
        if applyLetterSpacing
        {
            let attributedString = NSMutableAttributedString(string: text!)
            
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor ?? .black, range: NSRange(location:0,length:(text?.length)!))
            attributedString.addAttribute(NSAttributedString.Key.font, value: font ?? .systemFont(ofSize: 13), range: NSRange(location:0,length:(text?.length)!))
            attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSapcing, range: NSRange(location: 0, length: attributedString.length))
            
            attributedString.addAttribute(NSAttributedString.Key.baselineOffset,value: baseline, range: NSRange(location: 0, length: attributedString.length))
            
            attributedText = attributedString
            
        }
        
        
        if applyLineHeight
        {
            
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineHeight
            style.lineHeightMultiple = lineHeightMultiple
            style.alignment = textAlignment
            
            if (attributedText?.length)! > 0
            {
                let attributedString = NSMutableAttributedString(attributedString: attributedText!)
                attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
                
                attributedText = attributedString
            }else
            {
                
                let attributedString = NSMutableAttributedString(string: text!)
                
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor ?? .black, range: NSRange(location:0,length:(text?.length)!))
                attributedString.addAttribute(NSAttributedString.Key.font, value: font ?? .systemFont(ofSize: 13), range: NSRange(location:0,length:(text?.length)!))
                attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
                attributedString.addAttribute(NSAttributedString.Key.baselineOffset,value: baseline, range: NSRange(location: 0, length: attributedString.length))
                attributedText = attributedString
                
            }
            
        }
        
    }
}

class CustomTextField: UITextField {
    
    
    @IBInspectable var cornerRadius:CGFloat = 0
    @IBInspectable var borderWidth:CGFloat = 0
    @IBInspectable var borderColour:UIColor = UIColor.clear
    @IBInspectable var shadowColour:UIColor = UIColor.clear
    @IBInspectable var shouldAddPadding:Bool = true
    @IBInspectable var shouldAddRightPadding:Bool = true
    @IBInspectable var leftPadding:CGFloat = 10.0
    @IBInspectable var rightPadding:CGFloat = 10.0
    @IBInspectable var showLeftView:Bool = false
    @IBInspectable var leftImage:UIImage?
    
    private var  imageView = UIImageView()
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    private var padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        if shouldAddPadding
        {
            padding = UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: 5);
        }
        if shouldAddRightPadding
        {
            padding.right =  rightPadding
            
        }
        if showLeftView
        {
            leftViewMode = .always
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = leftImage
            leftView = imageView
            
        }
        
        //SearchScrSearch
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        if showLeftView
        {
            let width =  placeholder?.widthWithConstrainedHeight(self.frame.size.height, font: self.font!)
            var f =  leftView?.frame
            var _xPos =   (self.frame.size.width - width!)/2 - ((f?.size.width)! + 5)
            if _xPos < 5
            {
                _xPos = 5
            }
            f?.origin.x = _xPos
            leftView?.frame = f!
        }
        
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        
        if showLeftView
        {
            var width =  text?.widthWithConstrainedHeight(self.frame.size.height, font: self.font!)
            if width == 0
            {
                width =  placeholder?.widthWithConstrainedHeight(self.frame.size.height, font: self.font!)
            }
            
            var f =  leftView?.frame
            var _xPos =   (self.frame.size.width - width!)/2 - ((f?.size.width)! + 5)
            if _xPos < 5
            {
                _xPos = 5
            }
            f?.origin.x = _xPos
            leftView?.frame = f!
        }
        
        
        return bounds.inset(by: padding)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = borderColour.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColour.cgColor;
        self.layer.shadowOffset = CGSize(width: 2, height: 2);
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.2;
        
        self.clipsToBounds = true
        
    }
    
}
class CustomView: UIView {
    
    
    @IBInspectable var cornerRadius:CGFloat = 0
    @IBInspectable var borderWidth:CGFloat = 0
    @IBInspectable var borderColour:UIColor = UIColor.clear
    @IBInspectable var shadowColour:UIColor = UIColor.clear
    @IBInspectable var shadowOffsetY:CGFloat = 1
    @IBInspectable var shadowOffsetX:CGFloat = 0
    @IBInspectable var shadowOpacity:Float = 1
    @IBInspectable var shadowRadius:CGFloat = 2
    
    
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = borderColour.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColour.cgColor;
        self.layer.shadowOffset = CGSize(width: shadowOffsetX, height: shadowOffsetY)
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.clipsToBounds = true
        
//        self.layer.masksToBounds = false
    }
}

class CustomLabel: UILabel {
    
    
    @IBInspectable var cornerRadius:CGFloat = 0
    @IBInspectable var borderWidth:CGFloat = 0
    @IBInspectable var borderColour:UIColor = UIColor.clear
    @IBInspectable var shadowColour:UIColor = UIColor.clear
    @IBInspectable var shadowOffsetY:CGFloat = 1
    @IBInspectable var shadowOffsetX:CGFloat = 0
    @IBInspectable var shadowOpacity:Float = 1
    @IBInspectable var shadowRadius:CGFloat = 2
    @IBInspectable var letterSapcing:CGFloat = 0.5
    @IBInspectable var lineHeight:CGFloat = 10
    @IBInspectable var lineHeightMultiple:CGFloat = 0.9
    @IBInspectable var baseline:CGFloat = -1
    @IBInspectable var applyLineHeight:Bool = false
    @IBInspectable var applyLetterSpacing:Bool = false
    
    
    
    override var text: String? {
        didSet {
            if text != nil {
                
                applyAttributes()
                
            }
        }
    }
    
    
    
    private func applyAttributes()
    {
        if applyLetterSpacing
        {
            
            
            let attributedString = NSMutableAttributedString(string: text!)
            
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor ?? .black, range: NSRange(location:0,length:(text?.length)!))
            attributedString.addAttribute(NSAttributedString.Key.font, value: font as Any, range: NSRange(location:0,length:(text?.length)!))
            attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSapcing, range: NSRange(location: 0, length: attributedString.length))
            
            attributedString.addAttribute(NSAttributedString.Key.baselineOffset,value: baseline, range: NSRange(location: 0, length: attributedString.length))
            
            attributedText = attributedString
            
        }
        
        
        if applyLineHeight
        {
            
            
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineHeight
            style.lineHeightMultiple = lineHeightMultiple
            style.alignment = textAlignment
            
            if (attributedText?.length)! > 0
            {
                let attributedString = NSMutableAttributedString(attributedString: attributedText!)
                attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
                
                attributedText = attributedString
            }else
            {
                
                let attributedString = NSMutableAttributedString(string: text!)
                
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor ?? .black, range: NSRange(location:0,length:(text?.length)!))
                attributedString.addAttribute(NSAttributedString.Key.font, value: font as Any, range: NSRange(location:0,length:(text?.length)!))
                attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
                attributedString.addAttribute(NSAttributedString.Key.baselineOffset,value: baseline, range: NSRange(location: 0, length: attributedString.length))
                attributedText = attributedString
                
            }
            
        }
        
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        
        applyAttributes()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = borderColour.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColour.cgColor;
        self.layer.shadowOffset = CGSize(width: shadowOffsetX, height: shadowOffsetY)
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.clipsToBounds = true
        
    }
}


class Line: UIView {
    
    
    @IBInspectable var horizontal:Bool = true
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame =  self.frame as CGRect
        if horizontal
        {
            frame.size.height = 0.5
        }else{
            frame.size.width = 0.5
        }
        self.frame  = frame
    }
}



class PlayerDetailsCollectionViewLayout: UICollectionViewLayout {
    
    let numberOfColumns = 8
    
    var itemAttributes = [[UICollectionViewLayoutAttributes]]()
    var itemsSize = [CGSize]()
    var contentSize: CGSize = .zero
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        if collectionView.numberOfSections == 0 {
            return
        }
        
        if itemAttributes.count != collectionView.numberOfSections {
            generateItemAttributes(collectionView: collectionView)
            return
        }
        
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath.section][indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        for section in itemAttributes {
            let filteredArray = section.filter { obj -> Bool in
                return rect.intersects(obj.frame)
            }
            
            attributes.append(contentsOf: filteredArray)
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}

// MARK: - Helpers
extension PlayerDetailsCollectionViewLayout {
    
    func generateItemAttributes(collectionView: UICollectionView) {
        if itemsSize.count != numberOfColumns {
            calculateItemSizes()
        }
        
        var column = 0
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var contentWidth: CGFloat = 0
        
        itemAttributes = []
        
        for section in 0..<collectionView.numberOfSections {
            var sectionAttributes: [UICollectionViewLayoutAttributes] = []
            
            for index in 0..<numberOfColumns {
                let itemSize = itemsSize[index]
                let indexPath = IndexPath(item: index, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral
                
                
                sectionAttributes.append(attributes)
                
                xOffset += itemSize.width
                column += 1
                
                if column == numberOfColumns {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }
                    
                    column = 0
                    xOffset = 0
                    yOffset += itemSize.height
                }
            }
            
            itemAttributes.append(sectionAttributes)
        }
        
        if let attributes = itemAttributes.last?.last {
            contentSize = CGSize(width: contentWidth, height: attributes.frame.maxY)
        }
    }
    
    func calculateItemSizes() {
        itemsSize = []
        
        for index in 0..<numberOfColumns {
            itemsSize.append(sizeForItemWithColumnIndex(index))
        }
    }
    
    func sizeForItemWithColumnIndex(_ columnIndex: Int) -> CGSize {
        var text: NSString
        
        switch columnIndex {
        case 0:
            text = "Sr No."
            break
        case 1:
            text = "     Player Name     "
            break
        case 2:
            text = "    Player Type    "
            break
        case 3:
            text = "        Address       "
            break
        case 4:
            text = "    Contact No    "
            break
        case 5:
            text = "        Email ID          "
            break
        case 6:
            text = "      Age Group         "
            break
        case 7:
            text = "    Status    "
            break
        default:
            text = " Content "
            break
        }
        
        var finalSize : CGSize!
        let sizes = [CGFloat]()
        
//        for player in self.details {
//            let name: CGSize = player.PlayerName.size(withAttributes: [NSAttributedString.Key.font: UIFont.init(name: Constants.APP_REGULAR_FONT, size: 12)!])
//            let Final_Remarkwidth: CGFloat = name.width + 10
//            sizes.append(Final_Remarkwidth)
//            let address: CGSize = player.PlayerAddress.size(withAttributes: [NSAttributedString.Key.font: UIFont.init(name: Constants.APP_REGULAR_FONT, size: 12)!])
//            let addresswidth: CGFloat = address.width + 10
//            sizes.append(addresswidth)
//            let email: CGSize = player.PlayerAddress.size(withAttributes: [NSAttributedString.Key.font: UIFont.init(name: Constants.APP_REGULAR_FONT, size: 12)!])
//            let emailwidth: CGFloat = email.width + 10
//            sizes.append(emailwidth)
//        }
        
        if sizes.count > 0 && columnIndex == 5 {
            
            if let width: CGFloat = sizes.max() {
                finalSize = CGSize(width: width, height: 30)
            }else {
                let size: CGSize = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.init(name: Constants.APP_REGULAR_FONT, size: 12)!])
                let width: CGFloat = size.width + 16
                finalSize = CGSize(width: width, height: 30)
            }
        }else {
            let size: CGSize = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.init(name: Constants.APP_REGULAR_FONT, size: 12)!])
            let width: CGFloat = size.width + 16
            finalSize = CGSize(width: width, height: 30)
        }
        return finalSize
    }
    
}





class PlayerAssessmentCollectionViewLayout: UICollectionViewLayout {
    
    let numberOfColumns = 4
    
    var itemAttributes = [[UICollectionViewLayoutAttributes]]()
    var itemsSize = [CGSize]()
    var contentSize: CGSize = .zero
    var details = [String]()
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        if collectionView.numberOfSections == 0 {
            return
        }
        
        if itemAttributes.count != collectionView.numberOfSections {
            generateItemAttributes(collectionView: collectionView)
            return
        }
        
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath.section][indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        for section in itemAttributes {
            let filteredArray = section.filter { obj -> Bool in
                return rect.intersects(obj.frame)
            }
            
            attributes.append(contentsOf: filteredArray)
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
// MARK: - Helpers
extension PlayerAssessmentCollectionViewLayout {
    
    func generateItemAttributes(collectionView: UICollectionView) {
        if itemsSize.count != numberOfColumns {
            calculateItemSizes()
        }
        
        var column = 0
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var contentWidth: CGFloat = 0
        
        itemAttributes = []
        
        for section in 0..<collectionView.numberOfSections {
            var sectionAttributes: [UICollectionViewLayoutAttributes] = []
            
            for index in 0..<numberOfColumns {
                let itemSize = itemsSize[index]
                let indexPath = IndexPath(item: index, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral
                
                
                sectionAttributes.append(attributes)
                
                xOffset += itemSize.width
                column += 1
                
                if column == numberOfColumns {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }
                    
                    column = 0
                    xOffset = 0
                    yOffset += itemSize.height
                }
            }
            
            itemAttributes.append(sectionAttributes)
        }
        
        if let attributes = itemAttributes.last?.last {
            contentSize = CGSize(width: contentWidth, height: attributes.frame.maxY)
        }
    }
    
    func calculateItemSizes() {
        itemsSize = []
        
        for index in 0..<numberOfColumns {
            itemsSize.append(sizeForItemWithColumnIndex(index))
        }
    }
    
    func sizeForItemWithColumnIndex(_ columnIndex: Int) -> CGSize {
        var text: NSString
        
        switch columnIndex {
        case 0:
            text = "  Sr No.  "
            break
        case 1:
            text = "              Question              "
            break
        case 2:
            text = "  Coach Score  "
            break
        case 3:
            text = "    View Answer    "
            break
            
        default:
            text = " Content "
            break
        }
        
        var finalSize : CGSize!
        var sizes = [CGFloat]()
        let str = "  Coach Score  "
        let s = "    Out Of    "
        for player in self.details {
            let name: CGSize = player.size(withAttributes: [NSAttributedString.Key.font: UIFont.init(name: Constants.APP_REGULAR_FONT, size: 12)!])
            let Final_Remarkwidth: CGFloat = name.width + 100
            sizes.append(Final_Remarkwidth)
            let address: CGSize = str.size(withAttributes: [NSAttributedString.Key.font: UIFont.init(name: Constants.APP_REGULAR_FONT, size: 12)!])
            let addresswidth: CGFloat = address.width + 10
            sizes.append(addresswidth)
            let email: CGSize = s.size(withAttributes: [NSAttributedString.Key.font: UIFont.init(name: Constants.APP_REGULAR_FONT, size: 12)!])
            let emailwidth: CGFloat = email.width + 10
            sizes.append(emailwidth)
        }
        
        if sizes.count > 0 && columnIndex == 5 {
            
            if let width: CGFloat = sizes.max() {
                finalSize = CGSize(width: width, height: 30)
            }else {
                let size: CGSize = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.init(name: Constants.APP_REGULAR_FONT, size: 12)!])
                let width: CGFloat = size.width + 50
                finalSize = CGSize(width: width, height: 30)
            }
        }else {
            let size: CGSize = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.init(name: Constants.APP_REGULAR_FONT, size: 12)!])
            var width: CGFloat
            if text == "              Question              "{
                width  = size.width + 100
            }else if text == "        Key Learning Area       " {
                width  = size.width + 100
            }else{
                width  = size.width + 10
            }
            
            finalSize = CGSize(width: width, height: 30)
        }
        return finalSize
    }
    
}




class QuizCollectionViewLayout: UICollectionViewLayout {
    
    let numberOfColumns = 4
    
    var itemAttributes = [[UICollectionViewLayoutAttributes]]()
    var itemsSize = [CGSize]()
    var contentSize: CGSize = .zero
    var details = [String]()
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        if collectionView.numberOfSections == 0 {
            return
        }
        
        if itemAttributes.count != collectionView.numberOfSections {
            generateItemAttributes(collectionView: collectionView)
            return
        }
        
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath.section][indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        for section in itemAttributes {
            let filteredArray = section.filter { obj -> Bool in
                return rect.intersects(obj.frame)
            }
            
            attributes.append(contentsOf: filteredArray)
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
// MARK: - Helpers
extension QuizCollectionViewLayout {
    
    func generateItemAttributes(collectionView: UICollectionView) {
        if itemsSize.count != numberOfColumns {
            calculateItemSizes()
        }
        
        var column = 0
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var contentWidth: CGFloat = 0
        
        itemAttributes = []
        
        for section in 0..<collectionView.numberOfSections {
            var sectionAttributes: [UICollectionViewLayoutAttributes] = []
            
            for index in 0..<numberOfColumns {
                let itemSize = itemsSize[index]
                let indexPath = IndexPath(item: index, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral
                
                
                sectionAttributes.append(attributes)
                
                xOffset += itemSize.width
                column += 1
                
                if column == numberOfColumns {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }
                    
                    column = 0
                    xOffset = 0
                    yOffset += itemSize.height
                }
            }
            
            itemAttributes.append(sectionAttributes)
        }
        
        if let attributes = itemAttributes.last?.last {
            contentSize = CGSize(width: contentWidth, height: attributes.frame.maxY)
        }
    }
    
    func calculateItemSizes() {
        itemsSize = []
        
        for index in 0..<numberOfColumns {
            itemsSize.append(sizeForItemWithColumnIndex(index))
        }
    }
    
    func sizeForItemWithColumnIndex(_ columnIndex: Int) -> CGSize {
        var text: NSString
        
        switch columnIndex {
        case 0:
            text = "  Sr No.  "
            break
        case 1:
            text = "              Question              "
            break
        case 2:
            text = "  Coach Score  "
            break
        case 3:
            text = "    View Answer    "
            break
            
        default:
            text = " Content "
            break
        }
        
        var finalSize : CGSize!
        var sizes = [CGFloat]()
        let str = "  Coach Score  "
        let s = "    Out Of    "
        for player in self.details {
            let name: CGSize = player.size(withAttributes: [NSAttributedString.Key.font: UIFont.init(name: Constants.APP_REGULAR_FONT, size: 12)!])
            let Final_Remarkwidth: CGFloat = name.width + 100
            sizes.append(Final_Remarkwidth)
            let address: CGSize = str.size(withAttributes: [NSAttributedString.Key.font: UIFont.init(name: Constants.APP_REGULAR_FONT, size: 12)!])
            let addresswidth: CGFloat = address.width + 10
            sizes.append(addresswidth)
            let email: CGSize = s.size(withAttributes: [NSAttributedString.Key.font: UIFont.init(name: Constants.APP_REGULAR_FONT, size: 12)!])
            let emailwidth: CGFloat = email.width + 10
            sizes.append(emailwidth)
        }
        
        if sizes.count > 0 && columnIndex == 5 {
            
            if let width: CGFloat = sizes.max() {
                finalSize = CGSize(width: width, height: 30)
            }else {
                let size: CGSize = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.init(name: Constants.APP_REGULAR_FONT, size: 12)!])
                let width: CGFloat = size.width + 50
                finalSize = CGSize(width: width, height: 30)
            }
        }else {
            let size: CGSize = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.init(name: Constants.APP_REGULAR_FONT, size: 12)!])
            var width: CGFloat
            if text == "              Question              "{
                width  = size.width + 100
            }else if text == "        Key Learning Area       " {
                width  = size.width + 100
            }else{
                width  = size.width + 30
            }
            
            finalSize = CGSize(width: width, height: 30)
        }
        return finalSize
    }
    
}


class BadgeButton: UIButton {

    var badgeLabel = UILabel()

    var badge: String? {
        didSet {
            addbadgetobutton(badge: badge)
        }
    }

    public var badgeBackgroundColor = UIColor.red {
        didSet {
            badgeLabel.backgroundColor = badgeBackgroundColor
        }
    }

    public var badgeTextColor = UIColor.white {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }

    public var badgeFont = UIFont.systemFont(ofSize: 12.0) {
        didSet {
            badgeLabel.font = badgeFont
        }
    }

    public var badgeEdgeInsets: UIEdgeInsets? {
        didSet {
            addbadgetobutton(badge: badge)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        addbadgetobutton(badge: badge)
    }
    
    func addbadgetobutton(badge: String?) {
        badgeLabel.text = badge
        badgeLabel.textColor = badgeTextColor
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.font = badgeFont
        badgeLabel.sizeToFit()
        badgeLabel.textAlignment = .center
        let badgeSize = badgeLabel.frame.size

        let height = max(18, Double(badgeSize.height) + 5.0)
        let width = max(height, Double(badgeSize.width) + 10.0)

        var vertical: Double?, horizontal: Double?
        if let badgeInset = self.badgeEdgeInsets {
            vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
            horizontal = Double(badgeInset.left) - Double(badgeInset.right)

            let x = (Double(bounds.size.width) - 10 + horizontal!)
            let y = -(Double(badgeSize.height) / 2) - 10 + vertical!
            badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        } else {
            let x = self.frame.width - CGFloat((width / 2.0))
            let y = CGFloat(-(height / 2.0))
            badgeLabel.frame = CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height))
        }

        badgeLabel.layer.cornerRadius = badgeLabel.frame.height/2
        badgeLabel.layer.masksToBounds = true
        addSubview(badgeLabel)
        badgeLabel.isHidden = badge != nil ? false : true
    }

}

class CouponView: UIView {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 80
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        self.layer.masksToBounds = true
    }
}

