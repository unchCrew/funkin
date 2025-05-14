# syntax=docker/dockerfile:1

# ===== Builder stage =====
FROM oven/bun:1.2 AS builder
WORKDIR /app

# Copy project files
COPY . ./

# Install deps and build
RUN bun install --frozen-lockfile && \
    bun run build

# ===== Production image =====
FROM nginx:1.27-alpine AS runner

# Copy built assets from builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Remove default nginx config & add minimal config
RUN rm /etc/nginx/conf.d/default.conf
COPY ./nginx.conf /etc/nginx/conf.d

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
