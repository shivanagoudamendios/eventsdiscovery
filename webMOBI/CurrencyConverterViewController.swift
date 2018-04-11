//
//  CurrencyConverterViewController.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/20/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper

class CurrencyConverterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
//    @available(iOS 2.0, *)
    
    @IBOutlet var txtFieldToCurrency: UITextField!
    @IBOutlet var txtFieldFromCurrency: UITextField!
    @IBOutlet var txtFieldToValue: UITextField!
    @IBOutlet var txtFieldFromValue: UITextField!
    
    let fromCurrencyPicker = UIPickerView()
    let toCurrencyPicker = UIPickerView()
    
    var listOfCurrencyCountries : [String] = []
    var listOfCurrencyCountriesIds : [String] = []
    var bytes: NSMutableData?
    var data : [String : AnyObject] = [:]
    var toCurrencyId : String = ""
    var fromCurrencyId : String = ""
    
    @IBAction func editingFromField(sender: AnyObject) {
        let textField = sender as! UITextField
        if(textField.text != ""){
            convertTheValue(textField: textField)
        }
    }
    @IBAction func editingToField(sender: AnyObject) {
        let textField = sender as! UITextField
        if(textField.text != ""){
            convertTheValue(textField: textField)
        }
    }
    
    let defaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        
        if let themeclr = defaults.string(forKey: "themeColor"){
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
        }
        //********* From Currency picker *******
        fromCurrencyPicker.delegate = self
        fromCurrencyPicker.layer.backgroundColor = UIColor.white.cgColor
        fromCurrencyPicker.tag = 1
        self.txtFieldFromCurrency.inputView = fromCurrencyPicker
        fromCurrencyPickerMethod(fromCurrencyPicker: fromCurrencyPicker)
        
        //********* To Currency picker *******
        toCurrencyPicker.delegate = self
        toCurrencyPicker.layer.backgroundColor = UIColor.white.cgColor
        toCurrencyPicker.tag = 1
        self.txtFieldToCurrency.inputView = fromCurrencyPicker
        toCurrencyPickerMethod(toCurrencyPicker: toCurrencyPicker)
        
        txtFieldToValue.delegate = self
        txtFieldFromValue.delegate = self
        
        if let path = Bundle.main.path(forResource: "currency_countries", ofType: "json")
        {
            do{
                let jsonData = try NSData(contentsOfFile: path, options: .mappedIfSafe)
                
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments) as? NSDictionary
                    let data = (jsonResult!["results"] as? [NSDictionary])!
                    let count = data.count
                    for index in 1 ..< count{
                        listOfCurrencyCountries.append((Mapper<Currency>().map(JSONObject: data[index])?.currencyName)!)
                        listOfCurrencyCountriesIds.append((Mapper<Currency>().map(JSONObject: data[index])?.id)!)
                    }
                    
                } catch {
                    print(error)
                }
            }catch {
                print(error)
            }
            fromCurrencyPicker.selectRow(0, inComponent: 0, animated: false)
            toCurrencyPicker.selectRow(0, inComponent: 0, animated: false)
            super.viewDidLoad()
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    //******* From Currency picker START*****************
    func fromCurrencyPickerMethod(fromCurrencyPicker : UIPickerView){
        // Creates the toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .black
        toolBar.isTranslucent = true
        toolBar.backgroundColor = UIColor.white
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        
        // Adds the buttons
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CurrencyConverterViewController.fromcurrencydoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CurrencyConverterViewController.fromcurrencycancelClick))
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        //Create the view
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        inputView.layer.backgroundColor = UIColor.clear.cgColor
        fromCurrencyPicker.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240)
        
        inputView.addSubview(fromCurrencyPicker) // add date picker to UIView
        
        txtFieldFromCurrency.inputView = inputView
        txtFieldFromCurrency.inputAccessoryView = toolBar
    }
    func fromcurrencydoneClick(){
        txtFieldFromCurrency.text = listOfCurrencyCountries[fromCurrencyPicker.selectedRow(inComponent: 0)]
        fromCurrencyId = listOfCurrencyCountriesIds[fromCurrencyPicker.selectedRow(inComponent: 0)]
        txtFieldFromCurrency.resignFirstResponder()
    }
    func fromcurrencycancelClick(){
        txtFieldFromCurrency.resignFirstResponder()
    }
    //******* From Currency picker  END*****************
    //******* To Currency picker START*****************
    func toCurrencyPickerMethod(toCurrencyPicker : UIPickerView){
        // Creates the toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .black
        toolBar.isTranslucent = true
        toolBar.backgroundColor = UIColor.white
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        
        // Adds the buttons
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CurrencyConverterViewController.tocurrencydoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CurrencyConverterViewController.tocurrencycancelClick))
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        //Create the view
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        inputView.layer.backgroundColor = UIColor.clear.cgColor
        toCurrencyPicker.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240)
        
        inputView.addSubview(toCurrencyPicker) // add date picker to UIView
        
        txtFieldToCurrency.inputView = inputView
        txtFieldToCurrency.inputAccessoryView = toolBar
    }
    func tocurrencydoneClick(){
        txtFieldToCurrency.text = listOfCurrencyCountries[toCurrencyPicker.selectedRow(inComponent: 0)]
        toCurrencyId = listOfCurrencyCountriesIds[toCurrencyPicker.selectedRow(inComponent: 0)]
        txtFieldToCurrency.resignFirstResponder()
    }
    func tocurrencycancelClick(){
        txtFieldToCurrency.resignFirstResponder()
    }
    //******* To Currency picker  END*****************
    
    //    Set number of components in picker view
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
//    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
//        return 1
//        
//    }
    //    Set number of rows in components
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(pickerView.tag == 1){
            return (listOfCurrencyCountries.count)
        }else{
            return 0
        }
        
    }
    //    Set title for each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var res: String = "";
        if(pickerView.tag == 1){
            res = listOfCurrencyCountries[row]
        }
        return res
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "CurrencyConverter"
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        if(defaults.value(forKey: "fromhome") as! Bool == false)
        {
            self.setNavigationBarItem()
        }
        let dat = getJSON(urlToRequest: "http://openexchangerates.org/api/latest.json?app_id=06f51a26b46f473cb0c3ff99a8244031")
        let dic = parseJSON(inputData: dat)
        data = (dic["rates"] as? [String : AnyObject])!
        
    }
    func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOf: NSURL(string: urlToRequest)! as URL)!
    }
    
    func parseJSON(inputData: NSData) -> NSDictionary{
        do {
            let boardsDictionary: NSDictionary = try JSONSerialization.jsonObject(with: inputData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            
            return boardsDictionary
            
        } catch {
            print(error)
        }
        return [:]
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(textField.text != ""){
            convertTheValue(textField: textField)
        }
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField){
        if(textField.text != ""){
            convertTheValue(textField: textField)
        }
    }
    func convertTheValue(textField : UITextField){
        if(textField == txtFieldFromValue){
            
            for key in data.keys{
                if(key == fromCurrencyId){
                    fromConverter(fromCurrencyRate: String(describing: data[fromCurrencyId]!),toCurrencyRate: String(describing: data[toCurrencyId]!))
                }
            }
        }else{
            for key in data.keys{
                if(key == toCurrencyId){
                    toConverter(fromCurrencyRate: String(describing: data[fromCurrencyId]!),toCurrencyRate: String(describing: data[toCurrencyId]!))
                }
            }
        }
        
    }
    func fromConverter(fromCurrencyRate : String, toCurrencyRate : String){
        let ratio : Double = Double(fromCurrencyRate)! / Double(toCurrencyRate)!
        let textField = txtFieldFromValue.text!
        if(textField != ""){
            txtFieldToValue.text = String(Double(textField)! / ratio)
        }
    }
    func toConverter(fromCurrencyRate : String, toCurrencyRate : String){
        let ratio : Double = Double(fromCurrencyRate)! / Double(toCurrencyRate)!
        let textField = txtFieldToValue.text!
        if(textField != ""){
            txtFieldFromValue.text = String(Double(textField)! * ratio)
        }
    }
    
    
}
