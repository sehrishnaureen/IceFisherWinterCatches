import UIKit
import WebKit

final class RemoteContentController: UIViewController, WKNavigationDelegate {
    private var contentView: WKWebView!
    private var loadingIndicator: UIActivityIndicatorView!
    private var loadingBackground: UIView!
    private var isInitialLoad = true
    private let targetAddress: String
    
    override var prefersStatusBarHidden: Bool { true }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .all }
    
    override var shouldAutorotate: Bool { true }
    
    init(address: String) {
        self.targetAddress = address
        super.init(nibName: nil, bundle: nil)
        AppDelegate.orientationLock = .all
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        setupContentView()
        loadContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.orientationLock = .all
        setNeedsUpdateOfSupportedInterfaceOrientations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.orientationLock = .all
        guard let windowScene = view.window?.windowScene else { return }
        let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .all)
        windowScene.requestGeometryUpdate(geometryPreferences) { _ in }
        setNeedsUpdateOfSupportedInterfaceOrientations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.orientationLock = .portrait
        guard let windowScene = view.window?.windowScene else { return }
        let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .portrait)
        windowScene.requestGeometryUpdate(geometryPreferences) { _ in }
        setNeedsUpdateOfSupportedInterfaceOrientations()
    }
    
    private func setupLoadingView() {
        loadingBackground = UIView()
        loadingBackground.backgroundColor = .black
        loadingBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingBackground)
        
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .white
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.startAnimating()
        loadingBackground.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingBackground.topAnchor.constraint(equalTo: view.topAnchor),
            loadingBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: loadingBackground.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingBackground.centerYAnchor)
        ])
    }
    
    private func setupContentView() {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .nonPersistent()
        
        contentView = WKWebView(frame: .zero, configuration: config)
        contentView.navigationDelegate = self
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.scrollView.contentInsetAdjustmentBehavior = .never
        contentView.allowsBackForwardNavigationGestures = true
        contentView.isOpaque = false
        contentView.backgroundColor = .black
        contentView.scrollView.backgroundColor = .black
        
        view.insertSubview(contentView, belowSubview: loadingBackground)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadContent() {
        guard let destination = Foundation.URL(string: targetAddress) else { return }
        var request = URLRequest(url: destination)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.addValue("no-cache", forHTTPHeaderField: "Pragma")
        contentView.load(request)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if isInitialLoad {
            isInitialLoad = false
            UIView.animate(withDuration: 0.3) {
                self.loadingBackground.alpha = 0
            } completion: { _ in
                self.loadingBackground.isHidden = true
                self.loadingIndicator.stopAnimating()
            }
        }
    }
}
