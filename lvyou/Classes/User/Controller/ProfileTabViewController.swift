//
//  ProfileTabViewController.swift
//  「我的」tab：顶部背景图 + PersonalView 头部 + 写死的「设置」菜单。
//

import UIKit
import SDWebImage

@objc(ProfileTabViewController)
final class ProfileTabViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    private let userImgBG = UIImageView(image: UIImage(named: "icon_user_infobg"))
    private let table = UITableView(frame: .zero, style: .plain)
    private var header: PersonalView?

    private var dataArray: [PersonInfoModel] = []
    private var isRefreshing = false

    override func viewDidLoad() {
        super.viewDidLoad()

        userImgBG.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 236)
        userImgBG.contentMode = .scaleAspectFill
        view.addSubview(userImgBG)

        setupHardcodedMenu()
        setupTable()
        requestUserInfo()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        requestUserInfo()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - UI

    private func setupTable() {
        table.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.bounds.height)
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        table.dataSource = self
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 0
        table.estimatedSectionHeaderHeight = 0
        table.estimatedSectionFooterHeight = 0
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .clear
        table.contentInsetAdjustmentBehavior = .never
        table.tableHeaderView = makeHeader()
        view.addSubview(table)
    }

    private func makeHeader() -> PersonalView? {
        guard let h = Bundle.main.loadNibNamed("PersonalView", owner: self, options: nil)?.last as? PersonalView else { return nil }
        header = h
        h.exitBtnClick = { [weak self] in self?.pushEdit() }
        h.headimgBtnClick = { [weak self] in self?.pushEdit() }
        h.setBtnClick = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.pushViewController(UserMenuBridge.settingsViewController(), animated: true)
        }
        h.attentionBtnClick = { [weak self] in self?.pushAttention() }
        h.fansBtnClick = { [weak self] in self?.pushFans() }
        h.sendBtnClick = { [weak self] in self?.pushFriends() }
        h.listBtnClick = { [weak self] in
            guard let self = self else { return }
            HudHelper.hudHepler()?.showTips(self.view, tips: "贡献榜已关闭")
        }
        h.userInfoClick = { [weak self] in self?.pushProfile() }
        h.setUserTopBtn([])
        return h
    }

    // MARK: - 数据

    /// 来自 personal_function_list 的「设置」项，不再请求后台。
    private func setupHardcodedMenu() {
        if let setting = try? PersonInfoModel(dictionary: [
            "name": "设置功能",
            "icon": "https://img.cxlzc.com//static_data/uploaddata/personl_icon/5dbe0d113257c.png",
            "tag": "setting",
            "url": "",
            "linespace": "10",
            "update_time": "0",
        ]) {
            dataArray = [setting]
        }
    }

    @objc private func requestUserInfo() {
        RootHttpHelper.shared().achieveCommonGetURL(users_info, andController: nil, andView: nil, andParams: nil) { [weak self] successData in
            guard let self = self else { return }
            guard let model = CurrentUserBridge.applyUserInfoResponse(successData) else { return }
            self.header?.setUserInfo(model)
            self.header?.initAvatarImages(NSMutableArray())
        }
    }

    // MARK: - 表

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { dataArray.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = PersonalTableCell(tableView: tableView) else { return UITableViewCell() }
        cell.selectionStyle = .none
        guard indexPath.row < dataArray.count else { return cell }
        let model = dataArray[indexPath.row]
        if let icon = model.icon, !icon.isEmpty { cell.iconImg.sd_setImage(with: corpsURL(icon)) }
        if let name = model.name, !name.isEmpty { cell.titleLab.text = name }
        if let ls = model.linespace, !ls.isEmpty {
            cell.height.constant = CGFloat(Int(ls) ?? 0)
            if ls == "0" { cell.lineView.backgroundColor = .white }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row < dataArray.count else { return 58 }
        let ls = CGFloat(Int(dataArray[indexPath.row].linespace ?? "0") ?? 0)
        return 58 + ls / UIScreen.main.scale
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard indexPath.row < dataArray.count else { return }
        UserMenuBridge.handleMenuTap(dataArray[indexPath.row], navigation: navigationController, host: self)
    }

    // MARK: - 滚动：顶图拉伸 + 下拉刷新资料

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        let w = UIScreen.main.bounds.width
        if y < 0 {
            userImgBG.frame = CGRect(x: 0, y: 0, width: w, height: 236 - y)
            if y < -60 && !isRefreshing {
                isRefreshing = true
                requestUserInfo()
            }
        } else {
            userImgBG.frame = CGRect(x: 0, y: -y, width: w, height: 236)
            isRefreshing = false
        }
    }

    // MARK: - 跳转

    private func pushEdit() {
        navigationController?.pushViewController(UserMenuBridge.editUserInfoViewController(), animated: true)
    }

    private func pushProfile() {}
    private func pushAttention() {}
    private func pushFans() {}
    private func pushFriends() {}

    private func corpsURL(_ addr: String?) -> URL? {
        guard let addr = addr, !addr.isEmpty else { return nil }
        let full = (addr.hasPrefix("http://") || addr.hasPrefix("https://")) ? addr : "\(IMAGEAPI ?? "")\(addr)"
        return URL(string: full.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? full)
    }
}
