//
//  ThirdViewController.swift
//  EbookReader
//
//  Created by 黄文博 on 2020/4/29.
//  Copyright © 2020 CN. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.gray

        // Do any additional setup after loading the view.
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.height.equalTo(200)
            make.top.left.right.equalTo(0)
        }
        let avatarImageView = UIImageView()
        headerView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.centerX.equalTo(headerView)
        }
        let nameLabel = UILabel()
        nameLabel.text = "aa"
        headerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(headerView)
            make.top.equalTo(avatarImageView.snp.bottom).offset(30)
        }

        let settingView = UIView()
        settingView.backgroundColor = UIColor.white
        self.view.addSubview(settingView)
        settingView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.left.right.equalTo(0)
        }
        let settingTitleLabel = UILabel()
        settingTitleLabel.text = "Setting"
        settingView.addSubview(settingTitleLabel)
        settingTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(30)
        }
        let wifiLabel = UILabel()
        wifiLabel.text = "Download on Wifi Only"
        settingView.addSubview(wifiLabel)
        wifiLabel.snp.makeConstraints { (make) in
            make.top.equalTo(settingTitleLabel.snp.bottom).offset(30)
            make.left.equalTo(30)
        }
        let wifiSwitch = UISwitch()
        wifiSwitch.isOn = downloadWithWifiOnly
        wifiSwitch.addTarget(self, action: #selector(onWifiTapped), for: .touchUpInside)
        settingView.addSubview(wifiSwitch)
        wifiSwitch.snp.makeConstraints { (make) in
            make.centerY.equalTo(wifiLabel)
            make.right.equalTo(-30)
        }
        let screenLabel = UILabel()
        screenLabel.text = "Keep Screen On While Reading"
        settingView.addSubview(screenLabel)
        screenLabel.snp.makeConstraints { (make) in
            make.top.equalTo(wifiLabel.snp.bottom).offset(30)
            make.left.equalTo(30)
            make.bottom.equalTo(-30)
        }
        let screenSwitch = UISwitch()
        screenSwitch.isOn = keepScreenOnWhileReading
        screenSwitch.addTarget(self, action: #selector(onScreenTapped), for: .touchUpInside)
        settingView.addSubview(screenSwitch)
        screenSwitch.snp.makeConstraints { (make) in
            make.centerY.equalTo(screenLabel)
            make.right.equalTo(-30)
        }

        let aboutUsView = UIView()
        aboutUsView.backgroundColor = UIColor.white
        self.view.addSubview(aboutUsView)
        aboutUsView.snp.makeConstraints { (make) in
            make.top.equalTo(settingView.snp.bottom).offset(20)
            make.left.right.equalTo(0)
        }
        let aboutUsTitleLabel = UILabel()
        aboutUsTitleLabel.text = "About Us"
        aboutUsView.addSubview(aboutUsTitleLabel)
        aboutUsTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(30)
        }
        let versionView = UIView()
        aboutUsView.addSubview(versionView)
        versionView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalTo(aboutUsTitleLabel.snp.bottom).offset(30)
            make.left.right.equalTo(0)
        }
        let versionTitleLabel = UILabel()
        versionTitleLabel.text = "Version"
        versionView.addSubview(versionTitleLabel)
        versionTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(versionView)
            make.left.equalTo(30)
        }
        let versionContentLabel = UILabel()
        versionContentLabel.text = "v1.0.1"
        versionView.addSubview(versionContentLabel)
        versionContentLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(versionView)
            make.right.equalTo(-30)
        }
        let termsView = UIView()
        aboutUsView.addSubview(termsView)
        termsView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalTo(versionView.snp.bottom)
            make.left.right.equalTo(0)
        }
        let termsTitleLabel = UILabel()
        termsTitleLabel.text = "Terms of Use"
        termsView.addSubview(termsTitleLabel)
        termsTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(termsView)
            make.left.equalTo(30)
        }
        let termsImageView = UIImageView()
        termsView.addSubview(termsImageView)
        termsImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(termsView)
            make.right.equalTo(-30)
        }
        let ppView = UIView()
        aboutUsView.addSubview(ppView)
        ppView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalTo(termsView.snp.bottom)
            make.left.right.equalTo(0)
        }
        let ppTitleLabel = UILabel()
        ppTitleLabel.text = "Privacy Policy"
        ppView.addSubview(ppTitleLabel)
        ppTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(ppView)
            make.left.equalTo(30)
        }
        let ppImageView = UIImageView()
        ppView.addSubview(ppImageView)
        ppImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(ppView)
            make.right.equalTo(-30)
        }
        let disView = UIView()
        aboutUsView.addSubview(disView)
        disView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalTo(ppView.snp.bottom)
            make.left.right.bottom.equalTo(0)
        }
        let disTitleLabel = UILabel()
        disTitleLabel.text = "Disclaimer"
        disView.addSubview(disTitleLabel)
        disTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(disView)
            make.left.equalTo(30)
        }
        let disImageView = UIImageView()
        disView.addSubview(disImageView)
        disImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(disView)
            make.right.equalTo(-30)
        }


        let contactUsView = UIView()
        contactUsView.backgroundColor = UIColor.white
        self.view.addSubview(contactUsView)
        contactUsView.snp.makeConstraints { (make) in
            make.top.equalTo(aboutUsView.snp.bottom).offset(20)
            make.left.right.equalTo(0)
        }
        let contactTitleLabel = UILabel()
        contactTitleLabel.text = "Contact Us"
        contactUsView.addSubview(contactTitleLabel)
        contactTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(30)
        }
        let emailView = UIView()
        contactUsView.addSubview(emailView)
        emailView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalTo(contactTitleLabel.snp.bottom).offset(30)
            make.left.right.bottom.equalTo(0)
        }
        let emailTitleLabel = UILabel()
        emailTitleLabel.text = "Email Address"
        emailView.addSubview(emailTitleLabel)
        emailTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(emailView)
            make.left.equalTo(30)
        }
        let emailContentLabel = UILabel()
        emailContentLabel.text = "email@address.com"
        emailView.addSubview(emailContentLabel)
        emailContentLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(emailView)
            make.right.equalTo(-30)
        }
    }

    @objc func onWifiTapped() {
        downloadWithWifiOnly = !downloadWithWifiOnly
        prefs.set(downloadWithWifiOnly, forKey: wifiKey)
    }

    @objc func onScreenTapped() {
        keepScreenOnWhileReading = !keepScreenOnWhileReading
        prefs.set(keepScreenOnWhileReading, forKey: screenKey)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}