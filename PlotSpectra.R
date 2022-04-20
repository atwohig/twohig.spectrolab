#first spectra plot in spectrolab

rm(list = ls())

## installs packages if they aren't already installed
if(!is.element('spectrolab', installed.packages()))
{
  install.packages('spectrolab')
}

# if(!is.element('tidyverse', installed.packages()))
# {
#   install.packages("tidyverse")
# 
# }

library("spectrolab")
#library("tidyverse")


### EVERY DATAPOINT FROM AF5707A
## accessing the main file
# dir_path = file.path("C:", "Users", "amy twohig", "OneDrive", "Documents", "HVEDI", "AF5707_5736", "AF5707A")
# 
# AF5707_spectra = read_spectra(path = dir_path)
# 
# # 1 plot on the screen-- change y of (x,y) to change # of plots on right hand screen
# par(mfrow = c(1,1))
# 
# #plot(AF5707_spectra, lwd = 0.75, lty = 1, col = "grey25", main = "All Spectra")
# 
# 
# ## adds red highlight between points -- change total_prob to change width (1 = min to max)
# #plot_quantile(AF5707_spectra, total_prob = 1, col = rgb(1, 0, 0, 0.25), border = FALSE, add = TRUE)
# 
# ## plots every data point from AF5707A interactively
# #plot_interactive(AF5707_spectra)


## separating AF5705 into lower, middle,& upper : PATH NAMES SHOULD BE RENAMED ONCE USING MULTIPLE PLANTS
lower_path = file.path("C:", "Users", "amy twohig", "OneDrive", "Documents", "HVEDI", "AF5707_5736", "AF5707A", "AF5707A_LOWER")
middle_path = file.path("C:", "Users", "amy twohig", "OneDrive", "Documents", "HVEDI", "AF5707_5736", "AF5707A", "AF5707A_MIDDLE")
upper_path = file.path("C:", "Users", "amy twohig", "OneDrive", "Documents", "HVEDI", "AF5707_5736", "AF5707A", "AF5707A_UPPER")

L_spectra = read_spectra(path = lower_path)
M_spectra = read_spectra(path = middle_path)
U_spectra = read_spectra(path = upper_path)

par(mfrow = c(1,3))
plot(L_spectra, lwd = 1, lty = 1, col = "grey25", main = "Lower Spectra")
plot(M_spectra, lwd = 1, lty = 1, col = "grey25", main = "Middle Spectra")
plot(U_spectra, lwd = 1, lty = 1, col = "grey25", main = "Upper Spectra")

## separate: 5 scans each 
