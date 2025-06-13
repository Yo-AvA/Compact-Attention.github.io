#!/bin/bash

# 检查ffmpeg
# if ! command -v ffmpeg &> /dev/null; then
#     echo "错误：请先安装 ffmpeg"
#     exit 1
# fi

total=0
success=0
fail=0

echo "===== 开始批量转换 H.264 ====="

while IFS= read -r -d '' file; do
    ((total++))
    echo -n "[$(date '+%H:%M:%S')] 处理: ${file#./} ..."
    
    # 临时文件（同目录）
    temp_file="${file%.*}_temp.mp4"
    echo "临时文件: $temp_file"
    ffmpeg -i "$file" \
              -c:v libx264 -preset fast -crf 23 -c:a copy \
              "$temp_file"

    # # 转换命令
    # if ffmpeg -i "$file" \
    #           -c:v libx264 -preset fast -crf 23 \
    #           -pix_fmt yuv420p \
    #           -vsync cfr \
    #           -c:a copy \
    #           "$temp_file" 2> /dev/null; then
              
    #     if [[ -s "$temp_file" ]]; then
    #         # 保留原文件属性
    #         cat "$temp_file" > "$file" && rm -f "$temp_file"
    #         ((success++))
    #         echo "✓ [大小: $(du -sh "$file" | cut -f1)]"
    #     else
    #         rm -f "$temp_file"
    #         ((fail++))
    #         echo "× 生成空文件"
    #     fi
    # else
    #     rm -f "$temp_file"
    #     ((fail++))
    #     echo "× 转换失败"
    # fi
done < <(find . -type f -name "*.mp4" -print0)

echo "===== 转换完成 ====="
echo "总计: $total  成功: $success  失败: $fail"