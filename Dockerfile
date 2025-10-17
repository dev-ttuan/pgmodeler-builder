# This Dockerfile builds pgModeler from source on Ubuntu 24.04 (Qt6).
FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG USER_ID=1000
ARG GROUP_ID=1000
# Allow pinning to branch/tag (e.g.: v1.1.0, v1.0.6, main)
ARG PGMODELER_REF=main

# 1) Build deps (keeping close to old file) + minimum runtime libs
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    qt6-base-dev \
    qt6-base-dev-tools \
    qt6-tools-dev \
    qmake6 \
    libqt6svg6-dev \
    libxml2-dev \
    libxext-dev \
    libpq-dev \
    postgresql-server-dev-all \
    git \
    cmake \
    pkg-config \
    # --- minimum runtime Qt/psql to run smoothly on any machine ---
    libqt6network6 \
    libqt6sql6 \
    libqt6sql6-psql \
    libgl1 \
    # If GUI X11 reports plugin 'xcb' error, uncomment the group below:
    # libx11-xcb1 libxcb1 libxcb-cursor0 libxcb-xfixes0 libxcb-image0 \
    # libxcb-keysyms1 libxcb-icccm4 libxcb-render0 libxcb-shm0 \
    # libxkbcommon0 libxkbcommon-x11-0 \
    && rm -rf /var/lib/apt/lists/*

# 2) Alias qmake6 -> qmake
RUN ln -sf /usr/bin/qmake6 /usr/bin/qmake

# 3) Build & install under root (fast, no sudo needed)
WORKDIR /opt/src

# Clone narrow the ref to build fast & reproducible
RUN git clone --depth 1 --branch "${PGMODELER_REF}" https://github.com/pgmodeler/pgmodeler.git
WORKDIR /opt/src/pgmodeler
RUN git clone --depth 1 https://github.com/pgmodeler/plugins

# Build & install
RUN qmake -r CONFIG+=release PREFIX=/usr/local pgmodeler.pro \
    && make -j"$(nproc)" \
    && make install \
    && cd /opt/src && rm -rf /opt/src/pgmodeler

# 4) Create user runtime (no special privileges) — safe & idempotent
RUN set -eux; \
    grp_name="pgmodeler"; \
    if getent group "${GROUP_ID}" >/dev/null; then \
    grp_name="$(getent group ${GROUP_ID} | cut -d: -f1)"; \
    else \
    groupadd -g "${GROUP_ID}" "${grp_name}"; \
    fi; \
    if getent passwd "${USER_ID}" >/dev/null; then \
    cur_user="$(getent passwd ${USER_ID} | cut -d: -f1)"; \
    usermod -l pgmodeler -d /home/pgmodeler -m "${cur_user}" || true; \
    else \
    useradd -m -u "${USER_ID}" -g "${GROUP_ID}" -s /bin/bash pgmodeler; \
    fi; \
    mkdir -p /home/pgmodeler/.config; \
    chown -R "${USER_ID}:${GROUP_ID}" /home/pgmodeler

USER pgmodeler
WORKDIR /home/pgmodeler

# 5) Run GUI (need map DISPLAY when running)
CMD ["pgmodeler"]
