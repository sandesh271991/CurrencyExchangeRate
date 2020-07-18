//
//  ViewController.swift
//  CurrencyExchangeRate
//
//  Created by Sandesh on 15/07/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    var relativeToDoller: Double = 0
    var selectedCurrency = ""
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var btnSelectedCurrency: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    var currencyList = [AnyObject]()
    var exchangeRateList = [AnyObject]()
    
    var currenciesViewModel: CurrenciesViewModel?
    var currencyData: CurrencyData? {
        
        didSet {
            guard let currencyData = currencyData else { return }
            currenciesViewModel = CurrenciesViewModel.init(currencyData: currencyData)
        }
    }
    
    var exchangeRateViewModel: ExchangeRateViewModel?
    var exchangeRateData: ExchangeRateData? {
        
        didSet {
            guard let exchangeRateData = exchangeRateData else { return }
            exchangeRateViewModel = ExchangeRateViewModel.init(exchangeRateData: exchangeRateData)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchCurreniesData()
        self.fetchExchangeRateData {[weak self] (success) in
            
            if success {
                self?.retrieveExchangeRateData()
            }
        }
        txtAmount.delegate = self
    }
    
    
    // MARK: API Calling to get data
    @objc func fetchCurreniesData() {
        if isConnectedToInternet() == true &&  isNotCalledInLast30Min() {
            let webserviceURLNew = webserviceURL + "list?access_key=" + accessToken
            
            Webservice.shared.getCurreniesData(with: webserviceURLNew) { (currencyData, error) in
                
                if error != nil {
                    return
                }
                guard let currencyData = currencyData else {return}
                self.currencyData = currencyData
                CoreManager.shared.saveCurrencyListData(currencies: self.currenciesViewModel!.currencies)
            }
        } else {
            self.showAlert(title: "No Internet Connection", message: "Please check your internet connection")
        }
    }
    
    
    @objc func fetchExchangeRateData(completion:  @escaping (Bool)->Void) {
        
        if isConnectedToInternet() == true &&  isNotCalledInLast30Min() {
            let webserviceURLNew = webserviceURL + "live?access_key=" + accessToken + "&format=1"
            
            Webservice.shared.getExchangeRateData(with: webserviceURLNew) { (exchangeRateData, error) in
                
                if error != nil {
                    completion(false)
                    return
                }
                guard let exchangeRateData = exchangeRateData else {return}
                self.exchangeRateData = exchangeRateData
                CoreManager.shared.saveExchangeRateData(exchangeRate: self.exchangeRateViewModel!.exchangeRate)
                completion(true)
            }
        } else {
            self.showAlert(title: "No Internet Connection", message: "Please check your internet connection")
            completion(true)
        }
    }
    
    // MARK: To check if API called in last 30 min
    func isNotCalledInLast30Min() -> Bool {
        let lastTime  = UserDefaults.standard.double(forKey:"lastTime")
        
        let currentTime = Date().timeIntervalSince1970
        
        let defaults = UserDefaults.standard
        defaults.set(currentTime, forKey: "lastTime")
        if (lastTime == 0 || currentTime - lastTime >= 30.0 * 60){
            return true
        }
        else{
            return false
        }
    }
    
    
    @IBAction func btnSelectCurrency(_ sender: Any) {
        if txtAmount.text!.isEmpty || (txtAmount.text! as NSString).doubleValue <= 0 {
            showAlert(title: "Please enter amount to convert", message: "")
        }
        else{
            self.retrieveCurrencyListData()
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
    
    
    // MARK: TextFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btnSelectedCurrency.setTitle(selectCurrency, for: .normal)
        selectedCurrency = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        collectionView.reloadData()
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        collectionView.reloadData()
    }

    // MARK: To get relative doller rate for selected currency
    func getRateRelativeToDoller(exchangeRate: Double, amount: Double) -> Double{
        let relativeToDoller  = (1 *  (txtAmount.text! as NSString).doubleValue) / exchangeRate
        return relativeToDoller
    }
    
    // MARK: To get data from Core Data
    func retrieveCurrencyListData() {
        
        currencyList.removeAll()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: currencyLocalData)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                currencyList.append(data)
            }
        } catch {
            print("Failed")
        }
    }
    
    
    func retrieveExchangeRateData() {
        
        exchangeRateList.removeAll()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: exchangeRateLocalData )
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                exchangeRateList.append(data)
            }
        } catch {
            print("Failed")
        }
    }
}


