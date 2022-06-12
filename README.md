## 목차
- [학습 내용](#학습-내용)
- [요약](#요약)
- [학습 키워드](#학습-키워드)
- [주요 내용](#주요-내용(클릭-아키텍쳐))

## 학습 내용
- `layered architecture` 개념이 도입된 프로젝트.
- `OOP`, `의존성 주입`, `각 레이어의 역활과 책임 분리` , `네트워크 예외처리` 개념에 집중.
- News API를 활용한 프로젝트.

## 요약

| Index          | Detail                                                                                                                                                                                                                                   |
|----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 기여             | 개발 100%                                                                                                                                                                                                                                  |
| 구현 기간          | 2022.05.27 ~ 2022.06.03                                                                                                                                                                                                                  |
| 기술 스택          | - Flutter , Getx, Retrofit                                                                                                                                                                                                               |



## 학습 키워드
Getx

- GetFind
- GetView
- GexController (BaseView, BaseViewModel)
- Getx Route
- dependenceis

OOP

- Abstract, Implement

Retrofit

- fromtoJson, toJson
    - Singletone Pattern
- Json_annotation.

Exceptions

- Result Type
    - Like `Either`
- loadResponseOrThroe

DesignPattern

- Data, Domain, MVVM
- Exceptions



## 주요 내용(클릭 아키텍쳐)
<img src="https://user-images.githubusercontent.com/75591730/173224385-c28ab882-429d-4a67-bdaf-87fddd734825.png">

## API

<aside>
💡 서버와 직접적으로 통신하는 레이어. `request`  `response`  통신. (PATCH 메소드도 사용)

</aside>

- 사용된 라이브러리
    - Retrofit, Dio, JsonAnotation(@JsonSerializable)
- 해당 레이어에서는 모든 API 데이터를 그대로 가져와야됨. 데이터를 가져오는 과정에서 수정 및 추출 X
- request, response 객체를 만듦
    - `request`
        - 객체를 받아서 JSON으로 변환

        ```dart
        @JsonSerializable(explicitToJson: true, createFactory: false)
        class ExampleReuest {
        ......
        } 
        ```

        - 서버로 요청하는 값을 전달하는  것이기  때문에`create Factory`를할 필요가 없음. (toJson)
    - `response`
        - Json을 받아서 객체로 변환 (직렬화)
        - 현재 서비스에 사용되는 API 구조에서는 데이터 안쪽만 직렬화하는 경우만 고려하면 됨.

        ```dart
        @JsonSerializable(createToJson: false)
        class ExampleResponse {
        ....
        }
        ```

        - 서버가 준 응답을 받는 것이기 때문에 `createToJson` 을 할 필요가 없음.

---

## DataSource

<aside>
💡 DataSource에서도 API(Entity) 단계에서 필요한 `rqueset` `response` 와 관련된 로직을 포함.  자세히 말하자면 API 레이어에서 받은 Entity를 다음 레이어로 넘겨주는 역할을 수행하지만 이때 적절히 `Network Exception`로직과  `Token Excetion` (JWT 관련)로직이 수행됨.

</aside>

- 간단하게 말하면 API를 받거나 불러올 때 에러인지 아닌지 분기하는 레이어.

### 1. Network Exception 처리 (loadResponseOrThrow)

```dart
class ArticleRemoteDataSourceImpl
    with ApiErrorHandlerMixin
    implements ArticleRemoteDataSource {
  final ArticleApi _articleApi;

  ArticleRemoteDataSourceImpl(this._articleApi);

  @override
  **Future<ArticleResponse> getArticle(String country) =>
      loadResponseOrThrow(() => _articleApi.getArticle(country));**
}
```

- `Network Exception` 는 처리는  `loadResponseOrThrow` 커스텀 메소드 활용
    - `loadResponseOrThrow` , Try catch를 하나로 합쳐놓은 개념으로 이해할 수 있음.
    - 즉 Api Call을 할 때 Call이 되지 않으면 Exception처리를 하는 메소드.

### 2. Token Exception 처리

```dart
@override
  Future<ExampleResponse> getExample(String id) =>
      loadResponseOrThrow(() {
        if(_localDataSource.loadJwtToken() == null) {
          throw const InvalidTokenException();
        }
        return _exampleApi.getExample(_localDataSource.loadJwtToken()!, id);
      });
```

- `Local DB` 에 저장된 JWT토큰의 유효성을 검사가 시행됨.
- Local DB에 토큰이 없으면 Exception 처리

---

## Respository

<aside>
💡 데이터 Model로 변환하는 레이어(모델 매핑). `모델 매핑` 처리와 더불어 `DataSource` 레이어에서 처럼 에러인지 아니인지 분기하는 역할을 담당함. 유일하게 해당 레이어에서 `try - catch` 를 이용해서 에외처리를 진행. 핵심은 `Result` 타입으로 응답값을 반환하는 것.

</aside>

### 1. Result타입으로 반환

```dart
@override
Future<Result<ExampleModel>> getExample(String id) async {
  try {
    final response = await _dataSource.getExample(id);
    return Result.success(ExampleModel.fromResponse(response));
  } on Exception catch(e) {
    return Result.failure(e);
  }
}

```

- Result타입으로 반환하는 메소드.
- Result타입을 적용하는 이유는 ViewModel에서 데이터 호출 성공 여부에 따라 적절한 UI 예외처리를 할 수 있기 때문. (Flutter `Either` 타입과 비슷함)

### 2. toJson & FromJson 메소드로 모델링.

`response` , `resqueset` 에 따라서 API 레이어 단계에서 Retrofit에서 만들었던 메소드(toJson, FromJson)을 활용하면 됨.

---

## Usecase

<aside>
💡 핵심 비즈니스 로직과 관련된 로직을 관리하는 레이어.

</aside>

- BaseCode(추상화)클래스를 상속받는 클래스로 구성됨
    - 추상화 클래스는  단일 함수 (Call)로 구성되어 있음.
    - API Call에 맞춰진 Usecase.
- 반대로 프로젝트 내에서 종종 Usecase가 아닌 `Service` 레이어를 거치기도 하는데, 보통 API Call과 관련이 없는 로직들에 대한 내용을 담고 있음.



---

## VimewModel

<aside>
💡 Usecase 연동하여 비즈니스로직 controller 역할을하고 UI와 관련된 로직(유저 인터렉션)을 처리하는 레이어

</aside>

- Rxn으로 데이터를 초기화시키는 경우가 많음.
    - Nullable state 값을 기준으로 UI Layer에서 예외처리할 수 있다는 이점이 존재.
- onInit, onReady 메소드를 적절하게 사용. (보통 API콜을 onInit메소드에서 실행시킴)

# 고민했던 점 및 피드백

### 프로젝트 전반에 걸쳐 Implementation 구조를 사용하는 이유?

유지보수 고려. 미래의 변경에 대해 코드 보호. 요구사항이 변경되었을 때 쉽게 대처하기 위해. Implementation 구조를 통해 수정 과정 중 휴먼에러를 방지할 수 있음.

이런 추상화된 구조의 핵심은 주석 없이도 코드만으로 의도를 이해할 수 있어야함. 그리고 이런 구조가 수정을 용이하게 함.
## 목차
- [학습 내용](#학습-내용)
- [요약](#요약)
- [학습 키워드](#학습-키워드)
- [주요 내용](#주요-내용(클릭-아키텍쳐))

## 학습 내용
- `layered architecture` 개념이 도입된 프로젝트.
- `OOP`, `의존성 주입`, `각 레이어의 역활과 책임 분리` , `네트워크 예외처리` 개념에 집중.
- News API를 활용한 프로젝트.

## 요약

| Index          | Detail                                                                                                                                                                                                                                   |
|----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 기여             | 개발 100%                                                                                                                                                                                                                                  |
| 구현 기간          | 2022.05.27 ~ 2022.06.03                                                                                                                                                                                                                  |
| 기술 스택          | - Flutter , Getx, Retrofit                                                                                                                                                                                                               |



## 학습 키워드
Getx

- GetFind
- GetView
- GexController (BaseView, BaseViewModel)
- Getx Route
- dependenceis

OOP

- Abstract, Implement

Retrofit

- fromtoJson, toJson
    - Singletone Pattern
- Json_annotation.

Exceptions

- Result Type
    - Like `Either`
- loadResponseOrThroe

DesignPattern

- Data, Domain, MVVM
- Exceptions



## 주요 내용(클릭 아키텍쳐)
<img src="https://user-images.githubusercontent.com/75591730/173224385-c28ab882-429d-4a67-bdaf-87fddd734825.png">

## API

<aside>
💡 서버와 직접적으로 통신하는 레이어. `request`  `response`  통신. (PATCH 메소드도 사용)

</aside>

- 사용된 라이브러리
    - Retrofit, Dio, JsonAnotation(@JsonSerializable)
- 해당 레이어에서는 모든 API 데이터를 그대로 가져와야됨. 데이터를 가져오는 과정에서 수정 및 추출 X
- request, response 객체를 만듦
    - `request`
        - 객체를 받아서 JSON으로 변환

        ```dart
        @JsonSerializable(explicitToJson: true, createFactory: false)
        class ExampleReuest {
        ......
        } 
        ```

        - 서버로 요청하는 값을 전달하는  것이기  때문에`create Factory`를할 필요가 없음. (toJson)
    - `response`
        - Json을 받아서 객체로 변환 (직렬화)
        - 현재 서비스에 사용되는 API 구조에서는 데이터 안쪽만 직렬화하는 경우만 고려하면 됨.

        ```dart
        @JsonSerializable(createToJson: false)
        class ExampleResponse {
        ....
        }
        ```

        - 서버가 준 응답을 받는 것이기 때문에 `createToJson` 을 할 필요가 없음.

---

## DataSource

<aside>
💡 DataSource에서도 API(Entity) 단계에서 필요한 `rqueset` `response` 와 관련된 로직을 포함.  자세히 말하자면 API 레이어에서 받은 Entity를 다음 레이어로 넘겨주는 역할을 수행하지만 이때 적절히 `Network Exception`로직과  `Token Excetion` (JWT 관련)로직이 수행됨.

</aside>

- 간단하게 말하면 API를 받거나 불러올 때 에러인지 아닌지 분기하는 레이어.

### 1. Network Exception 처리 (loadResponseOrThrow)

```dart
class ArticleRemoteDataSourceImpl
    with ApiErrorHandlerMixin
    implements ArticleRemoteDataSource {
  final ArticleApi _articleApi;

  ArticleRemoteDataSourceImpl(this._articleApi);

  @override
  **Future<ArticleResponse> getArticle(String country) =>
      loadResponseOrThrow(() => _articleApi.getArticle(country));**
}
```

- `Network Exception` 는 처리는  `loadResponseOrThrow` 커스텀 메소드 활용
    - `loadResponseOrThrow` , Try catch를 하나로 합쳐놓은 개념으로 이해할 수 있음.
    - 즉 Api Call을 할 때 Call이 되지 않으면 Exception처리를 하는 메소드.

### 2. Token Exception 처리

```dart
@override
  Future<ExampleResponse> getExample(String id) =>
      loadResponseOrThrow(() {
        if(_localDataSource.loadJwtToken() == null) {
          throw const InvalidTokenException();
        }
        return _exampleApi.getExample(_localDataSource.loadJwtToken()!, id);
      });
```

- `Local DB` 에 저장된 JWT토큰의 유효성을 검사가 시행됨.
- Local DB에 토큰이 없으면 Exception 처리

---

## Respository

<aside>
💡 데이터 Model로 변환하는 레이어(모델 매핑). `모델 매핑` 처리와 더불어 `DataSource` 레이어에서 처럼 에러인지 아니인지 분기하는 역할을 담당함. 유일하게 해당 레이어에서 `try - catch` 를 이용해서 에외처리를 진행. 핵심은 `Result` 타입으로 응답값을 반환하는 것.

</aside>

### 1. Result타입으로 반환

```dart
@override
Future<Result<ExampleModel>> getExample(String id) async {
  try {
    final response = await _dataSource.getExample(id);
    return Result.success(ExampleModel.fromResponse(response));
  } on Exception catch(e) {
    return Result.failure(e);
  }
}

```

- Result타입으로 반환하는 메소드.
- Result타입을 적용하는 이유는 ViewModel에서 데이터 호출 성공 여부에 따라 적절한 UI 예외처리를 할 수 있기 때문. (Flutter `Either` 타입과 비슷함)

### 2. toJson & FromJson 메소드로 모델링.

`response` , `resqueset` 에 따라서 API 레이어 단계에서 Retrofit에서 만들었던 메소드(toJson, FromJson)을 활용하면 됨.

---

## Usecase

<aside>
💡 핵심 비즈니스 로직과 관련된 로직을 관리하는 레이어.

</aside>

- BaseCode(추상화)클래스를 상속받는 클래스로 구성됨
    - 추상화 클래스는  단일 함수 (Call)로 구성되어 있음.
    - API Call에 맞춰진 Usecase.
- 반대로 프로젝트 내에서 종종 Usecase가 아닌 `Service` 레이어를 거치기도 하는데, 보통 API Call과 관련이 없는 로직들에 대한 내용을 담고 있음.



---

## VimewModel

<aside>
💡 Usecase 연동하여 비즈니스로직 controller 역할을하고 UI와 관련된 로직(유저 인터렉션)을 처리하는 레이어

</aside>

- Rxn으로 데이터를 초기화시키는 경우가 많음.
    - Nullable state 값을 기준으로 UI Layer에서 예외처리할 수 있다는 이점이 존재.
- onInit, onReady 메소드를 적절하게 사용. (보통 API콜을 onInit메소드에서 실행시킴)

# 고민했던 점 및 피드백

### 프로젝트 전반에 걸쳐 Implementation 구조를 사용하는 이유?

유지보수 고려. 미래의 변경에 대해 코드 보호. 요구사항이 변경되었을 때 쉽게 대처하기 위해. Implementation 구조를 통해 수정 과정 중 휴먼에러를 방지할 수 있음.

이런 추상화된 구조의 핵심은 주석 없이도 코드만으로 의도를 이해할 수 있어야함. 그리고 이런 구조가 수정을 용이하게 함.

## Repository의 메소드만 호출만 하는 usecase를 만들어줄 필요가 있나?

코드의 일관성으 고려해 usecase를 만들어주어야 함. Implementation 구조를 적용하는 이유와 비슷함.

## Repository 소스와 모델 소스를 분리한 이유?

- 중복을 줄이려고. Repository소스에서  매핑하는 생성자 메소드를 포함해도 상관 없음. 다만 해당 데이터 모델이 다른 곳에서 사용한다고 했을 때 번거롭게 다시 생성자 메소드를 적어야되는 경우가 생김.
- 최악의 경우 모델의 스펙이 변경되었을 때, 매핑하는 생성자 메소드가 Repository 단계에 있다면 모든 Repository에서 생성자 메소드를 변경해야되는 번거로운 일이 생김.

### Hive를 이용할 때 원칙상 Box를 리턴하면 안됨. DB의 리스트 또는 객체 자체를  DataSource → Repository로 넘겨주는게 맞음.

### Retrofit에서 Baseurl을 적을 때, Dio객체를 완전히 분리했기 때문에 BaseUrl도 따로 적어야함.
## Repository의 메소드만 호출만 하는 usecase를 만들어줄 필요가 있나?

코드의 일관성으 고려해 usecase를 만들어주어야 함. Implementation 구조를 적용하는 이유와 비슷함.

## Repository 소스와 모델 소스를 분리한 이유?

- 중복을 줄이려고. Repository소스에서  매핑하는 생성자 메소드를 포함해도 상관 없음. 다만 해당 데이터 모델이 다른 곳에서 사용한다고 했을 때 번거롭게 다시 생성자 메소드를 적어야되는 경우가 생김.
- 최악의 경우 모델의 스펙이 변경되었을 때, 매핑하는 생성자 메소드가 Repository 단계에 있다면 모든 Repository에서 생성자 메소드를 변경해야되는 번거로운 일이 생김.

### Hive를 이용할 때 원칙상 Box를 리턴하면 안됨. DB의 리스트 또는 객체 자체를  DataSource → Repository로 넘겨주는게 맞음.

### Retrofit에서 Baseurl을 적을 때, Dio객체를 완전히 분리했기 때문에 BaseUrl도 따로 적어야함.
