-- Starter schema for Supabase. Review and test policies before production.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  role text not null default 'student' check (role in ('student','admin')),
  created_at timestamptz not null default now()
);

create table if not exists public.questions (
  id uuid primary key default gen_random_uuid(),
  subject text not null check (subject in ('Physics','Chemistry','Mathematics')),
  chapter text not null,
  topic text,
  exam_pattern text not null,
  question_type text not null,
  prompt text not null,
  image_path text,
  options jsonb,
  correct_answer jsonb not null,
  explanation text,
  difficulty text,
  is_premium boolean not null default false,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now()
);

create table if not exists public.revision_resources (
  id uuid primary key default gen_random_uuid(),
  subject text not null,
  chapter text not null,
  topic text,
  short_notes text not null,
  mind_map text,
  image_paths jsonb not null default '[]'::jsonb,
  is_premium boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.tests (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  exam_pattern text not null,
  subject text,
  chapter text,
  duration_minutes integer not null,
  is_demo boolean not null default false,
  is_premium boolean not null default false,
  published boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.test_questions (
  test_id uuid references public.tests(id) on delete cascade,
  question_id uuid references public.questions(id) on delete cascade,
  position integer not null,
  marks numeric not null default 4,
  negative_marks numeric not null default 1,
  primary key(test_id, question_id)
);

create table if not exists public.attempts (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references auth.users(id) on delete cascade,
  test_id uuid not null references public.tests(id),
  answers jsonb not null default '{}'::jsonb,
  score numeric,
  accuracy numeric,
  started_at timestamptz not null default now(),
  submitted_at timestamptz
);

create table if not exists public.memberships (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references auth.users(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending','active','rejected','expired')),
  amount_paise integer not null default 2900,
  payment_reference text,
  receipt_path text,
  reviewed_by uuid references auth.users(id),
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.questions enable row level security;
alter table public.revision_resources enable row level security;
alter table public.tests enable row level security;
alter table public.test_questions enable row level security;
alter table public.attempts enable row level security;
alter table public.memberships enable row level security;

-- Basic student self-access. Admin policies should be added only after secure role
-- management is implemented (e.g. trusted JWT custom claims / protected RPC).
create policy "read own profile" on public.profiles for select using (auth.uid() = id);
create policy "update own profile" on public.profiles for update using (auth.uid() = id);
create policy "read published tests" on public.tests for select using (published = true);
create policy "read own attempts" on public.attempts for select using (auth.uid() = student_id);
create policy "insert own attempts" on public.attempts for insert with check (auth.uid() = student_id);
create policy "read own memberships" on public.memberships for select using (auth.uid() = student_id);
create policy "submit own membership request" on public.memberships for insert with check (auth.uid() = student_id and status = 'pending');

-- IMPORTANT: Add policies for questions/resources, admin content management,
-- membership review, and private Storage buckets after deciding your access rules.
-- Never expose the Supabase service-role key in browser code.
