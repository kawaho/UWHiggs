#declare -a arr=('emPt' 'emEta' 'j1Pt' 'j2Pt' 'DeltaEta_em_j1' 'DeltaPhi_em_j1' 'DeltaEta_em_j2' 'DeltaPhi_em_j2' 'DeltaEta_e_m' 'DeltaPhi_e_m' 'DeltaEta_j1_j2' 'DeltaPhi_j1_j2' 'Mjj' 'm_met_mT_Per_e_m_Mass' 'e_met_mT_Per_e_m_Mass' 'DeltaPhi_e_met' 'DeltaPhi_m_met' 'DeltaEta_e_met' 'DeltaEta_m_met' 'MetEt' 'e_m_PZeta')

declare -a arr=('ePt_Per_e_m_Mass' 'mPt_Per_e_m_Mass' 'emEta' 'DeltaR_e_m' 'm_met_mT_Per_e_m_Mass' 'e_met_mT_Per_e_m_Mass' 'MetEt' 'j1Pt' 'j1Eta' 'DeltaR_em_j1' 'j2Eta' 'DeltaR_em_j2' 'DeltaEta_j1_j2' 'R_pT' 'Ht')
for i in "${arr[@]}"
do
  echo $i
  python shapesInputs.py --i $i --c gg
  python shapesInputs.py --i $i --c hj
done
