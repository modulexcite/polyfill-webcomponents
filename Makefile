.PHONY: update clean all test

all: index.js

index.js: build

update: build/tools
	-cd build/tools && sh bin/pull-all.sh

build: build/platform.concat.js

build/platform.concat.js: build/tools/components/platform-dev/build/platform-lite.concat.js
	sh replace.sh

build/tools/components/platform-dev/build/platform-lite.concat.js: build/tools/components/platform-dev
	cd build/tools/components/platform-dev && npm install
	cd build/tools/components/platform-dev && cp build-lite.json build-lite.old.json
	cd build/tools/components/platform-dev && cp build.json build-lite.json
	cd build/tools/components/platform-dev && grunt build-lite
	cd build/tools/components/platform-dev && mv build-lite.old.json build-lite.json
	cp -f build/tools/components/platform-dev/build/platform-lite.concat.js build/platform.concat.js

build/tools/components/platform-dev:
	-cd build/tools/components/platform-dev && git checkout .
	-rm build/platform.concat.js

build/tools:
	-mkdir build
	-cd build && git clone https://github.com/Polymer/tools.git
	-cd build/tools && git checkout . && git clean -df

test: build
	cd test && beefy index.js:build.js --open

clean:
	rm -Rf build

