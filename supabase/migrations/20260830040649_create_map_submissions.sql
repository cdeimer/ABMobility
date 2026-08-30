-- Create the table for map submissions
create table map_submissions (
  id uuid primary key default gen_random_uuid(),
  geo_data jsonb not null,
  sentiment text not null,
  comment text, -- Optional user comment explaining the submission
  user_identifier text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable Row Level Security (RLS)
alter table map_submissions enable row level security;

-- Policy: Allow public read access
create policy "Allow public read access"
  on map_submissions
  for select
  to public
  using (true);

-- Policy: Allow public insert access
create policy "Allow public insert access"
  on map_submissions
  for insert
  to public
  with check (true);
