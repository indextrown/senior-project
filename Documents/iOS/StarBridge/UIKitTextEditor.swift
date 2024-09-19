import SwiftUI
import UIKit

struct UIKitTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFocused: Bool
    @Binding var minHeight: CGFloat // 동적으로 높이를 변경할 바인딩 변수
    private let placeholder: String
    
    init(text: Binding<String>, isFocused: Binding<Bool>, minHeight: Binding<CGFloat>, placeholder: String = "내용을 입력하세요.") {
        self._text = text
        self._isFocused = isFocused
        self._minHeight = minHeight
        self.placeholder = placeholder
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.backgroundColor = UIColor(Color.p3LightGray)
        textView.textColor = .black
        textView.tintColor = UIColor(Color.pink)
        textView.textContainer.lineFragmentPadding = 0
    
        textView.autocorrectionType = .no
        updatePlaceholder(textView)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        updatePlaceholder(uiView)
        
        if isFocused && !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        } else if !isFocused && uiView.isFirstResponder {
            uiView.resignFirstResponder()
        }
        
        DispatchQueue.main.async {
            self.minHeight = max(uiView.contentSize.height, minHeight)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func updatePlaceholder(_ textView: UITextView) {
        if text.isEmpty && !isFocused {
            textView.text = placeholder
            textView.textColor = .gray
        } 
        else if textView.textColor == .gray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: UIKitTextEditor
        
        init(_ parent: UIKitTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            
            DispatchQueue.main.async {
                self.parent.minHeight = min(textView.contentSize.height, self.parent.minHeight)
            }
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            parent.isFocused = true
            if textView.textColor == .gray {
                textView.text = nil
                textView.textColor = .black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            parent.isFocused = false
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = .gray
            }
        }
    }
}

struct TestView: View {
    @State private var text = ""
    @State private var isFocused = false
    @State private var height = CGFloat(30)
    
    var body: some View {
        UIKitTextEditor(text: $text, isFocused: $isFocused, minHeight: $height)
            
        
        Text(!isFocused ? "Focusing" : "Not Focusing")
            .foregroundStyle(Color.blue)
            .onTapGesture {
                isFocused.toggle()
            }
    }
}

#Preview {
    TestView()
}
