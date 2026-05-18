-- LabVnua realtime chat policies.
-- Run this once in Supabase Dashboard > SQL Editor.
--
-- The Flutter app currently talks to Supabase with the anon key and does not
-- authenticate with Supabase Auth, so requests arrive as the `anon` role.

create unique index if not exists users_student_id_key
on public.users (student_id);

alter table public.users enable row level security;
alter table public.messages enable row level security;

grant usage on schema public to anon;
grant select, insert on public.users to anon;
grant select, insert on public.messages to anon;
grant usage, select on all sequences in schema public to anon;

drop policy if exists "chat_users_select_anon" on public.users;
drop policy if exists "chat_users_insert_anon" on public.users;
drop policy if exists "chat_messages_select_anon" on public.messages;
drop policy if exists "chat_messages_insert_anon" on public.messages;

create policy "chat_users_select_anon"
on public.users
for select
to anon
using (true);

create policy "chat_users_insert_anon"
on public.users
for insert
to anon
with check (
  student_id is not null
  and length(btrim(student_id)) > 0
);

create policy "chat_messages_select_anon"
on public.messages
for select
to anon
using (true);

create policy "chat_messages_insert_anon"
on public.messages
for insert
to anon
with check (
  sender_id is not null
  and receiver_id is not null
  and sender_id <> receiver_id
  and message is not null
  and length(btrim(message)) > 0
);

alter table public.messages replica identity full;

do $$
begin
  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'messages'
  ) then
    alter publication supabase_realtime add table public.messages;
  end if;
end $$;
