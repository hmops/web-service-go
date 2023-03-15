# Use a slim Alpine Linux as the base image
FROM golang:1.17-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy only the necessary files to the container
COPY go.mod .
COPY go.sum .
COPY main.go .

# Build the Go binary with optimizations
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o app .

# Use a scratch image as the final image
FROM scratch

# Copy only the necessary files to the final image
COPY --from=builder /app/app .

# Expose the application on port 8080
EXPOSE 8080

# Set the command to run the binary
CMD ["/app"]

