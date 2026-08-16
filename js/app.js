/* ==================== CONFIG ==================== */
const QRIS_IMAGE_URL = "https://cdn.aceimg.com/ZhkhxG9a8.jpg";
const MERCHANT_NAME = "NAIKIN SOSMED";
const LOGIN_BONUS = 13800;
const MIN_DEPOSIT = 10000;

const STORAGE_KEYS = {
  users: "app_users",
  currentUser: "app_current_user",
  theme: "app_theme",
  orders: "app_orders",
  transactions: "app_transactions"
};

function getStorage(key, fallback){
  try{
    const raw = localStorage.getItem(key);
    return raw ? JSON.parse(raw) : (fallback !== undefined ? fallback : null);
  }catch(e){ return fallback !== undefined ? fallback : null; }
}
function setStorage(key, value){
  try{ localStorage.setItem(key, JSON.stringify(value)); return true; }
  catch(e){ return false; }
}
function removeStorage(key){
  try{ localStorage.removeItem(key); return true; } catch(e){ return false; }
}

/* ==================== CATEGORIES & PRODUCTS ==================== */
/* qtyType: "unit" = user pilih qty (followers/likes/views), "fixed" = paket fixed (premium apps) */
const CATEGORIES = [
  {id:"instagram", name:"Instagram", icon:"fa-brands fa-instagram", group:"social"},
  {id:"tiktok", name:"TikTok", icon:"fa-brands fa-tiktok", group:"social"},
  {id:"youtube", name:"YouTube", icon:"fa-brands fa-youtube", group:"social"},
  {id:"facebook", name:"Facebook", icon:"fa-brands fa-facebook", group:"social"},
  {id:"twitter", name:"X / Twitter", icon:"fa-brands fa-x-twitter", group:"social"},
  {id:"telegram", name:"Telegram", icon:"fa-brands fa-telegram", group:"social"},
  {id:"whatsapp", name:"WhatsApp", icon:"fa-brands fa-whatsapp", group:"social"},
  {id:"spotify", name:"Spotify", icon:"fa-brands fa-spotify", group:"apps"},
  {id:"capcut", name:"CapCut", icon:"fa-solid fa-scissors", group:"apps"},
  {id:"canva", name:"Canva", icon:"fa-solid fa-palette", group:"apps"},
  {id:"digitalapps", name:"Digital Apps", icon:"fa-solid fa-mobile-screen", group:"apps"}
];

