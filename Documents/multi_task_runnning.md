# 멀티 태스크 러닝
하나의 모델을 이용해 다양한 테스크를 처리하기 위해 사용한다.

## 장점
- one forward propagation
- one backpropagation
- lower parameter

## 단점
- 테스크 별 데이터셋의 크기가 달라서 데이터 불균형 발생할 수 있기 때문에 학습하는 데 문제 발생 가능성 존재.
- 테스크 별 학습 난이도가 다를 수 있음. 따라서 테스크 별 다른 learning rate를 사용하거나 필요한 epoch수가 다를 수 있는데 학습할 때 이 점들을 모두 고려하여 반영하기 까다로움.

멀티 태스크 러닝은 shared network를 통해 공통의 feature를 추출하고 그 이후 분기별로 나뉘어져 각 테스크를 해결할 수 있도록 추가 학습되는 구조를 가진다. 

<img width="827" alt="Segmentation" src="https://github.com/indextrown/senior-project/assets/69367698/6396f537-e740-4cec-b236-fa719a8fb70e">
