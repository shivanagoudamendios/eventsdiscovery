//
//  CoreDataManager.swift
//  Tribeca
//
//  Created by webmobi on 2/3/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit
import CoreData
let appid = UserDefaults.standard.string(forKey: "selectedappid")

class CoreDataManager: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectContext!
    }
    
    class func storeFavEvents(event : getPopularEvents) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteEvents", in: context)
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        managedObj.setValue(event.appid, forKey: "appid")
        managedObj.setValue(event.app_category, forKey: "app_category")
        managedObj.setValue(event.app_name, forKey: "app_name")
        managedObj.setValue(event.app_title, forKey: "app_title")
        managedObj.setValue(event.app_url, forKey: "app_url")
        managedObj.setValue(event.app_image, forKey: "app_image")
        managedObj.setValue(event.entry_fee, forKey: "entry_fee")
        managedObj.setValue(event.app_description, forKey: "app_description")
        managedObj.setValue(event.info_privacy, forKey: "info_privacy")
        managedObj.setValue(event.accesstype, forKey: "accesstype")
        managedObj.setValue(event.start_date, forKey: "start_date")
        managedObj.setValue(event.end_date, forKey: "end_date")
        managedObj.setValue(event.venue, forKey: "venue")
        managedObj.setValue(event.location, forKey: "location")
        managedObj.setValue(event.latitude, forKey: "latitude")
        managedObj.setValue(event.longitude, forKey: "longitude")
        managedObj.setValue(event.users, forKey: "users")
        managedObj.setValue(event.users_length, forKey: "users_length")
        do {
            try context.save()
            print("saved!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func fetchfavEvents() -> [getPopularEvents]{
        var aray = [getPopularEvents]()
        let fetchRequest:NSFetchRequest<FavoriteEvents> = FavoriteEvents.fetchRequest()
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            for item in fetchResult {
                let img = getPopularEvents(appid : item.appid!, app_category : item.app_category!, app_name : item.app_name!, app_title : item.app_title!, app_url : item.app_url! , app_image : item.app_image! , entry_fee : item.entry_fee! , app_description : item.app_description! , info_privacy : item.info_privacy , accesstype : item.accesstype! , start_date : item.start_date! , end_date : item.end_date! , venue : item.venue! , location : item.location! , latitude : item.latitude , longitude : item.longitude , users : [] , users_length : item.users_length)
                aray.append(img)
            }
        }catch {
            print(error.localizedDescription)
        }
        return aray
    }
    
    class func checkforeventID(id: String) -> Bool{
        var check = Bool()
        let fetchRequest:NSFetchRequest<FavoriteEvents> = FavoriteEvents.fetchRequest()
        let idpredicate = NSPredicate(format: "appid == %@",id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            if fetchResult.count != 0
            {
                check = true
            }else{
                check = false
            }
        }catch {
            print(error.localizedDescription)
        }
        
        return check
    }
    
    class func cleanseletedEvent(id: String) {
        
        let fetchRequest:NSFetchRequest<FavoriteEvents> = FavoriteEvents.fetchRequest()
        let idpredicate = NSPredicate(format: "appid == %@",id)
        fetchRequest.predicate = idpredicate
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            do {
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }
        } else {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteEvents")
            fetchRequest.includesPropertyValues = false
            //only fetch the managedObjectID
            let fetchedObjects = try! getContext().fetch(fetchRequest) as! [FavoriteEvents]
            for object: NSManagedObject in fetchedObjects {
                getContext().delete(object)
            }
            do {
                try getContext().save()
                print("saved!")
            } catch {
                print(error.localizedDescription)
            }
            
            //            let fetchRequest:NSFetchRequest<SpeakersRatings> = SpeakersRatings.fetchRequest()
            //            do {
            //                var fetchResult = try getContext().fetch(fetchRequest)
            //                fetchResult.removeAll()
            //            }catch {
            //                print(error.localizedDescription)
            //            }
        }
    }
    
    //Agenda Notes Coredata
    class func storeAgendaNotes(agendaID:String, agendaNotes:String, agendaDidAdd : Bool, agendaName : String, lastUpdated: Int64, notesType: String) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "AgendaNotes", in: context)
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        managedObj.setValue(agendaID, forKey: "notesID")
        managedObj.setValue(agendaNotes, forKey: "notesContent")
        managedObj.setValue(agendaDidAdd, forKey: "notesDidAdd")
        managedObj.setValue(agendaName, forKey: "notesName")
        managedObj.setValue(lastUpdated, forKey: "lastUpdated")
        managedObj.setValue(notesType, forKey: "notesType")
        do {
            try context.save()
            print("saved!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func fetchAgendaNotes() -> [AgendaNotestruct]{
        var aray = [AgendaNotestruct]()
        let fetchRequest:NSFetchRequest<AgendaNotes> = AgendaNotes.fetchRequest()
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            for item in fetchResult {
                if (item.notesID?.contains(appid!))!{
                    let img = AgendaNotestruct(id: item.notesID!, lastUpdated: item.lastUpdated , notes: item.notesContent!, agendaDidAdd: item.notesDidAdd, agendaName: item.notesName!, notesType: item.notesType!)
                    aray.append(img)
                }
            }
        }catch {
            print(error.localizedDescription)
        }
        return aray
    }
    
    class func checkforAgendaID(id: String) -> Bool{
        var check = Bool()
        let fetchRequest:NSFetchRequest<AgendaNotes> = AgendaNotes.fetchRequest()
        let idpredicate = NSPredicate(format: "notesID == %@", id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            if fetchResult.count != 0
            {
                check = true
            }else{
                check = false
            }
        }catch {
            print(error.localizedDescription)
        }
        
        return check
    }
    
    class func GetAgendafromAgendaID(id: String) -> AgendaNotes{
        var notes : AgendaNotes!
        let fetchRequest:NSFetchRequest<AgendaNotes> = AgendaNotes.fetchRequest()
        let idpredicate = NSPredicate(format: "notesID == %@", id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            notes = fetchResult[0]
        }catch {
            print(error.localizedDescription)
        }
        return notes
    }
    
    class func UpdateNotesfromAgendaID(agendaID:String, agendaNotes:String, agendaDidAdd : Bool, lastUpdated: Int64){
        let context = getContext()
        let fetchRequest: NSFetchRequest<AgendaNotes> = AgendaNotes.fetchRequest()
        let idpredicate = NSPredicate(format: "notesID == %@", agendaID)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            fetchResult[0].setValue(agendaNotes, forKey: "notesContent")
            fetchResult[0].setValue(agendaDidAdd, forKey: "notesDidAdd")
            fetchResult[0].setValue(lastUpdated, forKey: "lastUpdated")
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                print(error.localizedDescription)
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    class func UpdateBoolforAgendaID(agendaID:String, agendaDidAdd : Bool){
        let context = getContext()
        let fetchRequest: NSFetchRequest<AgendaNotes> = AgendaNotes.fetchRequest()
        let idpredicate = NSPredicate(format: "notesID == %@", agendaID)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            fetchResult[0].setValue(agendaDidAdd, forKey: "notesDidAdd")
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                print(error.localizedDescription)
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    class func cleanAgendaCoreData() {
        
        let fetchRequest:NSFetchRequest<AgendaNotes> = AgendaNotes.fetchRequest()
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            do {
                print("deleting all contents")
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }
        } else {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AgendaNotes")
            fetchRequest.includesPropertyValues = false
            //only fetch the managedObjectID
            let fetchedObjects = try! getContext().fetch(fetchRequest) as! [AgendaNotes]
            for object: NSManagedObject in fetchedObjects {
                getContext().delete(object)
            }
            do {
                try getContext().save()
                print("saved!")
            } catch {
                print(error.localizedDescription)
            }
            
            //            let fetchRequest:NSFetchRequest<SpeakersRatings> = SpeakersRatings.fetchRequest()
            //            do {
            //                var fetchResult = try getContext().fetch(fetchRequest)
            //                fetchResult.removeAll()
            //            }catch {
            //                print(error.localizedDescription)
            //            }
        }
    }
    
    //Sponsors Core Data
    class func storeSponsorsNotes(sponsorsID:String, sponsorsNotes:String, sponsorsDidAdd : Bool, sponsorsName: String, lastUpdated: Int64, notesType: String) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "SponsorsNotes", in: context)
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        managedObj.setValue(sponsorsID, forKey: "notesID")
        managedObj.setValue(sponsorsNotes, forKey: "notesContent")
        managedObj.setValue(sponsorsDidAdd, forKey: "notesDidAdd")
        managedObj.setValue(sponsorsName, forKey: "notesName")
        managedObj.setValue(lastUpdated, forKey: "lastUpdated")
        managedObj.setValue(notesType, forKey: "notesType")
        
        do {
            try context.save()
            print("saved!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func fetchSponsorsNotes() -> [SponsorsNotestruct]{
        var aray = [SponsorsNotestruct]()
        let fetchRequest:NSFetchRequest<SponsorsNotes> = SponsorsNotes.fetchRequest()
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            for item in fetchResult {
                if (item.notesID?.contains(appid!))!{
                    let img = SponsorsNotestruct(id: item.notesID!, lastUpdated: item.lastUpdated , notes: item.notesContent! , agendaDidAdd: item.notesDidAdd, sponsorsName: item.notesName!, notesType: item.notesType!)
                    aray.append(img)
                }
            }
        }catch {
            print(error.localizedDescription)
        }
        return aray
    }
    
    class func checkforSponsorsID(id: String) -> Bool{
        var check = Bool()
        let fetchRequest:NSFetchRequest<SponsorsNotes> = SponsorsNotes.fetchRequest()
        let idpredicate = NSPredicate(format: "notesID == %@", id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            if fetchResult.count != 0
            {
                check = true
            }else{
                check = false
            }
        }catch {
            print(error.localizedDescription)
        }
        
        return check
    }
    
    class func GetSponsorsfromSponsorsID(id: String) -> SponsorsNotes{
        var notes : SponsorsNotes!
        let fetchRequest:NSFetchRequest<SponsorsNotes> = SponsorsNotes.fetchRequest()
        let idpredicate = NSPredicate(format: "notesID == %@", id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            notes = fetchResult[0]
        }catch {
            print(error.localizedDescription)
        }
        return notes
    }
    
    class func UpdateNotesfromSponsorsID(sponsorsID:String, sponsorsNotes:String, sponsorsDidAdd : Bool, lastUpdated: Int64){
        let context = getContext()
        let fetchRequest: NSFetchRequest<SponsorsNotes> = SponsorsNotes.fetchRequest()
        let idpredicate = NSPredicate(format: "notesID == %@", sponsorsID)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            fetchResult[0].setValue(sponsorsNotes, forKey: "notesContent")
            fetchResult[0].setValue(sponsorsDidAdd, forKey: "notesDidAdd")
            fetchResult[0].setValue(lastUpdated, forKey: "lastUpdated")
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                print(error.localizedDescription)
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    class func UpdateBoolforSponsorsID(sponsorsID:String, notesDidAdd:Bool){
        let context = getContext()
        let fetchRequest: NSFetchRequest<SponsorsNotes> = SponsorsNotes.fetchRequest()
        let idpredicate = NSPredicate(format: "notesID == %@", sponsorsID)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            fetchResult[0].setValue(notesDidAdd, forKey: "notesDidAdd")
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                print(error.localizedDescription)
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    class func cleanSponsorsCoreData() {
        
        let fetchRequest:NSFetchRequest<SponsorsNotes> = SponsorsNotes.fetchRequest()
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            do {
                print("deleting all contents")
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }
        } else {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SponsorsNotes")
            fetchRequest.includesPropertyValues = false
            //only fetch the managedObjectID
            let fetchedObjects = try! getContext().fetch(fetchRequest) as! [SponsorsNotes]
            for object: NSManagedObject in fetchedObjects {
                getContext().delete(object)
            }
            do {
                try getContext().save()
                print("saved!")
            } catch {
                print(error.localizedDescription)
            }
            
            //            let fetchRequest:NSFetchRequest<SpeakersRatings> = SpeakersRatings.fetchRequest()
            //            do {
            //                var fetchResult = try getContext().fetch(fetchRequest)
            //                fetchResult.removeAll()
            //            }catch {
            //                print(error.localizedDescription)
            //            }
        }
    }
    
    //Exhibitors Core Data
    class func storeExhibitorsNotes(exhibitorsID:String, exhibitorsNotes:String, exhibitorsDidAdd : Bool, exhibitorsName: String, lastUpdated: Int64, notesType: String) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "ExhibitorsNotes", in: context)
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        managedObj.setValue(exhibitorsID, forKey: "notesID")
        managedObj.setValue(exhibitorsNotes, forKey: "notesContent")
        managedObj.setValue(exhibitorsDidAdd, forKey: "notesDidAdd")
        managedObj.setValue(exhibitorsName, forKey: "notesName")
        managedObj.setValue(lastUpdated, forKey: "lastUpdated")
        managedObj.setValue(notesType, forKey: "notesType")
        do {
            try context.save()
            print("saved!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func fetchExhibitorsNotes() -> [ExhibitorsNotestruct]{
        var aray = [ExhibitorsNotestruct]()
        let fetchRequest:NSFetchRequest<ExhibitorsNotes> = ExhibitorsNotes.fetchRequest()
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            for item in fetchResult {
                if (item.notesID?.contains(appid!))!{
                    let img = ExhibitorsNotestruct(id: item.notesID!, lastUpdated: item.lastUpdated , notes: item.notesContent!, agendaDidAdd: item.notesDidAdd, exhibitorsName: item.notesName!, notesType: item.notesType!)
                    aray.append(img)
                }
            }
        }catch {
            print(error.localizedDescription)
        }
        return aray
    }
    
    class func checkforExhibitorsID(id: String) -> Bool {
        var check = Bool()
        let fetchRequest:NSFetchRequest<ExhibitorsNotes> = ExhibitorsNotes.fetchRequest()
        let idpredicate = NSPredicate(format: "notesID == %@", id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            if fetchResult.count != 0
            {
                check = true
            }else{
                check = false
            }
        }catch {
            print(error.localizedDescription)
        }
        
        return check
    }
    
    class func GetExhibitorsfromExhibitorsID(id: String) -> ExhibitorsNotes{
        var notes : ExhibitorsNotes!
        let fetchRequest:NSFetchRequest<ExhibitorsNotes> = ExhibitorsNotes.fetchRequest()
        let idpredicate = NSPredicate(format: "notesID == %@", id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            notes = fetchResult[0]
        }catch {
            print(error.localizedDescription)
        }
        return notes
    }
    
    class func UpdateNotesfromExhibitorsID(exhibitorsID:String, exhibitorsNotes:String, exhibitorsDidAdd : Bool, lastUpdated: Int64){
        let context = getContext()
        let fetchRequest: NSFetchRequest<ExhibitorsNotes> = ExhibitorsNotes.fetchRequest()
        let idpredicate = NSPredicate(format: "notesID == %@", exhibitorsID)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            fetchResult[0].setValue(exhibitorsNotes, forKey: "notesContent")
            fetchResult[0].setValue(exhibitorsDidAdd, forKey: "notesDidAdd")
            fetchResult[0].setValue(lastUpdated, forKey: "lastUpdated")
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                print(error.localizedDescription)
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    class func UpdateBoolforExhibitorsID(exhibitorsID:String,exhibitorsDidAdd : Bool){
        let context = getContext()
        let fetchRequest: NSFetchRequest<ExhibitorsNotes> = ExhibitorsNotes.fetchRequest()
        let idpredicate = NSPredicate(format: "notesID == %@", exhibitorsID)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            fetchResult[0].setValue(exhibitorsDidAdd, forKey: "notesDidAdd")
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                print(error.localizedDescription)
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    class func cleanExhibitorsCoreData() {
        
        let fetchRequest:NSFetchRequest<ExhibitorsNotes> = ExhibitorsNotes.fetchRequest()
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            do {
                print("deleting all contents")
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }
        } else {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExhibitorsNotes")
            fetchRequest.includesPropertyValues = false
            //only fetch the managedObjectID
            let fetchedObjects = try! getContext().fetch(fetchRequest) as! [ExhibitorsNotes]
            for object: NSManagedObject in fetchedObjects {
                getContext().delete(object)
            }
            do {
                try getContext().save()
                print("saved!")
            } catch {
                print(error.localizedDescription)
            }
            
            //            let fetchRequest:NSFetchRequest<SpeakersRatings> = SpeakersRatings.fetchRequest()
            //            do {
            //                var fetchResult = try getContext().fetch(fetchRequest)
            //                fetchResult.removeAll()
            //            }catch {
            //                print(error.localizedDescription)
            //            }
        }
    }
    
    //Agenda Rating
    class func storeAgendaRating(appid: String, rating: Int16, rating_id:String, rating_type: String, type_id: String, userid: String) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "AgendaRatings", in: context)
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        managedObj.setValue(appid, forKey: "appid")
        managedObj.setValue(rating, forKey: "rating")
        managedObj.setValue(rating_id, forKey: "rating_id")
        managedObj.setValue(rating_type, forKey: "rating_type")
        managedObj.setValue(type_id, forKey: "type_id")
        managedObj.setValue(userid, forKey: "userid")
        do {
            try context.save()
            print("saved!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func fetchAgendaRatings() -> [Ratingstruct]{
        var aray = [Ratingstruct]()
        let fetchRequest:NSFetchRequest<AgendaRatings> = AgendaRatings.fetchRequest()
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            for item in fetchResult {
                if (item.type_id?.contains(appid!))!{
                    let img = Ratingstruct(rating:item.rating, appid:item.appid!, rating_id: item.rating_id!, rating_type : item.rating_type!, type_id: item.type_id!, userid: item.userid!)
                    aray.append(img)
                }
            }
        }catch {
            print(error.localizedDescription)
        }
        return aray
    }
    
    class func checkforAgendaRatingID(id: String) -> Bool{
        var check = Bool()
        let fetchRequest:NSFetchRequest<AgendaRatings> = AgendaRatings.fetchRequest()
        let idpredicate = NSPredicate(format: "type_id == %@", id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            if fetchResult.count != 0
            {
                check = true
            }else{
                check = false
            }
        }catch {
            print(error.localizedDescription)
        }
        
        return check
    }
    
    class func GetRatingfromAgendaID(id: String) -> AgendaRatings{
        var notes : AgendaRatings!
        let fetchRequest:NSFetchRequest<AgendaRatings> = AgendaRatings.fetchRequest()
        let idpredicate = NSPredicate(format: "type_id == %@", id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            notes = fetchResult[0]
        }catch {
            print(error.localizedDescription)
        }
        return notes
    }
    
    class func UpdateRatingsfromAgendaID(type_id:String, rating:Int16){
        let context = getContext()
        let fetchRequest: NSFetchRequest<AgendaRatings> = AgendaRatings.fetchRequest()
        let idpredicate = NSPredicate(format: "type_id == %@", type_id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            fetchResult[0].setValue(type_id, forKey: "type_id")
            fetchResult[0].setValue(rating, forKey: "rating")
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                print(error.localizedDescription)
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    class func cleanAgendaRatingsCoreData() {
        
        let fetchRequest:NSFetchRequest<AgendaRatings> = AgendaRatings.fetchRequest()
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            do {
                print("deleting all contents")
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }
        } else {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AgendaRatings")
            fetchRequest.includesPropertyValues = false
            //only fetch the managedObjectID
            let fetchedObjects = try! getContext().fetch(fetchRequest) as! [AgendaRatings]
            for object: NSManagedObject in fetchedObjects {
                getContext().delete(object)
            }
            do {
                try getContext().save()
                print("saved!")
            } catch {
                print(error.localizedDescription)
            }
            
            //            let fetchRequest:NSFetchRequest<SpeakersRatings> = SpeakersRatings.fetchRequest()
            //            do {
            //                var fetchResult = try getContext().fetch(fetchRequest)
            //                fetchResult.removeAll()
            //            }catch {
            //                print(error.localizedDescription)
            //            }
        }
    }
    
    //Speakers Rating
    class func storeSpeakersRating(appid: String, rating: Int16, rating_id:String, rating_type: String, type_id: String, userid: String) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "SpeakersRatings", in: context)
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        managedObj.setValue(appid, forKey: "appid")
        managedObj.setValue(rating, forKey: "rating")
        managedObj.setValue(rating_id, forKey: "rating_id")
        managedObj.setValue(rating_type, forKey: "rating_type")
        managedObj.setValue(type_id, forKey: "type_id")
        managedObj.setValue(userid, forKey: "userid")
        do {
            try context.save()
            print("saved!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func fetchSpeakersRatings() -> [Ratingstruct]{
        var aray = [Ratingstruct]()
        let fetchRequest:NSFetchRequest<SpeakersRatings> = SpeakersRatings.fetchRequest()
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            for item in fetchResult {
                if (item.type_id?.contains(appid!))!{
                    let img = Ratingstruct(rating:item.rating, appid:item.appid!, rating_id: item.rating_id!, rating_type : item.rating_type!, type_id: item.type_id!, userid: item.userid!)
                    aray.append(img)
                }
            }
        }catch {
            print(error.localizedDescription)
        }
        return aray
    }
    
    class func checkforSpeakersRatingID(id: String) -> Bool{
        var check = Bool()
        let fetchRequest:NSFetchRequest<SpeakersRatings> = SpeakersRatings.fetchRequest()
        let idpredicate = NSPredicate(format: "type_id == %@", id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            if fetchResult.count != 0
            {
                check = true
            }else{
                check = false
            }
        }catch {
            print(error.localizedDescription)
        }
        
        return check
    }
    
    class func GetRatingfromSpeakersID(id: String) -> SpeakersRatings{
        var notes : SpeakersRatings!
        let fetchRequest:NSFetchRequest<SpeakersRatings> = SpeakersRatings.fetchRequest()
        let idpredicate = NSPredicate(format: "type_id == %@", id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            notes = fetchResult[0]
        }catch {
            print(error.localizedDescription)
        }
        return notes
    }
    
    class func UpdateRatingsfromSpeakersID(type_id:String, rating:Int16){
        let context = getContext()
        let fetchRequest: NSFetchRequest<SpeakersRatings> = SpeakersRatings.fetchRequest()
        let idpredicate = NSPredicate(format: "type_id == %@", type_id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            fetchResult[0].setValue(type_id, forKey: "type_id")
            fetchResult[0].setValue(rating, forKey: "rating")
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                print(error.localizedDescription)
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    class func cleanSpeakersRatingsCoreData() {
        
        let fetchRequest:NSFetchRequest<SpeakersRatings> = SpeakersRatings.fetchRequest()
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            do {
                print("deleting all contents")
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }
        } else {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SpeakersRatings")
            fetchRequest.includesPropertyValues = false
            //only fetch the managedObjectID
            let fetchedObjects = try! getContext().fetch(fetchRequest) as! [SpeakersRatings]
            for object: NSManagedObject in fetchedObjects {
                getContext().delete(object)
            }
            do {
                try getContext().save()
                print("saved!")
            } catch {
                print(error.localizedDescription)
            }
            
            //            let fetchRequest:NSFetchRequest<SpeakersRatings> = SpeakersRatings.fetchRequest()
            //            do {
            //                var fetchResult = try getContext().fetch(fetchRequest)
            //                fetchResult.removeAll()
            //            }catch {
            //                print(error.localizedDescription)
            //            }
        }
    }
    
    
    //Downloaded Event Details
    class func storeDownlodedEvent(appid: String, isfirstlogin: Bool, password: String) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "DownloadedEvents", in: context)
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        managedObj.setValue(appid, forKey: "appid")
        managedObj.setValue(isfirstlogin, forKey: "isfirstlogin")
        managedObj.setValue(password, forKey: "password")
        do {
            try context.save()
            print("Event login saved!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func fetchDownloadedEvent() -> [DownlodedEventLoginDetails]{
        var aray = [DownlodedEventLoginDetails]()
        let fetchRequest:NSFetchRequest<DownloadedEvents> = DownloadedEvents.fetchRequest()
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            for item in fetchResult {
                let img = DownlodedEventLoginDetails(appid: item.appid!, isfirstlogin: item.isfirstlogin, password: item.password!)
                aray.append(img)
            }
        }catch {
            print(error.localizedDescription)
        }
        return aray
    }
    
    class func checkforDownloadedAppID(id: String) -> Bool{
        var check = Bool()
        let fetchRequest:NSFetchRequest<DownloadedEvents> = DownloadedEvents.fetchRequest()
        let idpredicate = NSPredicate(format: "appid == %@", id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            if fetchResult.count != 0
            {
                check = true
            }else{
                check = false
            }
        }catch {
            print(error.localizedDescription)
        }
        
        return check
    }
    
    class func GetLoginDetailfromAppID(id: String) -> DownloadedEvents{
        var notes : DownloadedEvents!
        let fetchRequest:NSFetchRequest<DownloadedEvents> = DownloadedEvents.fetchRequest()
        let idpredicate = NSPredicate(format: "appid == %@", id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            notes = fetchResult[0]
        }catch {
            print(error.localizedDescription)
        }
        return notes
    }
    
    class func UpdateFirstLoginfromAppID(AppID:String, isfirstlogin:Bool){
        let context = getContext()
        let fetchRequest: NSFetchRequest<DownloadedEvents> = DownloadedEvents.fetchRequest()
        let idpredicate = NSPredicate(format: "appid == %@", AppID)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            fetchResult[0].setValue(AppID, forKey: "appid")
            fetchResult[0].setValue(isfirstlogin, forKey: "isfirstlogin")
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                print(error.localizedDescription)
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    class func cleanDownloadedEventCoreData() {
        
        let fetchRequest:NSFetchRequest<DownloadedEvents> = DownloadedEvents.fetchRequest()
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            do {
                print("deleting all contents")
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }
        } else {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DownloadedEvents")
            fetchRequest.includesPropertyValues = false
            //only fetch the managedObjectID
            let fetchedObjects = try! getContext().fetch(fetchRequest) as! [DownloadedEvents]
            for object: NSManagedObject in fetchedObjects {
                getContext().delete(object)
            }
            do {
                try getContext().save()
                print("saved!")
            } catch {
                print(error.localizedDescription)
            }
            
            //            let fetchRequest:NSFetchRequest<SpeakersRatings> = SpeakersRatings.fetchRequest()
            //            do {
            //                var fetchResult = try getContext().fetch(fetchRequest)
            //                fetchResult.removeAll()
            //            }catch {
            //                print(error.localizedDescription)
            //            }
        }
    }
    
    //Login Detail for every ViewController
    class func LoginDetailForAppID(appid: String, data: Data) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "LoginDataFromAppID", in: context)
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        managedObj.setValue(appid, forKey: "appid")
        managedObj.setValue(data, forKey: "data")
        do {
            try context.save()
            print("Event login saved!")
        } catch {
            print(error.localizedDescription)
        }
    }

    
    class func GetLoginDataFromAppID(id: String) -> LoginDataFromAppID{
        var notes : LoginDataFromAppID!
        let fetchRequest:NSFetchRequest<LoginDataFromAppID> = LoginDataFromAppID.fetchRequest()
        let idpredicate = NSPredicate(format: "appid == %@", id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            notes = fetchResult[0]
        }catch {
            print(error.localizedDescription)
        }
        return notes
    }
    
    class func cleanLoginDetailCoreData() {
        
        let fetchRequest:NSFetchRequest<LoginDataFromAppID> = LoginDataFromAppID.fetchRequest()
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            do {
                print("deleting all contents")
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }
        } else {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LoginDataFromAppID")
            fetchRequest.includesPropertyValues = false
            //only fetch the managedObjectID
            let fetchedObjects = try! getContext().fetch(fetchRequest) as! [LoginDataFromAppID]
            for object: NSManagedObject in fetchedObjects {
                getContext().delete(object)
            }
            do {
                try getContext().save()
                print("saved!")
            } catch {
                print(error.localizedDescription)
            }
            
            //            let fetchRequest:NSFetchRequest<SpeakersRatings> = SpeakersRatings.fetchRequest()
            //            do {
            //                var fetchResult = try getContext().fetch(fetchRequest)
            //                fetchResult.removeAll()
            //            }catch {
            //                print(error.localizedDescription)
            //            }
        }
    }
    
    //Exhibitor Favorites
    class func AddExhibitorToFavorites(id: String, eventid: Int64) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "ExhibitorFavorites", in: context)
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        managedObj.setValue(id, forKey: "id")
        managedObj.setValue(eventid, forKey: "eventid")
        do {
            try context.save()
            print("saved!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func GetAllExhibitorFavorites() -> [Int64]{
        var aray = [Int64]()
        let fetchRequest:NSFetchRequest<ExhibitorFavorites> = ExhibitorFavorites.fetchRequest()
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            for item in fetchResult {
                if (item.id?.contains(appid!))!{
                    let img = item.eventid
                    aray.append(img)
                }
            }
        }catch {
            print(error.localizedDescription)
        }
        return aray
    }
    
    class func RemoveExhibitorFromFavorites(id: String) {
        if #available(iOS 9.0, *) {
            let fetchRequest:NSFetchRequest<ExhibitorFavorites> = ExhibitorFavorites.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", id)
            fetchRequest.predicate = predicate
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            do {
                print("Removed sponsors from Favs")
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }
        } else {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExhibitorFavorites")
            fetchRequest.includesPropertyValues = false
            let predicate = NSPredicate(format: "id == %@", id)
            fetchRequest.predicate = predicate
            let fetchedObjects = try! getContext().fetch(fetchRequest) as! [ExhibitorFavorites]
            for object: NSManagedObject in fetchedObjects {
                getContext().delete(object)
            }
            do {
                try getContext().save()
                print("Removed sponsors from Favs")
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    class func checkExhibitorInFavorites(id: String) -> Bool{
        var check = Bool()
        let fetchRequest:NSFetchRequest<ExhibitorFavorites> = ExhibitorFavorites.fetchRequest()
        let idpredicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            if fetchResult.count != 0
            {
                check = true
            }else{
                check = false
            }
        }catch {
            print(error.localizedDescription)
        }
        
        return check
    }
    
    class func cleanExhibitorFavoritesCoreData() {
        
        let fetchRequest:NSFetchRequest<ExhibitorFavorites> = ExhibitorFavorites.fetchRequest()
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            do {
                print("deleting all contents")
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }
        } else {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExhibitorFavorites")
            fetchRequest.includesPropertyValues = false
            //only fetch the managedObjectID
            let fetchedObjects = try! getContext().fetch(fetchRequest) as! [ExhibitorFavorites]
            for object: NSManagedObject in fetchedObjects {
                getContext().delete(object)
            }
            do {
                try getContext().save()
                print("saved!")
            } catch {
                print(error.localizedDescription)
            }
            
            //            let fetchRequest:NSFetchRequest<SpeakersRatings> = SpeakersRatings.fetchRequest()
            //            do {
            //                var fetchResult = try getContext().fetch(fetchRequest)
            //                fetchResult.removeAll()
            //            }catch {
            //                print(error.localizedDescription)
            //            }
        }
    }

    //Schedule Favs
    class func AddScheduleToFavorites(id: String, eventid: Int64) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "ScheduleFavorites", in: context)
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        managedObj.setValue(id, forKey: "id")
        managedObj.setValue(eventid, forKey: "eventid")
        do {
            try context.save()
            print("saved!")
        } catch {
            print(error.localizedDescription)
        }
    }

    class func GetAllScheduleFavorites() -> [Int64]{
        var aray = [Int64]()
        let fetchRequest:NSFetchRequest<ScheduleFavorites> = ScheduleFavorites.fetchRequest()
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            for item in fetchResult {
                if (item.id?.contains(appid!))!{
                    let img = item.eventid
                    aray.append(img)
                }
            }
        }catch {
            print(error.localizedDescription)
        }
        return aray
    }
    
    class func RemoveScheduleFromFavorites(id: String) {
        if #available(iOS 9.0, *) {
            let fetchRequest:NSFetchRequest<ScheduleFavorites> = ScheduleFavorites.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", id)
            fetchRequest.predicate = predicate
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            do {
                print("Removed schedule from Favs")
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }
        } else {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ScheduleFavorites")
            fetchRequest.includesPropertyValues = false
            let predicate = NSPredicate(format: "id == %@", id)
            fetchRequest.predicate = predicate
            let fetchedObjects = try! getContext().fetch(fetchRequest) as! [ScheduleFavorites]
            for object: NSManagedObject in fetchedObjects {
                getContext().delete(object)
            }
            do {
                try getContext().save()
                print("Removed schedule from Favs")
            } catch {
                print(error.localizedDescription)
            }

        }
    }
    
    class func checkScheduleInFavorites(id: String) -> Bool{
        var check = Bool()
        let fetchRequest:NSFetchRequest<ScheduleFavorites> = ScheduleFavorites.fetchRequest()
        let idpredicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            if fetchResult.count != 0
            {
                check = true
            }else{
                check = false
            }
        }catch {
            print(error.localizedDescription)
        }
        
        return check
    }
    
    class func cleanScheduleFavoritesCoreData() {
        
        let fetchRequest:NSFetchRequest<ScheduleFavorites> = ScheduleFavorites.fetchRequest()
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            do {
                print("deleting all contents")
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }
        } else {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ScheduleFavorites")
            fetchRequest.includesPropertyValues = false
            //only fetch the managedObjectID
            let fetchedObjects = try! getContext().fetch(fetchRequest) as! [ScheduleFavorites]
            for object: NSManagedObject in fetchedObjects {
                getContext().delete(object)
            }
            do {
                try getContext().save()
                print("saved!")
            } catch {
                print(error.localizedDescription)
            }
            
            //            let fetchRequest:NSFetchRequest<SpeakersRatings> = SpeakersRatings.fetchRequest()
            //            do {
            //                var fetchResult = try getContext().fetch(fetchRequest)
            //                fetchResult.removeAll()
            //            }catch {
            //                print(error.localizedDescription)
            //            }
        }
    }

    //Sponsors Favs
    class func AddSponsorsToFavorites(id: String, eventid: Int64) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "SponsorsFavorites", in: context)
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        managedObj.setValue(id, forKey: "id")
        managedObj.setValue(eventid, forKey: "eventid")
        do {
            try context.save()
            print("saved!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func GetAllSponsorsFavorites() -> [Int64]{
        var aray = [Int64]()
        let fetchRequest:NSFetchRequest<SponsorsFavorites> = SponsorsFavorites.fetchRequest()
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            for item in fetchResult {
                if (item.id?.contains(appid!))!{
                    let img = item.eventid
                    aray.append(img)
                }
            }
        }catch {
            print(error.localizedDescription)
        }
        return aray
    }
    
    class func RemoveSponsorsFromFavorites(id: String) {
        if #available(iOS 9.0, *) {
            let fetchRequest:NSFetchRequest<SponsorsFavorites> = SponsorsFavorites.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", id)
            fetchRequest.predicate = predicate
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            do {
                print("Removed sponsors from Favs")
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }
        } else {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SponsorsFavorites")
            fetchRequest.includesPropertyValues = false
            let predicate = NSPredicate(format: "id == %@", id)
            fetchRequest.predicate = predicate
            let fetchedObjects = try! getContext().fetch(fetchRequest) as! [SponsorsFavorites]
            for object: NSManagedObject in fetchedObjects {
                getContext().delete(object)
            }
            do {
                try getContext().save()
                print("Removed sponsors from Favs")
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    class func checkSponsorsInFavorites(id: String) -> Bool{
        var check = Bool()
        let fetchRequest:NSFetchRequest<SponsorsFavorites> = SponsorsFavorites.fetchRequest()
        let idpredicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = idpredicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            if fetchResult.count != 0
            {
                check = true
            }else{
                check = false
            }
        }catch {
            print(error.localizedDescription)
        }
        
        return check
    }
    
    class func cleanSponsorsFavoritesCoreData() {
        
        let fetchRequest:NSFetchRequest<SponsorsFavorites> = SponsorsFavorites.fetchRequest()
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            do {
                print("deleting all contents")
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }
        } else {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SponsorsFavorites")
            fetchRequest.includesPropertyValues = false
            //only fetch the managedObjectID
            let fetchedObjects = try! getContext().fetch(fetchRequest) as! [SponsorsFavorites]
            for object: NSManagedObject in fetchedObjects {
                getContext().delete(object)
            }
            do {
                try getContext().save()
                print("saved!")
            } catch {
                print(error.localizedDescription)
            }
            
            //            let fetchRequest:NSFetchRequest<SpeakersRatings> = SpeakersRatings.fetchRequest()
            //            do {
            //                var fetchResult = try getContext().fetch(fetchRequest)
            //                fetchResult.removeAll()
            //            }catch {
            //                print(error.localizedDescription)
            //            }
        }
    }
}

