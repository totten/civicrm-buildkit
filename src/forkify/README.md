`forkify` is a script that performs operations across various repos/forks/branches of CiviCRM.

For ordinary usage, `civi-download-tools` compiles this as an executable PHAR (`BUILDKIT/bin/forkify`).

For development, you may find a flow like this handy:

```bash
## Option 1: Run script. Auto-download dependencies.

pogo src/forkify/forkify.php

## Option 2: Generate dependency folder. Use "run.php" stub.

pogo --get src/forkify/forkify.php
php src/forkify/deps/run.php

## Option 3: Generate dependency folder. Use "run.sh" stub.

pogo --get src/forkify/forkify.php
bash src/forkify/deps/run.sh
```