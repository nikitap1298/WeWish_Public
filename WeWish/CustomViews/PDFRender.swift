//
//  PDFRender.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 02.11.23.
//

import SwiftUI

@MainActor func renderPDFFromSwiftUIView(_ view: some View, _ pdfName: String) -> URL {
    
    let renderer = ImageRenderer(content: view)
    
    let url = URL.documentsDirectory.appending(path: pdfName)
    
    renderer.render { size, context in
        var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else { return }
        
        pdf.beginPDFPage(nil)
        
        context(pdf)
        
        pdf.endPDFPage()
        pdf.closePDF()
    }
    
    return url
}
