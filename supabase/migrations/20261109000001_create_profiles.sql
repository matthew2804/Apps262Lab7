create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text not null unique,
  full_name text not null,
  created_at timestamptz not null default now()
);

grant select, insert, update, delete on public.profiles to authenticated;

alter table public.profiles enable row level security;

create policy "profiles: lectura para autenticados"
on public.profiles for select to authenticated using (true);

create policy "profiles: insertar el propio"
on public.profiles for insert to authenticated
with check (id = (select auth.uid()));

create policy "profiles: actualizar el propio"
on public.profiles for update to authenticated
using (id = (select auth.uid())) with check (id = (select auth.uid()));
