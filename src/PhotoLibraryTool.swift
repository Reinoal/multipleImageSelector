//
//  ImagePicker.swift
//  Discover
//
//  Created by lansoft on 2021/9/16.
//

import Foundation
import UIKit
import Photos
import PhotosUI

let isLimitedVisit = "isLimitedVisit"
func imageFromAsset( _ asset: PHAsset, _ size: CGSize = CGSize.init(width: 500, height: 500), result:@escaping (UIImage?)->Void){
    let manager = PHImageManager.default()
    let options = PHImageRequestOptions.init()
    manager.requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFit, options: options) { image, info in
        
        result(image)
    }
}

class PhotoLibraryTool {
    
    static let shared: PhotoLibraryTool = PhotoLibraryTool()
    
    func getAlbumAssets() -> [PHAsset]{
        var result:[PHAsset] = []
        let options = PHFetchOptions.init()
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        let assets = PHAsset.fetchAssets(with: .image, options: options)
        assets.enumerateObjects { ass, index, stop in
            result.append(ass)
        }
        return result
    }
    
    func checkCameraAuthorization(_ target: UIViewController, _ authorResult:@escaping (Bool)->Void){
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted{
                authorResult(true)
            }
            else{
                
                self.showAlertCameraAuthorization(target)
            }
        }
    }
    
    func checkPhotoLibraryAuthorization(_ target: UIViewController, _ authorResult:@escaping (PhotoLibraryStatus)->Void){
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                if status == PHAuthorizationStatus.authorized{
                    DispatchQueue.main.async {
                        authorResult(.authorized)
                    }
                }
                else if status == PHAuthorizationStatus.limited{
                    DispatchQueue.main.async {
                        authorResult(.limited)
                    }
                }
                else{
                    self.showAlertPhotoAuthorization(target)
                }
            }
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                if status == PHAuthorizationStatus.authorized{
                    DispatchQueue.main.async {
                        authorResult(.authorized)
                    }
                }
                else{
                    self.showAlertPhotoAuthorization(target)
                }
            }
        }
        
    }
    
    private func showAlertCameraAuthorization(_ target: UIViewController){
        let con = UIAlertController.init(title: "相册未授权", message: "是否跳转到授权界面", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "去授权", style: .default) { _ in
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        let no = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        con.addAction(no)
        con.addAction(ok)
        DispatchQueue.main.async {
            target.present(con, animated: true, completion: nil)
        }
    }
    
    private func showAlertPhotoAuthorization(_ target: UIViewController){
        let con = UIAlertController.init(title: "相册未授权", message: "是否跳转到授权界面", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "去授权", style: .default) { _ in
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        let no = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        con.addAction(no)
        con.addAction(ok)
        DispatchQueue.main.async {
            target.present(con, animated: true, completion: nil)
        }
    }
    
}




