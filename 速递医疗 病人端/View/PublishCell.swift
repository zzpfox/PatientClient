//
//  PublishCell.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/5.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import Moya
import SVProgressHUD
import ObjectMapper
import HJPhotoBrowser
class PublishCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate,HJPhotoBrowserDelegate {
    @IBOutlet weak var label_desc: UILabel!
    @IBOutlet weak var label_age: UILabel!
    @IBOutlet weak var label_sex: UILabel!
    @IBOutlet weak var label_name: UILabel!
    
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var btn_publish: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func photoBrowser(_ browser: HJPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return #imageLiteral(resourceName: "photo_default")
    }
    func photoBrowser(_ browser: HJPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        return URL.init(string: imageSource[index])
    }
    
    
    var imageSource = [String]()
    var data:SickBean?
    var vc = BaseRefreshController<SickBean>()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func updataView(sickBean:SickBean, vc:BaseRefreshController<SickBean>) {
        self.data = sickBean
        self.vc = vc
        label_name.text = sickBean.familyname
        label_sex.text = sickBean.familymale
        label_age.text = "\(sickBean.familyage)"
        label_desc.text = sickBean.usersickdesc
        time_label.text = sickBean.usersicktime
        if sickBean.usersickpic == nil {
            collectionView.isHidden = true
            imageSource = []
        }else{
            // 子collectionView 数据绑定
            collectionView.isHidden = false
            imageSource = StringUTil.splitImage(str: sickBean.usersickpic!)
            collectionView.reloadData()
        }
        btn_publish.addTarget(self, action: #selector(PublishCell.PublishAction(button:)), for: .touchUpInside)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSource.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sonCell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        ImageUtil.setImage(path: imageSource[indexPath.row], imageView: imageView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let count = imageSource.count;
        let browser = HJPhotoBrowser()
        browser.sourceImagesContainerView = collectionView
        browser.imageCount = count
        browser.currentImageIndex = indexPath.row;
        browser.delegate = self
        browser.show()
    }
    
    @objc func PublishAction(button:UIButton) {
        AlertUtil.popAlert(vc: vc, msg: "确认发布病情", okhandler: {
        NetWorkUtil.init(method: .publishsick((self.data?.usersickid)!)).newRequest(successhandler: { (bean, json) in
                self.vc.refreshBtn()
            })
        })
    }
    
}


class PublishCell2: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, HJPhotoBrowserDelegate {
    
    func photoBrowser(_ browser: HJPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return #imageLiteral(resourceName: "photo_default")
    }
    func photoBrowser(_ browser: HJPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        return URL.init(string: imageSource[index])
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var label_desc: UILabel!
    @IBOutlet weak var label_age: UILabel!
    @IBOutlet weak var label_sex: UILabel!
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_time: UILabel!
    
    @IBOutlet weak var btn_del: UIButton!
    var imageSource = [String]()
    var data:SickBean?
    var vc = BaseRefreshController<SickBean>()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func updataView(sickBean:SickBean, vc:BaseRefreshController<SickBean>) {
        self.data = sickBean
        self.vc = vc
        label_time.text = sickBean.usersicktime
        label_name.text = sickBean.familyname
        label_sex.text = sickBean.familymale
        label_age.text = "\(sickBean.familyage)"
        label_desc.text = sickBean.usersickdesc
        if sickBean.usersickpic == nil {
            collectionView.isHidden = true
            imageSource = []
        }else{
            collectionView.isHidden = false
            // 子collectionView 数据绑定
            imageSource = StringUTil.splitImage(str: sickBean.usersickpic!)
            collectionView.reloadData()
        }
        btn_del.addTarget(self, action: #selector(PublishCell2.DelAction(button:)), for: .touchUpInside)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSource.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sonCell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        ImageUtil.setImage(path: imageSource[indexPath.row], imageView: imageView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let count = imageSource.count;
        let browser = HJPhotoBrowser()
        browser.sourceImagesContainerView = collectionView
        browser.imageCount = count
        browser.currentImageIndex = indexPath.row;
        browser.delegate = self
        browser.show()
    }
    
    
    @objc func DelAction(button:UIButton) {
        AlertUtil.popAlert(vc: vc, msg: "确认取消发布") {
            NetWorkUtil<BaseAPIBean>.init(method: API.cancelsick((self.data?.usersickid)!)).newRequest(successhandler: { (bean, json) in
                    self.vc.refreshData()
            })
            
        }
    }
    
}
