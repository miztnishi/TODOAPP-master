//
//  ViewController.swift
//  9
//
//  Created by first on 2019/04/09.
//  Copyright © 2019 Nanato. All rights reserved.
//

import UIKit
import Floaty
import SCLAlertView
import RealmSwift



let goalInfo = GoalInfo()
let sectionData = SectionData()

class ViewController: UIViewController {
    
    let realm = try! Realm()
    
    
    let tableView = UITableView()
    
    var goalList:[GoalInfo] = []
    var sectionDatata:[SectionData] = []
    
    
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        goalInfo.deleteAll()
        
        
        fetchTodos()
        
       
        view.backgroundColor = UIColor.white
        
        
        
        
        
        
        
        navigationItem.title = "目標!!"
        
        
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = CGRect(x: 0, y: 0, width:width , height: height)
        //cellを分けています
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "custom")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // trueで複数選択、falseで単一選択
        tableView.allowsMultipleSelection = false
        
        //中身なかったら画像表示
        if goalList.isEmpty{
            let appearance = SCLAlertView.SCLAppearance(kWindowWidth: self.width - 50,
                                                        showCircularIcon: false,contentViewColor: .white, contentViewBorderColor: UIColor.blue, titleColor: .lightGray
            )
            
            // Add a text field
            let alert = SCLAlertView(appearance: appearance)
            let txt1 = alert.addTextField("目標を記入してください")
            
            let txt2 = alert.addTextField("ステップをどうぞ")
            
            alert.addButton("Save",backgroundColor: UIColor.blue) {
                if txt1.text!.isEmpty{
             
                    SCLAlertView(appearance: appearance).showInfo(
                        "目標を設定してください", // Title of view
                        subTitle: "", // String of view
                        closeButtonTitle: "戻る",
                        colorStyle: 0x4248f4,
                        colorTextButton: 0xFFFFFF
                    )
                    
                }else{
                self.addTitles(title: txt1.text ?? "", minido: txt2.text!)
                }
            }
            
            alert.showInfo("することを記入しよう", subTitle: "小さな目標も記入しよう", closeButtonTitle: "cancel", animationStyle: .noAnimation)
            
        }
            
            view.addSubview(tableView)
       
        
        
        //右下のボタン関連
        let floaty = Floaty()
        
        floaty.addItem("closeCell", icon: UIImage(named: "close.png"), handler:{_ in  self.closeCell()} )
        
        
        floaty.addItem("New!", icon: UIImage(named: "add.png")!, handler: { item in
            let appearance = SCLAlertView.SCLAppearance(kWindowWidth: self.width - 50,
                                                        showCircularIcon: false,contentViewColor: .white, contentViewBorderColor: UIColor.blue, titleColor: .lightGray
                
            )
            
            // Add a text field
            let alert = SCLAlertView(appearance: appearance)
            let txt1 = alert.addTextField("Enter your name")
            
            let txt2 = alert.addTextField("Enter your task")
            
            alert.addButton("Save",backgroundColor: UIColor.blue) {
                if txt1.text!.isEmpty{
                SCLAlertView(appearance: appearance).showInfo(
                    "残念", // Title of view
                    subTitle: "Operation successfully completed.", // String of view
                    colorStyle: 0x4248f4,
                    colorTextButton: 0xFFFFFF
                )
                }
               else{
                self.addTitles(title: txt1.text ?? "", minido: txt2.text!)
                }
            }
            
            alert.showInfo("Define your task", subTitle: "make your decision!", closeButtonTitle: "cancel", animationStyle: .bottomToTop)})
        
        
      
        
        //        floaty.frame = CGRect(x: 200, y: 50, width: 50, height: 50)
        self.view.addSubview(floaty)
        
      
        //        //アプリ落とす時に関数closeCellを使う
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(ViewController.closeCell),
            name:UIApplication.willTerminateNotification,
            object: nil)
        
        
        
    }
    
    
    @objc func add(title:String,num:Int){
        let appearance = SCLAlertView.SCLAppearance(kWindowWidth: self.width - 50 ,
                                                    showCircularIcon: false,contentViewColor: .white, contentViewBorderColor: UIColor.blue, titleColor: .black
            
        )
        
        // Add a text field
        let alert = SCLAlertView(appearance: appearance)
//        let txt1 = alert.addTextField(title)
        let txt2 = alert.addTextField("Enter your task")
        
        alert.addButton("Save",backgroundColor: UIColor.blue) {
            self.UpdateMinido(title: title, minido: txt2.text ?? "")
            
        }
        
        alert.showInfo(title, subTitle:"スモールステップ", closeButtonTitle: "cancel", animationStyle: .bottomToTop)}
    

    //cell全て閉じる
    @objc func closeCell(){
        //中身なかったら動かないようにする
        if (goalList.isEmpty == false){
        for i in 0...goalList.count - 1{
            if goalList[i].opened == true{
                
                
                let realm = try! Realm()
                try! realm.write {
                    
                    goalList[i].opened = false
                }
                let sections = IndexSet.init(integer: i)
                tableView.reloadSections(sections, with: .fade) //animation
            }
        }
        
        }
    }
    func fetchTodos() {
        // TODO: todo一覧を取得する
        do{
            //            let realm = try Realm()
            //Todoに保存されているものを全て取得
            var results = realm.objects(GoalInfo.self)
            //todoListに格納
            goalList = Array(results)
            //            print("読み込んだよ", results)
            //            print("goalList",goalList)
        }catch{
            print("失敗したよ")
        }
        
    }
    
    
    
    func addTitles(title:String,minido:String){
    
        var sameTitle = realm.objects(GoalInfo.self).filter("title like '\(title)'")
        goalList = Array(sameTitle)
        if  goalList.isEmpty{
        
        do{
            try! realm.write {
                //sectionData内　内容の方
                let sectionData2 = SectionData()
                sectionData2.miniDo  = minido
                sectionData2.SectionOpned = false
                //タイトルの方　GoalInfo
                let goalInfo1 = GoalInfo()
                goalInfo1.title = title
                goalInfo1.opened = false
                goalInfo1.insideTitle.append(sectionData2)
                realm.add(goalInfo1)
                print("成功したよ",goalInfo1)
                
            }
            fetchTodos()
            tableView.reloadData()
            
        }catch{
            print("失敗")
        }
        }else{
            UpdateMinido(title: title, minido: minido)
        }
    }
    func UpdateMinido(title:String ,minido:String){
        do{
            try! realm.write {
                let resutls = realm.objects(GoalInfo.self).filter("title like '\(title)'")
                
                
                goalList = Array(resutls)
                
                //sectionData内　内容の方
                let sectionData1 = SectionData()
                sectionData1.miniDo = minido
                sectionData1.SectionOpned = false
                //タイトルの方　GoalInfo
                
                //同一のタイトルがないという想定です。
                goalList[0].insideTitle.append(sectionData1)
                print("成功したよ",goalInfo)
                
                
            }
            
            fetchTodos()
            tableView.reloadData()
            
        }catch{
            print("失敗")
        }
    }
    //そのタイトルに関するデータ全て削除
    func deleteTitle(title:String){
        try! realm.write(){
            
            var result = realm.objects(GoalInfo.self).filter("title like '\(title)'")
            print("削除データ内　result",result)
            realm.delete(result)
            print("result",result)
        }
        fetchTodos()
        tableView.reloadData()
        
    }
    
    //    //そのタイトルに関する選択されたsectionDataの削除
    //ロジックが甘い
    
    func deleteMinido(miniDo:String,title:String,num:IndexPath){
        try! realm.write(){
             let realm = try! Realm()
            var resultas = realm.objects(GoalInfo.self).filter("title like '\(title)'")
            
            print("--------------------------resultas-----------------------------------"
                ,resultas,
                 "------------------------------------------------------------------------")
            print(title)
            goalList = Array(resultas)
            //                    goalList
           
                  print("----------------------goalList------------------------------------",
                        goalList,
                        "---------------------------------------------------------------")
                  print(title)
        
                  print("11111111111111111111111111111111111111111111111111111111111",
                        goalList[0].insideTitle.filter("miniDo like'\(miniDo)'"),
                        "11111111111111111111111111111111111111111111111111111111111")
            
            var  section = goalList[0].insideTitle.filter("miniDo like'\(miniDo)'")
            print(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,section",
                  section,
                  ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,")
            
            
            var results = realm.objects(SectionData.self).filter("miniDo like '\(miniDo)'")
            
//            section[0].miniDo.removeAll()
            //これ上のremoveなしで行けんたんだがどうなってんだろ
            //test使って試してみよう初めてテスト使うからこれもググる
            realm.delete(section)
            print("----------------------------section-------------",
                  section,
                  "------------------------------------------------")
            print("........................goalList.......................................",
                  goalList,
                  "................................................................")
           
        }
       //GoalListにはからの辞書型か配列が残っている
//       tableView.deleteRows(at: [num], with: .fade)
        fetchTodos()
        tableView.reloadData()
        
    }
}

