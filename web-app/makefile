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

elm.js : src/*.elm
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

optimize :  src/*.elm
	elm make src/Main.elm --optimize --output=build/elm.opt.js
	uglifyjs build/elm.opt.js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output=build/elm.js
	rm build/elm.opt.js
	make css
	make html
	make assets

run_optimize :
	make optimize
	http-server build
