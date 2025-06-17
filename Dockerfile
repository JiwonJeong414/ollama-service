FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl bash && \
    rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | bash

# Expose port
EXPOSE 11434

# Pull models and start Ollama
CMD bash -c "\
  ollama serve & \
  sleep 5 && \
  ollama pull llama3.2:1b && \
  ollama pull mxbai-embed-large && \
  wait"
