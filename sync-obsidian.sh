#!/bin/bash

# 确保目录存在
mkdir -p content/posts
mkdir -p obsidian/posts

# 创建软链接（如果不存在）
if [ ! -L "content/posts" ]; then
    rm -rf content/posts
    ln -s ../obsidian/posts content/posts
fi

# 可以在这里添加其他同步逻辑 