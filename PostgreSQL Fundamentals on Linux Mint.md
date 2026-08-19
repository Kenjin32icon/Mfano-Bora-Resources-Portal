# PostgreSQL Fundamentals on Linux Mint

As a Lead Backend Architect, mastering the PostgreSQL command-line interface (`psql`) on your Linux Mint machine is essential for managing your portal's data. Here is your universal guide to executing core database tasks directly from the terminal.

### 1. Connecting and Executing Scripts

To access the PostgreSQL terminal or run automated SQL files, open your Linux Mint terminal and use the following commands:

* **Connect to psql:** Run `sudo -i -u postgres` to switch to the admin user, followed by typing `psql` to open the interactive prompt.
* **Execute Scripts:** To automatically run external files without opening the interactive prompt, use the `-f` flag. For example, you can build your portal by running `psql -U postgres -d mfano_bora_db -f database/schema.sql` and inject initial data using `psql -U postgres -d mfano_bora_db -f database/seed.sql`.

### 2. Core Database Operations

Once inside the `psql` terminal, you can define your architecture. Remember to end all standard SQL statements with a semicolon (`;`).

* **Databases & Navigation:** Type `CREATE DATABASE mfano_bora_db;` to create your new database, and use `\c mfano_bora_db` to switch your connection to it.
* **Tables & Indexes:** Create tables to securely capture unique visitor session data, such as `user_id`, `session_token`, and `created_at`. To speed up search queries, add indexes using commands like `CREATE INDEX idx_resources_published ON resources(is_published);`.

### 3. Querying and Altering Data

Managing existing records requires basic Data Manipulation Language (DML) commands.

* **Insert & Query:** Add new records using `INSERT INTO categories (name) VALUES ('Transport');` and fetch data using `SELECT * FROM categories;`.
* **Update & Alter:** Modify existing rows with `UPDATE resources SET download_count = 1 WHERE id = 1;`. To change a table's structure later, use `ALTER TABLE users ADD COLUMN phone VARCHAR(15);`.
* **Terminal Shortcuts:** Use `\dt` to list all tables in your current database and `\q` to safely exit the terminal.

### 4. Connecting to DBeaver

DBeaver provides a highly visual interface to manage the databases you just created in the terminal.

* Open DBeaver, select **New Database Connection**, and choose **PostgreSQL** from the list.
* Set the **Host** to `localhost` and **Port** to `5432`.
* Enter your target **Database** name (e.g., `mfano_bora_db`), your **Username** (usually `postgres`), and your database password.
* Click **Test Connection** to verify your credentials, then click **Finish** to save the connection.

Have you already installed the PostgreSQL server and DBeaver on your Linux Mint system, or do you need the exact installation commands first?
