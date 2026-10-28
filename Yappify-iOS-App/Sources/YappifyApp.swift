import SwiftUI
import WebKit

@main
struct YappifyApp: App {
    var body: some Scene { WindowGroup { ClientView() } }
}

struct ClientView: View {
    @StateObject private var browser = ClientBrowser()
    @State private var about = false
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Yapper with Yappify").font(.headline)
                Spacer()
                Button { browser.openSettings() } label: { Image(systemName: "slider.horizontal.3") }
                    .accessibilityLabel("Yappify settings").frame(minWidth: 44, minHeight: 44)
                Button { about = true } label: { Image(systemName: "info.circle") }
                    .accessibilityLabel("About and updates").frame(minWidth: 44, minHeight: 44)
            }.padding(.horizontal)
            Text("Unofficial · Not affiliated with Yapper").font(.caption2).foregroundStyle(.secondary)
            if let error = browser.error {
                VStack { Text(error); Button("Retry") { browser.load() } }.padding()
            }
            ClientWebView(browser: browser)
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $about) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Yappify for iPhone").font(.title2.bold())
                Text("Unofficial client. Sign in directly through Yapper. This app does not collect or log your password. Your login session is stored by WebKit on this device.")
                Text("This is an untested development build. Desktop-only plugins are omitted. Cloud badge enrolment and theme submissions are disabled in this iOS preview.")
                Text("For sideloaded builds, download the new Yappify IPA and re-sign it with your own Apple ID. Desktop ZIPs cannot update this app. TestFlight automatic updates apply only if the app is later distributed through TestFlight.")
                Button("Reload Yapper") { browser.load(); about = false }
                Button("Close") { about = false }
            }.padding().presentationDetents([.medium, .large])
        }
    }
}

@MainActor
final class ClientBrowser: ObservableObject {
    @Published var error: String?
    weak var view: WKWebView?
    func load() {
        error = nil
        view?.load(URLRequest(url: URL(string: "https://www.yapper.website/")!))
    }
    func openSettings() {
        view?.evaluateJavaScript("document.dispatchEvent(new KeyboardEvent('keydown',{code:'KeyY',key:'Y',ctrlKey:true,shiftKey:true,bubbles:true}));", completionHandler: nil)
    }
}

struct ClientWebView: UIViewRepresentable {
    @ObservedObject var browser: ClientBrowser
    func makeCoordinator() -> Coordinator { Coordinator(browser) }
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        config.allowsInlineMediaPlayback = true
        // Bundled code only. No password handlers, telemetry bridge or remote plugin loader.
        if let url = Bundle.main.url(forResource: "yappify-ios", withExtension: "js"),
           let source = try? String(contentsOf: url, encoding: .utf8) {
            config.userContentController.addUserScript(WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: true))
        }
        let view = WKWebView(frame: .zero, configuration: config)
        view.navigationDelegate = context.coordinator
        view.uiDelegate = context.coordinator
        view.allowsBackForwardNavigationGestures = true
        view.isOpaque = false
        view.backgroundColor = .black
        browser.view = view
        browser.load()
        return view
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        let browser: ClientBrowser
        init(_ browser: ClientBrowser) { self.browser = browser }
        func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = action.request.url else { decisionHandler(.cancel); return }
            if url.scheme == "https", ["yapper.website", "www.yapper.website"].contains(url.host ?? "") {
                decisionHandler(.allow); return
            }
            // External links leave the app; untrusted origins never receive Yappify injection.
            if action.navigationType == .linkActivated, ["https", "mailto"].contains(url.scheme ?? "") {
                UIApplication.shared.open(url)
            }
            decisionHandler(.cancel)
        }
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            if (error as NSError).code != NSURLErrorCancelled { browser.error = "Could not load Yapper. Check your connection and retry." }
        }
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if let url = action.request.url, url.scheme == "https" { UIApplication.shared.open(url) }
            return nil
        }
    }
}
