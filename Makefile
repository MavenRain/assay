.PHONY: all test gates
all:
	python3 -P dev/build.py build
test:
	python3 -P dev/build.py runtest
	python3 -P dev/lexer-keywords-test.py
	python3 -P dev/lexer-direct-test.py
	python3 -P dev/identifier-direct-test.py
	python3 -P dev/word-direct-test.py
	python3 -P dev/segment-direct-test.py
	python3 -P dev/cli-prefix-direct-test.py
gates: all
	python3 -P dev/stage-a-gates.py --lexer-direct
