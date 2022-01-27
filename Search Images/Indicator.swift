//
//  Indicator.swift
//  Search Images
//
//  Created by Дмитрий Балантаев on 27.01.2022.
//

import SwiftUI

struct indicator: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
    }
}
