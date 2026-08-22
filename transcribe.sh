#!/usr/bin/env bash
# Usage: ./transcribe.sh "data/foo.m4a"  -> transcripts/foo.txt
# Splits into 10-min mp3 chunks, transcribes each with gpt-4o-transcribe, concatenates.
set -euo pipefail
set -a; source .env; set +a
src="$1"; name="$(basename "${src%.*}")"
work="transcripts/.chunks/$name"; mkdir -p "$work" transcripts
ffmpeg -v error -y -i "$src" -ac 1 -ar 16000 -b:a 64k -f segment -segment_time 600 "$work/%03d.mp3"
: > "transcripts/$name.txt"
for c in "$work"/*.mp3; do
  echo "  $name ← $(basename "$c")"
  for try in 1 2 3; do
    out=$(curl -sS --fail-with-body https://api.openai.com/v1/audio/transcriptions \
      -H "Authorization: Bearer $OPENAI_API_KEY" \
      -F model=gpt-4o-transcribe -F language=ko -F response_format=json \
      -F "prompt=로보틱스 행사 발표. 용어: 강화학습, PPO, SAC, Sim-to-Real, 모방학습, 오프라인 강화학습, RRT, MPC, 휴머노이드, 스마트팜, 로보티즈, 유로보틱스, 디든로보틱스" \
      -F "file=@$c") && break
    echo "  retry $try: $out" >&2; sleep 5
  done
  echo "$out" | jq -er '.text' >> "transcripts/$name.txt"
  echo >> "transcripts/$name.txt"
done
echo "done: transcripts/$name.txt ($(wc -m < "transcripts/$name.txt") chars)"
