
rm(list = ls())

## installs packages if they aren't already installed
if(!is.element('spectrolab', installed.packages()))
{
  install.packages('spectrolab')
}


library("spectrolab")

### DATA FROM AF5736A
## accessing the main file: follows computer path
dir_path = file.path("C:", "Users", "amy twohig", "OneDrive", "Documents", "HVEDI", "AF5707_5736", "AF5736A")

## reading the entire AF5736A folder
AF5736A_spectra = read_spectra(path = dir_path)

## separating into lower/middle/upper: use format [x;y,] where x is the first scan and y is last
## 1-15 lower, 16-30 middle, 31-45 upper
LOWER_5736A = AF5736A_spectra[1:15,]
MIDDLE_5736A = AF5736A_spectra[16:30,]
UPPER_5736A = AF5736A_spectra[31:45,]

## further separating into the 3 sections on each leaf: same format as above, 1-5, 6-10, 11-15
LOWER_GROUP1 = LOWER_5736A[1:5,]
LOWER_GROUP2 = LOWER_5736A[6:10,]
LOWER_GROUP3 = LOWER_5736A[11:15,]

MIDDLE_GROUP1 = MIDDLE_5736A[1:5,]
MIDDLE_GROUP2 = MIDDLE_5736A[6:10,]
MIDDLE_GROUP3 = MIDDLE_5736A[11:15,]  

UPPER_GROUP1 = UPPER_5736A[1:5,]
UPPER_GROUP2 = UPPER_5736A[6:10,]
UPPER_GROUP3 = UPPER_5736A[11:15,]

# # 4x4 plot on the screen-- format (x,y) where x is rows and y is columns
## room to plot every graph-- CHANGE TO 2X2 IF FOCUSING ON ONE GROUP AT A TIME
par(mfrow = c(2,2))

## plot groupings-- comment out whatever one you're not focusing on
plot(LOWER_5736A, lwd = 0.50, lty = 1, col = "grey25", main = "AF5736A Lower")
plot(LOWER_GROUP1, lwd = 0.50, lty = 1, col = "grey25", main = "Lower 1-5")
plot(LOWER_GROUP2, lwd = 0.50, lty = 1, col = "grey25", main = " Lower 6-10")
plot(LOWER_GROUP3, lwd = 0.50, lty = 1, col = "grey25", main = "Lower 11-15")

# 
# plot(MIDDLE_5736A, lwd = 0.50, lty = 1, col = "grey25", main = "AF5736A Middle")
# plot(MIDDLE_GROUP1, lwd = 0.50, lty = 1, col = "grey25", main = "Middle 1-5")
# plot(MIDDLE_GROUP2, lwd = 0.50, lty = 1, col = "grey25", main = "Middle 6-10")
# plot(MIDDLE_GROUP3, lwd = 0.50, lty = 1, col = "grey25", main = "Middle 11-15")
# 
# 
# plot(UPPER_5736A, lwd = 0.50, lty = 1, col = "grey25", main = "AF5736A Upper")
# plot(UPPER_GROUP1, lwd = 0.50, lty = 1, col = "grey25", main = "Upper 1-5")
# plot(UPPER_GROUP2, lwd = 0.50, lty = 1, col = "grey25", main = "Upper 6-10")
# plot(UPPER_GROUP3, lwd = 0.50, lty = 1, col = "grey25", main = "Upper 11-15")

