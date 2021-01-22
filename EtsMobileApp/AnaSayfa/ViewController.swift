//
//  ViewController.swift
//  EtsMobileApp
//
//  Created by Salih Erkan Sandal on 14.01.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate {
    var viewModel: AnaSayfaVM = AnaSayfaVM()
    @IBOutlet weak var searceText: UITextField!
    @IBOutlet weak var serchBar: UISearchBar!
    @IBOutlet weak var searchTextLblView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Kişiler"
        clearDidLoad()
        
        
    }
    func clearDidLoad(){
        self.navigationController!.navigationBar.titleTextAttributes = [.font: UIFont(name: "HelveticaNeue-Bold", size: 30)!, .foregroundColor: UIColor.white ]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.nib, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.separatorStyle = .none
        naviBarIconItem()
        transparentNaviBar()
        searchTextLblView.yuvarla()
        searceText.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        guard let yazi = searceText.text else { return }
        if yazi == "" { return }
        let tumCount = self.viewModel.veriler.count - 1
        var yeniVeriler: [Veri] = []
        for i in 0...tumCount {
            let ara = viewModel.veriler[i].ad + " " + viewModel.veriler[i].soyad
            if ara.contains(yazi) {
                yeniVeriler.append(viewModel.veriler[i])
            }
        }
        viewModel.filtrelenmisVeriler = yeniVeriler
        tableView.reloadData()
        
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                print("Long pressed row: \(indexPath.row)")
                let sirasi = indexPath.row
                let count = self.viewModel.veriler.count - 1
                var yeniDizi: [Veri] = []
                if count >= 0{
                    for i in 0...count{
                        if i != sirasi{
                            yeniDizi.append(self.viewModel.veriler[i])
                            
                        }
                    }
                }
                navigationController?.pushViewController(KisiEkleVC.instantiate(),animated: true)
                self.viewModel.kaydet(gelen: yeniDizi)
                self.tableView.reloadData()
                let sayi = String(indexPath.row)
                let alert = UIAlertController(title: "Güncelleme Ekranı", message: "Kişi Silidindi Bilgilerini Tekar Giriniz", preferredStyle: UIAlertController.Style.alert)
                self.present(alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filtrelenmisVeriler.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        let verimiz = viewModel.filtrelenmisVeriler[indexPath.row]
        cell.ayarla(veri: verimiz)
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = KisiEkleVC.instantiate()
        vc.viewModel.guncelVeri = viewModel.veriler[indexPath.row]
        vc.viewModel.sira = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.filtrelenmisVeriler[indexPath.row].not == "" {
            return 170
        }
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let sirasi = indexPath.row
            let count = viewModel.veriler.count - 1
            var yeniDizi: [Veri] = []
            if count >= 0{
                for i in 0...count{
                    if i != sirasi{
                        yeniDizi.append(viewModel.veriler[i])
                        
                    }
                }
            }
            viewModel.kaydet(gelen: yeniDizi)
            tableView.reloadData()
            deleteAlert()
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.veriCek()
        tableView.reloadData()
        
    }
    
    func transparentNaviBar(){
        //Navigation Bar Backgraund Clear color Yapıldı
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func naviBarIconItem() {
        //navigation bar'da bulunan "ekle" butonuna image atandı. NavigationBar'a buton eklendi, butonun özellikleri eklendi
        var image = UIImage(named: "ekleButonu")!
        image = image.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped() {
        print("Ok")
        let vc = KisiEkleVC.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteAlert(){
        
        let alert = UIAlertController(title: "Lütfen Bekleyin", message: "Kişi Siliniyor", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) { [weak self] in
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
}
extension ViewController: StoryboardInstantiate {
    static var storyboardType: StoryboardType { return .main }
}


