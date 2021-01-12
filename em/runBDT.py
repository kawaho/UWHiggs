import Kinematics
import os 
f = open('runBDT.sh','w')
for sys in Kinematics.bdtSys:
  syslog = sys.replace("_", "")
  if sys == "": syslog = "test"
  f.write('nohup root -b -q \'TMVAClassification.C(\"' + sys + '\")\' >& BDTroot/' + syslog + '.log & \n')
f.close()
#os.system('source runBDT.sh')