const products = [
  // Instagram - harga per unit (murah + diskon)
  {id:1, category:"instagram", name:"Instagram Followers", description:"Followers aktif, tanpa password.", qtyType:"unit", unitLabel:"Followers", minQty:500, maxQty:10000000, step:100, pricePerUnit:8, oldPricePerUnit:12, popular:true, tag:"trending"},
  {id:2, category:"instagram", name:"Instagram Likes", description:"Likes postingan foto/reels.", qtyType:"unit", unitLabel:"Likes", minQty:100, maxQty:5000000, step:50, pricePerUnit:5, oldPricePerUnit:8, tag:"popular"},
  {id:3, category:"instagram", name:"Instagram Views", description:"Views reels / IGTV cepat.", qtyType:"unit", unitLabel:"Views", minQty:500, maxQty:10000000, step:100, pricePerUnit:1.5, oldPricePerUnit:3, new:true, tag:"trending"},
  {id:4, category:"instagram", name:"Instagram Comments", description:"Komentar custom natural.", qtyType:"unit", unitLabel:"Comments", minQty:10, maxQty:5000, step:5, pricePerUnit:400, oldPricePerUnit:600, tag:"popular"},
  {id:5, category:"instagram", name:"Instagram Story Views", description:"Views story biar lebih rame.", qtyType:"unit", unitLabel:"Views", minQty:100, maxQty:2000000, step:50, pricePerUnit:4, oldPricePerUnit:7, tag:"trending"},
  // TikTok
  {id:6, category:"tiktok", name:"TikTok Followers", description:"Followers TikTok aktif.", qtyType:"unit", unitLabel:"Followers", minQty:500, maxQty:5000000, step:100, pricePerUnit:7, oldPricePerUnit:11, popular:true, tag:"popular"},
  {id:7, category:"tiktok", name:"TikTok Likes", description:"Likes biar FYP lebih gampang.", qtyType:"unit", unitLabel:"Likes", minQty:100, maxQty:5000000, step:50, pricePerUnit:4, oldPricePerUnit:7, tag:"trending"},
  {id:8, category:"tiktok", name:"TikTok Views", description:"Views instan, aman algoritma.", qtyType:"unit", unitLabel:"Views", minQty:1000, maxQty:50000000, step:500, pricePerUnit:0.6, oldPricePerUnit:1.2, popular:true, tag:"trending"},
  {id:9, category:"tiktok", name:"TikTok Shares", description:"Shares biar jangkauan luas.", qtyType:"unit", unitLabel:"Shares", minQty:50, maxQty:100000, step:10, pricePerUnit:25, oldPricePerUnit:40, tag:"popular"},
  {id:10, category:"tiktok", name:"TikTok Comments", description:"Komentar custom natural.", qtyType:"unit", unitLabel:"Comments", minQty:10, maxQty:5000, step:5, pricePerUnit:450, oldPricePerUnit:700},
  // YouTube
  {id:11, category:"youtube", name:"YouTube Subscribers", description:"Subscribers aktif channel.", qtyType:"unit", unitLabel:"Subscribers", minQty:50, maxQty:500000, step:10, pricePerUnit:40, oldPricePerUnit:60, popular:true, tag:"popular"},
  {id:12, category:"youtube", name:"YouTube Views", description:"Views real, retensi bagus.", qtyType:"unit", unitLabel:"Views", minQty:500, maxQty:10000000, step:100, pricePerUnit:2.5, oldPricePerUnit:5, tag:"trending"},
  {id:13, category:"youtube", name:"YouTube Likes", description:"Likes video.", qtyType:"unit", unitLabel:"Likes", minQty:50, maxQty:500000, step:10, pricePerUnit:12, oldPricePerUnit:20},
  {id:14, category:"youtube", name:"YouTube Watch Hours", description:"Jam tayang monetisasi.", qtyType:"unit", unitLabel:"Jam", minQty:50, maxQty:10000, step:10, pricePerUnit:120, oldPricePerUnit:200, tag:"trending", limited:true},
  // Facebook
  {id:15, category:"facebook", name:"Facebook Page Likes", description:"Likes halaman.", qtyType:"unit", unitLabel:"Likes", minQty:100, maxQty:1000000, step:50, pricePerUnit:10, oldPricePerUnit:16, tag:"popular"},
  {id:16, category:"facebook", name:"Facebook Followers", description:"Followers profil/page.", qtyType:"unit", unitLabel:"Followers", minQty:100, maxQty:1000000, step:50, pricePerUnit:9, oldPricePerUnit:14},
  {id:17, category:"facebook", name:"Facebook Post Likes", description:"Likes postingan.", qtyType:"unit", unitLabel:"Likes", minQty:50, maxQty:500000, step:25, pricePerUnit:6, oldPricePerUnit:10, tag:"trending"},
  {id:18, category:"facebook", name:"Facebook Video Views", description:"Views video.", qtyType:"unit", unitLabel:"Views", minQty:500, maxQty:5000000, step:100, pricePerUnit:1.5, oldPricePerUnit:3},
  // X / Twitter
  {id:19, category:"twitter", name:"X Followers", description:"Followers aktif akun X.", qtyType:"unit", unitLabel:"Followers", minQty:100, maxQty:500000, step:50, pricePerUnit:12, oldPricePerUnit:20, tag:"trending"},
  {id:20, category:"twitter", name:"X Likes", description:"Likes post.", qtyType:"unit", unitLabel:"Likes", minQty:50, maxQty:500000, step:25, pricePerUnit:8, oldPricePerUnit:14},
  {id:21, category:"twitter", name:"X Retweets", description:"Retweet jangkauan luas.", qtyType:"unit", unitLabel:"Retweets", minQty:20, maxQty:100000, step:10, pricePerUnit:30, oldPricePerUnit:50, tag:"popular"},
  {id:22, category:"twitter", name:"X Views", description:"Views post/video.", qtyType:"unit", unitLabel:"Views", minQty:500, maxQty:10000000, step:100, pricePerUnit:0.8, oldPricePerUnit:1.5, new:true},
  // Telegram
  {id:23, category:"telegram", name:"Telegram Members", description:"Member grup/channel.", qtyType:"unit", unitLabel:"Members", minQty:100, maxQty:500000, step:50, pricePerUnit:12, oldPricePerUnit:20, tag:"trending"},
  {id:24, category:"telegram", name:"Telegram Post Views", description:"Views post channel.", qtyType:"unit", unitLabel:"Views", minQty:500, maxQty:5000000, step:100, pricePerUnit:1, oldPricePerUnit:2},
  {id:25, category:"telegram", name:"Telegram Reactions", description:"Reaction emoji post.", qtyType:"unit", unitLabel:"Reactions", minQty:50, maxQty:100000, step:25, pricePerUnit:8, oldPricePerUnit:14, new:true},
  // WhatsApp
  {id:26, category:"whatsapp", name:"WA Channel Members", description:"Member channel WhatsApp aktif.", qtyType:"unit", unitLabel:"Members", minQty:100, maxQty:500000, step:50, pricePerUnit:15, oldPricePerUnit:25, popular:true, tag:"trending"},
  {id:27, category:"whatsapp", name:"WA Channel Reactions", description:"Reaction di post channel WA.", qtyType:"unit", unitLabel:"Reactions", minQty:50, maxQty:100000, step:25, pricePerUnit:10, oldPricePerUnit:18, tag:"popular"},
  {id:28, category:"whatsapp", name:"WA Centang Biru", description:"Centang biru / verified badge WhatsApp Business.", qtyType:"fixed", duration:"1x proses", price:45000, oldPrice:75000, limited:true, tag:"trending", new:true},
  {id:29, category:"whatsapp", name:"WA Group Members", description:"Member grup WhatsApp.", qtyType:"unit", unitLabel:"Members", minQty:50, maxQty:100000, step:25, pricePerUnit:20, oldPricePerUnit:35, tag:"popular"},
  // Spotify (fixed packages, harga lebih murah)
  {id:30, category:"spotify", name:"Spotify Premium 1 Bulan", description:"Premium tanpa iklan + download.", qtyType:"fixed", duration:"1 Bulan", price:12000, oldPrice:20000, popular:true, tag:"popular"},
  {id:31, category:"spotify", name:"Spotify Premium 3 Bulan", description:"Paket hemat 3 bulan.", qtyType:"fixed", duration:"3 Bulan", price:32000, oldPrice:52000, tag:"popular"},
  {id:32, category:"spotify", name:"Spotify Premium 1 Tahun", description:"Paling hemat setahun penuh.", qtyType:"fixed", duration:"1 Tahun", price:99000, oldPrice:170000, tag:"trending"},
  {id:33, category:"spotify", name:"Spotify Plays", description:"Nambah plays track.", qtyType:"unit", unitLabel:"Plays", minQty:500, maxQty:5000000, step:100, pricePerUnit:1.2, oldPricePerUnit:2.5},
  // CapCut
  {id:34, category:"capcut", name:"CapCut Pro 1 Bulan", description:"Semua fitur Pro tanpa watermark.", qtyType:"fixed", duration:"1 Bulan", price:9000, oldPrice:15000, popular:true, tag:"popular"},
  {id:35, category:"capcut", name:"CapCut Pro 3 Bulan", description:"Hemat 3 bulan.", qtyType:"fixed", duration:"3 Bulan", price:24000, oldPrice:38000, tag:"popular"},
  {id:36, category:"capcut", name:"CapCut Pro 1 Tahun", description:"Paket setahun paling hemat.", qtyType:"fixed", duration:"1 Tahun", price:75000, oldPrice:120000, tag:"trending"},
  {id:37, category:"capcut", name:"CapCut Pro Lifetime", description:"Sekali beli, selamanya.", qtyType:"fixed", duration:"Lifetime", price:149000, oldPrice:250000, limited:true, tag:"trending"},
  // Canva
  {id:38, category:"canva", name:"Canva Pro 1 Bulan", description:"Template & elemen premium.", qtyType:"fixed", duration:"1 Bulan", price:9000, oldPrice:15000, popular:true, tag:"popular"},
  {id:39, category:"canva", name:"Canva Pro 6 Bulan", description:"Hemat 6 bulan.", qtyType:"fixed", duration:"6 Bulan", price:45000, oldPrice:75000},
  {id:40, category:"canva", name:"Canva Pro 1 Tahun", description:"Paket 1 tahun worth it.", qtyType:"fixed", duration:"1 Tahun", price:79000, oldPrice:130000, tag:"trending"},
  {id:41, category:"canva", name:"Canva Pro Lifetime", description:"Akses selamanya.", qtyType:"fixed", duration:"Lifetime", price:129000, oldPrice:220000, limited:true},
  // Digital Apps
  {id:42, category:"digitalapps", name:"Netflix Premium 1 Bulan", description:"Streaming Ultra HD.", qtyType:"fixed", duration:"1 Bulan", price:22000, oldPrice:35000, popular:true, tag:"popular"},
  {id:43, category:"digitalapps", name:"YouTube Premium 1 Bulan", description:"Tanpa iklan + YT Music.", qtyType:"fixed", duration:"1 Bulan", price:11000, oldPrice:18000, tag:"trending"},
  {id:44, category:"digitalapps", name:"Disney+ Hotstar 1 Bulan", description:"Film & series favorit.", qtyType:"fixed", duration:"1 Bulan", price:14000, oldPrice:22000, new:true},
  {id:45, category:"digitalapps", name:"ChatGPT Plus 1 Bulan", description:"Model AI premium.", qtyType:"fixed", duration:"1 Bulan", price:45000, oldPrice:65000, tag:"trending"},
  {id:46, category:"digitalapps", name:"VPN Premium 1 Bulan", description:"Browsing aman & bebas blokir.", qtyType:"fixed", duration:"1 Bulan", price:12000, oldPrice:20000},
  {id:47, category:"digitalapps", name:"Cloud Storage 100GB", description:"Simpan file tanpa khawatir.", qtyType:"fixed", duration:"1 Bulan", price:8000, oldPrice:12000, new:true},
  {id:48, category:"digitalapps", name:"Microsoft 365 1 Tahun", description:"Word, Excel, PowerPoint + cloud.", qtyType:"fixed", duration:"1 Tahun", price:89000, oldPrice:145000, tag:"popular"}
];

