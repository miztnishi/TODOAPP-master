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

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

 let goalInfo = GoalInfo()
// let sectionData = SectionData()

class ViewController: UIViewController {
    
    
     let tableView = UITableView()
    var tableViewData = [cellData]()
    var goalList:[GoalInfo] = []
    
//    var sectionList = ["サッカー","FIFA","プログラミング"]
//    var cellList = [
//        ["パス","シュート","ドリブル","トラップ","センタリング"],
//        ["AIの動き","CDMの位置","ドリブンシュート","R1クロス"],
//        ["Python","Go","Swift","C","C#","JAVA","PHP"]
//    ]

    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height

    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
//
    fetchTodos()
        
        print("goalList",goalList)
        
    
        
       
        
        
        
        
        
        
        
        
        
        tableViewData = [
            cellData(opened: false, title: "サッカー",
                     sectionData:["パス","シュート","ドリブル","トラップ","センタリング"] ),
            cellData(opened: false, title: "FIFA", sectionData:["AIの動き","CDMの位置","ドリブンシュート","R1クロス"] ),
            cellData(opened: false, title: "プログラミング", sectionData: ["Python","Go","Swift","C","C#","JAVA","PHP"] ),
            
        ]
    
         navigationItem.title = "目標!!"
        
//        //navbarにボタン
//        let settingBtn:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting.png"), style:.done, target: self, action: nil)
//        //ナビゲーションバーの右側にボタン付与
//        self.navigationItem.setRightBarButtonItems([settingBtn], animated: true)
        
       
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = CGRect(x: 0, y: 0, width:width , height: height)
        //cellを分けています
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "custom")
         tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // trueで複数選択、falseで単一選択
        tableView.allowsMultipleSelection = false
        view.addSubview(tableView)
        
        
       

        //右下のボタン関連
        let floaty = Floaty()
        floaty.addItem("closeCell", icon: UIImage(named: "close.png"), handler:{_ in self.closeCell()} )
        
        floaty.addItem("Search", icon: UIImage(named: "search.png"),handler:{_ in self.checkRealmAdd()})
        floaty.addItem("New!", icon: UIImage(named: "add.png")!, handler: { item in
            let appearance = SCLAlertView.SCLAppearance(kWindowWidth: self.width,
            showCircularIcon: false,contentViewColor: .white, contentViewBorderColor: UIColor.blue, titleColor: .lightGray
                
            )
            
            // Add a text field
            let alert = SCLAlertView(appearance: appearance)
            let txt1 = alert.addTextField("Enter your name")
            
            let txt2 = alert.addTextField("Enter your task")
            
            alert.addButton("Save",backgroundColor: UIColor.blue) {
                self.tableViewData.append(cellData(opened: false, title: txt1.text ?? "", sectionData: [txt2.text ?? ""]))
                 self.tableView.reloadData()
            }
           
            alert.showInfo("Define your task", subTitle: "make your decision!", closeButtonTitle: "cancel", animationStyle: .bottomToTop)})
        
        
      
        
        
        
        //        floaty.frame = CGRect(x: 200, y: 50, width: 50, height: 50)
        self.view.addSubview(floaty)
        
    }
    
     @objc func add(){
        let appearance = SCLAlertView.SCLAppearance(kWindowWidth: self.width,
                                                    showCircularIcon: false,contentViewColor: .white, contentViewBorderColor: UIColor.blue, titleColor: .lightGray
            
        )
        
        // Add a text field
        let alert = SCLAlertView(appearance: appearance)
        let txt1 = alert.addTextField("Enter your name")
        
        let txt2 = alert.addTextField("Enter your task")
        
        alert.addButton("Save",backgroundColor: UIColor.blue) {
            self.tableViewData.append(cellData(opened: false, title: txt1.text ?? "", sectionData: [txt2.text ?? ""]))
            self.tableView.reloadData()
        }
        
        alert.showInfo("Define your task", subTitle: "make your decision!", closeButtonTitle: "cancel", animationStyle: .bottomToTop)}

    //cell全て閉じる
    @objc func closeCell(){
        for i in 0...tableViewData.count - 1{
            if tableViewData[i].opened == true{
                tableViewData[i].opened = false
                let sections = IndexSet.init(integer: i)
                tableView.reloadSections(sections, with: .fade) //animation
            }
        }
            
        
    }
    func fetchTodos() {
        // TODO: todo一覧を取得する
        do{
            let realm = try Realm()
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
    func checkRealmAdd(){
        do{
                        // デフォルトRealmを取得する
                        let realm = try! Realm()
                    // トランザクションを開始して、オブジェクトをRealmに追加する
                    try! realm.write {
            
                        // Realmの取得はスレッドごとに１度だけ必要になります
                        let goalInfo = GoalInfo()
                        let baseBall = SectionData()
                        baseBall.miniDo = "soccer"
                        baseBall.SectionOpned = false
            
                        //            let soccer = SectionData()
                        //            soccer.miniDo = "soccer"
                        //            soccer.SectionOpned = false
                        //
                        let basketBall = SectionData()
                        basketBall.miniDo = "basketBall"
                        basketBall.SectionOpned = false
            
                        //            let data1 = GoalInfo()
                        goalInfo.title = "スポーツ"
                        goalInfo.opened = false
                        goalInfo.insideTitle.append(baseBall)
                        goalInfo.insideTitle.append(basketBall)
                        //        goalInfo.insideTitle.append(soccer)
                        //        goalInfo.insideTitle.append(basketBall)
            
                        realm.add(goalInfo)
//                        print("書き込んだよ",goalInfo)
                        }
            fetchTodos()
            tableView.reloadData()
                    }catch{
                        print("失敗したよ")
                    }
            
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
                 cell.backgroundColor = UIColor(displayP3Red: 78/255, green: 78/258, blue: 240/255, alpha: 0.7)
           
                return cell
            }
            
        }else{
            //必要なら違うcell identifierを
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
            cell.textLabel?.text = goalList[indexPath.section].insideTitle[dataIndex].miniDo
            
         
            
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
                
                goalList[indexPath.section].opened = false

                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .top) //アニメーション


            }else{

                goalList[indexPath.section].opened = true

                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .bottom) //animation

            }
        }else{
            let cell = tableView.cellForRow(at:indexPath)


            // チェックマークを入れる
            cell?.accessoryType = .checkmark
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        // チェックマークを外す
        cell?.accessoryType = .none
//        goalList[indexPath.section].insideTitle[indexPath.row].SectionOpned = false
    }
    
   func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let editAction = UIContextualAction(style: .destructive,
                                            title: "add",
                                            handler: {(action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
                                                self.add()
                                                // 処理を実行完了した場合はtrue
                                                completion(false)
        })
        editAction.backgroundColor = UIColor(red: 101/255.0, green: 198/255.0, blue: 187/255.0, alpha: 1)
    

        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete",
                                              handler: { (action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
                                                print("Delete")
                                                
                                                // 処理を実行できなかった場合はfalse
                                                completion(true)
        })
        deleteAction.backgroundColor = UIColor(red: 214/255.0, green: 69/255.0, blue: 65/255.0, alpha: 1)
    
    if indexPath.row == 0{
        return UISwipeActionsConfiguration(actions:  [editAction, deleteAction])
     }
    return UISwipeActionsConfiguration(actions:  [deleteAction])
    }
    
    
    
    
    
}

    
//ボタン押したら　追加と検索昨日
