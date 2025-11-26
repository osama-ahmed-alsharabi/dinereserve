-- Enable UUID extension if not already enabled
create extension if not exists "uuid-ossp";

-- 1. Create Advertisements Table
create table if not exists advertisements (
  id uuid default uuid_generate_v4() primary key,
  restaurant_id uuid not null, -- Assumes you have a 'restaurants' or 'profiles' table. Adjust foreign key if needed.
  image_url text not null,
  start_date timestamp with time zone not null,
  end_date timestamp with time zone not null,
  created_at timestamp with time zone default now()
);

-- Optional: Add Foreign Key if you have a restaurants table
-- alter table advertisements add constraint fk_restaurant foreign key (restaurant_id) references restaurants (id);

-- 2. Create Storage Bucket for Ads
insert into storage.buckets (id, name, public) 
values ('ads', 'ads', true)
on conflict (id) do nothing;

-- 3. Storage Policies (Security)

-- Allow authenticated users (restaurants) to upload ads
create policy "Allow authenticated uploads"
on storage.objects for insert
to authenticated
with check ( bucket_id = 'ads' );

-- Allow public to view ads (so users can see them)
create policy "Allow public viewing"
on storage.objects for select
to public
using ( bucket_id = 'ads' );

-- Allow restaurants to update/delete their own ads (Optional, for future use)
-- create policy "Allow owners to update" ...
