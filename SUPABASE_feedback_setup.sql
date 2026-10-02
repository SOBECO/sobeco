-- SOBECO : table des suggestions / réclamations
create table if not exists public.feedback_messages (
  id uuid primary key default gen_random_uuid(),
  type text not null default 'suggestion' check (type in ('suggestion','reclamation','autre')),
  nom text,
  contact text,
  message text not null check (char_length(message) between 3 and 2000),
  status text not null default 'nouveau' check (status in ('nouveau','lu','traite')),
  created_at timestamptz not null default now()
);

alter table public.feedback_messages enable row level security;

drop policy if exists "Public can send feedback" on public.feedback_messages;
create policy "Public can send feedback"
on public.feedback_messages
for insert
to anon, authenticated
with check (
  char_length(message) between 3 and 2000
  and type in ('suggestion','reclamation','autre')
);

drop policy if exists "Admins can read feedback" on public.feedback_messages;
create policy "Admins can read feedback"
on public.feedback_messages
for select
to authenticated
using ((select public.is_admin()));

drop policy if exists "Admins can update feedback" on public.feedback_messages;
create policy "Admins can update feedback"
on public.feedback_messages
for update
to authenticated
using ((select public.is_admin()))
with check ((select public.is_admin()));

drop policy if exists "Admins can delete feedback" on public.feedback_messages;
create policy "Admins can delete feedback"
on public.feedback_messages
for delete
to authenticated
using ((select public.is_admin()));
