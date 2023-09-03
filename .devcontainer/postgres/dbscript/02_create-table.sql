\c myappdb docker

CREATE TABLE IF NOT EXISTS "item" (
  "id" bigserial primary key,
  "name" character varying,
  "price" integer,
  "created_at" timestamp(6) NOT NULL,
  "updated_at" timestamp(6) NOT NULL
);
