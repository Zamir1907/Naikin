-- Naikin migration 004 — run once after 001, 002 and 003. No existing data deleted.
begin;
update public.naikin_products set active=true where id like 'new-%';
-- Prevent a member from self-promoting by updating their own profile role.
create or replace function public.naikin_guard_profile_role() returns trigger language plpgsql security definer set search_path='' as $$
begin
 if new.role is distinct from old.role and current_user <> 'postgres' and not public.naikin_is_admin() then
  raise exception 'Role akun tidak boleh diubah oleh pengguna';
 end if;
 return new;
end $$;
drop trigger if exists naikin_profile_role_guard on public.naikin_profiles;
create trigger naikin_profile_role_guard before update on public.naikin_profiles for each row execute function public.naikin_guard_profile_role();
create table if not exists public.naikin_notifications(
 id uuid primary key default gen_random_uuid(),user_id uuid not null references auth.users(id) on delete cascade,
 title text not null check(length(title) between 1 and 120),body text not null check(length(body) between 1 and 2000),
 kind text not null default 'info',is_read boolean not null default false,created_at timestamptz not null default now());
create index if not exists naikin_notifications_user_created on public.naikin_notifications(user_id,created_at desc);
alter table public.naikin_notifications enable row level security;
drop policy if exists naikin_notifications_read on public.naikin_notifications;
create policy naikin_notifications_read on public.naikin_notifications for select to authenticated using(user_id=auth.uid());
drop policy if exists naikin_notifications_update on public.naikin_notifications;
create policy naikin_notifications_update on public.naikin_notifications for update to authenticated using(user_id=auth.uid()) with check(user_id=auth.uid());
create or replace function public.naikin_admin_broadcast(p_title text,p_body text) returns integer
language plpgsql security definer set search_path='' as $$
declare n integer;
begin
 if not public.naikin_is_admin() then raise exception 'Tidak diizinkan'; end if;
 if length(trim(p_title)) not between 1 and 120 or length(trim(p_body)) not between 1 and 2000 then raise exception 'Isi pengumuman tidak valid'; end if;
 insert into public.naikin_notifications(user_id,title,body,kind)
 select id,trim(p_title),trim(p_body),'announcement' from public.naikin_profiles;
 get diagnostics n = row_count;
 insert into public.naikin_audit(actor_id,action,target) values(auth.uid(),'broadcast',left(p_title,120));
 return n;
end $$;
revoke all on function public.naikin_admin_broadcast(text,text) from public;
grant execute on function public.naikin_admin_broadcast(text,text) to authenticated;
create or replace function public.naikin_notify_status() returns trigger language plpgsql security definer set search_path='' as $$
begin
 if tg_op='UPDATE' and new.status is distinct from old.status then
 insert into public.naikin_notifications(user_id,title,body,kind) values
 (new.user_id,case when tg_table_name='naikin_deposits' then 'Pembaruan deposit' else 'Pembaruan pesanan' end,
 case when tg_table_name='naikin_deposits' then
 case new.status when 'user_confirmed' then 'Konfirmasi pembayaran diterima. Menunggu verifikasi.' when 'paid' then 'Deposit berhasil diverifikasi.' when 'rejected' then 'Deposit ditolak. Hubungi bantuan jika diperlukan.' else 'Status deposit diperbarui.' end
 else 'Status pesanan berubah menjadi '||new.status end,'status');
 end if;
 return new;
end $$;
drop trigger if exists naikin_deposit_notification on public.naikin_deposits;
create trigger naikin_deposit_notification after update of status on public.naikin_deposits for each row execute function public.naikin_notify_status();
drop trigger if exists naikin_order_notification on public.naikin_orders;
create trigger naikin_order_notification after update of status on public.naikin_orders for each row execute function public.naikin_notify_status();
create or replace function public.naikin_notify_ticket_reply() returns trigger language plpgsql security definer set search_path='' as $$
declare recipient uuid;
begin
 select case when new.sender_id=t.user_id then null else t.user_id end into recipient from public.naikin_tickets t where t.id=new.ticket_id;
 if recipient is not null then insert into public.naikin_notifications(user_id,title,body,kind) values(recipient,'Balasan tiket bantuan','Ada balasan baru untuk tiket bantuanmu.','ticket');end if;
 return new;
end $$;
drop trigger if exists naikin_ticket_notification on public.naikin_ticket_messages;
create trigger naikin_ticket_notification after insert on public.naikin_ticket_messages for each row execute function public.naikin_notify_ticket_reply();
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values('naikin-public','naikin-public',true,2097152,array['image/png','image/jpeg','image/webp']) on conflict(id) do nothing;
drop policy if exists naikin_public_storage_read on storage.objects;
create policy naikin_public_storage_read on storage.objects for select to anon,authenticated using(bucket_id='naikin-public');
drop policy if exists naikin_admin_storage_upload on storage.objects;
create policy naikin_admin_storage_upload on storage.objects for insert to authenticated with check(bucket_id='naikin-public' and public.naikin_is_admin());
commit;