struct AgendaNotestruct {
    var notesID:String?
    var lastUpdated:Int64?
    var notesString:String?
    var notesDidAdd:Bool?
    var notesName:String?
    var notesType: String?
    
    init() {
        notesID = ""
        lastUpdated = 0
        notesString = ""
        notesDidAdd = false
        notesName = ""
        notesType = ""
    }
    
    init(id:String, lastUpdated:Int64, notes:String, agendaDidAdd : Bool, agendaName : String, notesType: String) {
        self.notesID = id
        self.notesString = notes
        self.notesDidAdd = agendaDidAdd
        self.notesName = agendaName
        self.lastUpdated = lastUpdated
        self.notesType = notesType
    }
    
}

struct SponsorsNotestruct {
    var notesID:String?
    var lastUpdated:Int64?
    var notesString:String?
    var notesDidAdd:Bool?
    var notesName:String?
    var notesType: String?
    
    init() {
        notesID = ""
        lastUpdated = 0
        notesString = ""
        notesDidAdd = false
        notesName = ""
        notesType = ""
    }
    
    init(id:String, lastUpdated:Int64, notes:String, agendaDidAdd : Bool, sponsorsName: String, notesType: String) {
        self.notesID = id
        self.notesString = notes
        self.notesDidAdd = agendaDidAdd
        self.notesName = sponsorsName
        self.lastUpdated = lastUpdated
        self.notesType = notesType
    }
}

