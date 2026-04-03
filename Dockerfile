FROM python:3.14-alpine

WORKDIR /srv/ansible

RUN apk add --no-cache \
    bash \
    openssh \
    sshpass \
    git \
    curl \
    gcc \
    yq \
    jq \
    musl-dev \
    libffi-dev \
    openssl-dev \
    python3-dev \
    build-base

RUN pip install --no-cache-dir --root-user-action=ignore --break-system-packages \
    ansible \
    ansible-lint \
    pywinrm \
    requests \
    requests-ntlm \
    j2cli \
    jq \
    docker

RUN addgroup -S ansible && \
    adduser -S ansible -G ansible -h /srv/ansible -s /bin/bash && \
    chown -R ansible:ansible /srv/ansible

COPY --chown=ansible:ansible requirements.yml .

# USER ansible:ansible

RUN ansible-galaxy collection install -r requirements.yml || true

CMD ["ansible", "--version"]
