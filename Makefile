# Build. Compile Elm to Javascript
b:
	elm-format src/*.elm --yes && elm make src/*.elm --output=tmp/index.js
	make css
	make min

# Build with time travelling debugger
debug:
	elm-format src/*.elm --yes && elm make src/*.elm --output=tmp/index.js --debug
	make css
	make min

css:
	lessc index.less > tmp/index.css

# Minify
min:
	cd "./tmp" && minify --output=index.min.js index.js && minify --output=index.min.css index.css
	cp tmp/index.min.js build/
	cp tmp/index.min.css build/

sizes:
	du -h tmp/index.js build/index.min.js
	du -h tmp/index.css build/index.min.css

deploy:
	rsync -v -r build/ neillyons.io:/srv/www/snake.neillyons.io