let state = {
  currentCategory: "all",
  currentFilter: "all",
  searchQuery: "",
  sortBy: "default",
  selectedProductId: null,
  selectedDepositAmount: 0,
  selectedPayMethod: null,
  accountTab: "orders"
};

/* ==================== HELPERS ==================== */
function formatRupiah(n){ return "Rp" + Math.round(n).toLocaleString("id-ID"); }
function formatDate(ts){
  return new Date(ts).toLocaleDateString("id-ID", { day:"numeric", month:"short", year:"numeric", hour:"2-digit", minute:"2-digit" });
}
function randomId(prefix){ return prefix + "-" + Math.random().toString(36).slice(2,8).toUpperCase(); }
function brandIcon(catId){
  const cat = CATEGORIES.find(c => c.id === catId);
  return cat ? `<i class="${cat.icon} brand-icon"></i>` : `<i data-lucide="package"></i>`;
}
function calcPrice(p, qty){
  if(p.qtyType === "fixed") return p.price;
  return Math.round(p.pricePerUnit * qty);
}
function calcOldPrice(p, qty){
  if(p.qtyType === "fixed") return p.oldPrice || p.price;
  return Math.round((p.oldPricePerUnit || p.pricePerUnit) * qty);
}
function discountPercent(p){
  if(p.qtyType === "fixed"){
    if(!p.oldPrice || p.oldPrice <= p.price) return 0;
    return Math.round((1 - p.price / p.oldPrice) * 100);
  }
  if(!p.oldPricePerUnit || p.oldPricePerUnit <= p.pricePerUnit) return 0;
  return Math.round((1 - p.pricePerUnit / p.oldPricePerUnit) * 100);
}

