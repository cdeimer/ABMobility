# Allston-Brighton Active Streets

A grassroots advocacy platform built with Astro and Supabase.

This repository uses a dual-environment setup. We use a local Supabase instance (via Docker) for development and testing, and a remote Supabase project for production.

---

## 🛠 Local Development

To run the project locally, you will need Node.js and [Docker](https://docs.docker.com/get-docker/) installed.

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Start the local Supabase environment:**
   This will pull the necessary Docker images and apply any existing migrations.
   ```bash
   npx supabase start
   ```
   *Note: You can view your local database and manage data by navigating to the Local Studio URL: [http://127.0.0.1:54323](http://127.0.0.1:54323).*

3. **Configure Environment Variables:**
   Ensure your `.env` file at the root of the project contains the local Docker API keys (the Supabase CLI will print these out when it starts up). It should look like this:
   ```env
   PUBLIC_SUPABASE_URL=http://127.0.0.1:54321
   PUBLIC_SUPABASE_PUBLISHABLE_KEY=sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH
   ```

4. **Start the Astro development server:**
   ```bash
   npm run dev
   ```

5. **Stop the local database:**
   When you're done working, you can safely spin down the local Supabase containers:
   ```bash
   npx supabase stop
   ```

---

## 🗄 Database Migrations

Whenever you need to change the database schema (e.g., adding a new table or altering a column), you should create a migration file. **Do not make schema changes directly via the Studio UI without generating a migration.**

1. **Create a new migration:**
   ```bash
   npx supabase migration new my_descriptive_change_name
   ```
   This will create a new `.sql` file inside `supabase/migrations/`.

2. **Write your SQL:**
   Open the generated file and write the SQL required to make your changes (e.g., `CREATE TABLE ...`).

3. **Apply the migration locally:**
   To test your changes locally, restart your local database or apply them directly:
   ```bash
   npx supabase db reset
   ```
   *(Warning: `db reset` will wipe your local database data and re-apply all migrations from scratch. This is normal and expected in local development.)*

4. **Deploy migrations to Production:**
   Once you're satisfied with your schema changes locally, you can push them to the live remote database:
   ```bash
   npx supabase db push
   ```
   *(Note: You must link your CLI to your remote project first using `npx supabase link --project-ref <your-project-id>` if you haven't already).*

---

## 🚀 Production Deployment

### 1. The Frontend (Astro)
When you deploy the site to a hosting provider (like Vercel, Netlify, or Cloudflare Pages), you will need to override the environment variables so that the live site talks to your production database.

In your hosting provider's dashboard, set the following Environment Variables using your **Remote/Production** Supabase project credentials:
* `PUBLIC_SUPABASE_URL=https://<your-remote-project-id>.supabase.co`
* `PUBLIC_SUPABASE_PUBLISHABLE_KEY=<your-remote-publishable-key>`

### 2. The Database (Supabase)
As mentioned above, schema changes should be pushed to production using the Supabase CLI (`npx supabase db push`).

**Security Reminder:**
Always ensure that your production `map_submissions` table has **Row Level Security (RLS)** enabled, and that you only have policies for `SELECT` and `INSERT`. Never allow anonymous `UPDATE` or `DELETE` operations on public-facing maps.
