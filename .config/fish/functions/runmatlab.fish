function runmatlab
for file in $argv
matlab  -nosplash -nodesktop -sd (dirname (realpath $file)) -r "run('"(realpath $file)"');"
end
end