const catIconMap = Object.fromEntries(CATEGORIES.map(c=>[c.id, c.icon]));
const catNameMap = Object.fromEntries(CATEGORIES.map(c=>[c.id, c.name]));
const catGroupMap = Object.fromEntries(CATEGORIES.map(c=>[c.id, c.group]));

/* ==================== TOAST & MODAL ==================== */
const toastIcons = { success:"check-circle-2", error:"x-circle", warning:"alert-triangle", info:"info" };
function showToast(message, type="info", duration=3200){
  const wrap = document.getElementById("toastWrap");
  if(!wrap) return;
  const el = document.createElement("div");
  el.className = `toast ${type}`;
  el.innerHTML = `<div class="ic"><i data-lucide="${toastIcons[type]||'info'}" style="width:16px;height:16px"></i></div><p>${message}</p>`;
  wrap.appendChild(el);
  if(window.lucide) lucide.createIcons();
  setTimeout(()=>{ el.classList.add("hide"); setTimeout(()=>el.remove(), 260); }, duration);
}
function openModal(id, html){
  const overlay = document.getElementById(id);
  if(!overlay) return;
  overlay.querySelector(".modal-box").innerHTML = html;
  overlay.classList.add("open");
  document.body.style.overflow = "hidden";
  if(window.lucide) lucide.createIcons();

  // Light content protection
  document.addEventListener("contextmenu", e=>{
    if(e.target.closest("input,textarea,a,button")) return;
    e.preventDefault();
  });
  document.addEventListener("keydown", e=>{
    if((e.ctrlKey||e.metaKey) && ["u","U","s","S"].includes(e.key)) e.preventDefault();
  });
}
function closeModal(id){
  const el = document.getElementById(id);
  if(el) el.classList.remove("open");
  document.body.style.overflow = "";
}
function closeAllModals(){
  document.querySelectorAll(".modal-overlay").forEach(m=>m.classList.remove("open"));
  document.body.style.overflow = "";
}

/* ==================== THEME ==================== */
function initTheme(){
  const saved = getStorage(STORAGE_KEYS.theme, "light");
  document.documentElement.setAttribute("data-theme", saved);
  updateThemeIcon(saved);
}
function toggleTheme(){
  const current = document.documentElement.getAttribute("data-theme") || "light";
  const next = current === "light" ? "dark" : "light";
  document.documentElement.setAttribute("data-theme", next);
  setStorage(STORAGE_KEYS.theme, next);
  updateThemeIcon(next);
}
function updateThemeIcon(theme){
  const btn = document.getElementById("themeToggle");
  if(!btn) return;
  btn.innerHTML = `<i data-lucide="${theme === 'dark' ? 'sun' : 'moon'}"></i>`;
  if(window.lucide) lucide.createIcons();

  // Light content protection
  document.addEventListener("contextmenu", e=>{
    if(e.target.closest("input,textarea,a,button")) return;
    e.preventDefault();
  });
  document.addEventListener("keydown", e=>{
    if((e.ctrlKey||e.metaKey) && ["u","U","s","S"].includes(e.key)) e.preventDefault();
  });
}

/* ==================== AUTH ==================== */
function getCurrentUser(){
  const username = getStorage(STORAGE_KEYS.currentUser, null);
  if(!username) return null;
  const users = getStorage(STORAGE_KEYS.users, {});
  return users[username] || null;
}
function saveUser(user){
  const users = getStorage(STORAGE_KEYS.users, {});
  users[user.username] = user;
  setStorage(STORAGE_KEYS.users, users);
}
function registerUser(username, password){
  const users = getStorage(STORAGE_KEYS.users, {});
  if(!username || !password){ showToast("Username & password wajib diisi.", "error"); return false; }
  if(username.length < 3){ showToast("Username minimal 3 karakter.", "error"); return false; }
  if(password.length < 4){ showToast("Password minimal 4 karakter.", "error"); return false; }
  if(users[username]){ showToast("Username sudah dipakai.", "error"); return false; }
  users[username] = {
    username, password,
    balance: LOGIN_BONUS,
    hasDeposited: false,
    createdAt: Date.now()
  };
  setStorage(STORAGE_KEYS.users, users);
  setStorage(STORAGE_KEYS.currentUser, username);
  addTransaction({ id: randomId("TX"), type:"Bonus", amount: LOGIN_BONUS, date: Date.now(), status:"Completed", note:"Bonus daftar akun" });
  showToast(`Selamat datang! Bonus saldo ${formatRupiah(LOGIN_BONUS)} sudah masuk. Deposit dulu minimal Rp10.000 sebelum order pertama.`, "success", 5000);
  return true;
}
function loginUser(username, password){
  const users = getStorage(STORAGE_KEYS.users, {});
  const user = users[username];
  if(!user || user.password !== password){ showToast("Username atau password salah.", "error"); return false; }
  setStorage(STORAGE_KEYS.currentUser, username);
  showToast(`Login berhasil. Halo, ${username}!`, "success");
  return true;
}
function logoutUser(){
  removeStorage(STORAGE_KEYS.currentUser);
  showToast("Kamu berhasil logout.", "info");
  closeAllModals();
  if(typeof renderAll === "function") renderAll();
  else location.reload();
}
function updateBalance(delta){
  const user = getCurrentUser();
  if(!user) return false;
  user.balance += delta;
  saveUser(user);
  return true;
}
function markHasDeposited(){
  const user = getCurrentUser();
  if(!user) return;
  user.hasDeposited = true;
  saveUser(user);
}

