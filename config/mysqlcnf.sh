#!/bin/bash
# initialize hive environment 

# initialize mariadb with user root and password 123456 
# but abort because root had no remote connection right
schematool -dbType mysql -initSchema &> /dev/null 
# grant remote connection right to root
mysql -uroot -p123456 < sql.txt
# initialize again and finished
schematool -dbType mysql -initSchema &> /dev/null
#  hive