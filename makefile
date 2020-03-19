deploy :
	make push-arm
	ssh pi@getroutahere.servebeer.com < ops/launch_personal_site.sh

web-app :
	make web-app:optimize

dockerfiles : template.Dockerfile
	./gen_docker.hs

container-arm64-notls : docker/* static/*
	make dockerfiles
	docker build -t wolffdy/personal-site-arm64v8-notls:latest -f Dockerfile.arm64v8 .

container-x86_64-notls : docker/* static/*
	make dockerfiles
	docker build -t wolffdy/personal-site-x86_64-notls:latest -f Dockerfile.x86_64 .

containers :
	make container-arm64-notls
	make container-x86_64-notls

run-local :
	make container-x86_64-notls
	docker run -P wolffdy/personal-site-:latest

push-arm64-notls :
	make container-arm64-notls
	docker push wolffdy/personal-site-arm64v8-notls:latest

deploy-arm64-notls :
	make push-arm64-notls
	kubectl replace -f ops/deploy.yaml
