-- Smoke Room — Supabase schema
-- Paste into Supabase Dashboard → SQL Editor → Run.
-- Chat and presence use Realtime (broadcast + presence) and are NOT stored here.

create extension if not exists pgcrypto;

-- Rooms: the public themed rooms + private rooms reachable by share link.
create table if not exists public.rooms (
  id          uuid primary key default gen_random_uuid(),
  slug        text unique not null default encode(gen_random_bytes(8), 'hex'),
  name        text not null,
  theme       text not null default 'chai_stall'
              check (theme in ('rainy_terrace', 'chai_stall', 'office_fire_exit', 'hostel_rooftop')),
  is_private  boolean not null default false,
  created_at  timestamptz not null default now(),
  expires_at  timestamptz
);

-- Reports: abuse reports on chat messages. Readable only from the dashboard.
create table if not exists public.reports (
  id            bigint generated always as identity primary key,
  room_id       uuid references public.rooms(id) on delete set null,
  reported_name text not null,
  message_text  text not null check (char_length(message_text) <= 500),
  reason        text not null default 'other'
                check (reason in ('abuse', 'spam', 'underage', 'self_harm', 'other')),
  created_at    timestamptz not null default now()
);

alter table public.rooms   enable row level security;
alter table public.reports enable row level security;

-- Anyone (anon key) can read public rooms.
create policy "read public rooms" on public.rooms
  for select to anon, authenticated
  using (is_private = false);

-- Private rooms are fetched by slug through a function, so they can't be listed.
create or replace function public.room_by_slug(p_slug text)
returns setof public.rooms
language sql security definer set search_path = public as $$
  select * from public.rooms
  where slug = p_slug and (expires_at is null or expires_at > now());
$$;
grant execute on function public.room_by_slug(text) to anon, authenticated;

-- Anyone can create a private room (expires after 24 h).
create policy "create private rooms" on public.rooms
  for insert to anon, authenticated
  with check (is_private = true and expires_at <= now() + interval '24 hours');

-- Anyone can file a report; nobody but the dashboard (service role) can read them.
create policy "insert reports" on public.reports
  for insert to anon, authenticated
  with check (true);

-- Seed the first public room.
insert into public.rooms (name, theme, is_private)
select 'Chai Stall', 'chai_stall', false
where not exists (select 1 from public.rooms where is_private = false);
