build: build.falcon build.gruf build.nginx

build.falcon:
	docker build -f falcon/Dockerfile -t grpc-proxy/falcon:0.0.1 falcon/
	minikube image load grpc-proxy/falcon:0.0.1

build.gruf:
	docker build -f gruf/Dockerfile -t grpc-proxy/gruf:0.0.1 gruf/
	minikube image load grpc-proxy/gruf:0.0.1

build.nginx:
	docker build -f nginx/Dockerfile -t grpc-proxy/nginx:0.0.1 nginx/
	minikube image load grpc-proxy/nginx:0.0.1
