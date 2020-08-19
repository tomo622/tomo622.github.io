---
title: "데이터베이스 이론"
excerpt: "데이터베이스 이론을 정리한다."
categories:
 - database
last_modified_at: 2020-03-07T13:08:00
---




### 명령어

- DDL(Data Definition Language, 정의어) : CREATE, ALTER, DROP (*테이블 구조 정의*)
- DML(Data Manipulation Language, 조작어) : SELECT, INSERT, UPDATE, DELETE (*테이블의 데이터 조작*)
- DCL(Data Control Language, 제어어) : GRANT, REVOKE, COMMIT, ROLLBACK

### DBMS(Database Management System)

###### 구성요소

![database_img1](https://user-images.githubusercontent.com/19742979/75342821-85da1c00-58da-11ea-941b-ab50fd9ad566.png){: .align-center}

- 질의어 처리기
  SQL문을 이용한 삽입, 삭제, 조회, 갱신 작업을 처리하기 위해 DML 구문을 분해하여 DML 컴파일러에 전달
- DML컴파일러
  질의어 처리기에서 받은 DML 구문을 실행코드로 변환하여 런타임 데이터베이스 처리기에 전달
- DDL 컴파일러
  DDL을 이용한 작업을 번역하여 시스템 카탈로그에 저장
- 런타임 데이터베이스 처리기
  저장된 데이터베이스의 직접적인 검색, 갱신 등의 작업 수행
- 트랜잭션 관리자
  트랜잭션의 병행 제어, 권한 검사, 장애에 대한 자동 복구, 제약조건 검사 등의 작업 수행
- 저장 데이터 관리자
  저장된 데이터베이스나 시스템 카탈로그에 대한 직접적인 접근을 관리, 운영체제의 입출력 모듈을 이용하여 작업
- 저장 데이터베이스
  일단 테이블 데이터 저장
- 시스템 카탈로그
  파일의 이름, 크기, 데이터의 이름과 타입, 제약조건 등 메타 데이터 저장

### Key

- 후보키 (Candidate Key)
  튜플을 유일하게 식별할 수 있는 특성을 가진 속성이나 속성의 집합 `기본키 [+ 대체키1 + 대체키2 + ...]`
릴레이션에 기본키는 무조건 하나 존재해야하고 대체키는 0개 이상이다.
  유일성, 최소성 모두 만족
- 기본키 (Primary Key)
  후보키 중 각 튜플을 식별하기 위한 유일한 키, null 값과 중복된 값을 가질 수 없다.
  유일성, 최소성 모두 만족
- 대체키 (Alternate Key)
  후보키 중 기본키를 제외한 나머지 후보키들
  유일성, 최소성 모두 만족
- 슈퍼키 (Super Key)
  릴레이션 내의 둘 이상의 속성으로 구성된 키
  유일성만 만족
  (최소성을 만족시키지 못한다? : 여러 속성들이 함께 키로 작용될 때에만 유일성을 보장하고 각 속성들 개별적으로는 유일성을 만족시키지 못한다.)
- 외래키 (Foreign Key)
  다른 릴레이션의 기본키를 갖게 되는 키

