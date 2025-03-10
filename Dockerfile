# 使用 Python 3.9 作为基础镜像
FROM registry.cn-hangzhou.aliyuncs.com/strangerbell/python:3.10.13-slim-bullseye

# 设置工作目录
WORKDIR /app

# 使用清华大学镜像源
RUN echo '\
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free\n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free\n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free\n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free\n'\
> /etc/apt/sources.list

# 安装系统依赖
RUN apt-get clean && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    libreoffice-writer \
    libreoffice-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 复制项目文件
COPY requirements.txt .
COPY main.py .
COPY get_new_data.py .
COPY model.docx .
COPY table_refer.docx .
COPY static/ static/
COPY templates/ templates/

# 安装 Python 依赖
# 安装 Python 依赖
RUN pip install --no-cache-dir -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/ \
    && pip install --upgrade pip

# 创建数据目录
RUN mkdir -p /app/data

# 暴露端口
EXPOSE 5321

# 启动命令
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5321", "--reload"] 