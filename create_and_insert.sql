-- Membuat database bernama banking_system
CREATE DATABASE banking_system;

-- postgres=# \c banking_system

-- Mendefinisikan tipe data ENUM untuk jenis kelamin nasabah
CREATE TYPE GENDER AS ENUM('male', 'female');

-- Membuat tabel untuk menampung data nasabah
CREATE TABLE customers (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  gender GENDER NOT NULL,
  address TEXT,
  birth_date DATE NOT NULL
);

-- Membuat tabel untuk menampung data akun bank
CREATE TABLE accounts (
  id BIGSERIAL PRIMARY KEY,
  created_date DATE NOT NULL DEFAULT CURRENT_DATE,
  expired_date DATE NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  balance INT NOT NULL DEFAULT 0,
  customer_id BIGINT NOT NULL REFERENCES customers(id)
);

-- Mendefinisikan tipe data ENUM untuk jenis transaksi
CREATE TYPE TRANSACTION_TYPE AS ENUM('deposit', 'withdrawal');

-- Membuat tabel untuk menampung data transaksi
CREATE TABLE transactions (
  id BIGSERIAL PRIMARY KEY,
  type TRANSACTION_TYPE NOT NULL,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  amount INT NOT NULL,
  note VARCHAR(100),
  account_id BIGINT NOT NULL REFERENCES accounts(id)
);

-- Mendefinisikan tipe data ENUM untuk status transaksi yang berjalan
CREATE TYPE TRANSACTION_STATUS AS ENUM('success', 'failed', 'pending');

-- Memodifikasi tabel transaksi untuk menambahkan kolom status transaksi
ALTER TABLE transactions
ADD COLUMN status TRANSACTION_STATUS NOT NULL DEFAULT 'pending';

-- Menambahkan data baru untuk nasabah
INSERT INTO customers
  (name, gender, address, birth_date)
VALUES
  ('Joni Syaifudin', 'male', 'Jalan Anggrek Terindah', '1991-01-01'),
  ('Adam Jaya', 'male', 'Jalan Duren Enak', '1999-09-09'),
  ('Siti Jaya', 'female', 'Istana Negara Republik Indonesia', '1980-08-08'),
  ('Alex Cahyono', 'male', '', '2002-04-04'),
  ('Laras Putri', 'female', 'Jalan Pondok Indah', '2001-10-10');

-- Menambahkan data baru untuk akun berdasarkan nasabah yang telah dibuat sebelumnya
INSERT INTO accounts
  (expired_date, balance, customer_id)
VALUES
  ('2030-03-03', 0, 2),
  ('2029-09-19', 2000000, 4),
  ('2031-01-01', 10000, 5);

-- Menambahkan data baru untuk transaksi pada akun yang telah dibuat sebelumnya
INSERT INTO transactions
  (type, amount, note, account_id)
VALUES
  ('withdrawal', 1000000, 'Cicilan bootcamp Binar Academy', 2),
  ('deposit', 5000000, 'Nabung beli rumah', 1),
  ('withdrawal', 100000, '', 3);

-- Memperbarui status transaksi withdrawal menjadi sukses
-- dan mengurangi saldo pada akun terkait
UPDATE transactions
SET status = 'success' WHERE id = 1;
UPDATE accounts
SET balance = balance - 1000000 WHERE id = 2;

-- Memperbarui status transaksi deposit menjadi sukses
-- dan menambahkan saldo pada akun terkait
UPDATE transactions
SET status = 'success' WHERE id = 2;
UPDATE accounts
SET balance = balance + 1000000 WHERE id = 1;

-- Memperbarui status transaksi withdrawal menjadi gagal
-- karena saldo tidak mencukupi untuk penarikan
UPDATE transactions
SET status = 'failed' WHERE id = 3;
