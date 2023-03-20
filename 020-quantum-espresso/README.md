## Important scripts

### replace incar with relaxed cordinate from outcar

```bash
find_and_replace() {
  # Arguments:
  # $1: old incar-[scf/relax].pw
  # $2: outcar-relax.pw
  # $3: final output file

  # Get line numbers
  tempfile=$(mktemp)
  o_start=$(awk '/Begin final/ {print NR}' $2)
  o_end=$(awk '/End final/ {print NR}' $2)
  i_start=$(awk '/CELL_PARA/ {print NR}' $1)
  head -"${i_start}" $1 > $tempfile
  awk -v o_start="$o_start" -v o_end="$o_end" 'NR>4+o_start && NR<o_end {print}' $2 >>$tempfile
  mv $tempfile $3
}
```
