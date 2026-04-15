#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: sync_skills_repo.sh <check|sync> [repo_dir] [active_skills_dir]

Defaults:
  repo_dir          ${SKILLS_SYNC_REPO:-$HOME/skills}
  active_skills_dir ${CODEX_HOME:-$HOME/.codex}/skills
EOF
}

MODE="${1:-}"
REPO_DIR="${2:-${SKILLS_SYNC_REPO:-$HOME/skills}}"
ACTIVE_DIR="${3:-${CODEX_HOME:-$HOME/.codex}/skills}"

if [[ "$MODE" != "check" && "$MODE" != "sync" ]]; then
  usage
  exit 2
fi

if [[ ! -d "$REPO_DIR" ]]; then
  echo "[ERROR] Skills repo not found: $REPO_DIR" >&2
  exit 1
fi

if ! git -C "$REPO_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "[ERROR] Not a git repository: $REPO_DIR" >&2
  exit 1
fi

mkdir -p "$ACTIVE_DIR"

CURRENT_BRANCH="$(git -C "$REPO_DIR" branch --show-current)"
if [[ -z "$CURRENT_BRANCH" ]]; then
  echo "[ERROR] Could not determine the current branch for $REPO_DIR" >&2
  exit 1
fi

UPSTREAM_REF=""
if git -C "$REPO_DIR" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' >/dev/null 2>&1; then
  UPSTREAM_REF="$(git -C "$REPO_DIR" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}')"
else
  UPSTREAM_REF="origin/$CURRENT_BRANCH"
fi

echo "[INFO] Repo:   $REPO_DIR"
echo "[INFO] Active: $ACTIVE_DIR"
echo "[INFO] Branch: $CURRENT_BRANCH"
echo "[INFO] Fetching $UPSTREAM_REF"
git -C "$REPO_DIR" fetch --quiet origin "$CURRENT_BRANCH"

LOCAL_SHA="$(git -C "$REPO_DIR" rev-parse HEAD)"
REMOTE_SHA="$(git -C "$REPO_DIR" rev-parse "$UPSTREAM_REF")"
COUNTS="$(git -C "$REPO_DIR" rev-list --left-right --count "HEAD...$UPSTREAM_REF")"
AHEAD_COUNT="${COUNTS%%[[:space:]]*}"
BEHIND_COUNT="${COUNTS##*[[:space:]]}"

echo "[INFO] Local HEAD:  $LOCAL_SHA"
echo "[INFO] Remote HEAD: $REMOTE_SHA"
echo "[INFO] Ahead: $AHEAD_COUNT  Behind: $BEHIND_COUNT"

if [[ "$MODE" == "check" ]]; then
  if [[ "$BEHIND_COUNT" -gt 0 ]]; then
    echo "[RESULT] Updates are available."
  else
    echo "[RESULT] Local repo is up to date with $UPSTREAM_REF."
  fi
  exit 0
fi

if [[ -n "$(git -C "$REPO_DIR" status --porcelain --untracked-files=no)" ]]; then
  echo "[ERROR] Repo has tracked uncommitted changes. Commit or stash them before syncing." >&2
  exit 1
fi

if [[ "$AHEAD_COUNT" -gt 0 && "$BEHIND_COUNT" -gt 0 ]]; then
  echo "[ERROR] Repo has diverged from $UPSTREAM_REF. Resolve it manually before syncing." >&2
  exit 1
fi

if [[ "$BEHIND_COUNT" -gt 0 ]]; then
  echo "[INFO] Pulling latest commits with --ff-only"
  git -C "$REPO_DIR" pull --ff-only origin "$CURRENT_BRANCH"
else
  echo "[INFO] No pull needed."
fi

if [[ "$(cd "$REPO_DIR" && pwd -P)" == "$(cd "$ACTIVE_DIR" && pwd -P)" ]]; then
  echo "[INFO] Repo path and active skills path are the same. Skipping file copy."
  echo "[RESULT] Sync complete."
  exit 0
fi

if command -v rsync >/dev/null 2>&1; then
  rsync -a \
    --exclude='.git/' \
    --exclude='.gitignore' \
    --exclude='.codex' \
    --exclude='.skills_store_lock.json' \
    --exclude='__pycache__/' \
    --exclude='*.pyc' \
    "$REPO_DIR"/ "$ACTIVE_DIR"/
else
  shopt -s dotglob nullglob
  for item in "$REPO_DIR"/* "$REPO_DIR"/.[!.]* "$REPO_DIR"/..?*; do
    base="$(basename "$item")"
    case "$base" in
      .|..|.git|.gitignore|.codex|.skills_store_lock.json)
        continue
        ;;
    esac
    cp -a "$item" "$ACTIVE_DIR"/
  done
fi

echo "[RESULT] Sync complete."
