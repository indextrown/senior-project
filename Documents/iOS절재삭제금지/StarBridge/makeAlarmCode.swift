import SwiftUI
import UserNotifications

struct ContentView: View {
    var body: some View {
        Button("알림 보내기") {
            // 알림 권한 요청
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("알림 권한 허용됨")
                    sendNotification()
                } else {
                    print("알림 권한 거부됨")
                }
            }
        }
    }
    
    func sendNotification() {
        // 알림 콘텐츠 생성
        let content = UNMutableNotificationContent()
        content.title = "푸시 알림 제목"
        content.body = "이것은 버튼을 눌러서 보낸 알림입니다."
        content.sound = UNNotificationSound.default
        
        // 5초 후에 알림이 뜨도록 트리거 설정
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // 알림 요청 생성
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // 알림 요청을 Notification Center에 추가
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 요청 에러: \(error.localizedDescription)")
            } else {
                print("알림이 성공적으로 등록됨")
            }
        }
    }
}
