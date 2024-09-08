document.addEventListener('DOMContentLoaded', function() {

    //회원가입 버튼
    const submitButton = document.getElementById('user-create-btn');

    if (submitButton) {
        submitButton.addEventListener('click', function() {
            const formData = {
                userId: document.getElementById('userId').value,
                password: document.getElementById('password').value,
                nickname: document.getElementById('nickname').value,
                email: document.getElementById('email').value
            };

            fetch('/api/users', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            })
                .then(response => {
                    if (response.ok) {
                        // 성공적으로 가입이 완료되면 이동할 리디렉션 (login.html)
                        window.location.href = '/login';
                    } else {
                        return response.json().then(data => {
                            console.error('Error:', data);
                            alert('가입 중 오류가 발생했습니다.');
                        });
                    }
                })
                .catch((error) => {
                    console.error('Error:', error);
                    alert('가입 중 오류가 발생했습니다.');
                });
        });
    }


    //로그인 버튼
    const loginButton = document.getElementById('user-login-btn');

    if (loginButton) {
        loginButton.addEventListener('click', function() {
            const loginData = {
                userId: document.getElementById('userId').value,
                password: document.getElementById('password').value
            };

            fetch('/api/login', {  // '/api/login' 엔드포인트는 서버에서 정의한 URL입니다.
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(loginData)
            })
                .then(response => {
                    if (response.ok) {
                        return response.json();
                    }
                    throw new Error('Login failed');
                })
                .then(data => {
                    console.log('Login success:', data);
                    //도전
                    alert('반갑습니다 ^_^');
                    //로그인 성공시 리다이렉션 주소 (main.html)
                    window.location.href = '/main';
                })
                .catch((error) => {
                    console.error('Error:', error);
                    // 로그인 실패 시 사용자에게 알림을 표시하는 로직을 추가할 수 있습니다.
                    alert('아이디 혹은 비밀번호가 틀렸습니다.');

                });
        });
    }





});