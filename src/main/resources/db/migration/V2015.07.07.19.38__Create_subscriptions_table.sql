CREATE TABLE subscriptions (
  id BIGSERIAL NOT NULL,
  email VARCHAR(255) NOT NULL,
  subscriber_name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  PRIMARY KEY(id)
);
