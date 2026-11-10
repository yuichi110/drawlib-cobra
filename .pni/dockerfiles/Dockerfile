ARG GO_VERSION=1.22
FROM golang:${GO_VERSION}-bookworm

ENV CGO_ENABLED=0 \
    GOFLAGS="-buildvcs=false" \
    GOPATH="/go" \
    GOCACHE="/go/cache"

RUN useradd --uid 10001 --create-home --shell /bin/bash pni \
    && mkdir -p /workspace /out /go/cache \
    && chown -R pni:pni /workspace /out /go \
    && chmod 0777 /out

WORKDIR /workspace
COPY --chown=pni:pni . /workspace

# Pre-download module dependencies and warm build cache during image build so Stage 2/3 can run with --network=none
RUN if [ -f go.mod ]; then go mod download; fi \
    && go test -c ./... >/dev/null 2>&1 || true \
    && rm -f *.test \
    && chown -R pni:pni /workspace /go \
    && chmod -R a+rwX /workspace /go

USER pni
CMD ["go", "version"]
