FROM ollama/ollama

# Preload your models during image build
RUN ollama pull llama3.2:1b && \
    ollama pull mxbai/embed-large

CMD ["ollama", "serve"]