all:
	hugo

serve:
	hugo server

bootstrap:
	sudo apt install hugo
	git submodule update --init --recursive

help:
	echo "hugo new --kind post posts/hello-world.de.md"
