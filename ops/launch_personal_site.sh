docker pull wolffdy/personal-site:arm32v7-latest
docker rm -f personal-site
nohup docker run --name personal-site --net=host -v /home/pi/letsencrypt:/etc/letsencrypt -p 80:80 -p 443:443 wolffdy/personal-site:arm32v7-latest &> /dev/null &
