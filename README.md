# ROBOTS AT WORK : YEAR ONE — 현장 후기

https://runefor.github.io/robots-at-work-year-one/

- `site/` — GitHub Pages로 배포되는 정적 페이지 (main push 시 자동 배포)
- `blog-post.md` — 외부 블로그용 요약글
- `transcribe.sh` — 녹음(m4a)을 OpenAI `gpt-4o-transcribe`로 전사. `.env`에 `OPENAI_API_KEY` 필요.

```bash
./transcribe.sh "data/발표.m4a"   # → transcripts/발표.txt
```

녹음·전사본(`data/`, `transcripts/`)은 커밋하지 않는다.
