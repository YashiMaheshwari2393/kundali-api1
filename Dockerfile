# ─────────────────────────────────────────────────────────────────────────────
# Stage 1 – Builder
#   Uses a full GCC image to compile the Crow app and all its dependencies.
# ─────────────────────────────────────────────────────────────────────────────
FROM gcc:13 AS builder

# Install build tools & Crow's dependencies
RUN apt-get update && apt-get install -y \
    cmake \
    libboost-all-dev \
    libssl-dev \
    zlib1g-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Download Crow (header-only library)
RUN git clone --depth=1 https://github.com/CrowCpp/Crow.git /crow

WORKDIR /app

# Copy source file
COPY kundali.cpp .

# Compile  (-O2 for speed, static-link where possible for a smaller runtime image)
RUN g++ -std=c++17 -O2 \
    -I/crow/include \
    kundali.cpp \
    -o kundali_server \
    -lboost_system \
    -lpthread \
    -lssl \
    -lcrypto \
    -lz

# ─────────────────────────────────────────────────────────────────────────────
# Stage 2 – Runtime
#   Copies only the compiled binary into a slim Debian image.
#   This keeps the final Docker image small (~200 MB vs ~1.5 GB).
# ─────────────────────────────────────────────────────────────────────────────
FROM debian:bookworm-slim AS runtime

RUN apt-get update && apt-get install -y \
    libboost-system1.81.0 \
    libssl3 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy compiled binary from builder stage
COPY --from=builder /app/kundali_server .

# Render injects $PORT at runtime; expose 8080 as the default
EXPOSE 8080

# Run the server
CMD ["./kundali_server"]
