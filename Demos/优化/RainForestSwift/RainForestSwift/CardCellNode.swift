
import UIKit
import AsyncDisplayKit

class CardCellNode: ASCellNode {
  let animalInfo: RainforestCardInfo
  
  fileprivate let backgroundImageNode: ASImageNode
  fileprivate let animalImageNode: ASNetworkImageNode
  
  fileprivate let animalNameTextNode: ASTextNode
  fileprivate let animalDescriptionTextNode: ASTextNode
  
  fileprivate let gradientNode: GradientNode
  
  init(animalInfo: RainforestCardInfo) {
    self.animalInfo = animalInfo
    
    backgroundImageNode = ASImageNode()
    animalImageNode     = ASNetworkImageNode()
    
    animalNameTextNode        = ASTextNode()
    animalDescriptionTextNode = ASTextNode()
    
    gradientNode = GradientNode()
    
    super.init()
    
    backgroundColor = UIColor.lightGray
    clipsToBounds = true
    
    //Animal Image
    animalImageNode.url = animalInfo.imageURL
    animalImageNode.clipsToBounds = true
    animalImageNode.delegate = self
    animalImageNode.placeholderFadeDuration = 0.15
    animalImageNode.contentMode = .scaleAspectFill
    animalImageNode.shouldRenderProgressImages = true
    
    //Animal Name
    animalNameTextNode.attributedText = NSAttributedString(forTitleText: animalInfo.name)
    animalNameTextNode.placeholderEnabled = true
    animalNameTextNode.placeholderFadeDuration = 0.15
    animalNameTextNode.placeholderColor = UIColor(white: 0.777, alpha: 1.0)
    
    //Animal Description
    animalDescriptionTextNode.attributedText = NSAttributedString(forDescription: animalInfo.animalDescription)
    animalDescriptionTextNode.truncationAttributedText = NSAttributedString(forDescription: "…")
    animalDescriptionTextNode.backgroundColor = UIColor.clear
    animalDescriptionTextNode.placeholderEnabled = true
    animalDescriptionTextNode.placeholderFadeDuration = 0.15
    animalDescriptionTextNode.placeholderColor = UIColor(white: 0.777, alpha: 1.0)
    
    //Background Image
    backgroundImageNode.placeholderFadeDuration = 0.15
    backgroundImageNode.imageModificationBlock = { image in
      let newImage = UIImage.resize(image, newSize: CGSize(width: 100, height: 300)).applyBlur(withRadius: 10, tintColor: UIColor(white: 0.5, alpha: 0.3), saturationDeltaFactor: 1.8, maskImage: nil)
      return (newImage != nil) ? newImage : image
    }
    
    //Gradient Node
    gradientNode.isLayerBacked = true
    gradientNode.isOpaque = false
    
    addSubnode(backgroundImageNode)
    addSubnode(animalImageNode)
    addSubnode(gradientNode)
    
    addSubnode(animalNameTextNode)
    addSubnode(animalDescriptionTextNode)
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let ratio = (constrainedSize.min.height)/constrainedSize.max.width;
    
    let imageRatioSpec = ASRatioLayoutSpec(ratio: ratio, child: animalImageNode)
    let gradientOverlaySpec = ASOverlayLayoutSpec(child: imageRatioSpec, overlay: gradientNode)
    let relativeSpec = ASRelativeLayoutSpec(horizontalPosition: .start, verticalPosition: .end, sizingOption: [], child: animalNameTextNode)
    let nameInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 16, 8, 0), child: relativeSpec)
    
    let nameOverlaySpec = ASOverlayLayoutSpec(child: gradientOverlaySpec, overlay: nameInsetSpec)
    
    let descriptionTextInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(16.0, 28.0, 12.0, 28.0), child: animalDescriptionTextNode)
    
    let verticalStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: [nameOverlaySpec, descriptionTextInsetSpec])

    let backgroundLayoutSpec = ASBackgroundLayoutSpec(child: verticalStackSpec, background: backgroundImageNode)
    
    return backgroundLayoutSpec
  }
}

// MARK: - ASNetworkImageNodeDelegate

extension CardCellNode: ASNetworkImageNodeDelegate {
  func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {
    backgroundImageNode.image = image
  }
}
