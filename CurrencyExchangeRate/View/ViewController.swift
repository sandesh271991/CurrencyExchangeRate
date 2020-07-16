//
//  ViewController.swift
//  CurrencyExchangeRate
//
//  Created by Sandesh on 15/07/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var relativeToDoller: Double = 0
    var selectedCurrency = ""
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var btnSelectedCurrency: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    var currencyKeyList = [String]()
    var currencyValueList = [String]()
    
    var currenciesViewModel: CurrenciesViewModel?
    var currencyData: CurrencyData? {
        
        didSet {
            guard let currencyData = currencyData else { return }
            currenciesViewModel = CurrenciesViewModel.init(currencyData: currencyData)
            
            DispatchQueue.main.async {
                self.currencyKeyList = self.currenciesViewModel!.currencies.map { return $0.key }
                print(self.currencyKeyList)
                
                self.currencyValueList = self.currenciesViewModel!.currencies.map { return $0.value }
                print(self.currencyValueList)
            }
        }
    }
    
    var exchangeRateKeyList = [String]()
    var exchangeRateValueList = [Double]()
    
    var exchangeRateViewModel: ExchangeRateViewModel?
    var exchangeRateData: ExchangeRateData? {
        
        didSet {
            guard let exchangeRateData = exchangeRateData else { return }
            exchangeRateViewModel = ExchangeRateViewModel.init(exchangeRateData: exchangeRateData)
            
            DispatchQueue.main.async {
                self.exchangeRateKeyList = self.exchangeRateViewModel!.exchangeRate.map { return $0.key }
                print(self.exchangeRateKeyList)
                
                self.exchangeRateValueList = self.exchangeRateViewModel!.exchangeRate.map { return $0.value }
                print(self.exchangeRateValueList)
                
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.fetchCurreniesData()
        self.fetchExchangeRateData()
    }
    
    @objc func fetchCurreniesData() {
        
        if isConnectedToInternet() == true {
            let webserviceURLNew = webserviceURL + "list?access_key=" + accessToken
            
            Webservice.shared.getCurreniesData(with: webserviceURLNew) { (currencyData, error) in
                
                if error != nil {
                    return
                }
                guard let currencyData = currencyData else {return}
                self.currencyData = currencyData
            }
        } else {
            showAlert(title: "No Internet Connection", message: "Please check your internet connection")
        }
    }
    
    
    @objc func fetchExchangeRateData() {
        
        if isConnectedToInternet() == true {
            let webserviceURLNew = webserviceURL + "live?access_key=" + accessToken + "&format=1"
            
            Webservice.shared.getExchangeRateData(with: webserviceURLNew) { (exchangeRateData, error) in
                
                if error != nil {
                    return
                }
                guard let exchangeRateData = exchangeRateData else {return}
                self.exchangeRateData = exchangeRateData
                //self.createData()
            }
        } else {
            showAlert(title: "No Internet Connection", message: "Please check your internet connection")
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exchangeRateKeyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exchangeRateCell", for: indexPath) as! ExchangeRateCollectionViewCell
        cell.lblExchangeCurrency.text = exchangeRateKeyList[indexPath.row]
        cell.lblExchangeRate.text = "\((exchangeRateValueList[indexPath.row]).roundToDecimal(2))"
        
        if !txtAmount.text!.isEmpty || (txtAmount.text! as NSString).doubleValue > 0 {
            let exchangedValue = (relativeToDoller * exchangeRateValueList[indexPath.row])
            cell.lblExchangeAmount.text = "\(txtAmount.text!) \(selectedCurrency) = \(exchangeRateKeyList[indexPath.row].suffix(3)) \(exchangedValue.roundToDecimal(2))"
            cell.lblExchangeAmount.isHidden = false
        }
        else{
            cell.lblExchangeAmount.isHidden = true
        }
        return cell
    }
    
    
    
    @IBAction func btnSelectCurrency(_ sender: Any) {
        if txtAmount.text!.isEmpty || (txtAmount.text! as NSString).doubleValue <= 0 {
            showAlert(title: "Please enter amount to convert", message: "")
        }
        else{
            picker = UIPickerView.init()
            picker.delegate = self
            self.picker.dataSource = self
            picker.backgroundColor = UIColor.white
            picker.setValue(UIColor.black, forKey: "textColor")
            picker.autoresizingMask = .flexibleWidth
            picker.contentMode = .center
            picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            self.view.addSubview(picker)
            
            toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
            toolBar.barStyle = .default
            toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
            self.view.addSubview(toolBar)
        }
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        collectionView.reloadData()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyKeyList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(currencyKeyList[row]): \(currencyValueList[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let exchnageRateCode = "USD" + currencyKeyList[row]
        let exchnageRateCodeIndex = exchangeRateKeyList.firstIndex(of: exchnageRateCode)
        
        let exchangeRate = exchangeRateValueList[exchnageRateCodeIndex ?? 0]
        relativeToDoller  = (1 *  (txtAmount.text! as NSString).doubleValue) / exchangeRate
        selectedCurrency = currencyKeyList[row]
        btnSelectedCurrency.setTitle("\(currencyKeyList[row])", for: .normal)
    }
}


extension ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }
}
