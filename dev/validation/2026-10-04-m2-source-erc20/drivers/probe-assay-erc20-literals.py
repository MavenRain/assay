import importlib.util
from pathlib import Path

root = Path('/Users/oobi/Documents/assay')
spec = importlib.util.spec_from_file_location('erc20_literal_probe', root / 'dev/erc20-source-test.py')
t = importlib.util.module_from_spec(spec)
spec.loader.exec_module(t)
t.WORK = root / '.gatework/erc20-literal-probe'
t.WORK.mkdir(exist_ok=True)
t.C.WORK = t.WORK
cases, refusals = t.literals()
print(f'ERC20-LITERALS cases={len(cases)} refusals={len(refusals)} OK')
