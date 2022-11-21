//
//  AuthenticationViewModel.swift
//  GoogleCalendarAPIDemo
//
//  Created by Goel, Pratik on 20/11/22.
//

import Foundation
import Firebase
import GoogleSignIn
import GoogleAPIClientForREST_Calendar
import CoreSpotlight
import MobileCoreServices



enum SignInState {
    case signedIn
    case signedOut
}

enum CalendarError: Error {
    case calendarServiceError
    case networkError
}

struct CalendarColorDefinitons: Codable {
    let calendar: [Int : ColorDefinition]
    let event: [Int : ColorDefinition]
}

struct ColorDefinition: Codable {
    let background: String
    let foreground: String
}

class AuthenticationViewModel: ObservableObject {

    @Published var state: SignInState = .signedOut
    @Published var calendarService: GTLRCalendarService? = nil
    @Published var calendarList: GTLRCalendar_CalendarList = GTLRCalendar_CalendarList()
    @Published var calendarListItems: [GTLRCalendar_CalendarListEntry] = [] {
        didSet {
            addCalendarListToSpotlight()
        }
    }
    @Published var calendarColorDefinitions: CalendarColorDefinitons?
    @Published var allEvents : [String: [GTLRCalendar_Event]] = [:] {
        didSet {
            addCalendarEventsToSpotlight()
        }
    }

    func signIn() {
            // Checking for previous sign-in, if yes, then restore it, else move to sign in
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
                // fetching clientID from firebaseApp (GoogleService-Info.plist)
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }

                // creating google sign in config object with clientID
            let configuration = GIDConfiguration(clientID: clientID)

