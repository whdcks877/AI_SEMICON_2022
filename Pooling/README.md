Pooling의 경우 문제점은 분명하다
Pooling module 에서는 state가 4번째로 들어감과 동시에 Pool_valid값이 tigger된다. 
하지만 해당 경우 마지막 input값이 최댓값을 경우 그 전값이 result로 가질때 valid가 1이 된다는 문제점이 존재한다. 
그리고 result값도 max로 가기전에 잠깐 바뀌는 문제점도 개선되어야함
