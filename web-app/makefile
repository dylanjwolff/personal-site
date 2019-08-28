app :
	make elm.js
	make css
	make html
	make assets

assets : src/Main.elm src/*.png
	cp src/*.png build

css : src/Main.elm src/*.css
	cp src/*.css build

html:
	cp src/*.html build

elm.js : src/Main.elm
	elm make src/Main.elm --output=build/elm.js

clean :
	rm -rf build/*

run :
	make app
	http-server build

background_run :
	make app
	http-server build &> /dev/null &

devserver :
	 watch -n 3 "pkill node; make background_run"
