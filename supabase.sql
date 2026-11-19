-- Run once in the Supabase SQL editor (project: AP/IB practice project).
-- One row per signed-in user holding all flashcard progress as JSON.
create table if not exists public.ef_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.ef_state enable row level security;

drop policy if exists "ef_state select own" on public.ef_state;
drop policy if exists "ef_state insert own" on public.ef_state;
drop policy if exists "ef_state update own" on public.ef_state;

create policy "ef_state select own" on public.ef_state for select using (auth.uid() = user_id);
create policy "ef_state insert own" on public.ef_state for insert with check (auth.uid() = user_id);
create policy "ef_state update own" on public.ef_state for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
