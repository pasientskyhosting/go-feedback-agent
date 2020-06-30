FROM scratch
# Copy our static executable.
COPY bin/haproxy-agent64 /go/bin/haproxy-agent64
# Run gropsgenie.
ENTRYPOINT ["/go/bin/haproxy-agent64"]
