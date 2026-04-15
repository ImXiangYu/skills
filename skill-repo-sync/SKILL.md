---
name: skill-repo-sync
description: Use when the user asks to update skills, 更新技能, 更新skill, 查看是否有更新的skill, 同步skill仓库, sync the skills repo, pull the latest skills from git, or check whether the shared skills repository has updates. This skill checks the shared git repository, reports ahead/behind status, and when asked to sync it fast-forwards the repo and copies the repo contents into ~/.codex/skills.
---

# Skill Repo Sync

## Overview

Use this skill for requests about checking whether the shared skills git repository has updates or syncing the latest skills onto the current machine.

## Workflow

1. Run `scripts/sync_skills_repo.sh check` when the user only wants to know whether updates exist.
2. Run `scripts/sync_skills_repo.sh sync` when the user asks to update or synchronize skills.
3. Summarize the result clearly:
   - whether `origin` had new commits
   - whether the local repo was updated
   - whether files were copied into `~/.codex/skills`

## Safety Rules

- Do not force-pull, reset, or discard local changes in the repo.
- If `git pull --ff-only` cannot proceed because the repo is ahead, dirty, or diverged, stop and tell the user what blocked the sync.
- Keep local-only skills in `~/.codex/skills`; this workflow updates matching files but does not delete extra local skills.

## Paths

- Default shared repo path: `~/skills`
- Default active skills path: `~/.codex/skills`

The script also supports overriding these with:

- `SKILLS_SYNC_REPO=/custom/repo/path`
- `CODEX_HOME=/custom/codex/home`

## Notes

- The script ignores `.git`, `.gitignore`, `.codex`, lock files, and Python cache files.
- If the repo path and active skills path are the same directory, the copy step is skipped.
