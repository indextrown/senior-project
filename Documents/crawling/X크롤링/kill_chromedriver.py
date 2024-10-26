import psutil

def kill_chrome_processes():
    """
    크롬 드라이버와 크롬 프로세스를 강제 종료하는 함수.
    """
    # 종료할 프로세스 이름 목록
    process_names_to_kill = ["chromedriver", "chrome"]

    # 모든 프로세스를 탐색하여 종료
    for process in psutil.process_iter(['pid', 'name']):
        try:
            # 프로세스 이름이 우리가 종료하려는 프로세스와 일치하는 경우
            if process.info['name'] in process_names_to_kill:
                print(f"Terminating process {process.info['name']} with PID {process.info['pid']}")
                #process.terminate()  # 프로세스 종료
                process.kill()  # 프로세스 강제 종료 (SIGKILL)
                process.wait()  # 프로세스 종료 대기
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass

if __name__ == "__main__":
    kill_chrome_processes()

