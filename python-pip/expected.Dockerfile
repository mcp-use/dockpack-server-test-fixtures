# syntax=docker/dockerfile:1.7

FROM python:3.11-slim AS build
RUN pip install --no-cache-dir uv
WORKDIR /app
RUN python -m venv /app/.venv
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Copy dependency files first for better caching
COPY requirements.txt ./
RUN --mount=type=cache,target=/root/.cache/uv uv pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

FROM python:3.11-slim AS runtime
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
RUN groupadd -g 1001 appgroup && \
    useradd -u 1001 -g appgroup -m -d /app -s /usr/sbin/nologin appuser
WORKDIR /app
COPY --from=build --chown=appuser:appgroup /app /app

# Expose port
EXPOSE 3000

USER appuser



# Start the application
CMD ["python", "server.py"]
