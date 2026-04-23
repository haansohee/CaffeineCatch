<div align="center">

<!-- TODO: 프로젝트 로고/앱아이콘 이미지를 추가해주세요. (예: /images/appicon.png) -->
<img src="CaffeineCatch/Assets.xcassets/AppIcon.appiconset/AppIcon.png" alt="CaffeineCatch Logo" width="120" />

# CaffeineCatch (카페인캐치)

**건강한 카페인 습관을 위한 완벽한 파트너**

![Swift](https://img.shields.io/badge/Swift-5.0-orange?logo=swift)
![iOS](https://img.shields.io/badge/iOS-18.0+-black?logo=apple)
![Xcode](https://img.shields.io/badge/Xcode-16-blue?logo=xcode)
![License](https://img.shields.io/badge/License-MIT-green)

<a href="https://apps.apple.com/kr/app/caffeinecatch/id6739218653">
  <img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" alt="Download on the App Store" height="48" />
</a>

</div>

---

## 📑 목차 (Table of Contents)

- [프로젝트 소개](#-프로젝트-소개)
- [주요 기능](#-주요-기능-features)
- [기술 스택](#-기술-스택-tech-stack)
- [아키텍처](#-아키텍처-architecture)
- [폴더 구조](#-폴더-구조-project-structure)
- [기술적 고민 / 트러블 슈팅](#-기술적-고민--트러블-슈팅)
- [컨벤션](#-컨벤션-convention)
- [라이브러리 의존성](#-라이브러리-의존성)

---

## 📖 프로젝트 소개

### 배경 및 동기

현대인에게 카페인은 일상이지만, **무의식적인 과다 섭취는 수면 장애, 불안감, 심혈관 부담** 등 건강 문제로 이어질 수 있습니다.
하지만 기존 앱 대부분은 단순 음료 기록에 그치거나, 복잡한 영양 성분 분석에 치중해 "오늘 내가 카페인을 얼마나 섭취했는가"라는 가장 본질적인 질문에 답해주지 못했습니다.

**CaffeineCatch**는 이 문제를 해결하기 위해 시작되었습니다.
사용자가 **자신만의 목표 카페인 섭취량을 설정**하고, **매일의 섭취 기록을 시각적으로 확인**하며, 더 나아가 **제로 카페인 챌린지**까지 도전할 수 있도록 돕는 가벼운 동반자 앱입니다.

### 핵심 가치

- **목표 중심(Goal-Oriented)**: 일률적인 권장량이 아닌, 사용자 개인의 건강 상태에 맞춘 목표 설정
- **제로 카페인 모드**: 카페인을 끊고 싶은 사용자를 위해 "물 섭취 목표"로 자동 전환되는 대체 모드 제공
- **가볍고 직관적인 UX**: 3개의 탭(목표 / 기록 / 통계)만으로 모든 핵심 기능에 접근
- **오프라인 우선(Offline-First)**: CoreData 기반의 로컬 저장으로 서버 의존성 없이 즉시 사용 가능

---

## ✨ 주요 기능 (Features)

> 💡 각 기능의 실제 동작 스크린샷은 추후 추가될 예정입니다.

| 기능 | 설명 |
|------|------|
| 🎯 **목표 설정** | 카페인 / 제로카페인(물) 모드 선택 및 일일 목표량 설정 |
| ☕ **섭취 기록** | 카페인(shot/mg), 물(mL), 기타 음료를 카테고리별로 기록 |
| 📅 **캘린더 뷰** | 일별 목표 달성 여부를 색상으로 한눈에 확인 (FSCalendar) |
| 📊 **통계 대시보드** | 주/월 단위 섭취 추이를 차트로 시각화 (DGCharts) |
| 🔔 **푸시 알림** | 평소 카페인 섭취 시간 기반의 맞춤형 리마인더 |
| 📝 **기록 수정/삭제** | 잘못 입력한 섭취 기록을 언제든 편집 가능 |
| 👋 **온보딩 튜토리얼** | 최초 실행 시 사용자의 카페인 습관을 수집하여 목표 자동 추천 |

<!-- TODO: 아래 자리에 기능별 스크린샷 이미지를 추가해주세요.
예시:
| 목표 설정 | 섭취 기록 | 통계 |
|:---:|:---:|:---:|
| <img src="images/goal.png" width="200"/> | <img src="images/record.png" width="200"/> | <img src="images/stats.png" width="200"/> |
-->

---

## 🛠 기술 스택 (Tech Stack)

| 카테고리 | 사용 기술 |
|---------|----------|
| **Language** | Swift 5.0 |
| **Minimum iOS** | iOS 18.0 |
| **UI** | UIKit (Code-based, No Storyboard) |
| **Architecture** | MVVM |
| **Reactive** | RxSwift, RxDataSources |
| **Local Storage** | CoreData (Dual Persistent Container) |
| **Notification** | UserNotifications, NotificationCenter |
| **Dependency Manager** | Swift Package Manager (SPM) |
| **CI/CD** | - (추후 Fastlane / GitHub Actions 도입 예정) |

---

## 🏗 아키텍처 (Architecture)

### MVVM + RxSwift

```
┌────────────────────┐      bind       ┌────────────────────┐      fetch/save      ┌────────────────────┐
│  ViewController    │ ───────────────▶ │      ViewModel     │ ────────────────────▶ │   CoreData Store   │
│  (View Layer)      │ ◀─────────────── │ (Business Logic)   │ ◀──────────────────── │ (Persistent Layer) │
│  - Layout          │   Observable    │  - RxSubject       │     NSFetchRequest   │  - UserInfoModel   │
│  - User Input      │                 │  - Data Transform  │                      │  - CaffeineIntake  │
└────────────────────┘                 └────────────────────┘                      └────────────────────┘
```

### 레이어별 역할

- **View Layer (`ViewController` + `View`)**
  - 사용자 입력을 받고 ViewModel에 전달
  - ViewModel의 Observable을 구독하여 UI 갱신
  - 레이아웃은 모두 코드 기반(programmatic)

- **ViewModel Layer (`ViewModel`)**
  - 비즈니스 로직과 상태 관리
  - `PublishSubject`, `BehaviorSubject`를 통해 View에 데이터 스트림 제공
  - CoreData 접근 및 데이터 변환(domain-friendly)

- **Persistent Layer (`CoreDataModel`)**
  - `UserInfoModel`: 사용자 목표, 알림 설정, 제로카페인 여부
  - `CaffeineIntakeModel`: 섭취 기록(카테고리 / 양 / 날짜 / 목표 초과 여부)
  - 두 개의 `NSPersistentContainer`를 분리하여 도메인 응집도 확보

### 의존성 흐름

```
View  ──(action)──▶  ViewModel  ──(Rx.onNext)──▶  View
                         │
                         └──▶  CoreData (via AppDelegate.container)
```

### 왜 MVVM + RxSwift인가?

- **View ↔ 로직 분리**: `RecordViewController`가 섭취 저장 로직을 알 필요 없이, `RecordViewModel.saveCaffeineIntakeRecord()`를 호출하기만 하면 됩니다.
- **반응형 UI 갱신**: 섭취 기록이 저장되면 `isSavedIntakeRecord.onNext(true)` 한 줄로 View가 자동 갱신됩니다.
- **테스트 용이성**: ViewModel이 UIKit에 최소한으로 의존하여 단위 테스트 작성이 수월합니다.

---

## 📂 폴더 구조 (Project Structure)

```
CaffeineCatch/
├── AppDelegate.swift              # CoreData 컨테이너 초기화
├── SceneDelegate.swift
├── Info.plist
├── CaffeineCatch.entitlements
│
├── CoreDataModel/
│   ├── UserInfoModel.xcdatamodeld         # 사용자 정보 엔티티
│   └── CaffeineIntakeModel.xcdatamodeld   # 카페인 섭취 기록 엔티티
│
├── Splash/                        # 앱 진입 스플래시 화면
├── Tutorial/                      # 최초 실행 온보딩 플로우
│   ├── View/
│   ├── ViewController/
│   └── ViewModel/
│
├── MainTabBar/                    # 3개 탭 컨테이너
│   └── MainTabBarController.swift
│
├── MyGoalTab/                     # [탭 1] 목표 설정
│   ├── View/
│   ├── ViewController/
│   ├── ViewModel/
│   └── DataSourceModel/
│
├── RecordTab/                     # [탭 2] 섭취 기록
│   ├── View/
│   ├── ViewController/
│   ├── ViewModel/
│   └── DataSourceModel/
│
├── StatisticsTab/                 # [탭 3] 통계 차트
│   ├── View/
│   ├── ViewController/
│   └── ViewModel/
│
├── Calendar/                      # FSCalendar 래핑 뷰
├── Extension/                     # Date+, String+, UIViewController+ 등
├── Protocol/                      # ReuseIdentifierProtocol 등
├── Util/
│   ├── UI/                        # 공용 커스텀 버튼
│   ├── Enum/                      # 타입 안전한 상수 모음
│   └── NotificationManaged.swift  # 로컬 푸시 매니저
│
├── Resource/
├── Assets.xcassets/
└── Base.lproj/
```

---

## 💡 기술적 고민 / 트러블 슈팅

### 1. 도메인 분리를 위한 CoreData Persistent Container 이원화

- **문제 상황**
  `UserInfo`(사용자 설정)와 `CaffeineIntakeInfo`(섭취 기록)를 하나의 `.xcdatamodeld`에 묶어 관리하니, 섭취 기록 마이그레이션 시 사용자 설정 데이터까지 영향을 받고, 스키마가 서로 엉키면서 모델 변경에 대한 심리적 부담이 커졌습니다.

- **원인 분석**
  두 엔티티는 실제 도메인 맥락이 전혀 달랐습니다.
  - `UserInfo` → "한 명의 사용자 프로필"(레코드 1건)
  - `CaffeineIntakeInfo` → "시간에 따라 쌓이는 로그"(레코드 N건)

  생명주기도, 마이그레이션 전략도 다른 두 데이터를 하나의 Container로 묶는 것은 응집도를 해치는 선택이었습니다.

- **해결 방법**
  `AppDelegate`에서 `userPersistentContainer`와 `caffeinePersistentContainer`를 분리 선언하고, 각 ViewModel에서 도메인에 해당하는 컨텍스트만 주입받아 사용하도록 구조화했습니다.

  ```swift
  // AppDelegate.swift
  lazy var userPersistentContainer: NSPersistentContainer = { ... }()
  lazy var caffeinePersistentContainer: NSPersistentContainer = { ... }()
  ```

- **결과**
  - 카페인 기록 스키마 변경 시 사용자 설정은 완전히 무관해져, 마이그레이션 리스크가 도메인 단위로 한정되었습니다.
  - 각 ViewModel이 필요한 Container에만 의존하도록 설계되어, 관심사 분리가 명확해졌습니다.

  <!-- TODO: 정량적 지표(예: 마이그레이션 소요 시간 N% 감소)가 있다면 추가해주세요. -->

---

### 2. "같은 날, 같은 카테고리" 섭취 기록의 중복 저장 방지

- **문제 상황**
  초기 구현에서는 사용자가 하루에 카페인을 여러 번 기록할 때마다 `CaffeineIntakeInfo` 엔티티가 새로 생성되었습니다. 이로 인해 하루 총 섭취량을 조회하려면 모든 레코드를 `fetch` 후 합산해야 했고, 통계 탭 로딩이 눈에 띄게 느려졌습니다.

- **원인 분석**
  "기록 이벤트" 자체를 엔티티로 모델링하면 로그 수가 O(N)으로 증가합니다. 하지만 사용자 관점에서 필요한 정보는 **"오늘 얼마나 마셨는지"라는 집계값** 하나뿐이었습니다.

- **해결 방법**
  `saveCaffeineIntakeRecord` 내부에서 **동일 날짜 + 동일 카테고리** 레코드를 먼저 `NSPredicate`로 조회한 뒤, 존재하면 `intake` 값을 누적 갱신하고, 없을 때만 새 레코드를 생성하도록 변경했습니다.

  ```swift
  fetchCaffeineRequest.predicate = NSPredicate(
      format: "caffeineIntakeDate == %@ AND intakeCategory == %@",
      inputDate, IntakeCategory.caffeine.rawValue
  )
  if let existing = caffeineIntakes.first {
      existing.intake = Int32(Int(existing.intake) + Int(inputIntake))
  } else {
      // 신규 레코드 생성
  }
  ```

- **결과**
  - 하루 기준 레코드 수가 "섭취 횟수"에서 "카테고리 개수(최대 3~4개)"로 고정되었습니다.
  - 통계 탭 진입 시 fetch 대상이 획기적으로 줄어들어 체감 로딩 속도가 개선되었습니다.

  <!-- TODO: 실제 측정값(예: 통계 로딩 2.3s → 0.8s)이 있다면 추가해주세요. -->

---

## 📏 컨벤션 (Convention)

### Git Flow / Branch 전략

```
main       ──●───────────────────●──────────●──▶  (App Store 배포)
              ╲                 ╱           ╲
release        ●───────────────●             ●──▶  (QA / 릴리즈 후보)
                ╲             ╱
develop         ●──●──●──●──●─●──▶  (통합 개발)
                    │  │  │
feature/*          ●──●  │         (기능 단위 브랜치)
fix/*              ────── ●         (버그 수정 브랜치)
```

- `main`: 스토어 배포 반영 브랜치
- `release`: QA / 출시 준비 브랜치
- `develop`: 통합 개발 브랜치
- `feature/{기능명}`: 신규 기능 개발 (예: `feature/notification`)
- `fix/{대상}`: 버그 수정 (예: `fix/MyPageView-Layout`)

### Commit 메시지 규칙

이모지 + 타입 + 대상 순으로 작성합니다.

| 이모지 | 타입 | 사용 예시 |
|:---:|---|---|
| ✨ | `Feature` | ✨ Feature Push Notification |
| 🔧 | `Fix` | 🔧 Fix MyPageView Layout |
| ♻️ | `Refactor` | ♻️ Refactor Code |
| 📝 | `Docs` | 📝 Update README |

### 코드 컨벤션

- **네이밍**: Swift API Design Guidelines 준수
- **레이아웃**: 모든 UI는 **코드 기반(programmatic)**으로 작성, Storyboard 사용 금지
- **접근 제어**: 기본적으로 `private`, 외부 노출이 필요한 경우에만 명시적으로 상향
- **타입 안전성**: 매직 스트링 대신 `enum`(예: `EntityName`, `IntakeCategory`, `NotificationCenterName`) 사용
- **파일 구조**: 탭 단위로 `ViewController` / `View` / `ViewModel` / `DataSourceModel` 하위 폴더 분리

---

## 📦 라이브러리 의존성

모든 외부 의존성은 **Swift Package Manager (SPM)**로 관리됩니다.

| 라이브러리 | 선택 이유 |
|-----------|----------|
| **[RxSwift](https://github.com/ReactiveX/RxSwift)** | ViewModel ↔ View 간 데이터 바인딩을 선언적으로 표현하고, 비동기 CoreData 작업 결과를 스트림으로 처리하기 위해 도입. |
| **[RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources)** | 섭취 기록 리스트처럼 **섹션이 있는 TableView/CollectionView**를 RxSwift와 자연스럽게 결합하기 위해 사용. |
| **[FSCalendar](https://github.com/WenchaoD/FSCalendar)** | 목표 달성 여부를 날짜별 색상으로 커스터마이징할 수 있고, iOS 기본 `UICalendarView` 대비 세밀한 UI 제어가 가능해 선택. |
| **[Charts (DGCharts)](https://github.com/ChartsOrg/Charts)** | 통계 탭의 주/월 섭취량 시각화를 위해 도입. 막대/라인 차트를 빠르게 구현 가능. |
| **[IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager)** | 기록 입력 시 키보드가 TextField를 가리는 문제를 전역에서 한 번에 해결하기 위해 사용. |

---

<div align="center">

Made with ☕ by [@haansohee](https://github.com/haansohee)

</div>
