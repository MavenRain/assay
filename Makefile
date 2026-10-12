.PHONY: all test gates gates-m4-speed
all:
	python3 -P dev/build.py build
test:
	python3 -P dev/build.py runtest
	python3 -P dev/external-call-test.py
	python3 -P dev/milestone-speed-test.py
	python3 -P dev/packed-source-test.py
	python3 -P dev/mapping-cli-test.py
	python3 -P dev/mapping-source-test.py
	python3 -P dev/mapping-runtime-test.py
	python3 -P dev/function-abi-test.py
	python3 -P dev/return-abi-test.py
	python3 -P dev/event-source-test.py
	python3 -P dev/storage-proof-test.py
	python3 -P dev/erc20-source-test.py
	python3 -P dev/m2-abi-test.py
	python3 -P dev/m2-reconcile-test.py
	python3 -P dev/refined-word-test.py
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
	python3 -P dev/stage-a-gates.py --m2-reconcile
gates-m4-speed: all
	python3 -P dev/stage-a-gates.py --m4-speed
# C host (TinyCC). A translator writes c/gen/*.c from src/*.bend. Do not edit these files by hand.
.PHONY: c c-test
TCC ?= tcc
C_FLAGS = -Wall -Werror -I c
C_GEN = $(wildcard c/gen/*.c)
c:
	mkdir -p _build/c
	$(TCC) $(C_FLAGS) -o _build/c/assay c/main.c c/runtime.c $(filter-out c/gen/tests.c,$(C_GEN)) -lpthread
	$(TCC) $(C_FLAGS) -o _build/c/tests c/tests_main.c c/runtime.c $(C_GEN) -lpthread
c-test: c
	$(TCC) $(C_FLAGS) -o _build/c/runtime_test c/runtime.c c/runtime_test.c
	_build/c/runtime_test
