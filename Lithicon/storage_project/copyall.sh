#!/bin/bash

date > copyall.log

/net/adm/copyadm.sh
/net/departments/copydep.sh
/net/projects/copyrd.sh
/net/projects/copyts.sh
/net/software/copysw.sh
/net/resources/copyres.sh
/net/jungle/copyjungle.sh

date >> copyall.log
