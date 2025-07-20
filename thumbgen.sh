#!/data/data/com.termux/files/usr/bin/bash

echo "📁 영상 파일을 선택하세요"
VIDEO=$(termux-filepicker)
[ -z "$VIDEO" ] && { echo "❌ 선택이 취소되었습니다."; exit 1; }

BASENAME=$(basename "$VIDEO")
DIRNAME=$(dirname "$VIDEO")
OUT_IMG="${DIRNAME}/${BASENAME%.*}_preview.jpg"

RESOLUTION=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0:s=x "$VIDEO")
DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$VIDEO" | awk '{printf "%.2f", $1}')
SIZE=$(du -h "$VIDEO" | cut -f1)

TEXT="파일명: $BASENAME\n해상도: $RESOLUTION\n길이: ${DURATION}s\n용량: $SIZE"

ffmpeg -y -i "$VIDEO" \
-vf "select='not(mod(n\,100))',scale=320:180,tile=4x4,\
drawtext=fontfile=/system/fonts/DroidSans.ttf:text='$TEXT':x=10:y=10:fontsize=18:fontcolor=white:box=1:boxcolor=black@0.5" \
-frames:v 1 "$OUT_IMG"

echo "✅ 썸네일 생성 완료: $OUT_IMG"
