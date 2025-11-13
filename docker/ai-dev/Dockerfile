FROM ubuntu:25.10

# install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    ca-certificates \
    git \
    unzip \
    wget \
    software-properties-common \
    dpkg \
    # add any others you need
    && rm -rf /var/lib/apt/lists/*

# Install Node.js v24
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      | tee /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# Install Helix editor from PPA .deb package
RUN wget http://ppa.launchpadcontent.net/maveonair/helix-editor/ubuntu/pool/main/h/helix/helix_25.01.1-4~ubuntu24.10~ppa1_amd64.deb \
    && dpkg -i helix_25.01.1-4~ubuntu24.10~ppa1_amd64.deb \
    && rm helix_25.01.1-4~ubuntu24.10~ppa1_amd64.deb \
    && ln -sf /usr/bin/helix /usr/local/bin/hx || true

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io \
    && rm -rf /var/lib/apt/lists/*

# Install OpenCode
RUN curl -fsSL https://opencode.ai/install | bash

# Configure git user
RUN git config --global user.name "OpenCode" && \
    git config --global user.email "opencode@opencode.ai"

# Set editor to helix
ENV EDITOR=hx

# This is where the code will be mounted
RUN mkdir /work
WORKDIR /work

RUN git config --global --add safe.directory /work

CMD ["/root/.opencode/bin/opencode"]
