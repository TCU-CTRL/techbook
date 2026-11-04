FROM debian:trixie-slim

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates git make latexmk poppler-utils \
        texlive-luatex texlive-lang-japanese texlive-latex-extra \
        texlive-fonts-recommended \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid 1000 writer \
    && useradd --uid 1000 --gid writer --create-home --shell /bin/bash writer \
    && mkdir -p /workspace/techbook \
    && chown writer:writer /workspace/techbook

# Writable even when Compose overrides the UID to match a Linux host.
ENV LANG=C.UTF-8 \
    TEXMFVAR=/tmp/texmf-var \
    TEXMFCONFIG=/tmp/texmf-config

USER writer
WORKDIR /workspace/techbook
COPY --chown=writer:writer . .
CMD ["make", "pdf"]
