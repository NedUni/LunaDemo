//
//  LunaApp.swift
//  Luna
//
//  Created by Ned O'Rourke on 18/1/22.
//

import SwiftUI
import Firebase
import FirebaseMessaging
import FirebaseAnalytics
import FacebookLogin
import FacebookCore
import SDWebImage
import SDWebImageSwiftUI
import CoreLocation
import MapKit
import Mixpanel

@main
struct Luna: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @StateObject var sessionService = SessionServiceImpl()
//    @State var deepLink: DeepLinkHandler.DeepLink?
//    @Environment(\.deepLink) var deepLink
//    var locationManager : LocationManager = appDelegate.locationManager
//    @StateObject var locationManger = LocationManager()
//    @StateObject var locationManager : LocationManager
    @State var didReceiveDynamicLink = false
    @State var dynamicLinkedEvent : EventObj?
    
    @AppStorage("isDarkMode") var isDarkMode = true
    let timer = Timer.publish(every: 55, on: .main, in: .common).autoconnect()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                let signedIn = sessionService.isSignedIn()
                
                if signedIn == true {
                    ContentView(didReceiveDynamicLink: $didReceiveDynamicLink, dynamicLinkedEvent: $dynamicLinkedEvent)
                        .environmentObject(sessionService)
                        .environmentObject(delegate.locationManager)
                } else if let token = AccessToken.current,
                    !token.isExpired {
                          // User is logged in, do work such as go to next view controller.
                    ContentView(didReceiveDynamicLink: $didReceiveDynamicLink, dynamicLinkedEvent: $dynamicLinkedEvent)
                        .environmentObject(sessionService)
                        .environmentObject(delegate.locationManager)
                } else {
                    LandingPage()
                        .environmentObject(sessionService)
                        .environmentObject(delegate.locationManager)
                        .onOpenURL { url in
                            print("Received url: \(url)")
                            ApplicationDelegate.shared.application(
                                UIApplication.shared,
                                open: url,
                                sourceApplication: nil,
                                annotation: UIApplication.OpenURLOptionsKey.annotation
                            )
                        }
                    
                }
            }
            .onReceive(timer, perform: { output in
                if auth.currentUser != nil {
                    db.collection("profiles").document(auth.currentUser!.uid).updateData(["lastOnline" : Date()]) { error in
                        if let error = error {
                            print("Error updating online status: \(error.localizedDescription)")
                        }
                    }
                }
                
            })
            .onOpenURL { url in

                if sessionService.isSignedIn() == true {
                    let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(url) { dynamicLink, error in
                        guard error == nil else {
                          fatalError("Error handling the incoming dynamic link.")
                        }
                        // 3
                        if let dynamicLink = dynamicLink {
                          // Handle Dynamic Link
                            let eventID = sessionService.parseComponents(from: dynamicLink.url!)
                            if eventID == "" {
                                print("Could not parse URL components from url: \(url)")
                                return
                            }
                            sessionService.getEventByID(id: eventID) { event in
                                
                                DispatchQueue.main.async {
                                    dynamicLinkedEvent = event
                                    didReceiveDynamicLink = true
                                }
                            }
                        }
                      }
                      // 4
                      if linkHandled {
                        print("Link Handled")
                      } else {
                        print("No Link Handled")
                         
                      }
//                    var components = URLComponents(
//                        url: url,
//                        resolvingAgainstBaseURL: false
//                    )!
//                    guard let decodedLink = components.queryItems?[0] else {
//                        print("Couldn't get link from query.")
//                        return
//                    }
                    
                    
//                    let url2 = URL(string: decodedLink)
//                    var components = URLComponents(
//                        url: url2,
//                        resolvingAgainstBaseURL: false
//                    )!
//
//                    let items = components.queryItems
                    
                    
                    
                }
                
            }
            .preferredColorScheme(.dark)
        }
        
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var token = String()
    
    @ObservedObject var locationManager = LocationManager()
    
    

  var window: UIWindow?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//          locationManager.manager.stopUpdatingLocation()
