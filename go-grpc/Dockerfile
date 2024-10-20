FROM golang:1.22

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN go build -o go-app .

EXPOSE 9001

CMD ["/app/go-app"]
