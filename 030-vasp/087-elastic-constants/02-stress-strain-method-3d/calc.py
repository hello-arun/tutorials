import numpy as np
from tabulate import tabulate
data  = np.loadtxt("ELASTIC_TENSOR")
print(tabulate(data*2))