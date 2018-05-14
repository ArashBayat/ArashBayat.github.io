#!/bin/bash

###### this is to test scripts
bash genData.sh sim30K
bash runme.sh sim30K

###### Real Dataset
bash runme.sh AJ055
bash runme.sh AJ218
bash runme.sh AJ292

##### Simulated Dataset
bash genData.sh sim5M
bash runme.sh sim5M

bash genData.sh sim25M
bash runme.sh sim25M

##### collecting the results
bash JoinTSV.sh sim30K
bash JoinTSV.sh AJ055
bash JoinTSV.sh AJ218
bash JoinTSV.sh AJ292
bash JoinTSV.sh sim5M
bash JoinTSV.sh sim25M

exit
