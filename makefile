export PATH := node_modules/.bin:$(PATH)

all: index.js cli.js

test: index.js
	@lsc test.ls

test-readme: cli.js readme.markdown
	@txm < readme.markdown

index.js: index.ls
	lsc --compile --bare $<

cli.js: cli.ls index.js
	echo "#!/usr/bin/env node" > $@
	lsc --compile --bare --print cli.ls >> $@
	chmod +x $@

clean:
	rm -f index.js cli.js

.PHONY: all test clean
