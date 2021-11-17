//
//  BrowserImageController.swift
//  Discover
//
//  Created by lansoft on 2021/9/17.
//

import Foundation
import UIKit
import Photos

class BrowserImageController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var browserImageCallback:([(asset:PHAsset, number:String)]) -> Void = {assets in}
    
    private var imageAssets:[(asset:PHAsset, number:String)] = []
    private var currentSelectedAssets:[(asset:PHAsset, number:String)] = []
    private var startIndexPath: IndexPath = IndexPath.init()
    private var maxCount: Int = 0
    
    private lazy var imageScrollView: UICollectionView = {
        let v = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: BrowerImageViewLayout())
        v.backgroundColor = .white
        v.register(BrowerImageViewCell.self, forCellWithReuseIdentifier: "BrowerImageViewCell_id")
        v.delegate = self
        v.dataSource = self
        v.showsHorizontalScrollIndicator = false
        return v
    }()
    
    private var finishBtn: UIButton = {
        let b = UIButton()
        b.setTitle("(确 定)", for: .normal)
        b.titleLabel?.font = UIFont._16b
        b.setTitleColor(UIColor.globOrange, for: .normal)
        b.addTarget(self, action: #selector(finish), for: .touchUpInside)
        b.layer.borderWidth = 1
        b.layer.borderColor = UIColor.globOrange.cgColor
        b.cornerRadius(20)
        return b
    }()
    
    private var selectImageBtn: UIButton {
        return self.rightBarView.subviews.first { v in
            return v.classForCoder == UIButton.classForCoder()
        }! as! UIButton
    }
    
    private var selectImageLabel: UILabel {
        return self.rightBarView.subviews.first { v in
            return v.classForCoder == UILabel.classForCoder()
        }! as! UILabel
    }
    
    private lazy var rightBarView: UIView = {
        let v = UIView()
        let l = UILabel()
        l.textColor = UIColor.globOrange
        l.textAlignment = .right
        l.text = "(\(self.currentSelectedAssets.count)/\(maxCount))"
        v.addSubview(l)
        let b = UIButton.init()
        b.setImage(UIImage.init(named: "ic_has_input"), for: .normal)
        b.setImage(UIImage.init(named: "checked_round"), for: .selected)
        v.addSubview(b)
        l.frame = CGRect.init(x: 0, y: 0, width: 50, height: 44)
        b.frame = CGRect.init(x: l.frame.maxX, y: 0, width: 40, height: 44)
        b.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        return v
    }()
    
    convenience init(assets:[(asset:PHAsset, number:String)], currentSelected:[(asset:PHAsset, number:String)], currentIndexPath: IndexPath, maxCount: Int = 9) {
        self.init()
        self.imageAssets = assets
        self.imageAssets.removeLast()
        self.startIndexPath = currentIndexPath
        self.maxCount = maxCount
        self.currentSelectedAssets = currentSelected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageScrollView)
        view.addSubview(finishBtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rightBarView.size = CGSize.init(width: 80, height: 44)
        imageScrollView.frame = CGRect.init(x: 0, y: view.topSaveArea, width: view.width, height: view.height - view.topSaveArea - 49 - view.bottomSafeArea)
        finishBtn.frame = CGRect.init(x: 0, y: imageScrollView.frame.maxY + 2, width: view.width, height: 45)
        imageScrollView.scrollToItem(at: startIndexPath, at: .centeredHorizontally, animated: false)
        selectImageBtn.isSelected = currentSelectedAssets.map({ asset in
            return asset.asset.localIdentifier
        }).contains(imageAssets[startIndexPath.row].asset.localIdentifier)
    }
    
    @objc private func selectImage(){
        if selectImageBtn.isSelected {
            currentSelectedAssets.removeAll { asset in
                return asset.asset.localIdentifier == imageAssets[startIndexPath.row].asset.localIdentifier
            }
            selectImageBtn.isSelected = false
        }
        else{
            if currentSelectedAssets.count == maxCount {
                present(UIAlertController.init(title: "最多选择\(maxCount)张图片", closeTitle: "确定"), animated: true, completion: nil) 
            }
            else{
                currentSelectedAssets.append((imageAssets[startIndexPath.row].asset, (currentSelectedAssets.count + 1).description))
                selectImageBtn.isSelected = true
                
            }
        }
        
        selectImageLabel.text = "(\(currentSelectedAssets.count)/\(maxCount))"
    }
    
    @objc private func finish(){
        browserImageCallback(currentSelectedAssets)
        navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startIndexPath = IndexPath.init(row: Int(scrollView.contentOffset.x / scrollView.width), section: 0)
        selectImageBtn.isSelected = currentSelectedAssets.map({ asset in
            return asset.asset.localIdentifier
        }).contains(imageAssets[startIndexPath.row].asset.localIdentifier)
        
        if currentSelectedAssets.count == maxCount{
            if let selectBtn = rightBarView.subviews.first(where: { v in
                return v.classForCoder == UIButton.classForCoder()
            }){
                if selectImageBtn.isSelected {
                    selectBtn.isHidden = false
                }
                else{
                    selectBtn.isHidden = true
                }
            }
        }
        else{
            if let selectBtn = rightBarView.subviews.first(where: { v in
                return v.classForCoder == UIButton.classForCoder()
            }){
                selectBtn.isHidden = false
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowerImageViewCell_id", for: indexPath) as! BrowerImageViewCell
        imageFromAsset(imageAssets[indexPath.row].asset, CGSize.zero) { image in
            cell.imageV.image = image
        }
        
        return cell
    }
    
   
}

class BrowerImageViewLayout: UICollectionViewFlowLayout{
    override func prepare() {
        itemSize = CGSize.init(width: collectionView!.width, height: collectionView!.height)
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        super.prepare()
    }
}

class BrowerImageViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCell()
    }
    
    lazy var imageV: UIImageView = {
        let v = UIImageView.init()
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    func initCell() {
        contentView.addSubview(imageV)
    }
    
    override func layoutSubviews() {
        imageV.frame.size = frame.size
    }
}
