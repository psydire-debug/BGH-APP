-- Run this in your Supabase project's SQL Editor (Dashboard → SQL Editor → New query)

create table if not exists bookings (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz default now(),
  services text[] not null,
  size text,
  hours int,
  rooms int,
  total int,
  name text not null,
  phone text not null,
  address text,
  preferred_date date,
  notes text,
  status text default 'new'  -- new | confirmed | done | cancelled
);

create table if not exists garage_items (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz default now(),
  name text not null,
  phone text not null,
  item text not null,
  condition text,
  notes text,
  status text default 'new'  -- new | offer_made | collected | declined
);

-- Row Level Security: allow anyone to INSERT (customers submitting the public form),
-- but only allow reads via the Supabase dashboard (using your service role / logged-in admin).
alter table bookings enable row level security;
alter table garage_items enable row level security;

create policy "Public can submit bookings"
  on bookings for insert
  to anon
  with check (true);

create policy "Public can submit garage items"
  on garage_items for insert
  to anon
  with check (true);

-- No public (anon) SELECT policy — customer submissions stay private from the
-- public site. Only a logged-in Supabase Auth user (you, the admin) can read
-- and update rows, via the in-app Admin tab or the Supabase Table Editor.

create policy "Logged-in admin can view bookings"
  on bookings for select
  to authenticated
  using (true);

create policy "Logged-in admin can update bookings"
  on bookings for update
  to authenticated
  using (true);

create policy "Logged-in admin can view garage items"
  on garage_items for select
  to authenticated
  using (true);

create policy "Logged-in admin can update garage items"
  on garage_items for update
  to authenticated
  using (true);
