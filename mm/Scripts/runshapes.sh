declare -a arr=('pt' 'M')
for i in "${arr[@]}"
do
  echo $i
  python shapesInputs.py --i $i --c ZOS
done
