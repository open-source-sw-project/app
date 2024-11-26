
## Firebase 추가됨

현재 firebase에서 사용하는 기능은 3가지로 auth, firestore, storage가 있음

auth는 회원가입에대해 당담함 여러가지의 회원가입형태를 지원하는데 현재는 이메일 인증이 필요없는 이메일방식
firestore는 데이터베이스로 NoSql방식을 사용하고있음 사용자 정보나 이미지url같은 텍스트로 정의되는 정보를 저장함
storage는 이미지나 비디오같은 용량이크고 텍스트로 저장할수없는 파일을 저장함 firestore에서 이미지url정보를 이용해 해당 이미지를 불러올수있음

-----------------------------------------------------------------------------------------------------------------------------------------------

sign_up.dart, set_up_profile.dart   -->    회원가입기능 추가됨

아이디, 비밀번호, 생년월일, 생성시간, 이름과 성, 전화번호, 프로필이미지 storage경로, 마지막로그인시간

비밀번호는 보안정책때문에 프로젝트 관리자도 사용자의 비밀번호는 알수없음

예시)
createdAt   :   2024년 11월 26일 오전 9시 28분 11초 UTC+9

dateOfBirth :   "2024-11-01T00:00:00.000"

email   :   "a@a.com"

firstName   :   "as"

lastLogin   :   2024년 11월 26일 오전 9시 28분 43초 UTC+9

lastName    :   "qwer"

mobile  :   "123454124324"

profileImageUrl :   "https://firebasestorage.googleapis.com/v0/b/opensw-c2e3a.firebasestorage.app/o/profile_images%2FPawvZioJLwUTguq5M7Jcf7u0u8j2.jpg?alt=media&token=ab2ad670-9181-4497-80b5-13e2c5af20b2"

------------------------------------------------------------------------------------------------------------------------------------------------

diagonosis.dart  -->  진단데이터 저장하는 기능

이미지url, 생성날짜 

예시)
imageUrl    :   "https://firebasestorage.googleapis.com/v0/b/opensw-c2e3a.firebasestorage.app/o/diagnoses%2FPawvZioJLwUTguq5M7Jcf7u0u8j2%2F1732580926811.jpg?alt=media&token=2d520a48-7e46-4530-b738-1c607c072b6c"

timestamp   :   2024년 11월 26일 오전 9시 28분 52초 UTC+9
