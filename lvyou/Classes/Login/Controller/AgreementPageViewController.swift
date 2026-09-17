//
//  AgreementPageViewController.swift
//  协议 / 政策 H5 页面（Swift 重写，替代原 OC 版）。
//
//  只迁移功能：WKWebView 载入 self.url（追加 &from=ios）、加载中显示 HUD、
//  处理网页里的 JS alert/confirm/prompt 弹框。用 Auto Layout 取代原来的
//  SCREEN_WIDTH/NavigationBar_HEIGHT 魔法数字。
//
//  仍以 @objc(AgreementPageViewController) 暴露原类名，OC 侧（LoginEntryViewController）
//  的 [[AgreementPageViewController alloc] init] + .url 用法保持不变。
//

import UIKit
import WebKit
import MBProgressHUD

@objc(AgreementPageViewController)
final class AgreementPageViewController: UIViewController {

    /// 由 OC / Swift 调用方设置的目标地址
    @objc var url: String?

    private lazy var webView: WKWebView = {
        let wv = WKWebView(frame: .zero)
        wv.allowsBackForwardNavigationGestures = true
        wv.translatesAutoresizingMaskIntoConstraints = false
        return wv
    }()

    private var hud: MBProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupWebView()
        loadContent()
    }

    private func setupWebView() {
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func loadContent() {
        guard let url = url,
              let target = URL(string: "\(url)&from=ios") else { return }
        webView.load(URLRequest(url: target))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.navigationDelegate = nil
        webView.uiDelegate = nil
    }
}

// MARK: - WKNavigationDelegate（加载中/完成/失败的 HUD）

extension AgreementPageViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
        hud.color = UIColor.black.withAlphaComponent(0.5)
        hud.label.text = "加载中"
        self.hud = hud
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hud?.hide(animated: true, afterDelay: 1.0)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if let hud = hud {
            hud.mode = .text
            hud.label.text = NSLocalizedString("加载失败", comment: "")
            hud.hide(animated: true, afterDelay: 1.5)
        }
    }
}

// MARK: - WKUIDelegate（网页 JS 弹框转原生 UIAlertController）

extension AgreementPageViewController: WKUIDelegate {

    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确认", style: .default) { _ in completionHandler() })
        present(alert, animated: true)
    }

    func webView(_ webView: WKWebView,
                 runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel) { _ in completionHandler(false) })
        alert.addAction(UIAlertAction(title: "确认", style: .default) { _ in completionHandler(true) })
        present(alert, animated: true)
    }

    func webView(_ webView: WKWebView,
                 runJavaScriptTextInputPanelWithPrompt prompt: String,
                 defaultText: String?,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: prompt, message: "", preferredStyle: .alert)
        alert.addTextField { $0.text = defaultText }
        alert.addAction(UIAlertAction(title: "完成", style: .default) { _ in
            completionHandler(alert.textFields?.first?.text ?? "")
        })
        present(alert, animated: true)
    }
}
