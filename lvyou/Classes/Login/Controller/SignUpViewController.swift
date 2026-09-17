//
//  SignUpViewController.swift
//  注册页（Swift 重写，替代原 OC 版 + xib）。
//
//  UI 全部代码 + Auto Layout 重建（删除 xib，去掉一个 4.3 指纹），
//  视觉对齐原 xib：白底、关闭按钮、"注册"标题、手机号/验证码/密码三个下划线
//  输入框、验证码倒计时按钮、粉色圆角注册按钮。
//  会话相关的脏活（建 UserModel、存 token、连 IM、跳完善资料页）走 LoginBridge。
//

import UIKit
import WebKit

@objc(SignUpViewController)
final class SignUpViewController: UIViewController {

    // MARK: 配色 / 字体（对应原 xib 常量）
    private let pink = UIColor(red: 1.0, green: 91.0/255.0, blue: 135.0/255.0, alpha: 1)      // 0xFF5B87
    private let underlineGray = UIColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 1)
    private let codeBlue = UIColor(red: 0.125, green: 0.616, blue: 1.0, alpha: 1)
    private let titleBlack = UIColor(white: 0.02, alpha: 1)

    // MARK: 控件
    private let mobileField = UITextField()
    private let codeField = UITextField()
    private let passwordField = UITextField()
    private let codeButton = UIButton(type: .system)
    private let registerButton = UIButton(type: .system)

    // 协议勾选（默认不勾选，必须手动勾选才能注册）
    private let agreeCheckbox = UIButton(type: .custom)
    private let termsTextView = UITextView()

    // MARK: 倒计时
    private var timer: Timer?
    private var second = 60

    private let userAgentProbe = WKWebView(frame: .zero)

    deinit { timer?.invalidate() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        buildUI()
        configureFields()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        cleanText()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - UI 搭建

    private func buildUI() {
        let safe = view.safeAreaLayoutGuide

        // 关闭按钮
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "login_close")?.withRenderingMode(.alwaysOriginal), for: .normal)
        closeButton.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)

        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "注册"
        titleLabel.textColor = titleBlack
        titleLabel.font = UIFont(name: "PingFangSC-Medium", size: 24) ?? .systemFont(ofSize: 24, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // 三个输入行
        let mobileRow = makeFieldRow(field: mobileField, placeholder: "请输入手机号")
        let codeRow = makeFieldRow(field: codeField, placeholder: "请输入验证码")
        let passwordRow = makeFieldRow(field: passwordField, placeholder: "请输入密码")
        [mobileRow, codeRow, passwordRow].forEach { view.addSubview($0) }

        // 验证码按钮塞进验证码行右侧
        codeButton.setTitle("获取验证码", for: .normal)
        codeButton.setTitleColor(codeBlue, for: .normal)
        codeButton.titleLabel?.font = .systemFont(ofSize: 12)
        codeButton.addTarget(self, action: #selector(onGetCode), for: .touchUpInside)
        codeButton.translatesAutoresizingMaskIntoConstraints = false
        codeRow.addSubview(codeButton)

        // 注册按钮
        registerButton.setTitle("注册", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 20) ?? .systemFont(ofSize: 20)
        registerButton.backgroundColor = pink
        registerButton.layer.cornerRadius = 20
        registerButton.layer.masksToBounds = true
        registerButton.addTarget(self, action: #selector(onRegister), for: .touchUpInside)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(registerButton)

        // 协议勾选行
        let termsRow = UIView()
        termsRow.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(termsRow)

        agreeCheckbox.setImage(UIImage(named: "icon_login_un"), for: .normal)
        agreeCheckbox.setImage(UIImage(named: "icon_login_se"), for: .selected)
        agreeCheckbox.isSelected = false
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
            termsRow.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20),
            termsRow.leadingAnchor.constraint(equalTo: mobileRow.leadingAnchor),
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

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 52),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),

            mobileRow.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 37),
            mobileRow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            mobileRow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -67),

            codeRow.topAnchor.constraint(equalTo: mobileRow.bottomAnchor, constant: 24),
            codeRow.leadingAnchor.constraint(equalTo: mobileRow.leadingAnchor),
            codeRow.trailingAnchor.constraint(equalTo: mobileRow.trailingAnchor),

            passwordRow.topAnchor.constraint(equalTo: codeRow.bottomAnchor, constant: 24),
            passwordRow.leadingAnchor.constraint(equalTo: mobileRow.leadingAnchor),
            passwordRow.trailingAnchor.constraint(equalTo: mobileRow.trailingAnchor),

            codeButton.trailingAnchor.constraint(equalTo: codeRow.trailingAnchor),
            codeButton.centerYAnchor.constraint(equalTo: codeField.centerYAnchor),

            registerButton.topAnchor.constraint(equalTo: passwordRow.bottomAnchor, constant: 45),
            registerButton.leadingAnchor.constraint(equalTo: mobileRow.leadingAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 109),
            registerButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    /// 造一个「输入框 + 下划线」的行，返回容器
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

            underline.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 15),
            underline.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            underline.heightAnchor.constraint(equalToConstant: 1),
            underline.bottomAnchor.constraint(equalTo: row.bottomAnchor),
        ])
        return row
    }

    private func configureFields() {
        mobileField.keyboardType = .numberPad
        mobileField.delegate = self

        codeField.keyboardType = .numberPad

        passwordField.isSecureTextEntry = true
        passwordField.returnKeyType = .done
        passwordField.delegate = self

        // 验证码按钮：手机号未填完前不可点（对应原 userInteractionEnabled = NO）
        codeButton.isEnabled = false
    }

    // MARK: - 动作

    @objc private func onClose() {
        // 本页是 push 进来的，关闭 = 返回上一级（对应原 OC BaseViewController.dismiss = pop）
        if let nav = navigationController, nav.viewControllers.count > 1 {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - 协议勾选

    private func termsAttributedText() -> NSAttributedString {
        let normal: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.gray]
        let s = NSMutableAttributedString(string: "我已阅读并同意", attributes: normal)
        s.append(NSAttributedString(string: "《服务协议》", attributes: [.font: UIFont.systemFont(ofSize: 12), .link: "terms://service"]))
        s.append(NSAttributedString(string: "和", attributes: normal))
        s.append(NSAttributedString(string: "《隐私政策》", attributes: [.font: UIFont.systemFont(ofSize: 12), .link: "terms://privacy"]))
        return s
    }

    @objc private func onToggleAgree() { agreeCheckbox.isSelected.toggle() }

    private func ensureAgreed() -> Bool {
        if !agreeCheckbox.isSelected {
            MessageHelper().showMessage(self, title: "", sub: "请先阅读并同意《服务协议》和《隐私政策》")
            return false
        }
        return true
    }

    private func openPolicy(isPrivacy: Bool) {
        let pageID = isPrivacy ? "3" : "2"   // 隐私政策=3 / 服务协议=2
        let vc = AgreementPageViewController()
        vc.url = "\(DATAAPI ?? "")iumobile_beibei/apis/help_page.php?id=\(pageID)&type=new"
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func onGetCode() {
        codeField.text = ""
        guard let mobile = mobileField.text, !mobile.isEmpty else {
            MessageHelper().showMessage(self, title: "", sub: "手机号码不能为空")
            return
        }
        let params = NSMutableDictionary()
        params.setValue(mobile, forKey: "mobile")
        params.setValue("reg", forKey: "from")   // 注册场景的验证码
        RootHttpHelper.shared().achieveCommonPostURL(
            users_code, andController: self, andView: view, andParams: params
        ) { [weak self] successData in
            guard let self = self else { return }
            if (successData["api_code"] as? NSNumber)?.intValue == 200 {
                MessageHelper().showSuccessMessage(
                    self, title: "", sub: successData["data"] as? String ?? "")
                self.startCountdown()
                self.codeField.becomeFirstResponder()
            }
        }
    }

    @objc private func onRegister() {
        view.endEditing(true)
        guard ensureAgreed() else { return }
        let username = mobileField.text ?? ""
        let pass = passwordField.text ?? ""
        let autecode = codeField.text ?? ""

        if username.isEmpty {
            MessageHelper().showMessage(self, title: "", sub: "手机号码不能为空"); return
        }
        if pass.isEmpty {
            MessageHelper().showMessage(self, title: "", sub: "密码不能为空"); return
        }
        if pass.count < 6 {
            MessageHelper().showMessage(self, title: "", sub: "密码不能小于6位"); return
        }
        if autecode.isEmpty {
            MessageHelper().showMessage(self, title: "", sub: "短信验证码不能为空"); return
        }

        // 取 userAgent（对应原 WKWebView.evaluateJavaScript navigator.userAgent）。
        // iOS 26+：脱离视图层级的 WKWebView 渲染进程会被立即回收、completion 永不触发，
        // 故先把探针加进当前视图（0 尺寸、隐藏）再执行 JS，完成后移除。
        userAgentProbe.isHidden = true
        view.addSubview(userAgentProbe)
        userAgentProbe.evaluateJavaScript("navigator.userAgent") { [weak self] result, _ in
            guard let self = self else { return }
            self.userAgentProbe.removeFromSuperview()
            let agent = result as? String ?? ""
            self.submitRegister(username: username, pass: pass, autecode: autecode, agent: agent)
        }
    }

    private func submitRegister(username: String, pass: String, autecode: String, agent: String) {
        let versionApp = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let params = NSMutableDictionary()
        params.setValue("1", forKey: "type")   // NSDataRrquestUserOauthTypeMobile
        params.setValue(username, forKey: "external_uid")
        params.setValue(username, forKey: "external_name")
        params.setValue(autecode, forKey: "token")
        params.setValue(pass, forKey: "password")
        params.setValue(agent, forKey: "agent")
        params.setValue(versionApp, forKey: "version_app")
        if let unionId = LoginBridge.unionId() {
            params.setValue(unionId, forKey: "u")
        }
        if let apns = LoginBridge.apnsToken() {
            params.setValue(apns, forKey: "apnstoken")
        }

        RootHttpHelper.shared().achieveCommonPostURL(
            users_oauth, andController: self, andView: view, andParams: params
        ) { [weak self] successData in
            guard let self = self else { return }
            if (successData["api_code"] as? NSNumber)?.intValue != 200 {
                MessageHelper().showMessage(
                    self, title: "", sub: successData["api_msg"] as? String ?? "")
                return
            }
            LoginBridge.handleAuthSuccess(successData)
            self.pushToAddInfo()
        }
    }

    private func pushToAddInfo() {
        let addVC = ProfileSetupViewController()   // 已迁移到 Swift，直接创建
        addVC.hidesBottomBarWhenPushed = true
        addVC.navigationItem.title = "注册"
        navigationController?.pushViewController(addVC, animated: true)
    }

    // MARK: - 倒计时

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

    private func cleanText() {
        mobileField.text = ""
        codeField.text = ""
        passwordField.text = ""
        timer?.invalidate()
    }
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == mobileField {
            // 手机号输完，放开验证码按钮（未在倒计时中时）
            if timer == nil || !(timer?.isValid ?? false) {
                codeButton.isEnabled = true
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onRegister()
        return true
    }
}

// MARK: - UITextViewDelegate（协议链接点击）

extension SignUpViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL,
                  in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        openPolicy(isPrivacy: URL.absoluteString.contains("privacy"))
        return false
    }
}
