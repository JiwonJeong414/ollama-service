FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV OLLAMA_HOST=0.0.0.0

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        curl \
        ca-certificates \
        bash \
        procps \
        && rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | bash

# Create ollama user and directory
RUN useradd -r -s /bin/false -m -d /usr/share/ollama ollama

# Create startup script
RUN echo '#!/bin/bash\n\
set -e\n\
echo "Starting Ollama server..."\n\
ollama serve &\n\
OLLAMA_PID=$!\n\
\n\
# Wait for Ollama to be ready\n\
echo "Waiting for Ollama to be ready..."\n\
until curl -f http://localhost:11434/api/tags >/dev/null 2>&1; do\n\
    echo "Waiting for Ollama server..."\n\
    sleep 2\n\
done\n\
\n\
echo "Ollama is ready, pulling models..."\n\
ollama pull llama3.2:1b\n\
ollama pull mxbai-embed-large\n\
\n\
echo "Models pulled successfully. Ollama is ready!"\n\
\n\
# Keep the container running\n\
wait $OLLAMA_PID' > /start-ollama.sh && \
    chmod +x /start-ollama.sh

# Expose port
EXPOSE 11434

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:11434/api/tags || exit 1

# Start Ollama
CMD ["/start-ollama.sh"]