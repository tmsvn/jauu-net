all:
	hugo

bootstrap:
	sudo apt install hugo
	git submodule update --init --recursive

help:
	echo "hugo new posts/hello-world.de.md"
