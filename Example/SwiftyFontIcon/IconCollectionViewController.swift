//
//  IconCollectionViewController.swift
//  SwiftyFontIcon_Example
//
//  Created by Mohaned Benmesken on 7/23/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

import UIKit
import SwiftyFontIcon

let cellIdentifier = "IconCell"

class IconCollectionViewController: UICollectionViewController {
    let icons = [
        FAFontIcons.faBed,
        FAFontIcons.faViacoin,
        FAFontIcons.faTrain,
        FAFontIcons.faSubway,
        FAFontIcons.faMedium,
        FAFontIcons.faRecycle,
        FAFontIcons.faTree,
        FAFontIcons.faSpotify,
        FAFontIcons.faApple,
        FAFontIcons.faWindows,
        FAFontIcons.faAndroid,
        FAFontIcons.faLinux,
        FAFontIcons.faDribbble,
        FAFontIcons.faSkype,
        FAFontIcons.faFoursquare,
        FAFontIcons.faTrello,
        FAFontIcons.faFemale,
        FAFontIcons.faMale,
        FAFontIcons.faGratipay,
        FAFontIcons.faSun,
        FAFontIcons.faMoon,
        FAFontIcons.faArchive,
        FAFontIcons.faBug,
        FAFontIcons.faVk,
        FAFontIcons.faClone,
        MDFontIcon.sim_Card,
        MDFontIcon.sim_Card_Alert,
        MDFontIcon.skip_Next,
        MDFontIcon.skip_Previous,
        MDFontIcon.slideshow,
        MDFontIcon.smartphone,
        MDFontIcon.sms,
        MDFontIcon.sms_Failed,
        MDFontIcon.snooze,
        MDFontIcon.sort,
        MDFontIcon.sort_By_Alpha,
        MDFontIcon.space_Bar,
        MDFontIcon.speaker,
        MDFontIcon.speaker_Group,
        MDFontIcon.speaker_Notes,
        MDFontIcon.speaker_Phone,
        MDFontIcon.spellcheck,
        MDFontIcon.star,
        MDFontIcon.today,
        MDFontIcon.toll,
        MDFontIcon.tonality,
        MDFontIcon.toys,
        MDFontIcon.track_Changes,
        MDFontIcon.traffic,
        MDFontIcon.web,
        MDFontIcon.whatshot,
        MDFontIcon.widgets,
        MDFontIcon.wifi,
        MDFontIcon.wifi_Lock,
        MDFontIcon.wifi_Tethering,
        MDFontIcon.work,
        MDFontIcon.watch_Later
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwfIcon.instance.loadAllSync()
    }
    
    func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! IconCollectionViewCell
        cell.iconImageView.image = .icon(icons[indexPath.row], size:50)
        cell.iconImageView.tintColor = getRandomColor()
        return cell
    }
    
}
