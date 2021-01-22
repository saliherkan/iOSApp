//
//  KisiEkleVC.swift
//  EtsMobileApp
//
//  Created by Salih Erkan Sandal on 15.01.2021.
//

import Foundation
import UIKit

class KisiEkleVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var surNameView: UIView!
    @IBOutlet weak var birthdayDate: UIView!
    @IBOutlet weak var ePostView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    var datePicker :UIDatePicker!
    @IBOutlet weak var txtDatePicker: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var textField : UITextView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var noteField: UITextField!
    @IBOutlet weak var surNameTxt: UITextField!
    @IBOutlet weak var ePostaTxt: UITextField!
    @IBOutlet weak var telefonTxt: UITextField!
    @IBOutlet weak var noteTxtView: UITextView!
    var viewModel: KisiEkleVM = KisiEkleVM()
    @IBOutlet weak var nameUyariLbl: UILabel!
    @IBOutlet weak var surNameUyariLbl: UILabel!
    @IBOutlet weak var dogumUariLbl: UILabel!
    @IBOutlet weak var ePostaUyariLbl: UILabel!
    @IBOutlet weak var telefonUyariLbl: UILabel!
    @IBOutlet weak var notTxtField: UITextView!
    @IBOutlet weak var notUyariLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guncelle()
        title = viewModel.guncelVeri == nil ? "Kişi Ekle" : "Kişi Güncelle"
        saveBtn.setTitle(viewModel.guncelVeri == nil ? "Kaydet" : "Güncelle", for: .normal)
        naviBarIconItem()
        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func guncelle(){
        if let veri = viewModel.guncelVeri {
            nameTxt.text = veri.ad
            surNameTxt.text = veri.soyad
            txtDatePicker.text = veri.dogumTarihi
            ePostaTxt.text = veri.ePosta
            telefonTxt.text = veri.telefon
            notTxtField.text = veri.not
        }
    }
    
    func setupUI(){
        self.navigationController!.navigationBar.titleTextAttributes = [.font: UIFont(name: "HelveticaNeue-Bold", size: 30)!, .foregroundColor: UIColor.white ]
        nameTxt.delegate = self
        nameTxt.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        surNameTxt.delegate = self
        surNameTxt.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        telefonTxt.delegate = self
        telefonTxt.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        ePostaTxt.delegate = self
        ePostaTxt.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        nameTxt.textColor = #colorLiteral(red: 0.1921568627, green: 0.1921568627, blue: 0.1921568627, alpha: 1)
        surNameTxt.textColor = #colorLiteral(red: 0.1921568627, green: 0.1921568627, blue: 0.1921568627, alpha: 1)
        txtDatePicker.textColor = #colorLiteral(red: 0.1921568627, green: 0.1921568627, blue: 0.1921568627, alpha: 1)
        ePostaTxt.textColor = #colorLiteral(red: 0.1921568627, green: 0.1921568627, blue: 0.1921568627, alpha: 1)
        telefonTxt.textColor = #colorLiteral(red: 0.1921568627, green: 0.1921568627, blue: 0.1921568627, alpha: 1)
        notTxtField.textColor = #colorLiteral(red: 0.1921568627, green: 0.1921568627, blue: 0.1921568627, alpha: 1)
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        textField = notTxtField
        scrollView.delegate = self
        datePickers()
        //yuvarla isminde fonsiyonu extention olarak oluşturdum. UIView+Extentions sınıfında tanımladım
        noteView.yuvarla()
        nameView.yuvarla()
        surNameView.yuvarla()
        birthdayDate.yuvarla()
        ePostView.yuvarla()
        phoneView.yuvarla()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTxt || textField == surNameTxt{
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                    return false
                }
            }
            catch {
                print("ERROR")
            }
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 20
            //isim Soyisim Text'leri max 20 karakter olarak belirlendi
        }
        if textField == telefonTxt{
            do {
                let regex = try NSRegularExpression(pattern: ".*[^0-9].*", options: [])
                if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                    return false
                }
            }
            catch {
                print("ERROR")
            }
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 10
        }
        if textField == ePostaTxt{
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9@].*", options: [])
                if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                    return false
                }
            }
            catch {
                print("ERROR")
            }
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 60
        }
        return true
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.saveBtn.addGradiant()
    }
    func naviBarIconItem() {
        //navigation bar'da bulunan "ekle" butonuna image atandı. NavigationBar'a buton eklendi, butonun özellikleri eklendi
        var image = UIImage(named: "backBtn")!
        image = image.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem  = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
    }
    @objc func addTapped() {
        print("Ok")
        navigationController?.popViewController(animated: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    
    func datePickers() {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        txtDatePicker.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        txtDatePicker.text = dateFormatter.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        
        // reset back the content inset to zero after keyboard is gone
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @IBAction func saveBtnClick(_ sender: Any) {
        kontrolEt()
        
    }
    
    func olumsuzAlert(){
        let alert = UIAlertController(title: "Dikkat", message: "Bilgileri Kontrol Ediniz", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) { [weak self] in
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func olumluAlert(){
        let alert = UIAlertController(title: "Başarılı", message: "Kişi Kaydedildi", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) { [weak self] in
            alert.dismiss(animated: true, completion: nil)
        }
        
    }
    func kontrolEt(){
        let ad = nameTxt.text?.capitalized
        let soyad = surNameTxt.text?.capitalized
        let ePosta = ePostaTxt.text
        let telefon = telefonTxt.text
        let dogumTarihi = txtDatePicker.text
        let note = notTxtField.text
        let adSonuc = adKontrol()
        let soyadSonuc = soyadKontrol()
        let dogumTarihiSonuc = dogumTarihikontrol()
        let ePostaSonuc = ePostaKontol()
        let telefonSonuc = telefonKontrol()
        let notSonuc = notKontrol()
        if adSonuc && soyadSonuc && dogumTarihiSonuc && ePostaSonuc && telefonSonuc && notSonuc {
            let kisi = Veri(ad: ad!, soyad: soyad!, dogumTarihi: dogumTarihi!, ePosta: ePosta!, telefon: telefon!, not: note ?? "")
            if viewModel.guncelVeri == nil{
                viewModel.veriEkle(cek: kisi)
                print("abc")
            }else{
                viewModel.update(cek: kisi)
            }
            olumluAlert()
            print ("basarılı")
            nameTxt.text = ""
            surNameTxt.text = ""
            ePostaTxt.text = ""
            telefonTxt.text = ""
            txtDatePicker.text = ""
            notTxtField.text = ""
        }else {
            olumsuzAlert()
            print("Başarısız")
        }
        
    }
    func adKontrol() -> Bool{
        let isValid = (nameTxt.text ?? "").count > 2
        if isValid{
            nameView.layer.borderWidth = 0
            nameView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            nameUyariLbl.text = ""
        }else {
            nameView.layer.borderWidth = 1
            nameView.layer.borderColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
            nameUyariLbl.text = "Hatalı Ad Girişi"
        }
        return isValid
    }
    
    func soyadKontrol() -> Bool{
        let isValid = (surNameTxt.text ?? "").count > 2
        if isValid{
            surNameView.layer.borderWidth = 0
            surNameView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            surNameUyariLbl.text = ""
        }else {
            surNameView.layer.borderWidth = 1
            surNameView.layer.borderColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
            surNameUyariLbl.text = "Hatalı Soyad Girişi"
        }
        return isValid
    }
    
    func dogumTarihikontrol() -> Bool{
        let isValid = (txtDatePicker.text ?? "").count > 0
        if isValid{
            birthdayDate.layer.borderWidth = 0
            birthdayDate.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            dogumUariLbl.text = ""
        }else {
            birthdayDate.layer.borderColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
            birthdayDate.layer.borderWidth = 1
            dogumUariLbl.text = "Hatalı Giriş Yapıldı"
        }
        return isValid
    }
    
    func ePostaKontol() -> Bool{
        let isValid = (ePostaTxt.text ?? "").isValidEmail()
        if isValid{
            ePostView.layer.borderWidth = 0
            ePostView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            ePostaUyariLbl.text = ""
        }else {
            ePostView.layer.borderWidth = 1
            ePostView.layer.borderColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
            ePostaUyariLbl.text = "E-Posta Adresi Yanlış"
        }
        return isValid
    }
    
    func telefonKontrol() -> Bool{
        let isValid = (telefonTxt.text ?? "").count == 10
        if isValid{
            phoneView.layer.borderWidth = 0
            phoneView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            telefonUyariLbl.text = ""
        }else{
            phoneView.layer.borderWidth = 1
            phoneView.layer.borderColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
            telefonUyariLbl.text = "Hatalı Telefon Örn: 5557778811"
        }
        return isValid
    }
    
    func notKontrol () -> Bool{
        let isValid = (notTxtField.text ?? "").count < 100
        if isValid{
            notTxtField.layer.borderWidth = 0
            notTxtField.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            notUyariLbl.text = ""
        }else{
            notTxtField.layer.borderWidth = 1
            notTxtField.layer.borderColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
            notUyariLbl.text = "Max 100 Karakter"
        }
        return isValid
    }
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            noteTxtView.contentInset = .zero
        } else {
            noteTxtView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        noteTxtView.scrollIndicatorInsets = noteTxtView.contentInset
        let selectedRange = noteTxtView.selectedRange
        noteTxtView.scrollRangeToVisible(selectedRange)
    }
}
extension KisiEkleVC: StoryboardInstantiate {
    static var storyboardType: StoryboardType { return .kisiEkle }
}

//scrollView sağ-Sol hareketi yapması kapatıldı. Sadece Dikey haraket edebiliyor
extension KisiEkleVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}
extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}



