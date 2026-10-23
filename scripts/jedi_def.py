#!/usr/bin/env python3
"""Definition через jedi напрямую.

Обход бага pylsp: definition вызывает jedi_script(use_document_path=True),
добавляя каталог документа в sys_path, из-за чего jedi не резолвит
`from . import X` (относительный импорт из __init__.py пакета).
Прямой вызов jedi без каталога документа в sys_path работает корректно.

Вызов: jedi_def.py <файл> <line 1-based> <col 0-based>
Вывод: JSON-список [{"path": ..., "line": ..., "col": ...}, ...]
"""
import json
import sys

import jedi

path, line, col = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
with open(path, encoding="utf-8") as f:
    source = f.read()

script = jedi.Script(code=source, path=path)
out = []
for d in script.goto(line=line, column=col, follow_imports=True,
                     follow_builtin_imports=True):
    if d.module_path and d.line is not None and d.column is not None:
        out.append({"path": str(d.module_path), "line": d.line, "col": d.column})
print(json.dumps(out))
