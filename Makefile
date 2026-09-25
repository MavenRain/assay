.PHONY: all test gates
all:
	python3 -P dev/build.py build
test:
	python3 -P dev/build.py runtest
gates: all
	python3 -P dev/stage-a-gates.py --m2-packing
