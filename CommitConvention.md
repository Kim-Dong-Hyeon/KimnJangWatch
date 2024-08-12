Commit Style Guide
=================

### Commit Type: 커밋의 타입 구성

> 태그: 제목 <br>
> :(space)제목 으로 :뒤에만 space를 넣는다.<br>
> ex) Feat: 결제하기 기능 버튼 추가

| Tag Name | Description |
|---|---|
| Feat | 새로운 기능을 추가 |
| Fix | 버그 수정 |
| Design | CSS 등 사용자 UI 디자인 변경 |
| !HOTFIX | 급하게 치명적인 버그를 고쳐야하는 경우 |
| Style | 코드 포맷 변경, 세미 콜론 누락, 코드 수정이 없는 경우 |
| Refactor | 코드 리팩토링 |
| Comment | 필요한 주석 추가 및 변경 |
| Docs | 문서 수정 |
| Test | 테스트 코드, 리펙토링 테스트 코드 추가, Production Code(실제로 사용하는 코드) 변경 없음 |
| Chore | 빌드 업무 수정, 패키지 매니저 수정, 패키지 관리자 구성 등 업데이트, Production Code 변경 없음 |
| Rename | 파일 혹은 폴더명을 수정하거나 옮기는 작업만인 경우 |
| Remove | 파일을 삭제하는 작업만 수행한 경우 |

* 추가적인 문맥 정보를 제공하기 위한 목적으로 괄호 안에 적을 수도 있다.<br>
ex) Fix: 결제하기 기능 수정(UIAction 사용)
