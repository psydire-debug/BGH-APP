# BGH Services — deployment guide

This is the deployment-ready version of your booking app: house/garage/yard cleaning +
handyman add-ons, and a garage buy-back form. It's a real backend (Supabase) + installable
web app (PWA), ready to put on the internet.

Follow these steps in order. None of it requires coding experience — it's mostly clicking
buttons and copy-pasting keys.

## 1. Create your Supabase project (the database)

1. Go to supabase.com and sign up (free tier is enough to start).
2. Click **New project**. Name it `bgh-services`, pick a strong database password (save it
   somewhere), and choose a region close to South Africa (e.g. `eu-west` or `af-south-1` if offered).
3. Once it's created, go to **SQL Editor** → **New query**, paste in the contents of
   `supabase/schema.sql` from this project, and click **Run**. This creates your two tables:
   `bookings` and `garage_items`.
4. Go to **Project Settings → API**. Copy:
   - **Project URL**
   - **anon public** key

## 2. Add your keys locally

1. In this project folder, copy `.env.example` to a new file named `.env`.
2. Paste in your Project URL and anon key from step 1.

```
VITE_SUPABASE_URL=https://xxxxxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOi...
```

## 3. Run it locally to test

```bash
npm install
npm run dev
```

Open the local address it prints (usually `http://localhost:5173`). Submit a test booking,
then check it landed in Supabase under **Table Editor → bookings**.

## 4. Deploy to the internet (Vercel)

1. Push this project to a GitHub repo (create one on github.com, then follow their
   "push an existing folder" instructions — or ask me and I'll walk you through the git commands).
2. Go to vercel.com, sign up with your GitHub account, click **Add New → Project**, and
   import the repo.
3. Vercel will detect it's a Vite app automatically. Before deploying, add your environment
   variables under **Environment Variables**:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
4. Click **Deploy**. In about a minute you'll get a live link like
   `bgh-services.vercel.app`.

## 5. Let people "download" it (PWA install)

No app store needed. Once deployed:
- On Android (Chrome): visiting the link shows an "Add to Home screen" prompt automatically,
  or the user taps the browser menu → **Install app**.
- On iPhone (Safari): the user taps the Share icon → **Add to Home Screen**.

It then behaves like a normal app icon, opens full-screen, and works offline for anything
already loaded (the booking form still needs internet to actually submit, since it saves to
your database).

## 6. Viewing and managing bookings — in the app itself

The app now has a built-in **Admin** tab (next to "Book a service" and "Sell garage items")
where you can log in and see every booking and garage item, with a dropdown to update its
status (new → confirmed → done, etc). To set it up:

1. In Supabase, go to **Authentication → Users → Add user**. Create yourself a user with
   your email and a password you'll remember. This is the *only* account that can log in —
   there's no public sign-up.
2. Re-run `supabase/schema.sql` in the **SQL Editor** (or just run the new policy lines at
   the bottom if you already ran it before) — this lets that logged-in account read and
   update bookings, while keeping everything private from the public.
3. Open your deployed app, tap **Admin**, and log in with that email/password.

You can still also use Supabase's **Table Editor** any time as a backup way to view the same
data directly.

## 7. Get notified instantly (optional, recommended once live)

Right now you have to check the Supabase table manually. To get a WhatsApp or email the
moment someone books, the standard next step is a **Supabase Database Webhook** that fires
on every new row in `bookings`, connected to a service like Twilio (WhatsApp) or Resend
(email). Ask me when you're ready and I'll set that up as a next step — it's a small addition
on top of what's already built.

## 8. Custom domain (optional)

Once you're happy with the `.vercel.app` link, you can buy a domain (e.g. from
domains.co.za or Namecheap) — something like `bghservices.co.za` — and connect it in
Vercel under **Project → Settings → Domains**. Costs roughly R150–R250/year.

## Buy-in for later: native app store listing

Once bookings are steady and you want a Play Store / App Store listing instead of "add to
home screen," the same codebase can be wrapped with **Capacitor** without a rewrite. That's
a one-time future step, not needed to launch.
