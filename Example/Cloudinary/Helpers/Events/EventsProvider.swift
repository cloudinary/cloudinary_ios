//
//  EventsProvider.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 05/02/2024.
//

import Foundation

protocol EventsProvider {
    func logEvent(event: EventObject)
}
