# app
repository for app

---
## Git Workflow Strategy
+ Branch Overview
+ 우리 프로젝트는 다음과 같은 브랜치 구조를 사용합니다:


### main:
+ 최종 릴리스 버전이 저장되는 브랜치입니다. 직접 작업하지 않습니다.


### develop:
+ 모든 개발 작업이 병합되는 기본 브랜치입니다. joon, bell, jins 브랜치에서 작업이 완료되면 이 브랜치로 병합합니다.


### joon, bell, jins:
+ 각자 작업하는 브랜치입니다. 이름은 팀원별로 구분됩니다. 작업이 완료되면 develop 브랜치로 병합합니다.

---
## Workflow
### 1. 작업 브랜치 전환
+ 각자 자신의 브랜치에서 작업을 시작합니다. 예를 들어, joon 브랜치에서 작업하려면:

  $ git checkout joon


### 2. 작업 내용 커밋
+ 수정한 파일을 추가하고 커밋합니다.

  $ git add .

  $ git commit -m "Describe your changes"


### 3. 로컬 작업 내용 푸시
+ 로컬 브랜치의 작업 내용을 원격 저장소에 푸시합니다.

  $ git push origin joon


### 4. develop 브랜치로 병합
+ 작업이 완료되면 develop 브랜치로 병합합니다

  $ git checkout develop

  $ git pull origin develop  # 최신 상태로 업데이트

  $ git merge joon

  $ git push origin develop

---
## 팀원 간 협업
### 1. develop에서 변경사항 가져오기
+ 다른 팀원의 작업 내용을 반영하기 위해 develop 브랜치에서 최신 내용을 병합합니다.

  $ git checkout develop

  $ git pull origin develop


### 2. 작업 브랜치에 반영
+ develop 브랜치의 변경사항을 자신의 브랜치에 반영합니다.

  $ git checkout joon

  $ git merge develop

---
## 최종 릴리스
### 1. main으로 병합
+ develop 브랜치에서 릴리스 준비가 완료되면 main 브랜치로 병합합니다.

  $ git checkout main

  $ git pull origin main  # 최신 상태로 업데이트

  $ git merge develop

  $ git push origin main


### 2. 릴리스 태그 추가
+ 릴리스 버전을 태그로 표시합니다.

  $ git tag -a v1.0.0 -m "Release version 1.0.0"

  $ git push origin v1.0.0


---
### 브랜치 네이밍 규칙
   main: 최종 릴리스 브랜치.
   ㄴ develop: 통합 개발 브랜치.
     ㄴ joon: 팀원별 작업 브랜치.
     ㄴ bell: 팀원별 작업 브랜치.
     ㄴ jins: 팀원별 작업 브랜치.


### 협업 규칙
+ Pull Request(PR) 생성: 각 브랜치에서 작업 후 develop으로 병합할 때 PR을 생성합니다.
+ 리뷰어가 코드를 확인하고 승인한 후 병합합니다.


### Commit Message 규칙:
+ 작업 내용을 명확히 설명합니다.
    예: Add login validation logic.


### 정기 병합:
+ 팀원 간 충돌을 줄이기 위해 매일 정해진 시간에 develop 브랜치와 자신의 브랜치를 동기화합니다.

---
## 참고 명령어
### 현재 브랜치 확인:
  $ git branch


### 원격 브랜치 목록 확인:
  $ git branch -r


### 브랜치 삭제 (병합 후):
  $ git branch -d <branch_name>

  $ git push origin --delete <branch_name>
