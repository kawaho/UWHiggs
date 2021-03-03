import multiprocessing 
import os

def run(cmd):
  print "%s\n\n"%cmd
  os.system(cmd)

def sum_up_to(number):
    run("echo %i"%number)
    return sum(range(1, number + 1))

a_pool = multiprocessing.Pool()

result = a_pool.map(sum_up_to, range(10))
print(result)
