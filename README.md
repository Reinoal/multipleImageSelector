# multipleImageSelector

#### 介绍
类似微信的图片选择，使用超简单，多图片选择器

#### 软件架构
软件架构说明


#### 使用教程
通过PHImageManager从PHAsset获取图片即可
`func imageFromAsset( _ asset: PHAsset, _ size: CGSize = CGSize.init(width: 500, height: 500), result:@escaping (UIImage?)->Void){
    let manager = PHImageManager.default()
    let options = PHImageRequestOptions.init()
    manager.requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFit, options: options) { image, info in
        
        result(image)
    }
}`
currentSelectedImageAssets：当前已经选中的PHAsset，数组类型为[(PHAsset, String)] 里面是元组放PHAsset和当前这个资源选中的排序数字，使用的时候用这样的数组数据就可以了，拿到数组后只要用到PHAsset，其他的可以不用管
maxImageCount： 最多可以选择几张

```
let con = SelectImageController.init(currentSelectedAssets: currentSelectedImageAssets, maxImageCount)
        let nav = UINavigationController.init(rootViewController: con)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
        con.selectedImageCallback = {[weak self] assets in
            self?.setImages(assets)
        }
```



直接使用就行，有问题提交哦