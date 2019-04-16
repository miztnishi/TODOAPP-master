//
//  realmDB.swift
//  9
//
//  Created by first on 2019/04/13.
//  Copyright © 2019 Nanato. All rights reserved.
//

import Foundation
import RealmSwift

class SectionData: Object {
    @objc dynamic var miniDo = String()
     @objc dynamic var  SectionOpned = Bool()
}


class GoalInfo: Object {
    @objc dynamic var  opened = Bool()
    @objc dynamic var  title = String()
    let insideTitle = List<SectionData>()
   
    
    
//    var goalList = [NSDictionary]()
    
    
    
    //データ書き込み、保存用
    func
        create(opened:Bool,title:String,sectionData:String){
        let realm = try! Realm()
        
        try! realm.write{
            
            //インスタンス化
            let  goalInfo = GoalInfo()
            let sectionData = SectionData()
            goalInfo.opened = opened
            goalInfo.title = title
            goalInfo.insideTitle.append(sectionData)
           
            realm.add(goalInfo)
        }
    }
    
    func readAll(){
//        self.goalList = []
        let realm = try! Realm()
        let result = realm.objects(GoalInfo.self)
//
//        for value in goalInfo {
//            let goals = ["opened":value.opened,"title":value.title,"insideTitle":value.insideTitle] as NSDictionary
//            self.goalList.append(goals)
//        }
    }
    
    func trueOrFalseUpdate(bool:Bool){
        let realm = try! Realm()
        try! realm.write {
        let  goalInfo = GoalInfo()
           goalInfo.opened = !goalInfo.opened
            
        }
        
    }
    
    func deleteAll(){
        let realm = try!Realm()
        try! realm.write(){
            var result = realm.objects(GoalInfo.self)
            realm.delete(result)
        }
    }
    
    //そのタイトルに関するデータ全て削除
    func deleteTitle(title:String){
        let realm = try!Realm()
        try! realm.write(){
            var result = realm.objects(GoalInfo.self)
            result =  result.filter("title like '\(title)'")
            realm.delete(result)
        }
    }
    //そのタイトルに関する選択されたsectionDataの削除
    func deleteTitle(miniDo:String){
        let realm = try!Realm()
        
        try! realm.write(){
            var result = realm.objects(SectionData.self)
            result =  result.filter("miniDo like '\(miniDo)'")
            realm.delete(result)
        }
    }
    
}

//struct cellData {
//    var opened = Bool()
//    var title = String()
//    var sectionData = [String]()
//}
//var tableViewData = [cellData]()

//tableViewData = [
//    cellData(opened: false, title: "サッカー",
//             sectionData:["パス","シュート","ドリブル","トラップ","センタリング"] ),
//    cellData(opened: false, title: "FIFA", sectionData:["AIの動き","CDMの位置","ドリブンシュート","R1クロス"] ),
//    cellData(opened: false, title: "プログラミング", sectionData: ["Python","Go","Swift","C","C#","JAVA","PHP"] ),
//
//]
