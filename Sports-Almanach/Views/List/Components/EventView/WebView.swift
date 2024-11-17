//
//  WebView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 29.10.24.
//

import SwiftUI
import WebKit

/// Für das Anzeigen von Webseiten oder Youtube-Videos
struct WebView: UIViewRepresentable {
    let url: URL
    
    // Erstellt WKWebView-Instanz und lädt URL
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    // Lädt übergebenes URL in die WebView
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
