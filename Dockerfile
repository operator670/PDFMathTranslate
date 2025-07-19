FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

WORKDIR /app
EXPOSE 7860
ENV PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      libgl1 libglib2.0-0 libxext6 libsm6 libxrender1 && \
    rm -rf /var/lib/apt/lists/*

COPY pyproject.toml .
RUN uv pip install --system --no-cache -r pyproject.toml --all-extras \
 && babeldoc --version && babeldoc --warmup

COPY . .

RUN uv pip install --system --no-cache ".[mcp]" \
 && uv pip install --system --no-cache -U \
      "babeldoc<0.3.0" "pymupdf<1.25.3" "pdfminer-six==20250416" \
 && babeldoc --version && babeldoc --warmup

CMD ["pdf2zh", "-i"]
