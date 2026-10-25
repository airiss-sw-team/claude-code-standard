# .NET / WPF / Prism MVVM 규칙

WPF 데스크톱(.NET, Prism/DryIoc) 레포에서 활성화.
※ 표준 원본: claude-code-standard v0.11 — 이 파일은 레포에서 직접 수정하지 말 것(표준 레포 PR로).

## 아키텍처
- **Prism 모듈 단위**로 기능을 나눈다. 각 기능 모듈은 `IModule`을 구현하고 `RegisterTypes`에서 DI 등록.
- 모듈 간 통신은 **Prism EventAggregator / Region**을 사용한다. 모듈끼리 직접 참조로 강결합하지 않는다.
- 새 화면은 Region에 등록해 로드한다. 뷰를 코드에서 직접 `new` 하지 않는다.

## MVVM
- **View(.xaml)와 ViewModel을 1:1로 분리**한다. `Views/`와 `ViewModels/` 폴더 규칙을 지킨다.
- ViewModel은 `BindableBase`(또는 프로젝트의 base)를 상속, 프로퍼티는 `SetProperty`로 알림.
- 커맨드는 `DelegateCommand`를 사용한다. 코드비하인드(.xaml.cs)에 로직을 넣지 않는다 — 뷰 전용 처리만.
- View는 ViewModel을 알되, ViewModel은 View를 모른다(참조 금지).

## XAML
- 색, 폰트, 스타일은 하드코딩하지 말고 `ResourceDictionary`(테마 리소스)를 참조한다.
- 반복 UI는 `DataTemplate` / `Style`로 추출한다.
- 큰 리스트는 가상화(`VirtualizingStackPanel` 등)를 유지한다.
- 바인딩 경로 오타를 주의 — 빌드는 통과하고 런타임에 조용히 깨진다.

## 화면 문구
- 버튼은 동작을 말하고, 같은 동작은 앱 전체에서 같은 말로 부른다.
- 라벨은 줄이지 않는다. 화살표, 약어, 내부 용어로 함축하지 않는다.
- 빈 목록이나 빈 화면은 왜 비었는지 한 줄로 알린다.

## 비동기와 스레드
- UI 스레드를 막지 않는다. I/O와 하드웨어 호출은 `async/await`.
- UI 갱신은 Dispatcher를 통해. 백그라운드 스레드에서 UI 요소를 직접 만지지 않는다.

## 하드웨어와 위험
- Detector / PLC / Vision 등 **실장비 연동 코드는 실장비 없이 임의 실행하지 않는다**.
- 파괴적 동작(장비 제어, DB 마이그레이션)은 먼저 사용자에게 확인한다.
- `Debug.WriteLine` 은 출하 빌드에서 사라진다. 실패 기록을 맡기지 않는다.
- 위험 명령은 rule(권고)에만 기대지 말고 `.claude/settings.json` 의 **`ask` 규칙**으로 강제한다. `ask` 는 auto 모드에서도 분류기를 건너뛰고 사람에게 묻는다. 예: `"ask": ["Bash(dotnet ef database update:*)", "PowerShell(dotnet ef database update *)"]`

## 빌드
- 정확한 빌드와 실행 명령은 이 레포의 **CLAUDE.md**를 따른다(rule 파일에 레포 고유 값을 넣지 않는다).
- 공통 빌드 설정이 `Directory.Build.props`에 있으면 개별 csproj에서 함부로 오버라이드하지 않는다.
