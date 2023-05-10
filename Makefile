
bootstrap:
	sudo apt install hugo
	git submodule update --init --recursive

all:
	hugo

help:
	echo "hugo new posts/hello-world.de.md"
