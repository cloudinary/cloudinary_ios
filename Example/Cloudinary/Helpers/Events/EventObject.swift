//
//  EventObject.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 05/02/2024.
//

import Foundation

class EventObject{
    var eventName:String?;
    var eventAttributes:[String:String]?;

    init(name: String, attributes: [String: String]? = nil) {
        self.eventName = name
        self.eventAttributes = attributes
    }

    func getAttributes() -> [String:String]? {
        return eventAttributes;
    }

    func setEventAttribute(_ key:String,_ value:String) {
        eventAttributes![key] = value;
    }

    func setEventAttributes(attrs:[String:String]) {
        self.eventAttributes = attrs;
    }

    func getEventName()->String {
        return eventName!;
    }

    func setEventName(name:String) {
        eventName = name;
    }
}
