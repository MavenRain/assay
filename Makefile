.PHONY: all test gates gates-m4-speed
all:
	python3 -P dev/build.py build
test:
	python3 -P dev/build.py runtest
	python3 -P dev/milestone-speed-test.py
	python3 -P dev/packed-source-test.py
	python3 -P dev/mapping-cli-test.py
	python3 -P dev/mapping-source-test.py
	python3 -P dev/mapping-runtime-test.py
	python3 -P dev/function-abi-test.py
	python3 -P dev/event-cli-test.py
	python3 -P dev/event-decode-cli-test.py
	python3 -P dev/calldata-cli-test.py
	python3 -P dev/returndata-cli-test.py
	python3 -P dev/lexer-keywords-test.py
	python3 -P dev/lexer-direct-test.py
	python3 -P dev/identifier-direct-test.py
	python3 -P dev/word-direct-test.py
	python3 -P dev/segment-direct-test.py
	python3 -P dev/cli-prefix-direct-test.py
	python3 -P dev/cli-value-direct-test.py
	python3 -P dev/cli-error-direct-test.py
gates: all
	python3 -P dev/stage-a-gates.py --m2-function-abi
gates-m4-speed: all
	python3 -P dev/stage-a-gates.py --m4-speed
