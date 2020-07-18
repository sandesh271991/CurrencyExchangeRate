//
//  Viewcontroller+CollectionView.swift
//  CurrencyExchangeRate
//
//  Created by Sandesh on 18/07/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation
import UIKit

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exchangeRateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: exchangeRateCell, for: indexPath) as! ExchangeRateCollectionViewCell
        cell.lblExchangeCurrency.text = exchangeRateList[indexPath.row].exchangeRateCode
        cell.lblExchangeRate.text = "\((exchangeRateList[indexPath.row].exchangeRateValue).roundToDecimal(2))"
        
        if !txtAmount.text!.isEmpty && (txtAmount.text! as NSString).doubleValue > 0 && btnSelectedCurrency.titleLabel?.text != selectCurrency {
            let exchangedValue = (relativeToDoller * exchangeRateList[indexPath.row].exchangeRateValue)
            
            if let exchangeRateCode = exchangeRateList[indexPath.row].exchangeRateCode {
                cell.lblExchangeAmount.text = "\(txtAmount.text!) \(selectedCurrency) = \(exchangeRateCode!.suffix(3)) \(exchangedValue.roundToDecimal(2))"
            }
            
            cell.lblExchangeAmount.isHidden = false
        }
        else{
            cell.lblExchangeAmount.isHidden = true
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size - 20)
    }
}