/* ==================== ORDERS & TRANSACTIONS ==================== */
function getOrders(){
  const user = getCurrentUser();
  if(!user) return [];
  const all = getStorage(STORAGE_KEYS.orders, {});
  return all[user.username] || [];
}
function saveOrder(order){
  const user = getCurrentUser();
  if(!user) return;
  const all = getStorage(STORAGE_KEYS.orders, {});
  if(!all[user.username]) all[user.username] = [];
  all[user.username].unshift(order);
  setStorage(STORAGE_KEYS.orders, all);
}
function addTransaction(tx){
  const user = getCurrentUser();
  if(!user) return;
  const all = getStorage(STORAGE_KEYS.transactions, {});
  if(!all[user.username]) all[user.username] = [];
  all[user.username].unshift(tx);
  setStorage(STORAGE_KEYS.transactions, all);
}
function getTransactions(){
  const user = getCurrentUser();
  if(!user) return [];
  const all = getStorage(STORAGE_KEYS.transactions, {});
  return all[user.username] || [];
}
function getDeposits(){
  return getTransactions().filter(t => t.type === "Deposit");
}
function getPurchases(){
  return getTransactions().filter(t => t.type === "Purchase");
}


/* ==================== AUTH TRANSITION ==================== */
function showAuthTransition(message, then){
  let el = document.getElementById("authTransition");
  if(!el){
    el = document.createElement("div");
    el.id = "authTransition";
    el.className = "auth-transition";
    el.innerHTML = `<div class="ring"></div><p></p>`;
    document.body.appendChild(el);
  }
  el.querySelector("p").textContent = message || "Sedang masuk...";
  el.classList.add("show");
  setTimeout(()=>{
    if(typeof then === "function") then();
    else location.reload();
  }, 1200);
}

/* ==================== AUTH MODAL ==================== */
function openAuthModal(mode="login"){
  openModal("modalAuth", `
    <div class="modal-head">
      <h3>${mode === "login" ? "Masuk ke Akun" : "Buat Akun Baru"}</h3>
      <button class="modal-close" onclick="closeModal('modalAuth')"><i data-lucide="x" style="width:16px;height:16px"></i></button>
    </div>
    <div class="modal-body">
      ${mode === "register" ? `
      <div class="bonus-banner">
        <div class="ic"><i data-lucide="gift" style="width:18px;height:18px"></i></div>
        <div>Daftar sekarang dapat <b>bonus saldo ${formatRupiah(LOGIN_BONUS)}</b>! Happy order.</div>
      </div>` : ""}
      <div class="tabs" style="width:100%;margin-bottom:18px">
        <button class="tab-btn ${mode==='login'?'active':''}" id="authTabLogin" style="flex:1">Login</button>
        <button class="tab-btn ${mode==='register'?'active':''}" id="authTabRegister" style="flex:1">Register</button>
      </div>
      <div class="form-group">
        <label for="authUsername">Username</label>
        <input type="text" id="authUsername" placeholder="Minimal 3 karakter">
      </div>
      <div class="form-group">
        <label for="authPassword">Password</label>
        <input type="password" id="authPassword" placeholder="Minimal 4 karakter">
      </div>
      <button class="btn btn-primary btn-block" id="authSubmitBtn">${mode === "login" ? "Masuk" : "Daftar & Klaim Bonus"}</button>
    </div>
  `);
  let currentMode = mode;
  const submitBtn = document.getElementById("authSubmitBtn");
  const setMode = (m)=>{
    currentMode = m;
    document.getElementById("authTabLogin").classList.toggle("active", m==="login");
    document.getElementById("authTabRegister").classList.toggle("active", m==="register");
    submitBtn.textContent = m === "login" ? "Masuk" : "Daftar & Klaim Bonus";
    document.querySelector(".modal-head h3").textContent = m === "login" ? "Masuk ke Akun" : "Buat Akun Baru";
    const body = document.querySelector("#modalAuth .modal-body");
    const existing = body.querySelector(".bonus-banner");
    if(m === "register" && !existing){
      const banner = document.createElement("div");
      banner.className = "bonus-banner";
      banner.innerHTML = `<div class="ic"><i data-lucide="gift" style="width:18px;height:18px"></i></div><div>Daftar sekarang dapat <b>bonus saldo ${formatRupiah(LOGIN_BONUS)}</b>! Happy order.</div>`;
      body.insertBefore(banner, body.querySelector(".tabs"));
      if(window.lucide) lucide.createIcons();
    } else if(m === "login" && existing) existing.remove();
  };
  document.getElementById("authTabLogin").addEventListener("click", ()=>setMode("login"));
  document.getElementById("authTabRegister").addEventListener("click", ()=>setMode("register"));
  submitBtn.addEventListener("click", ()=>{
    const username = document.getElementById("authUsername").value.trim();
    const password = document.getElementById("authPassword").value;
    let ok = currentMode === "login" ? loginUser(username, password) : registerUser(username, password);
    if(ok){
      closeModal("modalAuth");
      const msg = currentMode === "login" ? "Login berhasil, menyiapkan dashboard..." : "Akun siap! Menyusun bonus & dashboard...";
      showAuthTransition(msg, ()=>{ if(typeof renderAll === "function"){ renderAll(); const tr=document.getElementById("authTransition"); if(tr) tr.classList.remove("show"); } else location.reload(); });
    }
  });
}

