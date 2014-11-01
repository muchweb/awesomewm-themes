all: lib/index.js

lib/index.js: ./node_modules/.bin/coffee src/index.coffee
	mkdir -p lib
	./node_modules/.bin/coffee --map --compile --output lib src
	chmod +x lib/index.js

./node_modules/.bin/coffee:
	npm install

themes: generated/obscur

clean:
	rm -rf generated

generated/obscur: lib/index.js themes/obscur.json
	node lib/index.js -o generated/obscur themes/obscur.json