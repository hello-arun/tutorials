import numpy as np
from scipy.optimize import curve_fit
from scipy.special import erfc
import math
import matplotlib.pyplot as plt
# Define your function
def errFun(x, mu, sigma):
    return 0.5*erfc((x-mu)/sigma)

# Define your data
data = np.loadtxt("p_vs_e.dat")
x_data = data[:,0]
y_data = data[:,1]
plt.plot(x_data,y_data,"o",label="data")
# Fit the data to the function
popt, pcov = curve_fit(errFun, x_data,y_data)


# Extract the optimized parameters
mu_opt, sigma_opt = popt
mu_scdm = mu_opt-3*sigma_opt
plt.plot(x_data,errFun(x_data,mu_opt,sigma_opt),"-",label="Fitted")
plt.plot(x_data,errFun(x_data,mu_scdm,sigma_opt),"-",label="Final")

# Print the optimized parameters
print(f"   mu_fit: {mu_opt:>8.4f}")
print(f"sigma_fit: {sigma_opt:>8.4f} ✅︎")
print(f"  mu_scdm: {mu_opt-3*sigma_opt:>8.4f} ✅︎")
plt.legend()
plt.savefig("fig-project-vs-E.svg")
plt.show()