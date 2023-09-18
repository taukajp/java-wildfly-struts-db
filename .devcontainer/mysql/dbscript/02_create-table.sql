use myappdb;

CREATE TABLE IF NOT EXISTS item (
  id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(255),
  price int,
  created_at datetime(6) NOT NULL,
  updated_at datetime(6) NOT NULL
);