/* ==================== SIDEBAR / NAV ==================== */
function renderSidebarUser(){
  const slot = document.getElementById("sidebarUserSlot");
  const topSlot = document.getElementById("navUserSlot");
  const user = getCurrentUser();
  if(slot){
    if(user){
      slot.innerHTML = `
        <a href="account.html" class="sidebar-user">
          <div class="avatar">${user.username.charAt(0).toUpperCase()}</div>
          <div class="meta"><b>${user.username}</b><span>${formatRupiah(user.balance)}</span></div>
        </a>
        <button class="btn btn-ghost btn-sm btn-block" onclick="logoutUser()"><i data-lucide="log-out" style="width:14px;height:14px"></i> Logout</button>`;
    } else {
      slot.innerHTML = `<button class="btn btn-primary btn-block" onclick="openAuthModal('login')"><i data-lucide="log-in" style="width:15px;height:15px"></i> Masuk / Daftar</button>`;
    }
  }
  if(topSlot){
    if(user){
      topSlot.innerHTML = `<a href="account.html" class="user-chip"><div class="avatar">${user.username.charAt(0).toUpperCase()}</div><span class="balance">${formatRupiah(user.balance)}</span></a>`;
    } else {
      topSlot.innerHTML = `<button class="btn btn-primary btn-sm" onclick="openAuthModal('login')">Masuk</button>`;
    }
  }
  if(window.lucide) lucide.createIcons();

  // Light content protection
  document.addEventListener("contextmenu", e=>{
    if(e.target.closest("input,textarea,a,button")) return;
    e.preventDefault();
  });
  document.addEventListener("keydown", e=>{
    if((e.ctrlKey||e.metaKey) && ["u","U","s","S"].includes(e.key)) e.preventDefault();
  });
}

function initSidebar(){
  const toggle = document.getElementById("menuToggle");
  const sidebar = document.getElementById("sidebar");
  const overlay = document.getElementById("sidebarOverlay");
  const close = ()=>{
    if(sidebar) sidebar.classList.remove("open");
    if(overlay) overlay.classList.remove("open");
  };
  if(toggle && sidebar){
    toggle.addEventListener("click", ()=>{
      sidebar.classList.toggle("open");
      if(overlay) overlay.classList.toggle("open", sidebar.classList.contains("open"));
    });
  }
  if(overlay) overlay.addEventListener("click", close);
  document.querySelectorAll(".sidebar-nav a").forEach(a=>{
    a.addEventListener("click", ()=>{ if(window.innerWidth <= 768) close(); });
  });
}

/* ==================== PRODUCT DETAIL & CHECKOUT ==================== */
function openProductDetail(id){
  const p = products.find(x=>x.id===id);
  if(!p) return;
  const disc = discountPercent(p);
  const features = [
    "Proses otomatis setelah konfirmasi",
    "Garansi refill jika turun",
    "Support 24/7",
    "Tidak butuh password akun"
  ];
  let priceHtml = "";
  if(p.qtyType === "unit"){
    priceHtml = `<div class="summary-row total"><span>Mulai dari</span><span>${formatRupiah(calcPrice(p, p.minQty))} <small style="font-weight:600;color:var(--text-faint)">/ ${p.minQty.toLocaleString("id-ID")} ${p.unitLabel}</small></span></div>`;
  } else {
    priceHtml = `<div class="summary-row total"><span>Harga</span><span>${p.oldPrice ? `<span class="old" style="text-decoration:line-through;color:var(--text-faint);font-size:13px;margin-right:8px">${formatRupiah(p.oldPrice)}</span>` : ""}${formatRupiah(p.price)}</span></div>`;
  }
  openModal("modalDetail", `
    <div class="modal-head">
      <h3>Detail Layanan</h3>
      <button class="modal-close" onclick="closeModal('modalDetail')"><i data-lucide="x" style="width:16px;height:16px"></i></button>
    </div>
    <div class="modal-body">
      <div style="display:flex;align-items:center;gap:12px;margin-bottom:14px">
        <div class="ic" style="width:46px;height:46px;border-radius:13px;background:var(--primary-soft);color:var(--primary);display:flex;align-items:center;justify-content:center">${brandIcon(p.category)}</div>
        <div>
          <h4 style="font-size:15.5px;font-weight:800">${p.name} ${disc > 0 ? `<span class="badge badge-discount">-${disc}%</span>` : ""}</h4>
          <span style="font-size:12px;color:var(--text-faint)">${catNameMap[p.category]}${p.qtyType==="unit" ? " · Custom qty" : " · "+(p.duration||"")}</span>
        </div>
      </div>
      <p style="font-size:13px;color:var(--text-soft);margin-bottom:14px">${p.description}</p>
      <div style="margin-bottom:14px">${features.map(f=>`<div class="detail-feat"><i data-lucide="check-circle-2" class="ic" style="width:14px;height:14px"></i>${f}</div>`).join("")}</div>
      ${priceHtml}
      <button class="btn btn-primary btn-block" style="margin-top:12px" onclick="closeModal('modalDetail'); openCheckout(${p.id})"><i data-lucide="shopping-cart" style="width:16px;height:16px"></i> Order Sekarang</button>
    </div>
  `);
}

