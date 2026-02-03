# 삼이공 (3-2-0)

20-20-20 규칙 기반 눈 휴식 타이머 앱

> 앱 이름 "삼이공"은 20-20-20 규칙의 숫자 "20"을 한국어로 읽은 것입니다.

## 20-20-20 규칙이란?

디지털 기기 사용으로 인한 눈의 피로를 줄이기 위한 규칙입니다:
- **20분** 동안 작업 후
- **20피트**(약 6m) 떨어진 곳을 바라보며
- **20초** 동안 휴식

## 주요 기능

### 타이머
- 집중 시간 설정 (1-60분)
- 휴식 시간 설정 (10-60초)
- 진행률에 따라 배경색이 채워지는 시각적 피드백
- 진행 단계별 응원 메시지

### 기록
- 오늘 휴식 횟수
- 연속 달성 일수
- 최고 연속 기록
- 총 휴식 횟수
- 주간 그래프

### 설정
- 집중/휴식 시간 조절
- 소리/진동 알림
- 테마 (시스템/라이트/다크)

## 기술 스택

- **Framework**: Flutter
- **State Management**: Riverpod
- **Local Storage**: Hive
- **Font**: Cafe24 Ssurround

## 프로젝트 구조

```
lib/
├── app.dart                 # 앱 진입점, 테마 설정
├── main.dart
├── core/
│   ├── constants/           # 색상, 설정값, 문자열
│   └── theme/               # 테마 정의
├── features/
│   ├── timer/               # 타이머 기능
│   ├── statistics/          # 통계/기록 기능
│   └── settings/            # 설정 기능
└── shared/
    └── widgets/             # 공통 위젯
```

## 실행 방법

```bash
# 의존성 설치
flutter pub get

# 앱 실행
flutter run

# 빌드
flutter build apk      # Android
flutter build ios      # iOS
flutter build macos    # macOS
```

## 라이선스

MIT License
