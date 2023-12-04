-- Create "account" table
CREATE TABLE "account" (
  "id" bigserial PRIMARY KEY,
  "owner" varchar NOT NULL,
  "balance" bigint NOT NULL,
  "currency" varchar NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT NOW()
);

-- Create "entries" table
CREATE TABLE "entries" (
  "id" bigserial PRIMARY KEY,
  "account_id" bigint,
  "amount" bigint NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT NOW(),
  -- Adding FOREIGN KEY constraint
  CONSTRAINT fk_entries_account
    FOREIGN KEY ("account_id")
    REFERENCES "account" ("id")
);

-- Create "transfers" table
CREATE TABLE "transfers" (
  "id" bigserial PRIMARY KEY,
  "from_account_id" bigint,
  "to_account_id" bigint,
  "amount" bigint NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT NOW(),
  -- Adding FOREIGN KEY constraints
  CONSTRAINT fk_transfers_from_account
    FOREIGN KEY ("from_account_id")
    REFERENCES "account" ("id"),
  CONSTRAINT fk_transfers_to_account
    FOREIGN KEY ("to_account_id")
    REFERENCES "account" ("id")
);

-- Create indexes
CREATE INDEX ON "account" ("owner");
CREATE INDEX ON "entries" ("account_id");
CREATE INDEX ON "transfers" ("from_account_id");
CREATE INDEX ON "transfers" ("to_account_id");
CREATE INDEX ON "transfers" ("from_account_id", "to_account_id");

-- Add comments
COMMENT ON COLUMN "entries"."amount" IS 'Can be negative or positive';
COMMENT ON COLUMN "transfers"."amount" IS 'Must be positive';

-- Correct FOREIGN KEY reference
-- ALTER TABLE "entries" ADD FOREIGN KEY ("created_at") REFERENCES "entries" ("id");
-- The above line is incorrect, as "created_at" is of type timestamptz, not a reference to another table.

-- If you intended to create a self-reference on "entries" table, you should use a different column for referencing, for example:
ALTER TABLE "entries" ADD COLUMN "reference_entry_id" bigint;
ALTER TABLE "entries" ADD FOREIGN KEY ("reference_entry_id") REFERENCES "entries" ("id");
