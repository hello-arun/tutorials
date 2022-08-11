# Dry-Run

Doing a Dry run before starting any calculation with multi-core setup is highly advisable.
as it can be useful for planning most efficient multi core architecture.

## How to Dry Run

```bash
cd 00-Dry-Run
chmod +x ./run.sh

./run.sh
```

Check after the run after 10 15 seconds the [OUTCAR](./calc-dry-run/OUTCAR) file. 
It should contain following information. 

![OUTCAR](./images/OUTCAR-NKPTS-NBANDS.png)

You can then stop the run.
You have enough information to proceed for the designing parallelisaiton.

## Folders

1. data : All files required to run the Dry.
2. calc-dry-run : Dry run files generated during Dry run.
3. images : Tutorial images.