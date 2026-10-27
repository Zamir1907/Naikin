-- Run once after migration 004. Adds admin notification on member payment confirmation.
-- No tables or existing records are deleted.
begin;
create or replace function public.naikin_alert_admin_deposit() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
 if new.status = 'user_confirmed' and old.status is distinct from new.status then
  insert into public.naikin_notifications(user_id,title,body,kind)
  select p.id,'Konfirmasi deposit baru',
   'Pengguna mengonfirmasi pembayaran deposit ' || left(new.id::text,8) || ' sebesar Rp' || new.amount::text || '. Periksa dana masuk sebelum menyetujui.',
   'deposit_admin'
  from public.naikin_profiles p where p.role = 'admin';
 end if;
 return new;
end $$;
drop trigger if exists naikin_admin_deposit_alert on public.naikin_deposits;
create trigger naikin_admin_deposit_alert after update of status on public.naikin_deposits
for each row execute function public.naikin_alert_admin_deposit();
commit;
