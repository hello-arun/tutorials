
# Crictical

While reading input file via `import_file` command sometimes the particle ids do not match with the particle ids in the input file. So always use `import_file(inputTopoFile,sort_particles=True)` this way across different files and even under different frames the particle ids will be consistent. You can check it by yourself.