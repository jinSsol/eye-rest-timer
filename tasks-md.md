# TASKS.md - 개발 작업 목록

삼이공 (20-20-20 눈 휴식 타이머) 앱 개발 진행 상황입니다.

---

## Phase 1: 프로젝트 초기 설정 ✅

### Task 1.1: Flutter 프로젝트 생성 ✅
- [x] 프로젝트 생성
- [x] 불필요한 기본 코드 정리
- [ ] 앱 아이콘 및 스플래시 화면 설정

### Task 1.2: 의존성 추가 ✅
- [x] pubspec.yaml 수정
- [x] flutter pub get 실행
- [x] Cafe24 Ssurround 폰트 추가

### Task 1.3: 폴더 구조 생성 ✅
- [x] 폴더 구조 완성
- [x] 기본 파일 생성

---

## Phase 2: Core 모듈 개발 ✅

### Task 2.1: 상수 정의 ✅
- [x] app_colors.dart - 색상 정의
- [x] app_strings.dart - 문자열 정의
- [x] app_config.dart - 설정값 정의

### Task 2.2: 테마 설정 ✅
- [x] 라이트 테마
- [x] 다크 테마
- [x] 커스텀 폰트 적용 (Cafe24 Ssurround)

---

## Phase 3: Timer 기능 개발 ✅

### Task 3.1: 타이머 상태 모델 ✅
- [x] TimerState 클래스
- [x] TimerStatus enum (idle, running, paused, resting)

### Task 3.2: 타이머 Provider ✅
- [x] start(), pause(), resume(), reset()
- [x] 자동 휴식 전환
- [x] 통계 연동

### Task 3.3: 타이머 화면 UI ✅
- [x] 배경 프로그레스 (색상이 채워지는 방식)
- [x] 상단 타이머 pill (시간 + 진행률)
- [x] 눈 캐릭터 위젯
- [x] 진행 단계별 응원 메시지
- [x] 컨트롤 버튼

### Task 3.4: 휴식 오버레이 ✅
- [x] 전체화면 오버레이
- [x] 카운트다운 표시
- [x] 건너뛰기 버튼

---

## Phase 4: Settings 기능 개발 ✅

### Task 4.1: 설정 모델 ✅
- [x] SettingsModel 정의
- [x] SharedPreferences 연동

### Task 4.2: 설정 화면 UI ✅
- [x] 집중 시간 슬라이더 (1-60분)
- [x] 휴식 시간 슬라이더 (10-60초)
- [x] 소리/진동 토글
- [x] 테마 선택 (시스템/라이트/다크 - 가로 세그먼트)
- [x] 심플한 UI 디자인

### Task 4.3: 설정-타이머 연동 ✅
- [x] 설정 변경 시 타이머에 즉시 반영

---

## Phase 5: Statistics 기능 개발 ✅

### Task 5.1: 통계 모델 ✅
- [x] DailyRecord Hive 모델
- [x] 어댑터 생성

### Task 5.2: 통계 저장소 ✅
- [x] 오늘 기록 조회/저장
- [x] 주간 데이터 조회
- [x] 연속 일수 계산

### Task 5.3: 통계 화면 UI ✅
- [x] 오늘 휴식 카드 (컴팩트)
- [x] 연속/최고/총 카드 (3개 가로 배치)
- [x] 주간 막대 그래프
- [x] 광고 배너 영역

---

## Phase 6: 앱 통합 ✅

### Task 6.1: 네비게이션 ✅
- [x] 상단 탭바 (타이머/기록/설정)
- [x] 세그먼트 스타일 디자인
- [x] IndexedStack으로 화면 전환

### Task 6.2: main.dart ✅
- [x] ProviderScope 래핑
- [x] Hive 초기화
- [x] intl 한국어 설정

---

## Phase 7: UI/UX 개선 ✅

### Task 7.1: 프로그레스바 개선 ✅
- [x] 배경 전체가 프로그레스 (색상 채우기)
- [x] 진행률 상단 pill에 표시

### Task 7.2: 아이콘 통일 ✅
- [x] 이모지 → Material Icons 변경
- [x] 통계 화면 아이콘 적용
- [x] 설정 화면 아이콘 적용

### Task 7.3: 레이아웃 개선 ✅
- [x] 상단 탭바로 네비게이션 변경
- [x] 플로팅 버튼 제거
- [x] 화면별 타이틀 제거 (탭바로 대체)
- [x] 카드 레이아웃 컴팩트화

### Task 7.4: 앱 사용 가이드 ✅
- [x] 온보딩 화면 구현 (4페이지 슬라이드)
- [x] 첫 실행 시 자동 표시
- [x] 설정에서 다시 보기 가능

---

## Phase 8: 출시 준비 🔄

### Task 8.1: 앱 아이콘 및 스플래시 ✅
- [x] 앱 아이콘 디자인/적용 (귀여운 눈 캐릭터)
- [x] 스플래시 화면 설정 (그린 배경 + 눈 캐릭터)

### Task 8.2: 스토어 등록 준비 ✅
- [ ] 스크린샷 캡처 (가이드 작성 완료)
- [x] 앱 설명 작성 (한국어/영어)
- [x] 개인정보처리방침 준비

### Task 8.3: 릴리즈 빌드
- [ ] Android APK/AAB 빌드
- [ ] iOS Archive 빌드
- [ ] 실제 AdMob ID 적용

---

## Phase 9: 추가 기능 (예정)

### Task 9.1: 알림 기능
- [ ] 로컬 알림 초기화
- [ ] 휴식 시작 알림
- [ ] 알림음/진동 커스텀

### Task 9.2: 위젯 지원
- [ ] iOS 위젯
- [ ] Android 위젯

### Task 9.3: Dynamic Island (iOS)
- [ ] Live Activity 구현
- [ ] 타이머 진행 표시

### Task 9.4: 휴식 가이드 애니메이션
- [ ] 눈 운동 가이드
- [ ] 시선 이동 애니메이션

---

## 완료 현황

| Phase | 상태 | 완료율 |
|-------|------|-------|
| Phase 1 | ✅ | 100% |
| Phase 2 | ✅ | 100% |
| Phase 3 | ✅ | 100% |
| Phase 4 | ✅ | 100% |
| Phase 5 | ✅ | 100% |
| Phase 6 | ✅ | 100% |
| Phase 7 | ✅ | 100% |
| Phase 8 | 🔄 | 66% |
| Phase 9 | ⏳ | 0% |

**전체 진행률: ~90%**