extension ViewController:UITableViewDataSource,UITableViewDelegate{
    // Section数
    func numberOfSections(in tableView: UITableView) -> Int {
        return goalList.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //ここのセクションはtableView funcのセクション番号
        if goalList[section].opened == true{
            
            return goalList[section].insideTitle.count + 1 //cell1を出すため +1 をしている
        }else{
            //空いていない時
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataIndex = indexPath.row - 1//コードを見やすくnumberOfRowsInsectionで +1 したためバランスをとっている
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "custom") else {return UITableViewCell()}
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        
        if indexPath.row == 0{
            //tilten間の線を消す
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            
            if goalList[indexPath.section].opened == true{
                
                cell.textLabel?.text = goalList[indexPath.section].title
                cell.backgroundColor = UIColor(white: 0.7, alpha: 1)
                
                return cell
            }else{
                
                
                cell.textLabel?.text = goalList[indexPath.section].title
                cell.backgroundColor = UIColor(displayP3Red: 30/255, green: 30/258, blue: 240/255, alpha: 0.7)
                
                return cell
            }
            
        }else{
            //必要なら違うcell identifierを
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
            cell.textLabel?.text = goalList[indexPath.section].insideTitle[dataIndex].miniDo
            if goalList[indexPath.section].insideTitle[dataIndex].SectionOpned == true{
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            
            
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 70
        }else{
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{ //cellをクリックしても閉じないようにするため、つまりセクションタイトルをクリックした時のみ閉じる
            if goalList[indexPath.section].opened == true{
                let realm = try! Realm()
                try! realm.write {
                    goalList[indexPath.section].opened = false
                }
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .top) //アニメーション
                
                
            }else{
                
                try! realm.write {
                    
                    goalList[indexPath.section].opened = true
                }
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .bottom) //animation
                
            }
        }else{
            let cell = tableView.cellForRow(at:indexPath)
            
            
            if(goalList[indexPath.section].insideTitle[indexPath.row - 1].SectionOpned == false){
                
                let realm = try! Realm()
                try! realm.write {
                    goalList[indexPath.section].insideTitle[indexPath.row - 1].SectionOpned = true
                }
                
                // チェックマークを入れる
                cell?.accessoryType = .checkmark
                tableView.reloadData()
                
            }else{
                let realm = try! Realm()
                try! realm.write {
                    goalList[indexPath.section].insideTitle[indexPath.row - 1].SectionOpned = false
                }
                
                // チェックマークを入れる
                cell?.accessoryType = .none
                tableView.reloadData()
            }
        }
    }
    
