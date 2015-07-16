The enhanced vegetation index (EVI) is an 'optimized' index
designed to enhance the vegetation signal with improved
sensitivity in high biomass regions and improved vegetation
monitoring through a de-coupling of the canopy background
signal and a reduction in atmosphere influences.

EVI is computed following this equation:
EVI = G*(NIR-RED)/(NIR+C1*RED-C2*Blue*L)

where NIR/red/blue are atmospherically-corrected or partially
atmosphere corrected (Rayleigh and ozone absorption) surface
reflectances, L is the canopy background adjustment that
addresses non-linear, differential NIR and red radiant transfer
through a canopy, and C1, C2 are the coefficients of the aerosol
resistance term, which uses the blue band to correct for aerosol
influences in the red band. 
The coefficients adopted in the MODIS-EVI algorithm are:
 L=1, C1 = 6, C2 = 7.5, and G (gain factor) = 2.5.

Whereas the Normalized Difference Vegetation Index (NDVI) is
chlorophyll sensitive, the EVI is more responsive to canopy
structural variations, including leaf area index (LAI), canopy type,
plant physiognomy, and canopy architecture. The two vegetation indices
complement each other in global vegetation studies and improve upon the
detection of vegetation changes and extraction of canopy biophysical
parameters.