//          locationManager.manager.delegate = nil
          locations.last.map {
              locationManager.region = MKCoordinateRegion(
                  center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                  span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
              )
          }
      }
    
    @objc func getLocation() {
        let calendar = Calendar.current
        let date = Date()
        let day = calendar.component(.weekday, from: date)
        if (day == 1 || day == 6 || day == 7) {
            let hour = calendar.component(.hour, from: date)
            if (hour >= 13 && hour <= 23) {
//                locationManager.manager.allowsBackgroundLocationUpdates = true
                locationManager.manager.delegate = self
                locationManager.manager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.manager.startUpdatingLocation()
                locationManager.manager.startMonitoringSignificantLocationChanges()
//                print("region2: \(locationManager.region)")
                
                guard let uid = auth.currentUser?.uid else {return}

                let docRef = db.collection("profiles").document(uid)

                docRef.getDocument { result, error in
                    if let error = error {
                        print("Error getting user document for location update: \(error)")
                        return
                    }
                    
                    let oldLat = result?["currLatitude"] ?? 0
                    let oldLong = result?["currLongitude"] ?? 0
                    
                    docRef.updateData([
                          "oldLatitude" : oldLat,
                          "oldLongitude" : oldLong,
                          "currLatitude" : self.locationManager.region.center.latitude,
                          "currLongitude" : self.locationManager.region.center.longitude,
                          "lastLocationUpdate" : Date()
                    ])
                    
                }
            }
        }
        
          
          
      }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("\(#function)")
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
      }
      
      func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("\(#function)")
        if Auth.auth().canHandleNotification(notification) {
          completionHandler(.noData)
          return
        }
      }
      
      func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        print("\(#function)")
        if Auth.auth().canHandle(url) {
          return true
        }
        return false
      }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if Auth.auth().currentUser != nil {
            OnlineOfflineService.online(for: (Auth.auth().currentUser?.uid)!, status: false){ (success) in

                print("User ==>", success)
            }
        }
     }
    

    
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        
    FirebaseApp.configure()
    FirebaseConfiguration.shared.setLoggerLevel(.min)
    FBSDKCoreKit.ApplicationDelegate.shared.application(
                application,
                didFinishLaunchingWithOptions: launchOptions
            )
    UNUserNotificationCenter.current().delegate = self
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        if auth.currentUser != nil {
            UNUserNotificationCenter.current().requestAuthorization(
              options: authOptions) { _, _ in }
        }
    
    Mixpanel.initialize(token: "3a311bbc3e84a53d38aa1e8d8c20696e")
    application.registerForRemoteNotifications()
    Messaging.messaging().delegate = self
    getLocation()
    
        _ = Timer.scheduledTimer(timeInterval: 1800.0, target: self, selector: #selector(getLocation), userInfo: nil, repeats: true)
    
        if auth.currentUser != nil {
            db.collection("profiles").document(auth.currentUser!.uid).updateData(["lastOnline" : Date()]) { error in
                if let error = error {
                    print("Error updating online status: \(error.localizedDescription)")
                }
            }
        }
 

    return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
                     annotation: Any) -> Bool {
      if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
          print("got dynamic link: \(dynamicLink)")
        // Handle the deep link. For example, show the deep-linked content or
        // apply a promotional offer to the user's account.
        // ...
        return true
      }
        print("didn't get dynamic link")
      return false
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
      let handled = DynamicLinks.dynamicLinks()
        .handleUniversalLink(userActivity.webpageURL!) { dynamiclink, error in
            print("got dynamic link 2: \(String(describing: dynamiclink))")
        }

      return handled
    }

}

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var pageToNavigationTo : String?
//    @Published var linkedEvent : String?
//    EventObj?
//    @Published var userObjPayload : UserObj?
}

//class NotificationService: UNNotificationServiceExtension {
//    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
//        let destination = request.content.userInfo["destination"] as? String ?? ""
//        if destination == "friendmessageview" {
//            UNUserNotificationCenter.current().requestAuthorization(options: .badge) { (granted, error) in
//                if error != nil {
//                    print("Error requesting notification auth: \(error!.localizedDescription)")
//                } else {
//                    DispatchQueue.main.async {
//                        UIApplication.shared.applicationIconBadgeNumber += 1
//                    }
//                }
//            }
//        }
//    }
//}

