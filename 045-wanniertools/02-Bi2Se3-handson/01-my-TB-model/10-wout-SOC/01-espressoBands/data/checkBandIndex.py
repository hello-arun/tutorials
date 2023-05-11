import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import Slider
data = np.loadtxt("./bi2se3-bands-bulk-soc-02.dat.gnu")
fermi = 10.72
num_bands = len(data[data[:,0]==data[0,0]])
num_kpts = data.shape[0]//num_bands
kpoints = data[0:num_kpts,0]
print(num_bands,num_kpts)
print(kpoints.shape)
print(kpoints)
bands = data[:,1].reshape((-1,num_kpts)).T
print(bands.shape)
print(bands[0,:])
bands = bands - fermi
# fermi = 10.4


# Create the initial plot
start = 50
end = 70
fig, ax = plt.subplots()
plt.subplots_adjust(bottom=0.25)
ax.plot(kpoints, bands[:, start-1:end], "-k")
plt.xlabel('kpoints')
plt.ylabel('Bands')

# Define the sliders
start_slider_ax = plt.axes([0.15, 0.1, 0.65, 0.03])
start_slider = Slider(start_slider_ax, 'Start', 1, bands.shape[1], valinit=start, valstep=1)

end_slider_ax = plt.axes([0.15, 0.05, 0.65, 0.03])
end_slider = Slider(end_slider_ax, 'End', 1, bands.shape[1], valinit=end, valstep=1)

# Define the update function
def update_plot(val):
    start = int(start_slider.val)
    end = int(end_slider.val)
    ax.cla()
    ax.plot(kpoints, bands[:, start-1:end], "-k")
    ax.relim()
    ax.autoscale_view()
    fig.canvas.draw_idle()

# Register the update function to the value change event of the sliders
start_slider.on_changed(update_plot)
end_slider.on_changed(update_plot)

plt.show()