# 👁️ Eye Rest Timer (눈 휴식 타이머)

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

20-20-20 규칙을 기반으로 한 눈 건강 관리 타이머 앱입니다.

## 📱 스크린샷

<!-- TODO: 앱 스크린샷 추가 -->

## ✨ 주요 기능

- ⏱️ **스마트 타이머**: 20분 작업 후 자동 휴식 알림
- 👀 **휴식 가이드**: 20초간 먼 곳 바라보기 안내
- 📊 **통계 대시보드**: 일간/주간/월간 휴식 기록
- ⚙️ **맞춤 설정**: 작업/휴식 시간 커스터마이징
- 🌙 **다크 모드**: 눈 편한 다크 테마 지원
- 🔔 **백그라운드 알림**: 앱을 닫아도 알림 수신

## 🏥 20-20-20 규칙이란?

디지털 눈 피로를 줄이기 위한 간단한 규칙:
- **20**분마다 휴식
- **20**피트(약 6m) 떨어진 곳을 바라보기
- **20**초간 지속

## 🚀 시작하기

### 요구사항
- Flutter SDK 3.x 이상
- Dart SDK 3.x 이상
- Android Studio / VS Code
- Xcode (iOS 빌드 시)

### 설치

```bash
# 저장소 클론
git clone https://github.com/yourusername/eye_rest_timer.git
cd eye_rest_timer

# 의존성 설치
flutter pub get

# Hive 어댑터 생성
flutter pub run build_runner build --delete-conflicting-outputs

# 앱 실행
flutter run
```

### AdMob 설정

1. [AdMob](https://admob.google.com)에서 앱 등록
2. 앱 ID 및 광고 단위 ID 발급
3. 환경 설정:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy</string>
```

## 📁 프로젝트 구조

```
lib/
├── main.dart              # 앱 진입점
├── app.dart               # 앱 설정
├── core/                  # 공통 유틸리티
├── features/              # 기능별 모듈
│   ├── timer/            # 타이머 기능
│   ├── settings/         # 설정 기능
│   └── statistics/       # 통계 기능
└── shared/               # 공유 위젯
```

## 🛠️ 기술 스택

| 카테고리 | 기술 |
|---------|-----|
| Framework | Flutter |
| Language | Dart |
| State Management | Riverpod |
| Local Storage | SharedPreferences, Hive |
| Notifications | flutter_local_notifications |
| Ads | Google Mobile Ads (AdMob) |
| Routing | GoRouter |

## 📝 개발 로드맵

- [x] 프로젝트 초기 설정
- [ ] 기본 타이머 UI
- [ ] 타이머 로직 구현
- [ ] 휴식 오버레이 화면
- [ ] 로컬 알림 연동
- [ ] 설정 화면
- [ ] 통계 기능
- [ ] AdMob 연동
- [ ] 다크 모드
- [ ] 다국어 지원 (한/영)

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'feat: Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

MIT License - 자세한 내용은 [LICENSE](LICENSE) 파일 참조

## 📧 문의

프로젝트 관련 문의사항이 있으시면 이슈를 등록해주세요.

---

⭐ 이 프로젝트가 도움이 되셨다면 Star를 눌러주세요!
