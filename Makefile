.PHONY: all test gates
all:
	python3 -P dev/build.py build
test:
	python3 -P dev/build.py runtest
	python3 -P dev/lexer-keywords-test.py
gates: all
	python3 -P dev/stage-a-gates.py --keyword-dispatch
