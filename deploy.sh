#!/usr/bin/env bash
# ==============================================================
# Deploy Cucumber Menu site to GitHub Pages
# ==============================================================
# วิธีใช้:
#   1) เปิด https://github.com/new → สร้าง repo ชื่อ "cucumber-menu" (Public)
#      อย่าเลือก README/license/.gitignore — ขอ repo ว่าง
#   2) บน Mac เปิด Terminal → cd ไปที่โฟลเดอร์นี้:
#        cd "/Users/suksanfongfon/Documents/Claude/Projects/Cucumber_Menu/site"
#   3) รัน:
#        bash deploy.sh <github-username>
#      เช่น  bash deploy.sh suksancmu
#   4) เปิด https://github.com/<username>/cucumber-menu/settings/pages
#      → Branch: main / folder: / (root) → Save
#   5) รอ 1-2 นาที แล้วเปิด:
#        https://<username>.github.io/cucumber-menu/
# ==============================================================

set -e
REPO_NAME="${REPO_NAME:-cucumber-menu}"
USER="${1:-}"

if [ -z "$USER" ]; then
  echo "❌ Usage: bash deploy.sh <github-username>"
  echo "   เช่น   bash deploy.sh suksancmu"
  exit 1
fi

echo "🥒 Deploying to https://github.com/$USER/$REPO_NAME ..."

# init git if not already
if [ ! -d .git ]; then
  git init -b main
fi

# config user from env or fallback
git config user.email "${GIT_EMAIL:-suksan.cmu@gmail.com}" 2>/dev/null || true
git config user.name  "${GIT_NAME:-Suksan}" 2>/dev/null || true

# stage everything
git add -A
git commit -m "Deploy cucumber-menu bilingual site" 2>/dev/null || echo "ℹ️  Nothing to commit."

# set or update origin
REMOTE_URL="https://github.com/$USER/$REPO_NAME.git"
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi

# push (will prompt for auth: GitHub PAT or 'gh auth login' first)
git branch -M main
echo "🚀 Pushing to $REMOTE_URL ..."
git push -u origin main

cat <<EOF

✅ Push สำเร็จ!

ขั้นถัดไป (ครั้งเดียว):
  1. เปิด https://github.com/$USER/$REPO_NAME/settings/pages
  2. ใต้ Build and deployment → Source: "Deploy from a branch"
  3. Branch: main, Folder: / (root) → Save
  4. รอ 1-2 นาที แล้วเปิด: https://$USER.github.io/$REPO_NAME/

หรือใช้ gh CLI สั่งเปิดให้อัตโนมัติ:
  gh api -X POST repos/$USER/$REPO_NAME/pages -f source.branch=main -f source.path=/
EOF
