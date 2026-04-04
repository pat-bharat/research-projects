
-- Supabase SQL schema for digital_guru
create schema if not exists digital_guru;
set search_path to digital_guru;

-- User table
create table if not exists user (
    id uuid primary key default gen_random_uuid(),
    business_id text,
    login_id text,
    user_type integer,
    full_name text,
    address text,
    city text,
    zip_code text,
    state text,
    country text,
    birth_date date,
    email text,
    mobile_phone text,
    locked boolean,
    deleted boolean,
    created_timestamp timestamptz,
    updated_timestamp timestamptz,
    deleted_timestamp timestamptz,
    modified_by text,
    last_login_timestamp timestamptz
);

-- Preferences table (1:1 with user)
create table if not exists preferences (
    id uuid primary key default gen_random_uuid(),
    user_id uuid unique references user(id) on delete cascade,
    download_lessons boolean,
    wifi_download_only boolean
);

-- UserModule table
create table if not exists user_module (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references user(id) on delete cascade,
    module_id uuid references module(id) on delete cascade,
    purchase_date timestamptz,
    completion_date timestamptz,
    certify_by_instructor integer
);

-- Module table
create table if not exists module (
    id uuid primary key default gen_random_uuid(),
    course_id uuid references course(id),
    title text,
    description text,
    discount_percentage text,
    locked boolean,
    deleted boolean,
    display_order integer,
    created_timestamp timestamptz,
    updated_timestamp timestamptz,
    deleted_timestamp timestamptz,
    modified_by text,
    lesson_count text
);

-- Tags table (many-to-one with module)
create table if not exists tags (
    id uuid primary key default gen_random_uuid(),
    module_id uuid references module(id) on delete cascade,
    name text
);

-- PricePlan table (many-to-one with module)
create table if not exists price_plan (
    id uuid primary key default gen_random_uuid(),
    module_id uuid references module(id) on delete cascade,
    -- add price plan fields as needed
);

-- ModuleMedia table (many-to-one with module)
create table if not exists module_media (
    id uuid primary key default gen_random_uuid(),
    module_id uuid references module(id) on delete cascade,
    -- add media fields as needed
);

-- Lesson table
create table if not exists lesson (
    id uuid primary key default gen_random_uuid(),
    module_id uuid references module(id) on delete cascade,
    title text,
    description text,
    instructor_notes text,
    locked boolean,
    deleted boolean,
    created_timestamp timestamptz,
    updated_timestamp timestamptz,
    deleted_timestamp timestamptz,
    modified_by text
);

-- LessonMedia table (many-to-one with lesson)
create table if not exists lesson_media (
    id uuid primary key default gen_random_uuid(),
    lesson_id uuid references lesson(id) on delete cascade,
    title text,
    media_type text,
    media_path text,
    media_size text,
    media_length text,
    created_timestamp timestamptz,
    updated_timestamp timestamptz,
    deleted_timestamp timestamptz,
    modify_by text
);

-- UserMedia table (many-to-one with user, module)
create table if not exists user_media (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references user(id) on delete cascade,
    module_id uuid references module(id) on delete cascade,
    title text,
    description text,
    media_type text,
    media_path text,
    nedia_url text,
    media_size text,
    media_length text,
    created_timestamp timestamptz,
    updated_timestamp timestamptz,
    deleted_timestamp timestamptz,
    modify_by text
);

-- UserDevices table (one-to-many with user)
create table if not exists user_device (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references user(id) on delete cascade,
    device_type text,
    app_version text,
    os_version text,
    created_timestamp timestamptz,
    updated_timestamp timestamptz,
    deleted_timestamp timestamptz,
    modified_by text
);

-- Legal table
create table if not exists legal (
    id uuid primary key default gen_random_uuid(),
    business_id text,
    title text,
    description text,
    active text,
    created_timestamp timestamptz,
    updated_timestamp timestamptz,
    deleted_timestamp timestamptz,
    modified_by text
);

-- Invoice table
create table if not exists invoice (
    id uuid primary key default gen_random_uuid(),
    business_id text,
    invoice_date date,
    invoice_amount text,
    currancy_code text,
    start_date date,
    end_date date,
    due_date date,
    paid_date date,
    paid_by text,
    paid_via text,
    created_timestamp timestamptz,
    updated_timestamp timestamptz,
    deleted_timestamp timestamptz,
    modify_by text
);

-- BillingItems table (many-to-one with invoice)
create table if not exists billing_items (
    id uuid primary key default gen_random_uuid(),
    invoice_id uuid references invoice(id) on delete cascade,
    item_type text,
    description text,
    quantity text,
    rate text,
    amount text,
    created_timestamp timestamptz,
    updated_timestamp timestamptz,
    deleted_timestamp timestamptz,
    modify_by text
);

-- Instructor table
create table if not exists instructor (
    id uuid primary key default gen_random_uuid(),
    full_name text,
    introduction text,
    profile_pic text,
    url_data url,
    created_timestamp timestamptz,
    updated_timestamp timestamptz,
    deleted_timestamp timestamptz
);

-- Course table
create table if not exists course (
    id uuid primary key default gen_random_uuid(),
    business_id text,
    title text,
    description text,
    instructor_id uuid references instructor(id),
    background_image text,
    deleted boolean,
    display_order integer,
    created_timestamp timestamptz,
    updated_timestamp timestamptz,
    deleted_timestamp timestamptz,
    modified_by text
);

-- CourseModule table (many-to-one with course)
create table if not exists course_module (
    id uuid primary key default gen_random_uuid(),
    course_id uuid references course(id) on delete cascade,
    module_id uuid references module(id),
    module_name text,
    lesson_count text
);

-- Business table
create table if not exists business (
    id uuid primary key default gen_random_uuid(),
    name text,
    punch_line text,
    description text,
    splash_screen text,
    logo_link text,
    banner_link text,
    url_data url,
    contact_email text,
    address text,
    city text,
    zip_code text,
    state text,
    country text,
    email_id text,
    mobile_phone text,
    locked boolean,
    deleted boolean,
    created_timestamp timestamptz,
    updated_timestamp timestamptz,
    deleted_timestamp timestamptz,
    modified_by text
);

-- BusinessLegal table (many-to-one with business)
create table if not exists business_legal (
    id uuid primary key default gen_random_uuid(),
    business_id uuid references business(id) on delete cascade,
    -- add legal fields as needed
);

-- Add indexes, constraints, and RLS policies as needed.
