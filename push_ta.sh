#!/bin/bash
cd "/c/ThuyNT_Viec/3. gscm_app_git_khoadulieu/3. gscm_app_git_khoadulieu"
git remote set-url origin https://github.com/thuynt5853/gscm_app_nghiencuu.git
git checkout nghiencuu_cursor || git checkout -b nghiencuu_cursor
git add .
git commit -m "Initial commit for research" || echo "No changes to commit"
git push -u origin nghiencuu_cursor
echo "✅ Push hoàn tất!"