    //    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    //        let cell = tableView.cellForRow(at:indexPath)
    //        if  goalList[indexPath.section].insideTitle[indexPath.row - 1].SectionOpned == true {
    //
    //            let realm = try! Realm()
    //            try! realm.write {
    //                goalList[indexPath.section].insideTitle[indexPath.row - 1].SectionOpned = false
    //            }
    //            // チェックマークを外す
    //            cell?.accessoryType = .none
    //            tableView.reloadData()
    //
    //       }
    //    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .destructive,
                                            title: "add",
                                            handler: {(action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
                                                self.add(title: self.goalList[indexPath.section].title, num: indexPath.section)
                                                // 処理を実行完了した場合はtrue
                                                completion(false)
        })
        editAction.backgroundColor = UIColor(red: 101/255.0, green: 198/255.0, blue: 187/255.0, alpha: 1)
        
        
        let titleDeleteAction = UIContextualAction(style: .destructive,
                                                   title: "Delete",
                                                   handler: { (action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
                                                    print("Delete")
                                                    self.deleteTitle(title: self.goalList[indexPath.section].title)
                                                    
                                                    
                                                    // 処理を実行できなかった場合はfalse
                                                    completion(true)
                                                  
        })
        
        let miniDoDeleteAction = UIContextualAction(style: .destructive,
                                                    title: "Delete",
                                                    handler: { (action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
                                                        print("Delete")
                                                        
                                                        
                                                        self.deleteMinido(miniDo: self.goalList[indexPath.section].insideTitle[indexPath.row - 1].miniDo, title: self.goalList[indexPath.section].title, num: indexPath)
//                                                        print(self.goalList[indexPath.section].title)
                                                        
                                                        
                                                        // 処理を実行できなか¥た場合はfalse
                                                        completion(true)
                                                        print(indexPath.row,indexPath.section)
                                                       
        })
        titleDeleteAction.backgroundColor = UIColor(red: 214/255.0, green: 69/255.0, blue: 65/255.0, alpha: 1)
        miniDoDeleteAction.backgroundColor = UIColor(red: 214/255.0, green: 69/255.0, blue: 65/255.0, alpha: 1)
        
        if indexPath.row == 0{
            return UISwipeActionsConfiguration(actions:  [editAction, titleDeleteAction])
        }
        return UISwipeActionsConfiguration(actions:  [miniDoDeleteAction])
    }
    
    
    
    
    
}

