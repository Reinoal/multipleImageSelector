//
//  SelectImageController.swift
//  Discover
//
//  Created by lansoft on 2021/9/16.
//

import Foundation
import UIKit
import Photos

class SelectImageController: BaseController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var selectedImageCallback:([(asset:PHAsset, number:String)])-> Void = {assets in}
    
    private var currentSelectedImageAssets:[(asset:PHAsset, number:String)] = []
    private var imageAssets:[(asset:PHAsset, number:String)] = []
    private var maxCount: Int = 0
    private var assetsFromAlbum:[PHAsset] = []
    
    private var photoLibraryAuthorIsLimited: Bool = false
    
    lazy var imageCollectionView: UICollectionView = {
        
        let v = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: ImageCollectionLayout())
        v.register(ImageSelectCell.self, forCellWithReuseIdentifier: "ImageSelectCell_cell")
        v.backgroundColor = .white
        v.delegate = self
        v.dataSource = self
        return v
    }()
    
    convenience init(currentSelectedAssets:[(asset:PHAsset, number:String)], _ maxCount: Int = 9) {
        self.init()
        self.currentSelectedImageAssets = currentSelectedAssets
        self.maxCount = maxCount
        PhotoLibraryTool.shared.checkPhotoLibraryAuthorization(self) { status in
            if status == .limited{
                DispatchQueue.main.async {
                    self.photoLibraryAuthorIsLimited = true
                    self.reSetAsset()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageCollectionView)
        navigationItem.title = "选择图片"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "关闭", style: .done, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "完成(\(currentSelectedImageAssets.count)/\(maxCount))", style: .done, target: self, action: #selector(finish))
        PHPhotoLibrary.shared().register(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageCollectionView.frame = CGRect.init(x: 0, y: view.topSaveArea, width: view.width, height: view.height - view.topSaveArea)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    @objc private func close(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func finish(){
        selectedImageCallback(currentSelectedImageAssets)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func selectBtnClick(btn: UIButton){
        
        if btn.isSelected{
            currentSelectedImageAssets.removeAll { asset in
                return asset.asset.localIdentifier.isEqual(imageAssets[btn.tag].asset.localIdentifier)
            }
            let resortSelectedAssets = reMarkSelectedAssetNumber(currentSelectedImageAssets)
            setCollectionAssetNumber(assetsFromAlbum, selectedAssets: resortSelectedAssets)
            imageAssets.append((PHAsset.init(), ""))
            imageCollectionView.reloadItems(at: imageCollectionView.indexPathsForVisibleItems)
        }
        else{
            if currentSelectedImageAssets.count == maxCount {
                imageCollectionView.reloadItems(at: imageCollectionView.indexPathsForVisibleItems)
            }
            else{
                currentSelectedImageAssets.append((imageAssets[btn.tag].asset, (currentSelectedImageAssets.count + 1).description))
                imageAssets[btn.tag].number = currentSelectedImageAssets.count.description
                imageCollectionView.reloadItems(at: imageCollectionView.indexPathsForVisibleItems)
            }
        }
        navigationItem.rightBarButtonItem?.title = "完成(\(currentSelectedImageAssets.count)/\(maxCount))"
    }
    
    private func reSetAsset(){
        assetsFromAlbum = PhotoLibraryTool.shared.getAlbumAssets()
        currentSelectedImageAssets.removeAll { ass in
            return !assetsFromAlbum.contains { a in
                a.localIdentifier == ass.asset.localIdentifier
            }
        }
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem?.title = "完成(\(self.currentSelectedImageAssets.count)/\(self.maxCount))"
        }
        let resortSelectedAssets = reMarkSelectedAssetNumber(currentSelectedImageAssets)
        setCollectionAssetNumber(assetsFromAlbum, selectedAssets: resortSelectedAssets)
        self.imageAssets.append((PHAsset.init(), ""))
        DispatchQueue.main.async {
            self.imageCollectionView.reloadData()
        }
        
    }
    
    private func reMarkSelectedAssetNumber(_ assets:[(asset:PHAsset, number:String)]) -> [(asset:PHAsset, number:String)]{
        var reSortAssets:[(asset:PHAsset, number:String)] = []
        for (index, var a) in assets.enumerated(){
            a.number = (index + 1).description
            reSortAssets.append(a)
        }
        return reSortAssets
    }
    
    private func setCollectionAssetNumber(_ assets:[PHAsset], selectedAssets:[(asset:PHAsset, number:String)]){
        imageAssets = assets.map({ asset in
            var number = ""
            if let currentInSelectAsset = selectedAssets.first(where: { assetInfo in
                return assetInfo.asset.localIdentifier == asset.localIdentifier
            }){
                number = currentInSelectAsset.number
            }
            return (asset, number)
        })
    }
    
    //MARK:******************************collectionViewdelegate************************************
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageSelectCell_cell", for: indexPath) as! ImageSelectCell
        if photoLibraryAuthorIsLimited{
            if indexPath.row == imageAssets.count - 1{
                cell.imageV.image = UIImage.init(named: "icon_addimage")
                cell.coverView.isHidden = true
                cell.selectBtn.isHidden  = true
                return cell
            }
            else{
                
                cell.coverView.isHidden = false
                cell.selectBtn.isHidden  = false
                imageFromAsset(imageAssets[indexPath.row].asset) { image in cell.imageV.image = image}
                cell.selectBtn.tag = indexPath.row
                cell.selectBtn.isSelected = currentSelectedImageAssets.contains(where: { asset in
                    asset.asset.localIdentifier.isEqual(imageAssets[indexPath.row].asset.localIdentifier)
                })
                cell.selectBtn.addTarget(self, action: #selector(selectBtnClick), for: .touchUpInside)
                if currentSelectedImageAssets.count < 9 && !cell.selectBtn.isSelected{
                    cell.coverView.alpha = 0
                }
                else if (currentSelectedImageAssets.count) <= 9 && cell.selectBtn.isSelected{
                    cell.coverView.alpha = 0.35
                } else {
                    cell.coverView.alpha = 1
                }
                
                cell.selectBtn.isEnabled = (currentSelectedImageAssets.count) < 9 || cell.selectBtn.isSelected ? true : false
                cell.numberLabel.isHidden = cell.selectBtn.isSelected ? false : true
                cell.numberLabel.text = imageAssets[indexPath.row].number
                return cell
            }
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageSelectCell_cell", for: indexPath) as! ImageSelectCell
            imageFromAsset(imageAssets[indexPath.row].asset) { image in cell.imageV.image = image}
            cell.selectBtn.tag = indexPath.row
            cell.selectBtn.isSelected = currentSelectedImageAssets.contains(where: { asset in
                asset.asset.localIdentifier.isEqual(imageAssets[indexPath.row].asset.localIdentifier)
            })
            cell.selectBtn.addTarget(self, action: #selector(selectBtnClick), for: .touchUpInside)
            if currentSelectedImageAssets.count < 9 && !cell.selectBtn.isSelected{
                cell.coverView.alpha = 0
            }
            else if (currentSelectedImageAssets.count) <= 9 && cell.selectBtn.isSelected{
                cell.coverView.alpha = 0.35
            } else {
                cell.coverView.alpha = 1
            }
            
            cell.selectBtn.isEnabled = (currentSelectedImageAssets.count) < 9 || cell.selectBtn.isSelected ? true : false
            cell.numberLabel.isHidden = cell.selectBtn.isSelected ? false : true
            cell.numberLabel.text = imageAssets[indexPath.row].number
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if photoLibraryAuthorIsLimited{
            if indexPath.row == imageAssets.count - 1{
                if #available(iOS 14, *) {
                    PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
                    PHPhotoLibrary.shared().register(self)
                }
            }
            else{
                if currentSelectedImageAssets.count == maxCount {
                    DispatchQueue.main.async {
                        self.present(UIAlertController.init(title: "最多选择\(self.maxCount)张照片", closeTitle: "确定"), animated: true, completion: nil)
                    }
                    return
                }
                let con = BrowserImageController.init(assets: imageAssets, currentSelected: currentSelectedImageAssets, currentIndexPath: indexPath)
                navigationController?.pushViewController(con, animated: true)
                con.browserImageCallback = { [weak self]assets in
                    self?.currentSelectedImageAssets = assets
                    self?.reSetAsset()
                }
            }
        }
        else{
            if currentSelectedImageAssets.count == maxCount {
                DispatchQueue.main.async {
                    self.present(UIAlertController.init(title: "最多选择\(self.maxCount)张照片", closeTitle: "确定"), animated: true, completion: nil)
                }
                return
            }
            let con = BrowserImageController.init(assets: imageAssets, currentSelected: currentSelectedImageAssets, currentIndexPath: indexPath)
            navigationController?.pushViewController(con, animated: true)
            con.browserImageCallback = { [weak self]assets in
                self?.currentSelectedImageAssets = assets
                self?.setCollectionAssetNumber(self?.assetsFromAlbum ?? [], selectedAssets: assets)
                self?.navigationItem.rightBarButtonItem?.title = "完成(\(self?.currentSelectedImageAssets.count ?? 0)/\(self?.maxCount ?? 9))"
                collectionView.reloadData()
            }
        }
        
    }
}


extension SelectImageController: PHPhotoLibraryChangeObserver{
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        reSetAsset()
    }
}


class ImageCollectionLayout: UICollectionViewFlowLayout{
    
    override func prepare() {
        itemSize = CGSize.init(width: (collectionView!.width - 25) * 0.25, height: (collectionView!.width - 25) * 0.25)
        minimumLineSpacing = 5
        minimumInteritemSpacing = 5
        super.prepare()
    }
    
}


