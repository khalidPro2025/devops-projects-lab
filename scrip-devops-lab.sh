#!/bin/bash
set -e

GIT_USER="khalidPro2025"
REPO_NAME="devops-projects-lab"
BRANCH="main"
REMOTE_URL="git@github.com:${GIT_USER}/${REPO_NAME}.git"

echo "[INIT] Déploiement GitHub : $REPO_NAME"

# SSH
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    ssh-keygen -t ed25519 -C "${GIT_USER}@github.com" -f "$HOME/.ssh/id_ed25519" -N ""
fi

eval "$(ssh-agent -s)" >/dev/null
ssh-add "$HOME/.ssh/id_ed25519"

if ! ssh -T git@github.com 2>&1 | grep -qi "successfully authenticated"; then
    echo "[ERREUR] Clé SSH non enregistrée sur GitHub"
    cat ~/.ssh/id_ed25519.pub
    exit 1
fi

# Git init
if [ ! -d ".git" ]; then
    git init
    git branch -M "$BRANCH"
fi

git remote remove origin 2>/dev/null || true
git remote add origin "$REMOTE_URL"

# Commit & push
git add .
git commit -m "Import DevOps projects portfolio"
git push -u origin "$BRANCH"

echo "✅ Import terminé : https://github.com/${GIT_USER}/${REPO_NAME}"