function openCheckout(id){
  const p = products.find(x=>x.id===id);
  if(!p) return;
  const user = getCurrentUser();
  state.selectedProductId = id;
  const targetLabel = catGroupMap[p.category] === "apps" ? "Email / Akun Tujuan" : "Username / Link Target";
  const targetPlaceholder = catGroupMap[p.category] === "apps" ? "contoh: kamu@email.com" : "contoh: @username atau link";

  let qtySection = "";
  if(p.qtyType === "unit"){
    const presets = [p.minQty, Math.min(p.maxQty, 1000), Math.min(p.maxQty, 5000), Math.min(p.maxQty, 10000), Math.min(p.maxQty, 50000)].filter((v,i,a)=>a.indexOf(v)===i);
    qtySection = `
      <div class="form-group">
        <label>Jumlah ${p.unitLabel} <small style="color:var(--text-faint);font-weight:600">(min ${p.minQty.toLocaleString("id-ID")} – max ${p.maxQty.toLocaleString("id-ID")})</small></label>
        <div class="qty-control">
          <button type="button" id="qtyMinus">−</button>
          <input type="number" id="qtyInput" value="${p.minQty}" min="${p.minQty}" max="${p.maxQty}" step="${p.step||1}">
          <button type="button" id="qtyPlus">+</button>
        </div>
        <div class="qty-presets">
          ${presets.map(q => `<button type="button" class="qty-preset" data-qty="${q}">${q.toLocaleString("id-ID")}</button>`).join("")}
        </div>
      </div>`;
  } else {
    qtySection = `<div class="form-group"><label>Paket</label><div style="font-weight:700;padding:10px 0">${p.duration}</div></div>`;
  }

  openModal("modalCheckout", `
    <div class="modal-head">
      <h3>Checkout</h3>
      <button class="modal-close" onclick="closeModal('modalCheckout')"><i data-lucide="x" style="width:16px;height:16px"></i></button>
    </div>
    <div class="modal-body">
      <div style="display:flex;align-items:center;gap:12px;margin-bottom:16px;padding-bottom:14px;border-bottom:1px solid var(--border)">
        <div class="ic" style="width:40px;height:40px;border-radius:11px;background:var(--primary-soft);color:var(--primary);display:flex;align-items:center;justify-content:center">${brandIcon(p.category)}</div>
        <div><b style="font-size:14px">${p.name}</b><div style="font-size:11.5px;color:var(--text-faint)">${p.qtyType==="unit"?p.unitLabel:(p.duration||"")}</div></div>
      </div>
      <div class="form-group">
        <label for="targetInput">${targetLabel}</label>
        <input type="text" id="targetInput" placeholder="${targetPlaceholder}">
      </div>
      ${qtySection}
      <div class="summary-row"><span>Harga satuan</span><span id="unitPriceDisplay">${p.qtyType==="unit"?formatRupiah(p.pricePerUnit)+" / "+p.unitLabel:formatRupiah(p.price)}</span></div>
      <div class="summary-row"><span>Jumlah</span><span id="qtyDisplay">${p.qtyType==="unit"?p.minQty.toLocaleString("id-ID"):"1"}</span></div>
      <div class="summary-row total"><span>Total</span><span id="totalDisplay">${formatRupiah(p.qtyType==="unit"?calcPrice(p,p.minQty):p.price)}</span></div>
      <button class="btn btn-primary btn-block" id="confirmOrderBtn" style="margin-top:14px"><i data-lucide="check" style="width:16px;height:16px"></i> Konfirmasi Order</button>
    </div>
  `);

  if(p.qtyType === "unit"){
    const qtyInput = document.getElementById("qtyInput");
    const clamp = (v)=>{
      v = parseInt(v) || p.minQty;
      return Math.min(p.maxQty, Math.max(p.minQty, v));
    };
    const updateTotal = ()=>{
      const qty = clamp(qtyInput.value);
      qtyInput.value = qty;
      document.getElementById("qtyDisplay").textContent = qty.toLocaleString("id-ID");
      document.getElementById("totalDisplay").textContent = formatRupiah(calcPrice(p, qty));
      document.querySelectorAll(".qty-preset").forEach(b=>b.classList.toggle("active", parseInt(b.dataset.qty)===qty));
    };
    document.getElementById("qtyMinus").addEventListener("click", ()=>{ qtyInput.value = clamp((parseInt(qtyInput.value)||p.minQty) - (p.step||1)); updateTotal(); });
    document.getElementById("qtyPlus").addEventListener("click", ()=>{ qtyInput.value = clamp((parseInt(qtyInput.value)||p.minQty) + (p.step||1)); updateTotal(); });
    qtyInput.addEventListener("input", updateTotal);
    document.querySelectorAll(".qty-preset").forEach(btn=>{
      btn.addEventListener("click", ()=>{ qtyInput.value = btn.dataset.qty; updateTotal(); });
    });
    updateTotal();
  }

  document.getElementById("confirmOrderBtn").addEventListener("click", ()=> confirmOrder(p));
}

