#!/bin/bash

set -e

echo "========================================"
echo " RESET GIT - KEEP CURRENT VERSION ONLY"
echo "========================================"

# Kiểm tra đang ở thư mục Git
if [ ! -d ".git" ]; then
    echo "ERROR: Không tìm thấy thư mục .git"
    echo "Hãy chạy script trong thư mục project."
    exit 1
fi

# Kiểm tra remote hiện tại
REMOTE=$(git remote get-url origin 2>/dev/null || true)

if [ -z "$REMOTE" ]; then
    echo "ERROR: Không tìm thấy remote origin."
    exit 1
fi

echo ""
echo "Project : $(pwd)"
echo "Remote  : $REMOTE"
echo ""

# Xác nhận
read -p "XÓA TOÀN BỘ LỊCH SỬ GIT CŨ? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Đã hủy."
    exit 0
fi

echo ""
echo "[1/6] Xóa .git cũ..."
rm -rf .git

echo "[2/6] Khởi tạo Git mới..."
git init

echo "[3/6] Đặt branch master..."
git branch -M master

echo "[4/6] Thêm remote..."
git remote add origin "$REMOTE"

echo "[5/6] Add toàn bộ file hiện tại..."
git add -A

echo ""
echo "Các file sẽ được commit:"
git status --short

echo ""
echo "[6/6] Tạo commit mới..."
git commit -m "Current version"

echo ""
echo "========================================"
echo " Push lên remote..."
echo "========================================"

git push -u origin master --force

echo ""
echo "========================================"
echo " HOÀN TẤT"
echo "========================================"
echo ""
echo "Repository hiện chỉ giữ bản hiện tại."
echo "Branch: master"
echo "Remote: $REMOTE"
echo ""
echo "Kiểm tra:"
git log --oneline --decorate -5

echo ""
echo "Dung lượng Git:"
git count-objects -vH