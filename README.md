# LocalWeather

- OpenWeather API를 이용한 지역날씨 정보 App
- RxSwift, RxCocoa가 사용 되었습니다.


## 첫 번째 화면

<img src="https://user-images.githubusercontent.com/30033658/152104806-171be8fa-0360-4bca-a8cc-1aeda6dc5ea6.png" width="50%">
- 전국 지역의 날씨를 지역명을 기준으로 기온, 날씨 아이콘, 습도를 포함한 TableView로 표시합니다.

- 지역 정보를 선택하면 상세 날씨정보 화면으로 이동합니다.

- 섭씨/화씨 변환 버튼을 통해 표시방식을 변경 할 수 있습니다.

## 두 번째 화면

<img src="https://user-images.githubusercontent.com/30033658/152105010-bc4af71f-28ce-4049-9654-91108150e648.png" width="50%">
- 선택 된 지역의 날씨 상세정보를 표시합니다 

- API Data에서 가져온 현재기온, 체감기온, 날씨 설명, 최고/최저 기온, 현재습도, 기압, 풍속을 표시합니다.

- 미래날씨 버튼을 선택하여 해당 지역의 날씨 예보 화면으로 이동합니다.

## 세 번째 화면
<img src="https://user-images.githubusercontent.com/30033658/152105090-33430a55-aaf0-4193-9291-fe438a6ac52f.png" width="50%">
<img src="https://user-images.githubusercontent.com/30033658/152105140-61bb104a-cadb-43ca-abbb-ccc51f6b63bd.png" width="50%">
- 미래날씨 화면에서는 Forecase API Data를 이용하여 3시간 간격으로 5일간의 최저/최고 기온과 습도를 꺾은서 그래프로 표시합니다.

- 핀치줌 동작으로 그래프를 확대/축소 할 수 있습니다.

- 화면의 방향에 따라 그래프를 넓게 확인 할 수 있습니다.
