FROM ollama/ollama

# Start Ollama server in background & preload models, then run normally
CMD bash -c "\
  ollama serve & \
  sleep 2 && \
  ollama pull llama3.2:1b && \
  ollama pull mxbai/embed-large && \
  wait"
