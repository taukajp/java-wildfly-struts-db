#!/usr/bin/env bash

set -e

mysql -u root -e "SET GLOBAL local_infile=on"

# mysql -u docker -D myappdb -vvv --local_infile=on \
#   -e "LOAD DATA LOCAL INFILE '/docker-entrypoint-initdb.d/item_data.csv' INTO TABLE item FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n' (@1,@2,@3,@4) SET name=@1,price=@2,created_at=@3,updated_at=@4"

mysql -u docker -D myappdb -vvv --local_infile=on <<-EOF
  LOAD DATA LOCAL INFILE '/docker-entrypoint-initdb.d/item_data.csv'
  INTO TABLE item
  FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  (@1,@2,@3,@4)
  SET name=@1,price=@2,created_at=@3,updated_at=@4
EOF
