web-app :
	make web-app:optimize

container-arm : Dockerfile.arm32v7 docker/*
	make web-app
	docker build -t wolffdy/personal-site:arm32v7-latest -f Dockerfile.arm32v7 .

push-arm :
	make container-arm
	docker push wolffdy/personal-site:arm32v7-latest

deploy :
	ssh pi@getroutahere.servebeer.com < ops/launch_personal_site.sh
