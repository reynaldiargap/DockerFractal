FROM python:3.11.4-slim

# Install dependencies
RUN apt-get update && apt-get install -y nano vim libcairo2-dev python3-dev build-essential libpq-dev git wget dpkg \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libu2f-udev \
    libvulkan1 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Install gosu for handling user permissions
RUN apt-get update && apt-get install -y gosu && rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb

# Set environment variables
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN export GIT_TRACE_PACKET=1
RUN export GIT_TRACE=1
RUN export GIT_CURL_VERBOSE=1

# Create a custom Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Create and set the working directory
WORKDIR /app
RUN git config --global http.version HTTP/1.1
RUN git config --global core.compression 0
RUN git config --global http.postBuffer 1048576000
# Clone Django project from GitHub
RUN git clone yourgiturl .
RUN pip install --upgrade pip && pip install -r Yourproject/requirements.txt
# Collect static files
RUN python Yourproject/manage.py collectstatic --noinput