# COMPASS_paper
# Notebooks and files for Wellcome Open Research submission

### These notebooks provide examples of one method for processing timeseries data from the COMPASS system described in Brown et al (2016)

Brown LA, Hasan S, Foster RG and Peirson SN. COMPASS: Continuous Open Mouse Phenotyping of Activity and Sleep Status [version 1; referees: 3 approved, 1 approved with reservations]. Wellcome Open Res 2016, 1:2 (doi: 10.12688/wellcomeopenres.9892.1)

####  https://wellcomeopenresearch.org/articles/1-2/v1


The analysis uses the Python programming language, version 2.7.11, as well a a number of more specific packages. These are all found as part of the Anaconda Python environment produced by Contiuum Analytics This is BSD licenced and cross platform. (https://www.continuum.io/downloads)

all required python packages:
  - pandas  0.18.0
  - numpy   1.10.4
  - matplotlib 1.5.1
  - seaborn   0.7.0

(environment can be recreated using 'conda create included COMPASS.yml file)

```
conda env create -f COMPASS.yml

```

![workflow](dataFiles.png)



