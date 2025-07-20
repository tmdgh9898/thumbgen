# 📸 thumbgen

**Termux에서 터치로 영상 선택 → 4x4 썸네일 이미지 + 영상 정보 포함 프리뷰 이미지 생성기**

## ✅ 기능
- 영상 선택기 (`termux-filepicker`)
- 자동 4x4 타일 썸네일 생성
- 파일명, 해상도, 길이, 용량 자동 삽입
- 원본 영상과 동일한 폴더에 JPG 저장

## 🚀 설치

```bash
pkg update
pkg install ffmpeg termux-api
git clone https://github.com/tmdgh9898/thumbgen.git
cd thumbgen
chmod +x thumbgen.sh
./thumbgen.sh