struct ExhibitorsNotestruct {
    var notesID:String?
    var lastUpdated:Int64?
    var notesString:String?
    var notesDidAdd:Bool?
    var notesName:String?
    var notesType:String?
    
    init() {
        notesID = ""
        lastUpdated = 0
        notesString = ""
        notesDidAdd = false
        notesName = ""
        notesType = ""
    }
    
    init(id:String, lastUpdated:Int64, notes:String, agendaDidAdd : Bool, exhibitorsName: String, notesType: String) {
        self.notesID = id
        self.notesString = notes
        self.notesDidAdd = agendaDidAdd
        self.notesName = exhibitorsName
        self.lastUpdated = lastUpdated
        self.notesType = notesType
    }
    
}

struct Ratingstruct {
    
    var rating:Int16?
    var appid:String?
    var rating_id:String?
    var rating_type:String?
    var type_id:String?
    var userid:String?
    
    init() {
        rating = 0
        appid = ""
        rating_id = ""
        rating_type = ""
        type_id = ""
        userid = ""
    }
    
    init(rating:Int16, appid:String, rating_id:String, rating_type : String, type_id: String, userid: String) {
        self.rating = rating
        self.appid = appid
        self.rating_id = rating_id
        self.rating_type = rating_type
        self.type_id = type_id
        self.userid = userid
    }
    
}


struct DownlodedEventLoginDetails {
    
    var appid:String?
    var isfirstlogin: Bool?
    var password:String?
    
    init() {
        appid = ""
        isfirstlogin = true
        password = ""
    }

    init(appid:String, isfirstlogin: Bool, password: String) {
        self.appid = appid
        self.isfirstlogin = isfirstlogin
        self.password = password
    }
    
}

struct LoginDetailsForEveryEvent {
    
    var appid:String?
    var data: Data?

    init() {
        appid = ""
        data = nil
    }
    
    init(appid:String, data: Data) {
        self.appid = appid
        self.data = data
    }
    
}


struct FavoritesEvents {
    
    var id:String?
    var eventid: Int64?
    
    init() {
        id = ""
        eventid = 0
    }
    
    init(id:String, eventid: Int64) {
        self.id = id
        self.eventid = eventid
    }
    
}
