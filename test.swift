import UIKit
import Combine

class FifthViewController: UIViewController {
   
   var subscriptions = Set<AnyCancellable>()

   let nicknameTextField = UITextField()
   let agreeButton = UIButton(type: .system)
   let completeButton = UIButton(type: .system)
   
   override func viewDidLoad() {
       super.viewDidLoad()
       
       nicknameTextField.delegate = self
       setupUI()
       
   }
   
   // Return 키를 눌렀을 때 호출되는 메서드
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // 키보드 내리기
       textField.resignFirstResponder()
       return true
   }
   
   

   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       // 네비게이션바 숨기기
       self.navigationController?.setNavigationBarHidden(true, animated: animated)
       // 탭바 숨기기
       self.tabBarController?.tabBar.isHidden = true
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       // 네비게이션바 보이기
       self.navigationController?.setNavigationBarHidden(false, animated: animated)
       // 탭바 보이기
       self.tabBarController?.tabBar.isHidden = false
   }
   
   func setupUI() {
       // 상단바
       let headerLabel = UILabel()
       headerLabel.text = "BanCnango"
       headerLabel.font = UIFont.systemFont(ofSize: 24, weight: .black)
       headerLabel.textAlignment = .center
       headerLabel.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(headerLabel)
       
       NSLayoutConstraint.activate([
           headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
           headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
       ])
       
       // 안내 텍스트
       let guideLabel = UILabel()
       guideLabel.text = "회원가입에 필요한\n정보를 입력해주세요"
       guideLabel.font = UIFont.boldSystemFont(ofSize: 18)
       guideLabel.numberOfLines = 0
       guideLabel.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(guideLabel)
       
       NSLayoutConstraint.activate([
           guideLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
           guideLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
           guideLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
       ])
       
       // 닉네임 필드
       let nicknameLabel = UILabel()
       nicknameLabel.text = "반창고 닉네임"
       nicknameLabel.font = UIFont.boldSystemFont(ofSize: 14)
       nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(nicknameLabel)
       
       nicknameTextField.placeholder = "언제든 바꿀 수 있어요"
       nicknameTextField.borderStyle = .roundedRect
       nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(nicknameTextField)
       
       NSLayoutConstraint.activate([
           nicknameLabel.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 80),
           nicknameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
           nicknameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
           
           nicknameTextField.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
           nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
           nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
           nicknameTextField.heightAnchor.constraint(equalToConstant: 44)
       ])
       
       /*
       // 서비스 약관 동의
       let agreementLabel = UILabel()
       agreementLabel.text = "서비스 약관 동의 *"
       agreementLabel.font = UIFont.boldSystemFont(ofSize: 14)
       agreementLabel.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(agreementLabel)
       
       let agreeGuide = UILabel()
       agreeGuide.text = "동의 체크 후 앱을 이용할 수 있어요"
       agreeGuide.font = UIFont.systemFont(ofSize: 14)
       agreeGuide.textColor = UIColor.gray
       agreeGuide.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(agreeGuide)
       
       agreeButton.setImage(UIImage(systemName: "square"), for: .normal)
       agreeButton.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
       agreeButton.translatesAutoresizingMaskIntoConstraints = false
       agreeButton.addTarget(self, action: #selector(agreeButtonTapped), for: .touchUpInside)
       view.addSubview(agreeButton)
       
       // 이용약관 및 개인정보처리방침
       let termsLabel = UILabel()
       termsLabel.text = "이용약관 및 개인정보처리방침"
       termsLabel.font = UIFont.systemFont(ofSize: 14)
       termsLabel.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(termsLabel)

       NSLayoutConstraint.activate([
           agreementLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 80),
           agreementLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
           agreementLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
           
           agreeGuide.topAnchor.constraint(equalTo: agreementLabel.bottomAnchor, constant: 5),
           agreeGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
           agreeGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
           
           agreeButton.topAnchor.constraint(equalTo: agreeGuide.bottomAnchor, constant: 20),
           agreeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
           agreeButton.widthAnchor.constraint(equalToConstant: 24),
           agreeButton.heightAnchor.constraint(equalToConstant: 24),
           
           termsLabel.centerYAnchor.constraint(equalTo: agreeButton.centerYAnchor),
           termsLabel.leadingAnchor.constraint(equalTo: agreeButton.trailingAnchor, constant: 8)
       ])
       
       
       // 완료 버튼
       completeButton.setTitle("완료", for: .normal)
       completeButton.backgroundColor = .gray
       completeButton.setTitleColor(.white, for: .normal)
       completeButton.layer.cornerRadius = 22
       completeButton.isEnabled = false
       completeButton.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(completeButton)

       NSLayoutConstraint.activate([
           completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
           completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
           completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
           completeButton.heightAnchor.constraint(equalToConstant: 44)
       ])
       */
   }
   
   @objc func agreeButtonTapped() {
       // Toggle the button's selected state
       agreeButton.isSelected.toggle()
       
       // Enable or disable the completeButton based on the state of agreeButton
       completeButton.isEnabled = agreeButton.isSelected
       completeButton.backgroundColor = agreeButton.isSelected ? .systemBlue : .gray
   }
   
//    // 바탕을 누르면 키보드 내려가게 설정
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
}




extension FifthViewController: UITextFieldDelegate {
   // 바탕을 누르면 키보드 내려가게 설정
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       self.view.endEditing(true)
   }
}

