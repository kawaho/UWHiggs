declare -a arr=('pt' 'M')
for i in "${arr[@]}"
do
  echo $i
  python plotterRatio.py --channel "mm"  --prefix "postfit" --blind 0 --var $i --cat "ZOS" --higgsSF 0
done

