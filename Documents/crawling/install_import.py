import importlib
import platform
import subprocess
import selenium
print(selenium.__version__)
class PackageManager:
    def __init__(self):
        self.required_modules = [
            "requests",
            "bs4",
            "selenium",
            "webdriver_manager",
            "chromedriver_autoinstaller",
            # ... add more modules if needed
        ]
        self.max_module_length = max(len(module) for module in self.required_modules)

    def import_module(self, module):
        try:
            importlib.import_module(module)
            print(f"# {module} 모듈을 성공적으로 임포트했습니다.{' ' * (self.max_module_length - len(module))} #")
        except ImportError:
            self.install_module(module)

    def install_module(self, module):
        install_message = f"'{module}' 모듈이 설치되어 있지 않습니다. Installing now..."
        print(f"# {install_message}{' ' * (50 - len(install_message))} #")
        try:
            #subprocess.check_call(["pip", "install", module])
            subprocess.check_call(["pip", "install", module], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            success_message = f"'{module}' 모듈 설치에 성공했습니다."
            print(f"# {success_message}{' ' * (50 - len(success_message))} #")
            self.import_module(module)  # 설치 후에 import
        except Exception as e:
            error_message = f"'{module}' 모듈 설치 중 에러 발생: {e}"
            print(f"# {error_message}{' ' * (50 - len(error_message))} #")

    def check_and_install_modules(self):
        system = platform.system()
        if system == "Windows":
            print("현재 시스템은 Windows입니다.")
            self.check_modules()

        elif system == "Darwin":
            print("현재 시스템은 macOS입니다.")
            self.check_modules()

        else:
            print("지원되지 않는 운영체제입니다.")
            try:
                print("맥 os로 시도중")
                self.check_modules()
            except:
                print("지원 불가로 강제종료")

    def check_modules(self):
        print('#' * (self.max_module_length + 38))
        print("#                필요한 패키지 확인합니다. . .                 #")
        print("#                                                              #")
        for module in self.required_modules:
            self.import_module(module)
        print('#' * (self.max_module_length + 38))
        print()

if __name__ == "__main__":
    package_manager = PackageManager()
    package_manager.check_and_install_modules()