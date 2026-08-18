# Mfano Bora Resources Portal

## 📖 What the System Is

The Mfano Bora Resources Portal is a central digital library designed to safely store, manage, and share important organisational documents. It acts as a single hub where users can easily find and download materials such as industrial attachment forms, ICT cybersecurity guides, road safety manuals, and corporate award brochures.

## ⚙️ How It Works

The project is divided into three main components working together to deliver a seamless experience:

* **The Database (PostgreSQL):** This stores the structure of the portal, organising files logically into Categories (e.g., "Transport & Fleet Safety") and Sub-Categories (e.g., "Road Safety Guides"). It also keeps track of how many times a file has been downloaded.


* **The Backend API (Node.js):** This acts as the secure bridge between the database and the user interface. It processes searches, fetches the correct documents, and requires a secure secret key (`x-api-key`) before allowing anyone to add or delete files.


* **The Admin Dashboard (React):** A simple, user-friendly control panel for Mfano Bora staff. It allows non-technical administrators to securely upload new PDFs, categorise them, feature important documents on the home page, and manage the knowledge base without needing to write code.



---

## 🚀 Getting Started

Follow these step-by-step instructions to clone the repository, install the necessary dependencies, and run the project locally on your machine.

### 1. Clone the Repository

First, download the project files to your computer using Git. Open your terminal and run:

```bash
git clone https://github.com/Kenjin32icon/Mfano-Bora-Resources-Portal.git
cd Mfano-Bora-Resources-Portal

```

### 2. Set Up the Database

You need to have PostgreSQL installed and running on your computer.

1. Create a new database named `mfano_bora_db`.


2. Run the provided SQL scripts to build the tables and insert the initial sample data:



```bash
psql -U postgres -d mfano_bora_db -f database/schema.sql
psql -U postgres -d mfano_bora_db -f database/seed.sql

```

### 3. Configure Environment Variables

You must set up secret configuration files (called `.env` files) so the different parts of the system can talk to each other securely.

**For the Backend API:**
Create a file named `.env` inside the `backend-api/` folder and add the following:

```env
PORT=5000
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/mfano_bora_db
ADMIN_API_KEY=your_secret_admin_password

```

**For the Admin Dashboard:**
Create a file named `.env` inside the `admin-dashboard/` folder and add the following:

```env
REACT_APP_ADMIN_API_KEY=your_secret_admin_password

```

(Note: Ensure the password is exactly the same in both files so the dashboard can verify its identity with the backend.)

### 4. Install Dependencies

You need to install the required software packages for both the backend and the frontend.

**Install Backend Dependencies:**

```bash
cd backend-api
npm install

```

**Install Frontend Dependencies:**

```bash
cd ../admin-dashboard
npm install

```

### 5. Run the Project

To see the system in action, you will need to run the backend and the dashboard at the same time. It is easiest to open two separate terminal windows.

**Terminal 1: Start the Backend API**

```bash
cd backend-api
npm run dev

```

You should see a message saying "Backend Server running on port 5000".

**Terminal 2: Start the Admin Dashboard**

```bash
cd admin-dashboard
npm start

```

This will open the React Admin Panel in your web browser, allowing you to view and manage your existing resources.
