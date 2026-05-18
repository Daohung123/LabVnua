-- LabVnua realtime chat policies.
-- Use with anonymous Supabase requests or authenticated JWTs.

alter table public.users enable row level security;
alter table public.conversations enable row level security;
alter table public.messages enable row level security;

grant usage on schema public to anon;
grant select, insert, update on public.users to anon;
grant select, insert, update on public.conversations to anon;
grant select, insert on public.messages to anon;
grant usage, select on all sequences in schema public to anon;

drop policy if exists "chat_users_select_anon" on public.users;
drop policy if exists "chat_users_insert_anon" on public.users;
drop policy if exists "chat_users_update_anon" on public.users;
drop policy if exists "chat_conversations_select_anon" on public.conversations;
drop policy if exists "chat_conversations_insert_anon" on public.conversations;
drop policy if exists "chat_conversations_update_anon" on public.conversations;
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
    and full_name is not null
    and length(btrim(full_name)) > 0
  );

create policy "chat_users_update_anon"
  on public.users
  for update
  to anon
  with check (
    student_id is not null
    and length(btrim(student_id)) > 0
  );

create policy "chat_conversations_select_anon"
  on public.conversations
  for select
  to anon
  using (
    user_1 = auth.jwt() ->> 'student_id'
    or user_2 = auth.jwt() ->> 'student_id'
  );

create policy "chat_conversations_insert_anon"
  on public.conversations
  for insert
  to anon
  with check (
    user_1 is not null
    and user_2 is not null
    and user_1 <> user_2
    and last_sender_id is not null
  );

create policy "chat_conversations_update_anon"
  on public.conversations
  for update
  to anon
  with check (
    user_1 is not null
    and user_2 is not null
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
    conversation_id is not null
    and sender_student_id is not null
    and receiver_student_id is not null
    and sender_student_id <> receiver_student_id
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

  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'conversations'
  ) then
    alter publication supabase_realtime add table public.conversations;
  end if;
end $$;
