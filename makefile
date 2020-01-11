deploy :
	make push-arm
	ssh pi@getroutahere.servebeer.com < ops/launch_personal_site.sh

web-app :
	make web-app:optimize

container-arm64 : Dockerfile.arm64v8 docker/*
	make web-app
	docker build -t wolffdy/personal-site:arm64v8-latest -f Dockerfile.arm64v8 .

container-arm : Dockerfile.arm32v7 docker/*
	make web-app
	docker build -t wolffdy/personal-site:arm32v7-latest -f Dockerfile.arm32v7 .

push-arm :
	make container-arm
	docker push wolffdy/personal-site:arm32v7-latest

