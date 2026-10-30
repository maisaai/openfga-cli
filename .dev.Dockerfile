# Maisa fork: builder pinned to a chainguard/go digest with Go >= 1.27.3
# (upstream's v0.8.2 release binary is built with go1.27.2, CVE-2026-111943),
# -trimpath and upstream's "-s -w" ldflags, and the Apache-2.0 LICENSE shipped
# at /LICENSE next to /fga, the layout maisa-helm-tools copies from.
FROM cgr.dev/chainguard/go:latest@sha256:0d2e83bf723e1edef67732d22b9272dd1311c7a19dff695bd6928a7831c31a9f AS builder

WORKDIR /app

COPY . .
RUN CGO_ENABLED=0 GOTOOLCHAIN=local go build -trimpath -ldflags "-s -w" -o fga ./cmd/fga/main.go

FROM cgr.dev/chainguard/static@sha256:fc42af33e643f20d08baf03cddcc1c02ba57052dfb02edb0d79f3fc47bcea8d9

COPY --from=builder /app/fga /fga
COPY LICENSE /LICENSE
ENTRYPOINT ["/fga"]
