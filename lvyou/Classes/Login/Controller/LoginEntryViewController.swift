//
//  LoginEntryViewController.swift
//  主登录页（Swift 重写，替代原 OC 版 + xib）。
//
//  功能完整迁移：账号密码登录 / 手机验证码登录（可切换）/ 微信三方登录 /
//  跳注册·忘记密码·隐私条款（均已是 Swift）/ 异地登录提示（isOut）。
//  登录成功的完整落地（建 UserModel、进主 TabBar、刷缓存、连 IM）走
//  LoginBridge.handleLoginSuccess。原 xib 里隐藏且未被触发的「隐私政策概要弹窗」
//  为死代码，已省略。
//
//  ⚠️ 布局为「功能完整 + 合理竖排」的重建（原 xib 506 行含大量约束未逐像素复刻），
//     需真机视觉微调。
//

import UIKit
import AuthenticationServices

@objc(LoginEntryViewController)
final class LoginEntryViewController: UIViewController {

    /// 异地登录/退出后回到登录页时置 YES（OC 的 RootHttpHelper loginout 会设）
    @objc var isOut = false

    private let pink = UIColor(red: 1.0, green: 91.0/255.0, blue: 135.0/255.0, alpha: 1)  // colorHead
    private let underlineGray = UIColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 1)

    // 密码登录
    private let accountField = UITextField()
    private let passwordField = UITextField()
    private var accountRow: UIView!
    private var passwordRow: UIView!
    private let loginButton = UIButton(type: .system)
    private let registerButton = UIButton(type: .system)
    private let forgetButton = UIButton(type: .system)
    private let toggleButton = UIButton(type: .system)   // 验证码登录 / 手机登录 切换

    // 验证码登录
    private let codeView = UIView()
    private let phoneField = UITextField()
    private let codeField = UITextField()
    private let codeButton = UIButton(type: .system)

    // 三方
    private let weixinButton = UIButton(type: .custom)
    // 苹果登录（App Store 4.8：提供微信三方登录时须提供苹果登录）
    private let appleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)

    // 协议勾选（默认不勾选，必须手动勾选才能登录）
    private let agreeCheckbox = UIButton(type: .custom)
    private let termsTextView = UITextView()

    private var isCodeLogin = false
    private var timer: Timer?
    private var second = 60

    deinit { timer?.invalidate() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        buildUI()
        configureFields()
        if isOut { showOtherDeviceAlert() }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - UI

    private func buildUI() {
        let safe = view.safeAreaLayoutGuide

        let titleLabel = UILabel()
        titleLabel.text = "登录"
        titleLabel.textColor = pink
        titleLabel.font = UIFont(name: "PingFangSC-Medium", size: 24) ?? .systemFont(ofSize: 24, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        accountRow = makeFieldRow(field: accountField, placeholder: "请输入账户")
        passwordRow = makeFieldRow(field: passwordField, placeholder: "请输入密码")
        [accountRow!, passwordRow!].forEach { view.addSubview($0) }

        loginButton.setTitle("登录", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 18)
        loginButton.backgroundColor = pink
        loginButton.layer.cornerRadius = 22
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)

        registerButton.setTitle("立即注册", for: .normal)
        registerButton.setTitleColor(pink, for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 14)
        registerButton.addTarget(self, action: #selector(onRegister), for: .touchUpInside)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(registerButton)

        forgetButton.setTitle("忘记密码?", for: .normal)
        forgetButton.setTitleColor(.gray, for: .normal)
        forgetButton.titleLabel?.font = .systemFont(ofSize: 14)
        forgetButton.addTarget(self, action: #selector(onForget), for: .touchUpInside)
        forgetButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(forgetButton)

        toggleButton.setTitle("验证码登录", for: .normal)
        toggleButton.setTitleColor(.gray, for: .normal)
        toggleButton.titleLabel?.font = .systemFont(ofSize: 14)
        toggleButton.addTarget(self, action: #selector(onToggleLoginType), for: .touchUpInside)
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toggleButton)

        buildCodeView(below: passwordRow)

        // 微信三方登录
        weixinButton.setBackgroundImage(UIImage(named: "icon_login_weichat"), for: .normal)
        weixinButton.addTarget(self, action: #selector(onWeChat), for: .touchUpInside)
        weixinButton.isHidden = !LoginBridge.isWeChatAvailable()
        weixinButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weixinButton)

        // 苹果登录按钮（官方样式，自动本地化）
        appleButton.cornerRadius = 22
        appleButton.addTarget(self, action: #selector(onApple), for: .touchUpInside)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appleButton)

        // 协议勾选行：[勾选框] 我已阅读并同意《服务协议》和《隐私政策》
        let termsRow = UIView()
        termsRow.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(termsRow)

        agreeCheckbox.setImage(UIImage(named: "icon_login_un"), for: .normal)
        agreeCheckbox.setImage(UIImage(named: "icon_login_se"), for: .selected)
        agreeCheckbox.isSelected = false   // 默认不同意
        agreeCheckbox.addTarget(self, action: #selector(onToggleAgree), for: .touchUpInside)
        agreeCheckbox.translatesAutoresizingMaskIntoConstraints = false
        termsRow.addSubview(agreeCheckbox)

        termsTextView.attributedText = termsAttributedText()
        termsTextView.isEditable = false
        termsTextView.isScrollEnabled = false
        termsTextView.backgroundColor = .clear
        termsTextView.textContainerInset = .zero
        termsTextView.textContainer.lineFragmentPadding = 0
        termsTextView.linkTextAttributes = [.foregroundColor: pink]
        termsTextView.delegate = self
        termsTextView.translatesAutoresizingMaskIntoConstraints = false
        termsRow.addSubview(termsTextView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),

            accountRow.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            accountRow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            accountRow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            passwordRow.topAnchor.constraint(equalTo: accountRow.bottomAnchor, constant: 24),
            passwordRow.leadingAnchor.constraint(equalTo: accountRow.leadingAnchor),
            passwordRow.trailingAnchor.constraint(equalTo: accountRow.trailingAnchor),

            forgetButton.topAnchor.constraint(equalTo: passwordRow.bottomAnchor, constant: 12),
            forgetButton.trailingAnchor.constraint(equalTo: passwordRow.trailingAnchor),
            toggleButton.centerYAnchor.constraint(equalTo: forgetButton.centerYAnchor),
            toggleButton.leadingAnchor.constraint(equalTo: passwordRow.leadingAnchor),

            loginButton.topAnchor.constraint(equalTo: forgetButton.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            loginButton.heightAnchor.constraint(equalToConstant: 44),

            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            weixinButton.bottomAnchor.constraint(equalTo: termsRow.topAnchor, constant: -24),
            weixinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weixinButton.widthAnchor.constraint(equalToConstant: 44),
            weixinButton.heightAnchor.constraint(equalToConstant: 44),

            appleButton.bottomAnchor.constraint(equalTo: weixinButton.topAnchor, constant: -16),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            appleButton.heightAnchor.constraint(equalToConstant: 44),

            termsRow.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -12),
            termsRow.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            termsRow.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            termsRow.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),

            agreeCheckbox.leadingAnchor.constraint(equalTo: termsRow.leadingAnchor),
            agreeCheckbox.centerYAnchor.constraint(equalTo: termsTextView.centerYAnchor),
            agreeCheckbox.widthAnchor.constraint(equalToConstant: 16),
            agreeCheckbox.heightAnchor.constraint(equalToConstant: 16),

            termsTextView.leadingAnchor.constraint(equalTo: agreeCheckbox.trailingAnchor, constant: 6),
            termsTextView.trailingAnchor.constraint(equalTo: termsRow.trailingAnchor),
            termsTextView.topAnchor.constraint(equalTo: termsRow.topAnchor),
            termsTextView.bottomAnchor.constraint(equalTo: termsRow.bottomAnchor),
        ])
    }

    private func buildCodeView(below topRow: UIView) {
        codeView.isHidden = true
        codeView.backgroundColor = .white   // 不透明白底，覆盖底层账号/密码区，避免 placeholder 重影
        codeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(codeView)

        let phoneRow = makeFieldRow(field: phoneField, placeholder: "请输入手机号")
        let codeRow = makeFieldRow(field: codeField, placeholder: "请输入验证码")
        [phoneRow, codeRow].forEach { codeView.addSubview($0) }

        codeButton.setTitle("获取验证码", for: .normal)
        codeButton.setTitleColor(pink, for: .normal)
        codeButton.titleLabel?.font = .systemFont(ofSize: 13)
        codeButton.addTarget(self, action: #selector(onGetCode), for: .touchUpInside)
        codeButton.translatesAutoresizingMaskIntoConstraints = false
        codeRow.addSubview(codeButton)

        NSLayoutConstraint.activate([
            // codeView 覆盖在账号/密码区域位置
            codeView.topAnchor.constraint(equalTo: topRow.topAnchor, constant: -55),
            codeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            codeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            phoneRow.topAnchor.constraint(equalTo: codeView.topAnchor),
            phoneRow.leadingAnchor.constraint(equalTo: codeView.leadingAnchor),
            phoneRow.trailingAnchor.constraint(equalTo: codeView.trailingAnchor),

            codeRow.topAnchor.constraint(equalTo: phoneRow.bottomAnchor, constant: 24),
            codeRow.leadingAnchor.constraint(equalTo: codeView.leadingAnchor),
            codeRow.trailingAnchor.constraint(equalTo: codeView.trailingAnchor),
            codeRow.bottomAnchor.constraint(equalTo: codeView.bottomAnchor),

            codeButton.trailingAnchor.constraint(equalTo: codeRow.trailingAnchor),
            codeButton.centerYAnchor.constraint(equalTo: codeField.centerYAnchor),
        ])
    }

    private func makeFieldRow(field: UITextField, placeholder: String) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = placeholder
        field.font = .systemFont(ofSize: 15)
        field.clearButtonMode = .always
        field.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(field)
        let underline = UIView()
        underline.backgroundColor = underlineGray
        underline.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(underline)
        NSLayoutConstraint.activate([
            field.topAnchor.constraint(equalTo: row.topAnchor),
            field.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            field.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            field.heightAnchor.constraint(equalToConstant: 21),
            underline.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 12),
            underline.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            underline.heightAnchor.constraint(equalToConstant: 1),
            underline.bottomAnchor.constraint(equalTo: row.bottomAnchor),
        ])
        return row
    }

    private func configureFields() {
        accountField.clearButtonMode = .always
        accountField.delegate = self
        passwordField.isSecureTextEntry = true
        passwordField.returnKeyType = .done
        passwordField.delegate = self
        codeField.keyboardType = .numberPad
    }

    private func termsAttributedText() -> NSAttributedString {
        let normal: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.gray]
        let s = NSMutableAttributedString(string: "我已阅读并同意", attributes: normal)
        s.append(NSAttributedString(string: "《服务协议》", attributes: [.font: UIFont.systemFont(ofSize: 12), .link: "terms://service"]))
        s.append(NSAttributedString(string: "和", attributes: normal))
        s.append(NSAttributedString(string: "《隐私政策》", attributes: [.font: UIFont.systemFont(ofSize: 12), .link: "terms://privacy"]))
        return s
    }

    /// 未勾选同意则拦截（返回 false）
    private func ensureAgreed() -> Bool {
        if !agreeCheckbox.isSelected {
            HudHelper.hudHepler().showShortTips(view, tips: "请先阅读并同意《服务协议》和《隐私政策》")
            return false
        }
        return true
    }

    @objc private func onToggleAgree() {
        agreeCheckbox.isSelected.toggle()
    }

    // MARK: - 动作

    @objc private func onRegister() {
        let vc = SignUpViewController()
        vc.navigationItem.title = "注册"
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func onForget() {
        let vc = PasswordResetViewController()
        vc.delegate = self
        vc.navigationItem.title = "忘记密码"
        navigationController?.pushViewController(vc, animated: true)
    }

    /// 打开协议页（服务协议 / 隐私政策）
    private func openPolicy(isPrivacy: Bool) {
        let servicePageID = "2"   // 服务协议
        let privacyPageID = "3"   // 独立隐私政策
        let pageID = isPrivacy ? privacyPageID : servicePageID
        let vc = AgreementPageViewController()
        vc.url = "\(DATAAPI ?? "")iumobile_beibei/apis/help_page.php?id=\(pageID)&type=new"
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func onWeChat() {
        guard ensureAgreed() else { return }
        LoginBridge.startWeChatLogin(self)
    }

    // MARK: - 苹果登录（Sign in with Apple）

    @objc private func onApple() {
        guard ensureAgreed() else { return }
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    @objc private func onToggleLoginType() {
        view.endEditing(true)
        if isCodeLogin {
            // 回到密码登录
            codeView.isHidden = true
            accountRow.isHidden = false
            passwordRow.isHidden = false
            isCodeLogin = false
            registerButton.isHidden = false
            toggleButton.setTitle("验证码登录", for: .normal)
            accountField.text = phoneField.text
        } else {
            // 切到验证码登录：隐藏账号/密码行，显示验证码区
            codeView.isHidden = false
            accountRow.isHidden = true
            passwordRow.isHidden = true
            isCodeLogin = true
            registerButton.isHidden = true
            toggleButton.setTitle("手机登录", for: .normal)
            phoneField.text = accountField.text
            view.bringSubviewToFront(codeView)
        }
    }

    @objc private func onLogin() {
        view.endEditing(true)
        guard ensureAgreed() else { return }
        if isCodeLogin { codeLogin(); return }

        let username = accountField.text ?? ""
        let pass = passwordField.text ?? ""
        if username.isEmpty {
            HudHelper.hudHepler().showShortTips(view, tips: "手机号/靓号不能为空"); return
        }
        if pass.isEmpty {
            HudHelper.hudHepler().showShortTips(view, tips: "密码不能为空"); return
        }
        if pass.count < 6 {
            HudHelper.hudHepler().showShortTips(view, tips: "密码不能小于6位"); return
        }
        let params = baseParams()
        params.setValue(username, forKey: "username")
        params.setValue(pass, forKey: "password")
        let url = "\(DATAAPI ?? "")v4/\(users_login)"
        doLogin(url: url, params: params)
    }

    private func codeLogin() {
        view.endEditing(true)
        let username = phoneField.text ?? ""
        let code = codeField.text ?? ""
        if username.isEmpty {
            MessageHelper().showMessage(self, title: "", sub: "手机号不能为空"); return
        }
        if code.isEmpty {
            MessageHelper().showMessage(self, title: "", sub: "验证码不能为空"); return
        }
        let params = baseParams()
        params.setValue(username, forKey: "mobile")
        params.setValue(code, forKey: "code")
        let url = "\(DATAAPI ?? "")v4/phone/login"
        doLogin(url: url, params: params)
    }

    /// 公共登录参数（version_app / apnstoken / u）
    private func baseParams() -> NSMutableDictionary {
        let params = NSMutableDictionary()
        params.setValue(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "", forKey: "version_app")
        if let apns = LoginBridge.apnsToken() { params.setValue(apns, forKey: "apnstoken") }
        if let u = LoginBridge.unionId() { params.setValue(u, forKey: "u") }
        return params
    }

    private func doLogin(url: String, params: NSMutableDictionary) {
        RootHttpHelper.shared().achieveCommonPostURL2(
            url, andController: self, andView: view, andParams: params
        ) { [weak self] successData in
            guard let self = self else { return }
            if (successData["api_code"] as? NSNumber)?.intValue != 200 {
                MessageHelper().showMessage(self, title: nil, sub: successData["api_msg"] as? String ?? "")
                if let addr = successData["ios_add_address"] as? String {
                    let alert = UIAlertController(title: "", message: successData["api_msg"] as? String ?? "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
                        if let u = URL(string: addr) { UIApplication.shared.open(u) }
                    })
                    self.present(alert, animated: true)
                }
                return
            }
            LoginBridge.handleLoginSuccess(successData)
        }
    }

    // MARK: - 验证码

    @objc private func onGetCode() {
        codeField.text = ""
        guard let username = phoneField.text, !username.isEmpty else {
            MessageHelper().showMessage(self, title: "", sub: "手机号码不能为空"); return
        }
        let params = NSMutableDictionary()
        params.setValue(username, forKey: "mobile")
        RootHttpHelper.shared().achieveCommonPostURL(
            users_code, andController: self, andView: view, andParams: params
        ) { [weak self] successData in
            guard let self = self else { return }
            if (successData["api_code"] as? NSNumber)?.intValue == 200 {
                MessageHelper().showSuccessMessage(self, title: "", sub: successData["data"] as? String ?? "")
                self.startCountdown()
                self.codeField.becomeFirstResponder()
            }
        }
    }

    private func startCountdown() {
        timer?.invalidate()
        second = 60
        codeButton.isEnabled = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func tick() {
        second -= 1
        if second <= 0 {
            codeButton.setTitle("获取验证码", for: .normal)
            codeButton.isEnabled = true
            timer?.invalidate()
            second = 60
        } else {
            codeButton.setTitle("\(second)s", for: .normal)
            codeButton.isEnabled = false
        }
    }

    // MARK: - 异地登录提示

    private func showOtherDeviceAlert() {
        let alert = UIAlertController(title: "温馨提示",
                                      message: "您的账号在新的设备登录 如非本人登录请修改密码",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "知道了", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension LoginEntryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onLogin()
        return true
    }
}

// MARK: - UserResetDelegate（找回密码成功后回填账号）

extension LoginEntryViewController: UserResetDelegate {
    func userResetSucceed(_ username: String!, andType type: Int) {
        accountField.text = username
    }
}

// MARK: - UITextViewDelegate（协议链接点击）

extension LoginEntryViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL,
                  in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        openPolicy(isPrivacy: URL.absoluteString.contains("privacy"))
        return false
    }
}

// MARK: - 苹果登录回调

extension LoginEntryViewController: ASAuthorizationControllerDelegate,
                                    ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()
    }

    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let cred = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        // Apple 稳定用户标识（等价微信 openid），后端按此 find-or-create
        let userId = cred.user
        let identityToken = cred.identityToken.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        // 昵称仅首次授权返回；返回用户靠 userId 匹配，无需本地存
        var name = ""
        if let full = cred.fullName {
            name = [full.familyName, full.givenName].compactMap { $0 }.joined()
        }
        if name.isEmpty { name = "Apple用户" }

        // 复用微信同款 users_oauth 端点，仅 type 不同（5=苹果，须后端加分支）
        let params = baseParams()
        params.setValue("5", forKey: "type")
        params.setValue(userId, forKey: "external_uid")
        params.setValue(name, forKey: "external_name")
        params.setValue(identityToken, forKey: "token")

        RootHttpHelper.shared().achieveCommonPostURL(
            users_oauth, andController: self, andView: view, andParams: params
        ) { [weak self] successData in
            guard let self = self else { return }
            if (successData["api_code"] as? NSNumber)?.intValue != 200 {
                MessageHelper().showMessage(self, title: nil, sub: successData["api_msg"] as? String ?? "")
                return
            }
            LoginBridge.handleLoginSuccess(successData)
        }
    }

    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        // 用户取消不提示
        if (error as NSError).code == ASAuthorizationError.canceled.rawValue { return }
        MessageHelper().showMessage(self, title: nil, sub: "Apple 登录失败，请重试")
    }
}
