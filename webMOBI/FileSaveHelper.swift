//
//  FileSaveHelper.swift
//  SavingFiles


import Foundation
import UIKit

class FileSaveHelper {
  
  // MARK:- Error Types
  
  private enum FileErrors:Error {
    case JsonNotSerialized
    case FileNotSaved
    case ImageNotConvertedToData
    case FileNotRead
    case FileNotFound
  }
  
  // MARK:- File Extension Types
  enum FileExtension:String {
    case TXT = ".txt"
    case JPG = ".jpg"
    case JSON = ".json"
  }
  
  // MARK:- Private Properties
  private let directory:FileManager.SearchPathDirectory
  private let directoryPath: String
  private let fileManager = FileManager.default
  private let fileName:String
  private let filePath:String
  private let fullyQualifiedPath:String
  private let subDirectory:String
  
  // MARK:- Public Properties
  var fileExists:Bool {
    get {
      return fileManager.fileExists(atPath: fullyQualifiedPath)
    }
  }
  
  var directoryExists:Bool {
    get {
      var isDir = ObjCBool(true)
      return fileManager.fileExists(atPath: filePath, isDirectory: &isDir )
    }
  }
  
  // MARK:- Initializers
  convenience init(fileName:String, fileExtension:FileExtension){
    self.init(fileName:fileName, fileExtension:fileExtension, subDirectory:"", directory:.documentDirectory)
  }
  
  convenience init(fileName:String, fileExtension:FileExtension, subDirectory:String){
    self.init(fileName:fileName, fileExtension:fileExtension, subDirectory:subDirectory, directory:.documentDirectory)
  }
    convenience init(fileName:String, Extension:FileExtension, subDirectory:String){
        self.init(fileName:fileName, Extension:Extension, subDirectory:subDirectory, directory:.documentDirectory)
    }
    
  
  /**
  Initialize the FileSaveHelper Object with parameters
  
  :param: fileName      The name of the file
  :param: fileExtension The file Extension
  :param: directory     The desired sub directory
  :param: saveDirectory Specify the NSSearchPathDirectory to save the file to
  
  */
  init(fileName:String, fileExtension:FileExtension, subDirectory:String, directory:FileManager.SearchPathDirectory){
    self.fileName = fileName + fileExtension.rawValue
    self.subDirectory = "/\(subDirectory)"
    self.directory = directory
    self.directoryPath = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)[0]
    self.filePath = directoryPath + self.subDirectory
    self.fullyQualifiedPath = "\(filePath)/\(self.fileName)"
    createDirectory()
  }
    init(fileName:String, Extension:FileExtension, subDirectory:String, directory:FileManager.SearchPathDirectory){
        self.fileName = fileName + Extension.rawValue
        self.subDirectory = "/\(subDirectory)"
        self.directory = directory
        self.directoryPath = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)[0]
        self.filePath = directoryPath + self.subDirectory 
        self.fullyQualifiedPath = "\(filePath)/\(self.fileName)"
        removeDirectory()
    }
    
    
    
    private func removeDirectory(){
        if directoryExists {
            do {
                try fileManager.removeItem(atPath: filePath)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
    }
  
  /**
  If the desired directory does not exist, then create it.
  */
  private func createDirectory(){
    if !directoryExists {
      do {
        try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: false, attributes: nil)
      }
      catch {
        print("An Error was generated creating directory")
      }
    }
  }
  
  // MARK:- File saving methods
  
  /**
  Save the contents to file
  
  :param: fileContents A String that will be saved in the file
  */
  func saveFile(string fileContents:String) throws{

    do {
      try fileContents.write(toFile: fullyQualifiedPath, atomically: true, encoding: String.Encoding.utf8)
    }
    catch  {
      throw error
    }
  }
  
  /**
  Save the image to file.
  
  :param: image UIImage
  */
  func saveFile(image:UIImage) throws {
    guard let data = UIImageJPEGRepresentation(image, 1.0) else {
      throw FileErrors.ImageNotConvertedToData
    }
    if !fileManager.createFile(atPath: fullyQualifiedPath, contents: data, attributes: nil){
      throw FileErrors.FileNotSaved
    }
  }
  
  /**
  Save a JSON file
  
  :param: dataForJson NSData
  */
  func saveFile(dataForJson:AnyObject) throws{
    do {
    let jsonData = try convertObjectToData(data: dataForJson)
        print("fullyQualifiedPath", fullyQualifiedPath)
      if !fileManager.createFile(atPath: fullyQualifiedPath, contents: jsonData as Data, attributes: nil){
        throw FileErrors.FileNotSaved
      }
    } catch {
      print(error)
      throw FileErrors.FileNotSaved
    }
    
  }
  
  func getContentsOfFile() throws -> String {
    guard fileExists else {
      throw FileErrors.FileNotFound
    }
    
    var returnString:String
    do {
       returnString = try String(contentsOfFile: fullyQualifiedPath, encoding: String.Encoding.utf8)
    } catch {
      throw FileErrors.FileNotRead
    }
    return returnString
  }
  
  func getImage() throws -> UIImage {
    guard fileExists else {
      throw FileErrors.FileNotFound
    }
    
    guard let image = UIImage(contentsOfFile: fullyQualifiedPath) else {
      throw FileErrors.FileNotRead
    }
    
    return image
    
  }
  
  func getJSONData() throws -> NSDictionary {
    guard fileExists else {
      throw FileErrors.FileNotFound
    }
    do {
      let data = try NSData(contentsOfFile: fullyQualifiedPath, options: NSData.ReadingOptions.mappedIfSafe)
      let jsonData = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! NSDictionary
      return jsonData
    } catch {
      throw FileErrors.FileNotRead
    }
    
  }

  // MARK:- Json Converting
  
  /**
  Convert the NSData to Json Data
  
  :param: data NSData
  
  :returns: Json Serialized NSData
  */
  private func convertObjectToData(data:AnyObject) throws -> NSData {
    
    do {
      let newData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
      return newData as NSData
    }
    catch {
      print("Error writing data: \(error)")
    }
    throw FileErrors.JsonNotSerialized
  }
  
  
}
