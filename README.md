# Mfano Bora Resources Portal

**What the System Is & How It Works**
The Mfano Bora Resources Portal is a central digital library designed to safely store, manage, and share important organisational documents. It uses a PostgreSQL database to organise files and track downloads. Following a recent architectural update, the system now utilizes a vanilla HTML/CSS/JS frontend that interacts securely with a lightweight PHP REST API. This removes the need for Node.js or complex React build steps, making it exceptionally easy to integrate into traditional web servers.

---

## Version Control & Branches

To accommodate this architectural shift while preserving past work, our repository is divided into two primary branches:

* **`main` Branch:** This is the active, production-ready branch containing the refactored Vanilla PHP and HTML/CSS/JS stack.
* **`React-Node.js` Branch:** This branch serves as an archive for the legacy React frontend and Express.js backend codebase.

---

## System Directory & File Routing

The repository is modularly structured with clear relative paths to ensure easy navigation on GitHub and straightforward integration:

* **`database/`**: Contains `schema.sql` and `seed.sql` to construct the database tables and inject initial sample data.


* **`config/config.example.php`**: The base template for your core application settings and database connections.


* **`api/`**: Houses the PHP REST backend, including protected administrative endpoints (e.g., `api/admin/resources.php`) for managing the portal.


* **`admin/`**: Contains the frontend interface (`index.html` and `js/admin.js`), serving as the control panel for staff to categorise and upload PDFs.



---

## Windows Setup & Configuration Guide

Windows users should bypass the `.sh` automated scripts and manually configure the environment using standard development tools.

* **Required Tools:** Install a local server environment (such as XAMPP or WAMP) to serve the PHP files, alongside a standard PostgreSQL Windows installer.
* **Database Setup:** Open pgAdmin, create a new database named `mfano_bora_db`, and manually run the scripts inside the `database/` folder to build your tables.


* **Core Configuration:** In the `config/` directory, duplicate `config.example.php` and rename the copy to `config.php`.


* **Database Credentials:** Open `config.php` and update the `'user'` and `'password'` fields to match your local PostgreSQL credentials.


* **Security & Connection:** Generate a secure password for the `'admin_api_key'` in `config.php`, and update the `API_BASE` variable inside `admin/js/admin.js` to match your local XAMPP/WAMP folder path (e.g., `/mfano-bora/api`).
