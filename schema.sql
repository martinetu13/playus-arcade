-- Playus initial Supabase schema. Review and tighten policies before production.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  nickname text not null check (char_length(nickname) between 1 and 18),
  created_at timestamptz not null default now()
);
create table if not exists public.groups (
  id uuid primary key default gen_random_uuid(),
  name text not null default 'Friends',
  invite_code text not null unique,
  created_by uuid not null references public.profiles(id),
  created_at timestamptz not null default now()
);
create table if not exists public.group_members (
  group_id uuid not null references public.groups(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  joined_at timestamptz not null default now(),
  primary key (group_id, user_id)
);
create table if not exists public.scores (
  id bigint generated always as identity primary key,
  group_id uuid not null references public.groups(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  game_id smallint not null check (game_id between 0 and 12),
  score integer not null check (score >= 0),
  achieved_at timestamptz not null default now()
);
create index if not exists scores_group_game_idx on public.scores(group_id, game_id, score desc);

alter table public.profiles enable row level security;
alter table public.groups enable row level security;
alter table public.group_members enable row level security;
alter table public.scores enable row level security;

-- Starter policies: authenticated users can read group-related data.
-- Add membership checks and restrict writes to the authenticated user before production.
create policy "profiles readable by authenticated users" on public.profiles
for select to authenticated using (true);
create policy "users can create own profile" on public.profiles
for insert to authenticated with check (auth.uid() = id);
create policy "users can update own profile" on public.profiles
for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

create policy "authenticated can read groups" on public.groups
for select to authenticated using (true);
create policy "users create groups as themselves" on public.groups
for insert to authenticated with check (auth.uid() = created_by);

create policy "authenticated can read memberships" on public.group_members
for select to authenticated using (true);
create policy "users can join as themselves" on public.group_members
for insert to authenticated with check (auth.uid() = user_id);

create policy "authenticated can read scores" on public.scores
for select to authenticated using (true);
create policy "users submit own scores" on public.scores
for insert to authenticated with check (auth.uid() = user_id);
