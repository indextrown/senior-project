import SwiftUI
import Combine

struct testingView: View {
    @State private var date = ""
    @State private var result: String = ""
    @State private var parsedData: [String: ResponseData] = [:]
    
    var body: some View {
        VStack {
            
            TextField("date", text: $date)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .border(Color.black)
                .padding()
            
            Button("Fetch Data") {
                getData(for: date)
            }
            .padding()
            ScrollViewReader{ sclProxy in
                ScrollView(){
                    ForEach(Array(parsedData.values), id: \.self){ pdValue in
                        VStack{
                            Text("""
                        kind: \(pdValue.kind ?? ""),
                        title: \(pdValue.title ?? ""),
                        detail: \(pdValue.detail ?? ""),
                        singer: \(pdValue.singer ?? ""),
                        x_id: \(pdValue.x_id ?? ""),
                        event_date: \(pdValue.event_date ?? ""),
                        post_date: \(pdValue.post_date ?? ""),
                        url: \(pdValue.url ?? ""),
                        """)
                            .padding()
                            if let photos = pdValue.photos{
                                ForEach(photos.compactMap{$0}, id: \.self){ photo in
                                    if let image = loadImage(from: photo) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 300, height: 300)
                                            .padding()
                                    }
                                    else {
                                        Text("Image not available")
                                            .frame(width: 300, height: 300)
                                            .background(Color.gray)
                                    }
                                }
                                if photos.isEmpty{
                                    Text("No Image")
                                        .frame(width: 300, height: 300)
                                        .border(Color.black)
                                }
                            }
                            else{
                                ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(3) // 스피너 크기 조정
                                .padding()
                            }
                        }
                        .frame(width: iPhonePointRes.currentDeviceWidth(), height: iPhonePointRes.currentDeviceHeight())
                        .padding()
                        .border(Color.black)
                    }
                    .padding()
                }
            }
        }
        .padding()
    }
    
    func getData(for date: String) {
       guard let url = URL(string: "http://13.125.169.165:8000/api_main") else {
           print("Wrong URL")
           return
       }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = ["date": date]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let data = data {
                do {
                    // JSON 데이터를 모델로 디코딩
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode([String: ResponseData].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.parsedData = decodedData
                    }
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.result = jsonString
                        print(jsonString)
                    }
                }
            }
            else{
                print("Unable to get data")
            }
        }
        .resume()
    }
    
    func loadImage(from base64String: String) -> UIImage?{
        guard let imageData = Data(base64Encoded: base64String) else {
            print("Failed to decode base64 string.")
            return nil
        }
        return UIImage(data: imageData)
    }
}

#Preview{
    testingView()
}
