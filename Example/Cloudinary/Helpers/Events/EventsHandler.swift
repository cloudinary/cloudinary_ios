//
//  EventsHandler.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 05/02/2024.
//

import Foundation
import Foundation
class EventsHandler{
    static let shared = EventsHandler();
    private var providersList = [EventsProvider]();
    private init() {
        initProvidersList();
    }

    private func initProvidersList(){
        providersList.append(FirebaseEventsHandler())
    }

    func logEvent(event:EventObject){
        for provider in providersList{
            provider.logEvent(event: event);
        }
    }


}