function confirmOrder(p){
  const target = document.getElementById("targetInput").value.trim();
  if(!target){ showToast("Username / target wajib diisi.", "error"); return; }

  let qty = 1;
  if(p.qtyType === "unit"){
    qty = parseInt(document.getElementById("qtyInput").value) || p.minQty;
    qty = Math.min(p.maxQty, Math.max(p.minQty, qty));
  }
  const total = calcPrice(p, qty);

  const user = getCurrentUser();
  if(!user){
    showToast("Login dulu buat order, ya.", "warning");
    closeModal("modalCheckout");
    openAuthModal("login");
    return;
  }

  // Wajib sudah deposit minimal sekali (bukan cuma bonus)
  if(!user.hasDeposited){
    closeModal("modalCheckout");
    openModal("modalDetail", `
      <div class="modal-head">
        <h3>Deposit Diperlukan</h3>
        <button class="modal-close" onclick="closeModal('modalDetail')"><i data-lucide="x" style="width:16px;height:16px"></i></button>
      </div>
      <div class="modal-body" style="text-align:center">
        <div style="width:52px;height:52px;border-radius:50%;background:var(--yellow-soft);color:#9A6B00;display:flex;align-items:center;justify-content:center;margin:0 auto 12px"><i data-lucide="wallet" style="width:22px;height:22px"></i></div>
        <p style="font-size:14px;color:var(--text-soft);margin-bottom:6px">Bonus saldo belum bisa dipakai untuk order.</p>
        <p style="font-size:13px;color:var(--text-faint);margin-bottom:18px">Lakukan deposit minimal <b>Rp10.000</b> dulu, baru bisa order layanan.</p>
        <div style="display:flex;gap:10px">
          <button class="btn btn-ghost btn-block" onclick="closeModal('modalDetail')">Nanti</button>
          <a href="deposit.html" class="btn btn-primary btn-block">Deposit Sekarang</a>
        </div>
      </div>
    `);
    return;
  }

  if(user.balance < total){
    closeModal("modalCheckout");
    openModal("modalDetail", `
      <div class="modal-head">
        <h3>Saldo Tidak Cukup</h3>
        <button class="modal-close" onclick="closeModal('modalDetail')"><i data-lucide="x" style="width:16px;height:16px"></i></button>
      </div>
      <div class="modal-body" style="text-align:center">
        <div style="width:52px;height:52px;border-radius:50%;background:var(--red-soft);color:var(--red);display:flex;align-items:center;justify-content:center;margin:0 auto 12px"><i data-lucide="wallet" style="width:22px;height:22px"></i></div>
        <p style="font-size:14px;color:var(--text-soft);margin-bottom:6px">Saldo kamu belum cukup.</p>
        <p style="font-size:13px;color:var(--text-faint);margin-bottom:18px">Total: <b>${formatRupiah(total)}</b> · Saldo: <b>${formatRupiah(user.balance)}</b></p>
        <div style="display:flex;gap:10px">
          <button class="btn btn-ghost btn-block" onclick="closeModal('modalDetail')">Batal</button>
          <a href="deposit.html" class="btn btn-primary btn-block">Deposit</a>
        </div>
      </div>
    `);
    return;
  }

  updateBalance(-total);
  const order = {
    id: randomId("ORD"),
    productId: p.id,
    name: p.name,
    category: p.category,
    target, qty, total,
    unitLabel: p.unitLabel || p.duration || "",
    date: Date.now(),
    status: "Pending"
  };
  saveOrder(order);
  addTransaction({ id: randomId("TX"), type:"Purchase", amount: -total, date: Date.now(), status:"Completed", note: `${p.name} x${qty}` });

  closeModal("modalCheckout");
  showToast("Order berhasil! Cek status di Riwayat Order.", "success");
  if(typeof renderAll === "function") renderAll();
  else renderSidebarUser();

  setTimeout(()=> updateOrderStatus(order.id, "Processing"), 4000);
  setTimeout(()=> updateOrderStatus(order.id, "Completed"), 9000);
}

function updateOrderStatus(orderId, newStatus){
  const user = getCurrentUser();
  if(!user) return;
  const all = getStorage(STORAGE_KEYS.orders, {});
  const list = all[user.username] || [];
  const order = list.find(o=>o.id===orderId);
  if(order){
    order.status = newStatus;
    setStorage(STORAGE_KEYS.orders, all);
    if(typeof renderAccountArea === "function") renderAccountArea();
  }
}

/* ==================== COMMON INIT ==================== */
function initCommon(){
  initTheme();
  renderSidebarUser();
  initSidebar();

  const themeBtn = document.getElementById("themeToggle");
  if(themeBtn) themeBtn.addEventListener("click", toggleTheme);

  document.querySelectorAll(".modal-overlay").forEach(overlay=>{
    overlay.addEventListener("click", (e)=>{ if(e.target === overlay) closeAllModals(); });
  });
  document.addEventListener("keydown", (e)=>{ if(e.key === "Escape") closeAllModals(); });

  const topbar = document.getElementById("topbar");
  if(topbar){
    window.addEventListener("scroll", ()=>{ topbar.classList.toggle("scrolled", window.scrollY > 8); });
  }

  setTimeout(()=>{
    const loader = document.getElementById("loaderOverlay");
    if(loader){ loader.classList.add("hide"); setTimeout(()=> loader.remove(), 400); }
  }, 350);

  if(window.lucide) lucide.createIcons();

  // Light content protection
  document.addEventListener("contextmenu", e=>{
    if(e.target.closest("input,textarea,a,button")) return;
    e.preventDefault();
  });
  document.addEventListener("keydown", e=>{
    if((e.ctrlKey||e.metaKey) && ["u","U","s","S"].includes(e.key)) e.preventDefault();
  });
}
