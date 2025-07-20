#!/data/data/com.termux/files/usr/bin/bash

echo "📁 가장 최근의 mp4 파일을 자동으로 선택합니다..."

# 최신 mp4 파일 1개 자동 선택 (디폴트 경로: 내부 저장소)
VIDEO=$(find /storage/emulated/0 -type f -name '*.mp4' -print0 2>/dev/null | xargs -0 ls -t | head -n 1)

# 없을 경우 종료
if [ ! -f "$VIDEO" ]; then
  echo "❌ mp4 파일을 찾을 수 없습니다."
  exit 1
fi

BASENAME=$(basename "$VIDEO")
DIRNAME=$(dirname "$VIDEO")
OUT_IMG="${DIRNAME}/${BASENAME%.*}_preview.jpg"

# 영상 정보 추출
RESOLUTION=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0:s=x "$VIDEO")
DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$VIDEO" | awk '{printf "%.2f", $1}')
SIZE=$(du -h "$VIDEO" | cut -f1)

TEXT="파일명: $BASENAME\n해상도: $RESOLUTION\n길이: ${DURATION}s\n용량: $SIZE"

# 썸네일 생성
ffmpeg -y -i "$VIDEO" \
-vf "select='not(mod(n\,100))',scale=320:180,tile=4x4,\
drawtext=fontfile=/system/fonts/DroidSans.ttf:text='$TEXT':x=10:y=10:fontsize=18:fontcolor=white:box=1:boxcolor=black@0.5" \
-frames:v 1 "$OUT_IMG"

echo "✅ 썸네일 생성 완료: $OUT_IMG"