                // since swiftui has no viewcontroller, we use uiapplication window to check for the root vc
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }

                // signing in if all dependencies are met
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController, hint: "", additionalScopes: [kGTLRAuthScopeCalendar]) { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        }
    }

    func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
            // handle authentication error
        if let error = error {
            print(error.localizedDescription)
            self.state = .signedOut
            return
        }
        self.state = .signedIn

        getCalendarService(user)
        fetchData()
    }

    func fetchData() {
        self.getCalendarList()
        self.getCalendarColors()
        var timer = Timer()
        switch state {
        case .signedIn:
            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
                self.getCalendarList()
                self.getCalendarColors()
            })
        case .signedOut:
            timer.invalidate()
        }
    }

    func signOut() {
            // sign out of google
        GIDSignIn.sharedInstance.signOut()

        do {
                // sign out of firebase app as well
            try Auth.auth().signOut()
            state = .signedOut
        } catch {
            print(error.localizedDescription)
        }
    }

    func restoreSignIn() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        }
    }

    func getCalendarService(_ user: GIDGoogleUser?) {
        let service = GTLRCalendarService()
        service.shouldFetchNextPages = true
        service.isRetryEnabled = true
        service.maxRetryInterval = 15
        guard let currentUser = user else { return }
        let authentication = currentUser.authentication
        service.authorizer = authentication.fetcherAuthorizer()
        self.calendarService = service
    }

    func getCalendarColors() {
        guard let calendarService = self.calendarService else { return }

        let colorListQuery = GTLRCalendarQuery_ColorsGet.query()

        _ = calendarService.executeQuery(colorListQuery) { (_, colorList, error) in
            guard error == nil, let colorList = colorList as? GTLRCalendar_Colors else { return }

            // Fetch all calendar color definitions
            do {
                self.calendarColorDefinitions = try JSONDecoder().decode(CalendarColorDefinitons.self, from: Data(colorList.jsonString().utf8))
            } catch {
                print(error)
            }
        }
    }

    func getCalendarList() {
        guard let calendarService = self.calendarService else { return }

        let calendarListQuery = GTLRCalendarQuery_CalendarListList.query()

        _ = calendarService.executeQuery(calendarListQuery) { (_, calendarList, error) in
            guard error == nil, let calendarList = (calendarList) as? GTLRCalendar_CalendarList else { return }

            self.calendarList = calendarList

            // check for nil or no calendars
            guard let calendarListItems = calendarList.items, calendarListItems.count > 0 else { return }

            // Fetch all calendar items
            self.calendarListItems = calendarListItems as [GTLRCalendar_CalendarListEntry]

            // Fetch all calendar events for calendar items
            for item in calendarListItems {
                self.getEventList(for: item.identifier ?? "primary") { result in
                    switch result {
                    case .success((let events)):
                        var id = item.identifier
                        let user = GIDSignIn.sharedInstance.currentUser
                        if let email = user?.profile?.email {
                            if let idx = id, idx == email {
                                id = "primary"
                            }
                        }
                        self.allEvents[id ?? "primary"] = events
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }

    func getEventList(for calendarId: String, showDeleted: Bool = false, showHidden: Bool = false, startDateTime: GTLRDateTime? = nil, endDateTime: GTLRDateTime? = nil, completion: @escaping (Result<[GTLRCalendar_Event], Error>) -> Void) {
        guard let service = self.calendarService else {
            completion(.failure(CalendarError.calendarServiceError))
            return
        }

        let eventsListQuery = GTLRCalendarQuery_EventsList.query(withCalendarId: calendarId)
        eventsListQuery.timeMin = startDateTime
        eventsListQuery.timeMax = endDateTime
        eventsListQuery.showDeleted = showDeleted

        _ = service.executeQuery(eventsListQuery) { (_, result, error) in
            guard error == nil, let items = (result as? GTLRCalendar_Events)?.items else {
                completion(.failure(CalendarError.networkError))
                return
            }
            completion(.success(items))
        }
    }
}


extension AuthenticationViewModel {

    func addCalendarListToSpotlight() {
        let bundleID = Bundle.main.bundleIdentifier
        let domainIdentifier = "\(bundleID).calendarList"
        let searchableItems = calendarListItems.map { entity -> CSSearchableItem in
            let attributeSet = CSSearchableItemAttributeSet(contentType: .content)
            attributeSet.containerDisplayName = "Calendar"
            attributeSet.title = entity.summary
            attributeSet.contentDescription = entity.descriptionProperty
            attributeSet.relatedUniqueIdentifier = entity.identifier
            return CSSearchableItem(uniqueIdentifier: entity.identifier, domainIdentifier: domainIdentifier, attributeSet: attributeSet)
        }
        removeFromSpotlight(domainIdentifier)
        addToSpotlight(searchableItems)
    }

    func addCalendarEventsToSpotlight() {
        let bundleID = Bundle.main.bundleIdentifier
        let domainIdentifier = "\(bundleID).calendarEvents"
        let events = allEvents.flatMap { $0.value }
        let searchableItems = events.map { entity -> CSSearchableItem in
            let attributeSet = CSSearchableItemAttributeSet(contentType: .content)
            attributeSet.containerDisplayName = "Event"
            attributeSet.title = entity.summary
            attributeSet.contentDescription = entity.descriptionProperty
            attributeSet.relatedUniqueIdentifier = entity.identifier
            attributeSet.url = URL(string: entity.hangoutLink ?? "")
            attributeSet.startDate = entity.start?.dateTime?.date ?? Date.now
            attributeSet.endDate = entity.end?.dateTime?.date ?? Date.now
            return CSSearchableItem(uniqueIdentifier: entity.identifier, domainIdentifier: domainIdentifier, attributeSet: attributeSet)
        }
        removeFromSpotlight(domainIdentifier)
        addToSpotlight(searchableItems)
    }

    func addToSpotlight( _ searchableItems: [CSSearchableItem]) {
        CSSearchableIndex.default().indexSearchableItems(searchableItems) { error in
            if let error = error {
                print(error)
            }
        }
    }

    func removeFromSpotlight(_ domainIdentifier: String) {
        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [domainIdentifier])
        { (error: Error?) -> Void in
            if let error = error {
                print("Remove error: \(error.localizedDescription)")
            }
        }
    }

    func stringArrayToData(stringArray: [String]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: stringArray, options: [])
    }

    func dataToStringArray(data: Data) -> [String]? {
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String]
    }
}
