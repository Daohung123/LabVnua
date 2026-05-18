-- Supabase chat migration for LabVnua.
-- Creates profile-backed chat schema using local student_data as source of truth.

create extension if not exists "pgcrypto";

create table if not exists public.users (
  student_id text primary key,
  full_name text not null,
  class_name text,
  faculty text,
  email text,
  phone text,
  avatar_url text,
  last_online timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.conversations (
  id uuid primary key default gen_random_uuid(),
  user_1 text not null,
  user_2 text not null,
  last_message text,
  last_sender_id text not null,
  updated_at timestamptz not null default now(),
  constraint conversations_users_order_check check (user_1 < user_2),
  constraint conversations_unique_pair unique (user_1, user_2),
  foreign key (user_1) references public.users(student_id) on delete cascade,
  foreign key (user_2) references public.users(student_id) on delete cascade
);

create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations(id) on delete cascade,
  sender_student_id text not null references public.users(student_id),
  receiver_student_id text not null references public.users(student_id),
  message text not null,
  message_type text not null default 'text',
  is_seen boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists idx_conversations_user_1 on public.conversations(user_1);
create index if not exists idx_conversations_user_2 on public.conversations(user_2);
create index if not exists idx_conversations_updated_at on public.conversations(updated_at desc);
create index if not exists idx_messages_conversation_id on public.messages(conversation_id);
create index if not exists idx_messages_sender_student_id on public.messages(sender_student_id);
create index if not exists idx_messages_receiver_student_id on public.messages(receiver_student_id);
create index if not exists idx_users_full_name on public.users(full_name);

create or replace function public.set_updated_at_column()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger users_set_updated_at
  before update on public.users
  for each row
  execute procedure public.set_updated_at_column();

create trigger conversations_set_updated_at
  before update on public.conversations
  for each row
  execute procedure public.set_updated_at_column();
