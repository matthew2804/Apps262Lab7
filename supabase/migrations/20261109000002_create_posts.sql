create table public.posts (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  content text not null check (char_length(content) <= 280),
  created_at timestamptz not null default now()
);

grant select, insert, update, delete on public.posts to authenticated;

alter table public.posts enable row level security;

create policy "posts: lectura para autenticados"
on public.posts for select to authenticated using (true);

create policy "posts: insertar los propios"
on public.posts for insert to authenticated
with check (profile_id = (select auth.uid()));

create policy "posts: modificar los propios"
on public.posts for update to authenticated
using (profile_id = (select auth.uid())) with check (profile_id = (select auth.uid()));

create policy "posts: borrar los propios"
on public.posts for delete to authenticated
using (profile_id = (select auth.uid()));
