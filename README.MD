# Mfano Bora Resources Portal

The Mfano Bora Resources Portal is a central document management and resource system designed to store, manage, and deliver 102 core organizational resources across categories like Attachment & Careers, ICT, Transport, and Corporate Awards.

---

## System Directory Structure

```text
Mfano Bora Resources_Portal/
├── admin-dashboard/          # React.js Admin Portal (Resource upload & metadata management)
│   ├── src/
│   │   ├── pages/            # Page components (KnowledgeBaseEditor / Admin Panel)
│   │   └── utils/            # RBAC and authentication helpers
│   └── package.json
├── backend-api/              # Node.js & Express REST API Server
│   ├── config/               # Database pool and environment config
│   ├── controllers/          # Resource & Category request handlers
│   ├── models/               # Query builders and data definitions
│   ├── routes/               # API Endpoints (/api/resources, /api/admin)
│   ├── server.js             # Main server entry point
│   └── package.json
├── database/                 # PostgreSQL Database Schemas & Seed Data
│   ├── schema.sql            # Table definitions (categories, sub_categories, resources)
│   └── seed.sql              # Initial category data & preliminary links
├── Docs/                     # Implementation guides, team workflows, and specs
├── .env                      # Unified environment variable store
├── docker-compose.yml        # Multi-container orchestration config
└── README.md                 # System overview and setup guide

```

---

## Installation & Setup Guide

### 1. Repository Cloning

Clone the repository and enter the project directory:

```bash
git clone https://github.com/mfano-bora/resources-portal.git
cd mfano-bora-chatbot-system

```

### 2. Environment Configuration

Create a `.env` file in the root directory and add the following configuration:

```env
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/mfano_bora_db
PORT=5000
REACT_APP_API_URL=http://localhost:5000/api

```

### 3. Database Initialization

Ensure PostgreSQL is running locally or in Docker, then initialize the relational schema and core seeds:

```bash
psql -U postgres -d mfano_bora_db -f database/schema.sql
psql -U postgres -d mfano_bora_db -f database/seed.sql

```

### 4. Dependency Installation & Local Execution

* **Backend Server (`backend-api`):**
```bash
cd backend-api
npm install
npm run dev

```


* **Admin Dashboard (`admin-dashboard`):**
```bash
cd ../admin-dashboard
npm install
npm start

```



---

## Collaborative Workflow & Team Integration Protocol

To ensure seamless integration across the 11-developer rollout plan, team members must adhere to the following task handshakes:

* **Git Branching Convention:** Feature work must be performed on isolated branches named `feature/dev-[ID]-[short-description]` (e.g., `feature/dev-5-search-bar`).
* **API Handshake (Devs 1, 2, 3 & Frontend Devs 4–6):** The JSON schema returned by `GET /api/resources` and `GET /api/categories` serves as the contract between the API Architect (Dev 2) and Frontend developers (Devs 4–6).
* **Content Upload Protocol (Devs 7–10):** Content uploaders must store PDF binaries on AWS S3 or Cloudinary and input the resulting public URLs directly into the Admin Panel (`/admin-dashboard`).
* **QA & Performance Validation (Dev 11):** Prior to merging into the `main` branch, Developer 11 must audit search functionality, link connectivity, and ensure database query times remain sub-100ms.