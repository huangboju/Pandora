//
//  CGView10.swift
//  ZZPhotoHandle
//
//  Created by duzhe on 16/3/1.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class CGView10: UIView {

    var path: String!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0.0, y: self.bounds.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        let url = URL(fileURLWithPath: path) as CFURL
        let pdf = CGPDFDocument(url)
        let page = pdf?.page(at: 1)
        context?.saveGState()
        
//        let pdfTransform = CGPDFPageGetDrawingTransform(page, CGPDFBox.CropBox, self.bounds, 0, true)
//        CGContextConcatCTM(context, pdfTransform)

        context?.drawPDFPage(page!);
        context?.restoreGState()
    }
 
    
    
}
