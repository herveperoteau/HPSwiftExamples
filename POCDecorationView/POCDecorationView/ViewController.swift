//
//  ViewController.swift
//  POCDecorationView
//
//  Created by Hervé Péroteau on 29/07/2017.
//  Copyright © 2017 Herve Peroteau. All rights reserved.
//

import UIKit


class MyLayout : UICollectionViewFlowLayout {

    private var fullLineLayer: CAShapeLayer?
    private var dottedLineLayer: CAShapeLayer?
    
    override init() {
        super.init()
        itemSize = CGSize(width: 200, height: 200)
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        
        print("MyLayout.prepare ...")

        super.prepare()
        
        fullLineLayer?.removeFromSuperlayer()
        dottedLineLayer?.removeFromSuperlayer()
        
        guard let collectionView = collectionView else {
            fatalError("pas de collectionView ???")
        }
        
        
        print ("contentSize:\(collectionView.contentSize.debugDescription), \(self.collectionViewContentSize.debugDescription)")

        // FullLine
        
        var shapeLayer = CAShapeLayer()
        
        fullLineLayer = shapeLayer
        
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.lineCap = "round"
        
        var path = CGMutablePath()
        let yLine = self.collectionViewContentSize.height/2
        let xMax = self.collectionViewContentSize.width/2
        path.addLines(between: [CGPoint(x: 0, y: yLine),
                                CGPoint(x: xMax, y: yLine)])
        
        shapeLayer.path = path
        shapeLayer.zPosition = -1

        collectionView.layer.addSublayer(shapeLayer)

        // DottedLine
        
        shapeLayer = CAShapeLayer()
        
        dottedLineLayer = shapeLayer
        
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.lineCap = "round"
        shapeLayer.lineDashPattern = [10, 10]
        
        path = CGMutablePath()
        path.addLines(between: [CGPoint(x: xMax, y: yLine),
                                CGPoint(x: self.collectionViewContentSize.width, y: yLine)])
        
        shapeLayer.path = path
        shapeLayer.zPosition = -1
        
        collectionView.layer.addSublayer(shapeLayer)
    }
    
    

}

class ViewController: UIViewController {
    
    fileprivate let countCell = 10
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        print("viewDidLoad ...")
        super.viewDidLoad()
        collectionView.collectionViewLayout = MyLayout()
    }
    
}


extension ViewController: UICollectionViewDataSource {
 
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("UICollectionViewDataSource.numberOfItemsInSection ...")
        return countCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("UICollectionViewDataSource.cellForItemAt \(indexPath.debugDescription) ...")
        return collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
    }
}

extension ViewController: UICollectionViewDelegate {
    
}
