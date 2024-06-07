//
//  CalenderViewController.swift
//  KoreBotSDKDemo
//
//  Created by Kartheek Pagidimarri on 7/13/20.
//  Copyright © 2020 Kore. All rights reserved.
//

import UIKit
protocol calenderSelectDelegate {
    func optionsButtonTapNewAction(text:String, payload:String)
}
class CalenderViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    var dataString: String!
    var messageId: String!
    var kreMessage: KREMessage!
    var selectedFromDate : String?
    var selectedToDate : String?
    
    var selectedPayloadFromDate : String?
    var selectedPayloadToDate : String?
    
    var comp = NSDateComponents()
    var viewDelegate: calenderSelectDelegate?
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var fromDateView: UIView!
    @IBOutlet weak var fromYearLabel: UILabel!
    @IBOutlet weak var fromDateLabel: UILabel!
    
    
    @IBOutlet weak var dateRangeView: UIView!
    @IBOutlet weak var dateRangeSubView: UIView!
    @IBOutlet weak var fromDateButton: UIButton!
    @IBOutlet weak var toDateButton: UIButton!
    
    @IBOutlet weak var fromDateRangeLabel: UILabel!
    @IBOutlet weak var toDateRangeLabel: UILabel!
    var formte: String?
    
    var templateType : String?
    var startdateString : String?
    var endDateString : String?
    let dateFormatter = DateFormatter()
    var compareEndDate : String?
    let bundle = KREResourceLoader.shared.resourceBundle()
      var isStartDateComing = false
    
    // MARK: init
       init(dataString: String, chatId: String, kreMessage: KREMessage) {
           super.init(nibName: "CalenderViewController", bundle: bundle)
           self.dataString = dataString
           self.messageId = chatId
           self.kreMessage = kreMessage
       }
    
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        headingLabel.font = UIFont(name: "29LTBukra-Semibold", size: 16.0)
        confirmButton.titleLabel?.font = UIFont(name: "29LTBukra-Medium", size: 17.0)
        
        fromYearLabel.font = UIFont(name: "29LTBukra-Regular", size: 17.0)
        fromDateLabel.font = UIFont(name: "29LTBukra-Bold", size: 21.0)
        
        fromDateRangeLabel.font = UIFont(name: "29LTBukra-Bold", size: 14.0)
        toDateRangeLabel.font = UIFont(name: "29LTBukra-Bold", size: 14.0)
        
        headingLabel.textColor =  UIColor.init(hexString: (brandingShared.widgetTextColor) ?? "#26344A")
        confirmButton.backgroundColor = UIColor.init(hexString: (brandingShared.buttonActiveBgColor) ?? "#26344A")
        if preferred_language_Type == preferredLanguage{
            headingLabel.textAlignment = .right
            confirmButton.setTitle("تؤكد", for: .normal)
        }
        
        confirmButton.setTitleColor(UIColor.init(hexString: (brandingShared.buttonActiveTextColor) ?? "#FFFFFF"), for: .normal)
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.backgroundColor = .white
            datePicker.sizeToFit()
        }
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        if #available(iOS 11.0, *) {
            self.bgView.roundCorners([ .layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10.0, borderColor: UIColor.clear, borderWidth: 1.5)
        }
        
        datePicker.addTarget(self, action: #selector(CalenderViewController.datePickerChanged(datePicker:)), for: UIControl.Event.valueChanged)
        dateRangeSubView.layer.cornerRadius = 5.0
        dateRangeSubView.clipsToBounds = true
        dateRangeSubView.layer.borderWidth = 1.0
        dateRangeSubView.layer.borderColor = UIColor.lightGray.cgColor
        getData()
    }

    @IBAction func clickOnCloseButton(_ sender: Any) {
        calenderCloseTag = true
         self.dismiss(animated: true, completion: nil)
    }
    func getData(){
        let jsonObject: NSDictionary = Utilities.jsonObjectFromString(jsonString: dataString!) as! NSDictionary
        let jsonDecoder = JSONDecoder()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject as Any , options: .prettyPrinted),
            let allItems = try? jsonDecoder.decode(Componentss.self, from: jsonData) else {
                                        return
            }
        
        let formaterStr = allItems.format ?? "MM-dd-yyyy"
        formte = formaterStr.replacingOccurrences(of: "D", with: "d")
        formte = formte!.replacingOccurrences(of: "Y", with: "y")
        dateFormatter.dateFormat = formte
        let todayDate = dateFormatter.string(from: Date())
        
        let currentDate = Date()
        var dateComponent = DateComponents()
         dateComponent.year = 1
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        let futureDateStr = dateFormatter.string(from: futureDate ?? Date())
        
        headingLabel.text = allItems.title ?? "Please Choose"
        endDateString = allItems.endDate ?? futureDateStr
        templateType = allItems.template_type ?? ""
        startdateString = allItems.startDate ?? todayDate
        compareEndDate = allItems.endDate ?? ""
        if allItems.startDate != nil{
            isStartDateComing = true
        }

        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = formte
        let fromDate: NSDate? = dateFormatterGet.date(from: startdateString!) as NSDate?
        let startDateNew = (dateFormatterGet.string(from: fromDate! as Date))
        print(startDateNew)
        let toDate: NSDate? = dateFormatterGet.date(from: endDateString!) as NSDate?
        let toDateNew = (dateFormatterGet.string(from: toDate! as Date))
        print(toDateNew)
        
        
        if templateType == "daterange" {
            datePicker.setDate(toDate! as Date, animated: true) // todate showing in TextFeild
            datePickerOfMinimumMaximum(minimumdate: toDate! as Date, maximumDate: toDate! as Date)
            datePicker.setDate(fromDate! as Date, animated: true)  //fromdate showing in TextFeild
            clickOnFromDateRangeViewButton(fromDateButton as Any)
            dateRangeView.isHidden = false
        }else{
            datePickerTemplateOfMinimumMaximum(minimumdate: fromDate! as Date, maximumDate: toDate! as Date)
            dateRangeView.isHidden = true
            fromDateButton.isUserInteractionEnabled = false
            fromYearLabel.textAlignment = .left
            fromDateLabel.textAlignment = .left
        }
       
    }
    
    @objc func datePickerChanged(datePicker:UIDatePicker){
       selectDate(datePicker: datePicker)
    }
    func selectDate(datePicker:UIDatePicker){
        let dayOfweek = datePicker.date.dayOfWeek()! as String
        let year = datePicker.date.year()! as String
        let day = datePicker.date.day()! as String
        let monthName = datePicker.date.monthName()! as String
        let month = datePicker.date.month()! as String
        
        if templateType == "daterange" {
            if fromDateButton.isSelected {
                fromDateRangeLabel.text = "Start: \(monthName) \(day), \(year)"
                selectedFromDate = datePicker.date.currentDate()! as Any as? String
                selectedPayloadFromDate = "\(month)/\(day)/\(year)"
            }else{
                toDateRangeLabel.text = "End: \(monthName) \(day), \(year)"
                selectedToDate = datePicker.date.currentDate()! as Any as? String
                selectedPayloadToDate = "\(month)/\(day)/\(year)"
            }
        }else{
            fromYearLabel.text = year
            fromDateLabel.text = "\(dayOfweek), \(monthName) \(day)"
            selectedFromDate = datePicker.date.currentDate()! as Any as? String
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func clickOnFromDateRangeViewButton(_ sender: Any) {
        fromDateButton.isSelected = true
        toDateButton.isSelected = false
        fromDateButton.backgroundColor = themeColor
        toDateButton.backgroundColor = .clear
        fromDateRangeLabel.textColor = .white
        toDateRangeLabel.textColor = .black
    
        dateFormatter.dateFormat = formte
        
        if isStartDateComing{
            let startDate = dateFormatter.date(from: (startdateString!)) //selectedFromDate
            let endaDate = dateFormatter.date(from: (endDateString!))
            print(startDate as Any)
            datePickerOfMinimumMaximum(minimumdate: startDate ?? Date(), maximumDate: endaDate ?? Date())
        }else{
            let startDate = dateFormatter.date(from: (endDateString!))
            print(startDate as Any)
            datePickerOfMinimumMaximum(minimumdate: startDate ?? Date(), maximumDate: startDate ?? Date())
        }
    }
    
    @IBAction func clickOnToDateRangeViewButton(_ sender: Any) {
        fromDateButton.isSelected = false
        toDateButton.isSelected = true
        toDateButton.backgroundColor = themeColor
        fromDateButton.backgroundColor = .clear
        fromDateRangeLabel.textColor = .black
        toDateRangeLabel.textColor = .white
        
        dateFormatter.dateFormat = formte
        let startDate = dateFormatter.date(from: selectedFromDate!)
        let endDate = dateFormatter.date(from: endDateString!)
        print(startDate as Any)
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: startDate!)
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to:endDate!)
        datePicker.setDate(Date(), animated: true)
        selectDate(datePicker: datePicker)
    }
    
    func datePickerOfMinimumMaximum(minimumdate: Date, maximumDate: Date){
        if isStartDateComing{
            datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: minimumdate)
        }else{
            datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -10, to: minimumdate)
        }
        
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: maximumDate)
//        datePicker.setDate(Date(), animated: true)
        selectDate(datePicker: datePicker)
    }
    
    func datePickerTemplateOfMinimumMaximum(minimumdate: Date, maximumDate: Date){
        if compareEndDate == ""{
            datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: minimumdate)
            datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 10, to: maximumDate)
        }else{
            datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -10, to: minimumdate)
            datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: maximumDate)
        }
        datePicker.setDate(Date(), animated: true)
        selectDate(datePicker: datePicker)
    }
    
    @IBAction func clickConfirmBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        if templateType == "daterange" {
            //let selectedDates = ("\(selectedFromDate!) to \(selectedToDate!)")
            var changeFromDateformat = formattedDateFromString(dateString: selectedFromDate!, withFormat: "MMM dd, yyyy")
            var changeToDateformat = formattedDateFromString(dateString: selectedToDate!, withFormat: "MMM dd, yyyy")
            
            let dateFormatterUK = DateFormatter()
            dateFormatterUK.dateFormat = "MM-dd-yyyy"
            let fromDate = selectedFromDate!
            if let date = dateFormatterUK.date(from: fromDate) {
               
                // Use this to add st, nd, th, to the day
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .ordinal
                numberFormatter.locale = Locale.current
                
                //Set other sections as preferred
                let monthFormatter = DateFormatter()
                monthFormatter.dateFormat = "MMMM"
                
                // Works well for adding suffix
                let dayFormatter = DateFormatter()
                dayFormatter.dateFormat = "dd"
                
                // Works well for adding suffix
                let yearFormatter = DateFormatter()
                yearFormatter.dateFormat = "YYYY"
                
                let dayString = dayFormatter.string(from: date)
                let monthString = monthFormatter.string(from: date)
                let yearString = yearFormatter.string(from: date)
                
                // Add the suffix to the day
                let dayNumber = NSNumber(value: Int(dayString)!)
                let day = numberFormatter.string(from: dayNumber)!
                
                changeFromDateformat = "\(monthString) \(day), \(yearString)"
                
            }
            
            let toDate = selectedToDate!
            if let date = dateFormatterUK.date(from: toDate) {
               
                // Use this to add st, nd, th, to the day
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .ordinal
                numberFormatter.locale = Locale.current
                
                //Set other sections as preferred
                let monthFormatter = DateFormatter()
                monthFormatter.dateFormat = "MMMM"
                
                // Works well for adding suffix
                let dayFormatter = DateFormatter()
                dayFormatter.dateFormat = "dd"
                
                // Works well for adding suffix
                let yearFormatter = DateFormatter()
                yearFormatter.dateFormat = "YYYY"
                
                let dayString = dayFormatter.string(from: date)
                let monthString = monthFormatter.string(from: date)
                let yearString = yearFormatter.string(from: date)
                
                // Add the suffix to the day
                let dayNumber = NSNumber(value: Int(dayString)!)
                let day = numberFormatter.string(from: dayNumber)!
                
                changeToDateformat = "\(monthString) \(day), \(yearString)"
                
            }
            let selectedFromatDates = ("\(changeFromDateformat!) to \(changeToDateformat!)")
            let selectedPayloadFromatDates = ("\(selectedPayloadFromDate!) to \(selectedPayloadToDate!)")
            self.viewDelegate?.optionsButtonTapNewAction(text:selectedFromatDates , payload: selectedPayloadFromatDates)
        }else{
            
            var convertDateformat = formattedDateFromString(dateString: selectedFromDate!, withFormat: "MMM dd, yyyy")
            var convertDateformatPayload = formattedDateFromString(dateString: selectedFromDate!, withFormat: "MMM dd, yyyy")
            print(convertDateformat as Any)
            
            let dateFormatterUK = DateFormatter()
            dateFormatterUK.dateFormat = "MM-dd-yyyy"
            let fromDate = selectedFromDate!
            if let date = dateFormatterUK.date(from: fromDate) {
               
                // Use this to add st, nd, th, to the day
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .ordinal
                numberFormatter.locale = Locale.current
                
                //Set other sections as preferred
                let monthFormatter = DateFormatter()
                monthFormatter.dateFormat = "MMMM"
                
                // Works well for adding suffix
                let dayFormatter = DateFormatter()
                dayFormatter.dateFormat = "dd"
                
                // Works well for adding suffix
                let yearFormatter = DateFormatter()
                yearFormatter.dateFormat = "YYYY"
                
                let dayString = dayFormatter.string(from: date)
                let monthString = monthFormatter.string(from: date)
                let yearString = yearFormatter.string(from: date)
                
                // Add the suffix to the day
                let dayNumber = NSNumber(value: Int(dayString)!)
                let day = numberFormatter.string(from: dayNumber)!
                
                convertDateformat = "\(monthString) \(day), \(yearString)"
                convertDateformatPayload = "\(day) \(monthString) \(yearString)"
            }
            
            self.viewDelegate?.optionsButtonTapNewAction(text:convertDateformat! , payload:convertDateformatPayload!)
        }
    }
    
}
extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: self).capitalized
    }
    func year() -> String? {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy"
           return dateFormatter.string(from: self).capitalized
       }
    func day() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self).capitalized
    }
    func monthName() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self).capitalized
    }
    func currentDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: self).capitalized
    }
    func month() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self).capitalized
    }
    
}

func formattedDateFromString(dateString: String, withFormat format: String) -> String? {

    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "MM-dd-yyyy"

    if let date = inputFormatter.date(from: dateString) {

        let outputFormatter = DateFormatter()
      outputFormatter.dateFormat = format

        return outputFormatter.string(from: date)
    }

    return nil
}