extension AppDelegate: UNUserNotificationCenterDelegate {
//  func userNotificationCenter(
//    _ center: UNUserNotificationCenter,
//    willPresent notification: UNNotification,
//    didReceive response: UNNotificationResponse,
//    withCompletionHandler completionHandler:
//    @escaping (UNNotificationPresentationOptions) -> Void
//  ) {
//
//    print("notif data: \(response.notification.request.content.userInfo)")
//    completionHandler([[.banner, .sound]])
//  }

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
//      let destinationsWithPayload = ["friendmessageview"]
      let destination = response.notification.request.content.userInfo["destination"] as? String ?? ""

      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          print("Dispatched to \(destination)")
          AppState.shared.pageToNavigationTo = destination
          
          if destination == "friendmessageview" {
              UNUserNotificationCenter.current().requestAuthorization(options: .badge) { (granted, error) in
                  if error != nil {
                      print("Error requesting notification auth: \(error!.localizedDescription)")
                  } else {
                      DispatchQueue.main.async {
                          UIApplication.shared.applicationIconBadgeNumber += 1
                      }
                  }
              }
              
////              AppState.shared.userObjPayload = response.notification.request.content.userInfo["payload"] as! UserObj
//
          }
          
      }
      
    completionHandler()
  }
    
    

//    func application(
//      _ application: UIApplication,
//      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
//    ) {
//        Messaging.messaging().apnsToken = deviceToken
//    }
//    
//    func application(
//        _ app: UIApplication,
//        open url: URL,
//        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
//    ) -> Bool {
//        ApplicationDelegate.shared.application(
//            app,
//            open: url,
//            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//        )
//    }
}

extension AppDelegate: MessagingDelegate {
  func messaging(
    _ messaging: Messaging,
    didReceiveRegistrationToken fcmToken: String?
  ) {
    let tokenDict = ["token": fcmToken ?? ""]
      token.self = fcmToken ?? "no token"
      print(fcmToken ?? "no token")
      

    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: tokenDict)
  }
}

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}

struct OnlineOfflineService {
    static func online(for uid: String, status: Bool, success: @escaping (Bool) -> Void) {
        //True == Online, False == Offline
        db.collection("profiles").document(uid).updateData(["lastOnline" : Date()]) { error in
            if let error = error {
                print("Error updating user status: \(error)")
                success(false)
            }
            success(true)
        }
    }
}
//extension Font {
//
//    /// Create a font with the large title text style.
//    public static var largeTitle: Font {
//        return Font.custom("OpenSans-Regular", size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
//    }
//
//    /// Create a font with the title text style.
//    public static var title: Font {
//        return Font.custom("OpenSans-Regular", size: UIFont.preferredFont(forTextStyle: .title1).pointSize)
//    }
//
//    /// Create a font with the headline text style.
//    public static var headline: Font {
//        return Font.custom("OpenSans-Regular", size: UIFont.preferredFont(forTextStyle: .headline).pointSize)
//    }
//
//    /// Create a font with the subheadline text style.
//    public static var subheadline: Font {
//        return Font.custom("OpenSans-Light", size: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
//    }
//
//    /// Create a font with the body text style.
//    public static var body: Font {
//           return Font.custom("OpenSans-Regular", size: UIFont.preferredFont(forTextStyle: .body).pointSize)
//       }
//
//    /// Create a font with the callout text style.
//    public static var callout: Font {
//           return Font.custom("OpenSans-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize)
//       }
//
//    /// Create a font with the footnote text style.
//    public static var footnote: Font {
//           return Font.custom("OpenSans-Regular", size: UIFont.preferredFont(forTextStyle: .footnote).pointSize)
//       }
//
//    /// Create a font with the caption text style.
//    public static var caption: Font {
//           return Font.custom("OpenSans-Regular", size: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
//       }
//
//    public static func system(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
//        var font = "OpenSans-Regular"
//        switch weight {
//        case .bold: font = "OpenSans-Bold"
//        case .heavy: font = "OpenSans-ExtraBold"
//        case .light: font = "OpenSans-Light"
//        case .medium: font = "OpenSans-Regular"
//        case .semibold: font = "OpenSans-SemiBold"
//        case .thin: font = "OpenSans-Light"
//        case .ultraLight: font = "OpenSans-Light"
//        default: break
//        }
//        return Font.custom(font, size: size)
//    }
//}
//
