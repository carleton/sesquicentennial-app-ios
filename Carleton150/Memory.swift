//
//  Memory.swift
//  Carleton150

class Memory {
    
    var title: String!
    var desc: String!
    var timestamp: NSDate!
    var timeString: String!
    var uploader: String!
    var location: CLLocationCoordinate2D!
    var image: UIImage!
   
    init(title: String, desc: String,
         time: String, uploader: String,
         location: CLLocationCoordinate2D?, image: UIImage) {
        self.title = title
        self.desc = desc
        self.timestamp = Memory.parseDateString(time)
        self.timeString = time
        self.uploader = uploader
        self.location = location
        self.image = image
    }
   
    /**
        For building memories to be served to the user.
     */
    convenience init(title: String, desc: String,
        timestamp: String, uploader: String,
        image: UIImage) {
            
        self.init(
            title: title,
            desc: desc,
            time: timestamp,
            uploader: uploader,
            location: nil,
            image: image
        )
    }
    
    /**
        For building memories to be sent to the server.
     */
    convenience init(title: String, desc: String,
        timestamp: NSDate, uploader: String,
        location: CLLocationCoordinate2D, image: UIImage) {
            
        self.init(
            title: title,
            desc: desc,
            time: Memory.buildDateString(timestamp),
            uploader: uploader,
            location: location,
            image: image
        )
    }
   
    /**
        Given the date of the upload, formats it into the server's 
        format for accepting date strings.
     
        - Parameters: 
            - date: The date for this memory (usually the current one).
     */
    class func buildDateString(date: NSDate) -> String {
        let outFormatter = NSDateFormatter()
        outFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
        return outFormatter.stringFromDate(date)
    }
    
    
    /**
        Given the date string from the server, formats the date
        into a NSDate object.
     
        - Parameters: 
            - dateString: The dateString for the memory from the server.
     */
    class func parseDateString(dateString: String) -> NSDate {
        let inFormatter = NSDateFormatter()
        inFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
        return inFormatter.dateFromString(dateString)!
    }
    
    /**
        Given the date string from the server, formats the date
        into a nice date string with words.
     
        - Parameters: 
            - dateString: The dateString for the memory from the server.
     */
    class func buildReadableDate(date: NSDate) -> String {
        let outFormatter = NSDateFormatter()
        outFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        outFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return outFormatter.stringFromDate(date)
    }
   
    /**
        Builds a UIImage from a base64 encoded string.
     
        - Parameters: 
            - imageString: The base64 encoded string.
     
        - Returns: The built UIImage.
     */
    class func buildImageFromString(imageString: String?) -> UIImage? {
        if let imageString = imageString,
            data = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
}