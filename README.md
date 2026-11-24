# Jarkom-Modul-5-2026-K-18

# Laporan Resmi Praktikum Modul 5 - Komunikasi Data & Jaringan Komputer 2026

## Operation Geofront

**Kelompok:** K-18
**Prefix IP Kelompok:** `192.220.0.0/16`

Topologi terdiri dari 17 router, 17 switch, 25 container (`debinet`), dan 1 NAT. Gendou adalah satu-satunya router yang terhubung ke NAT1.

![Topologi GNS3](assets/topologi.png)
<!-- TODO: tambahkan screenshot topologi GNS3 ke assets/topologi.png -->

---

## Soal 1: Markas tanpa peta (VLSM)

**Deskripsi soal:** membagi prefix IP kelompok dengan VLSM untuk 17 LAN dan 16 link antar-router, urut dari kebutuhan terbesar, menggunakan prefix terkecil yang muat. Disertakan tabel, pohon IP, dan subnet jalur Dummy-Plug ke Armisael dilingkari.

### Langkah pengerjaan
1. **Kebutuhan alamat** tiap LAN = jumlah host + 1 gateway (gateway adalah IP usable pertama sesuai glosarium). Tiap link antar-router butuh 2 alamat.
2. **Prefix** dipilih yang terkecil dengan usable `2^n - 2 >= kebutuhan`.
3. **Urutan alokasi:** prefix terkecil (subnet terbesar) lebih dulu. Jika ukuran sama, LAN didahulukan daripada link, lalu urutan tabel soal.
4. **Alokasi** dilakukan berurutan (contiguous) mulai dari `192.220.0.0`, dan tiap network selalu sejajar dengan batas blok ukurannya.

### Contoh hitungan satu subnet (Switch-Quarters, 500 host)
- Kebutuhan alamat = 500 host + 1 gateway = **501**.
- Ditambah network dan broadcast = 501 + 2 = 503.
- `2^9 = 512 >= 503`, maka host bits = 9 dan prefix = 32 - 9 = **/23**.
- Usable = 512 - 2 = 510, sisa = 510 - 501 = **9**.
- Network `192.220.0.0/23`, gateway `192.220.0.1`, broadcast `192.220.1.255`.

### Tabel subnet LAN (17 LAN)
| No | Subnet | Network/Prefix | Range host | Gateway | Broadcast | Terpakai | Sisa |
|---|---|---|---|---|---|---|---|
| 1 | Switch-Quarters (Rei) | 192.220.0.0/23 | 192.220.0.1 – 192.220.1.254 | 192.220.0.1 | 192.220.1.255 | 501 | 9 |
| 2 | Switch-Comm (Hikari) | 192.220.2.0/24 | 192.220.2.1 – 192.220.2.254 | 192.220.2.1 | 192.220.2.255 | 201 | 53 |
| 3 | Switch-Hangar (Yui) | 192.220.3.0/25 | 192.220.3.1 – 192.220.3.126 | 192.220.3.1 | 192.220.3.127 | 101 | 25 |
| 4 | Switch-Bunker (Kensuke) | 192.220.3.128/26 | 192.220.3.129 – 192.220.3.190 | 192.220.3.129 | 192.220.3.191 | 56 | 6 |
| 5 | Switch-Medic (Maya) | 192.220.3.192/27 | 192.220.3.193 – 192.220.3.222 | 192.220.3.193 | 192.220.3.223 | 27 | 3 |
| 6 | Switch-Relay (Kaworu) | 192.220.3.224/27 | 192.220.3.225 – 192.220.3.254 | 192.220.3.225 | 192.220.3.255 | 26 | 4 |
| 7 | Switch-Garden (Shinji) | 192.220.4.0/27 | 192.220.4.1 – 192.220.4.30 | 192.220.4.1 | 192.220.4.31 | 15 | 15 |
| 8 | Switch-Dock (Mari) | 192.220.4.32/28 | 192.220.4.33 – 192.220.4.46 | 192.220.4.33 | 192.220.4.47 | 13 | 1 |
| 9 | Switch-Lab (Ritsuko) ⭕ | 192.220.4.48/29 | 192.220.4.49 – 192.220.4.54 | 192.220.4.49 | 192.220.4.55 | 6 | 0 |
| 10 | Switch-Terminal (Fuyutsuki) | 192.220.4.56/29 | 192.220.4.57 – 192.220.4.62 | 192.220.4.57 | 192.220.4.63 | 4 | 2 |
| 11 | Switch-Cage (Misato) | 192.220.4.64/29 | 192.220.4.65 – 192.220.4.70 | 192.220.4.65 | 192.220.4.71 | 4 | 2 |
| 12 | Switch-Dogma (Toji) | 192.220.4.72/29 | 192.220.4.73 – 192.220.4.78 | 192.220.4.73 | 192.220.4.79 | 3 | 3 |
| 13 | Switch-Monolith (Shigeru) ⭕ | 192.220.4.80/29 | 192.220.4.81 – 192.220.4.86 | 192.220.4.81 | 192.220.4.87 | 3 | 3 |
| 14 | Switch-Radar (Makoto) | 192.220.4.88/29 | 192.220.4.89 – 192.220.4.94 | 192.220.4.89 | 192.220.4.95 | 5 | 1 |
| 15 | Switch-Archive (Asuka) | 192.220.4.96/30 | 192.220.4.97 – 192.220.4.98 | 192.220.4.97 | 192.220.4.99 | 2 | 0 |
| 16 | Switch-Intel (Kaji) | 192.220.4.100/30 | 192.220.4.101 – 192.220.4.102 | 192.220.4.101 | 192.220.4.103 | 2 | 0 |
| 17 | Switch-Cmd (Gendou) | 192.220.4.104/30 | 192.220.4.105 – 192.220.4.106 | 192.220.4.105 | 192.220.4.107 | 2 | 0 |

### Tabel link antar-router (16 link, semuanya /30)
| No | Link | Network/Prefix | Range host | Broadcast |
|---|---|---|---|---|
| 1 | Gendou-Yui | 192.220.4.108/30 | 192.220.4.109 – 192.220.4.110 | 192.220.4.111 |
| 2 | Gendou-Hikari | 192.220.4.112/30 | 192.220.4.113 – 192.220.4.114 | 192.220.4.115 |
| 3 | Gendou-Asuka ⭕ | 192.220.4.116/30 | 192.220.4.117 – 192.220.4.118 | 192.220.4.119 |
| 4 | Gendou-Kaji | 192.220.4.120/30 | 192.220.4.121 – 192.220.4.122 | 192.220.4.123 |
| 5 | Gendou-Misato | 192.220.4.124/30 | 192.220.4.125 – 192.220.4.126 | 192.220.4.127 |
| 6 | Gendou-Shigeru ⭕ | 192.220.4.128/30 | 192.220.4.129 – 192.220.4.130 | 192.220.4.131 |
| 7 | Gendou-Fuyutsuki | 192.220.4.132/30 | 192.220.4.133 – 192.220.4.134 | 192.220.4.135 |
| 8 | Yui-Mari | 192.220.4.136/30 | 192.220.4.137 – 192.220.4.138 | 192.220.4.139 |
| 9 | Yui-Rei | 192.220.4.140/30 | 192.220.4.141 – 192.220.4.142 | 192.220.4.143 |
| 10 | Yui-Shinji | 192.220.4.144/30 | 192.220.4.145 – 192.220.4.146 | 192.220.4.147 |
| 11 | Hikari-Kaworu | 192.220.4.148/30 | 192.220.4.149 – 192.220.4.150 | 192.220.4.151 |
| 12 | Asuka-Ritsuko ⭕ | 192.220.4.152/30 | 192.220.4.153 – 192.220.4.154 | 192.220.4.155 |
| 13 | Asuka-Kensuke | 192.220.4.156/30 | 192.220.4.157 – 192.220.4.158 | 192.220.4.159 |
| 14 | Shigeru-Makoto | 192.220.4.160/30 | 192.220.4.161 – 192.220.4.162 | 192.220.4.163 |
| 15 | Fuyutsuki-Maya | 192.220.4.164/30 | 192.220.4.165 – 192.220.4.166 | 192.220.4.167 |
| 16 | Fuyutsuki-Toji | 192.220.4.168/30 | 192.220.4.169 – 192.220.4.170 | 192.220.4.171 |

> Pada link, router yang lebih dekat ke Gendou memakai IP host pertama, dan router di bawahnya memakai IP host kedua. Tanda ⭕ menandai subnet pada jalur **Dummy-Plug ke Armisael**: Switch-Lab, Ritsuko-Asuka, Asuka-Gendou, Gendou-Shigeru, dan Switch-Monolith.

Spreadsheet lengkap: [`Subnetting_VLSM_K-18_Modul5.xlsx`](Subnetting_VLSM_K-18_Modul5.xlsx)

### Pohon IP
![Pohon IP](assets/pohon_ip.png)
<!-- TODO: gambar pohon IP dan lingkaran jalur Dummy-Plug ke Armisael -->

### Subnet jalur Dummy-Plug ke Armisael
Jalur: Dummy-Plug, Switch-Lab, Ritsuko, Asuka, Gendou, Shigeru, Switch-Monolith, Armisael.

| Subnet | Network |
|---|---|
| Switch-Lab | `192.220.4.48/29` |
| Link Ritsuko-Asuka | `192.220.4.152/30` |
| Link Asuka-Gendou | `192.220.4.116/30` |
| Link Gendou-Shigeru | `192.220.4.128/30` |
| Switch-Monolith | `192.220.4.80/29` |

![Subnet jalur dilingkari](assets/topologi_lingkaran.png)
<!-- TODO: topologi dengan lingkaran subnet jalur Dummy-Plug ke Armisael -->

---

## Soal 2: Geofront gelap gulita (IP interface dan IP forwarding)

**Deskripsi soal:** memasang semua node sesuai topologi, memberi IP ke tiap interface router sesuai soal 1, mengaktifkan IP forwarding di semua router, dan Gendou mendapat alamat NAT1 lewat DHCP. Bukti: `ip -br` di tiap router dan ping dua ujung tiap link.

### Langkah pengerjaan
1. Memasang semua node sesuai topologi dan mencocokkan nomor interface (`eth0` sampai `ethN`) tiap router.
2. Menyusun script per router di `scripts/<router>.sh` yang berisi:
   - penulisan `/etc/network/interfaces` (salinannya di [`routings/`](routings)),
   - pemasangan IP lewat `ip addr add` di tiap interface,
   - `sysctl -w net.ipv4.ip_forward=1` dan penyimpanannya di `/etc/sysctl.conf`.
3. **Gendou** memakai `udhcpc` bawaan GNS3 (`/gns3/bin/busybox`) dengan handler `/root/udhcpc.script`, agar IP, default route, dan DNS dari NAT1 otomatis terpasang. Handler diperlukan karena `udhcpc` GNS3 tidak membawa script default.
4. Script dijalankan di `/root` tiap router (`bash init.sh`).
5. Pembuktian dilakukan manual di tiap router: `ip -br a`, lalu `ping` ke IP kedua ujung tiap link router ke router.

### Pembagian IP per interface router
Router yang dekat ke Gendou memakai IP pertama tiap link, dan gateway LAN memakai IP usable pertama subnet. Isi lengkap ada di [`routings/`](routings).

| Router | Interface | Terhubung ke | IP |
|---|---|---|---|
| Gendou | eth0 | NAT1 | DHCP |
| Gendou | eth1 | Yui | 192.220.4.109/30 |
| Gendou | eth2 | Hikari | 192.220.4.113/30 |
| Gendou | eth3 | Asuka | 192.220.4.117/30 |
| Gendou | eth4 | Kaji | 192.220.4.121/30 |
| Gendou | eth5 | Misato | 192.220.4.125/30 |
| Gendou | eth6 | Shigeru | 192.220.4.129/30 |
| Gendou | eth7 | Fuyutsuki | 192.220.4.133/30 |
| Gendou | eth8 | Switch-Cmd | 192.220.4.105/30 |

Router lainnya mengikuti pola yang sama dan tertulis di `routings/<router>.conf`.

### Bukti
**A. Gendou mendapat IP dari NAT1 (DHCP)**
![ip -br Gendou](assets/misi_soal2_gendou_ip_br.png)

**B. `ip -br` di tiap router**
![ip -br semua router](assets/misi_soal2_ip_br.png)
<!-- TODO: screenshot ip -br tiap router (17 router) -->

**C. Ping dua ujung tiap link router ke router**
![ping link](assets/misi_soal2_ping_link.png)
<!-- TODO: screenshot ping dua ujung tiap link (16 link) -->

---

## Soal 3: Pulau-pulau yang terpisah (routing statis)

**Deskripsi soal:** menghubungkan semua subnet dengan routing statis dan jumlah rute sesedikit mungkin. Router selain Gendou cukup punya satu default route ke atas dan rute untuk subnet di bawahnya. Gendou memakai default route ke NAT1. Subnet satu cabang yang bisa digabung tepat menjadi satu CIDR harus diringkas. Bukti: Armisael bisa ping ke Lilith, Sachiel, dan Comm-Net.

### Langkah pengerjaan
1. Menyusun pohon router: Gendou, lalu Yui/Hikari/Asuka/Kaji/Misato/Shigeru/Fuyutsuki, lalu cabang di bawahnya.
2. Tiap router selain Gendou diberi satu **default route** lewat IP router induknya.
3. Untuk tiap router yang punya cabang, semua subnet di bawah satu next hop (LAN dan link di bawahnya) dikumpulkan lalu **diringkas** dengan penggabungan CIDR yang tepat (tanpa menutupi subnet yang bukan bagian cabang).
4. Gendou memakai default route yang didapat dari DHCP NAT1, ditambah rute ke tiap cabang.
5. Node uji diberi IP dan gateway sementara (permanen di soal 6): Armisael `192.220.4.83/29`, Lilith `192.220.4.74/29`, Sachiel `192.220.3.130/26`, dan Comm-Net `192.220.2.2/24`.

### Peringkasan CIDR yang terjadi
| Hasil ringkas | Asal |
|---|---|
| `192.220.4.136/29` | link Yui-Mari `.136/30` + Yui-Rei `.140/30` |
| `192.220.4.152/29` | link Asuka-Ritsuko `.152/30` + Asuka-Kensuke `.156/30` |
| `192.220.4.80/28` | Switch-Monolith `.80/29` + Switch-Radar `.88/29` |

### Tabel routing
**Gendou** (default route ke NAT1 lewat DHCP, 22 rute lain):

| Next hop | Rute |
|---|---|
| Yui `192.220.4.110` | `192.220.0.0/23`, `192.220.3.0/25`, `192.220.4.0/27`, `192.220.4.32/28`, `192.220.4.136/29`, `192.220.4.144/30` |
| Hikari `192.220.4.114` | `192.220.2.0/24`, `192.220.3.224/27`, `192.220.4.148/30` |
| Asuka `192.220.4.118` | `192.220.3.128/26`, `192.220.4.48/29`, `192.220.4.96/30`, `192.220.4.152/29` |
| Kaji `192.220.4.122` | `192.220.4.100/30` |
| Misato `192.220.4.126` | `192.220.4.64/29` |
| Shigeru `192.220.4.130` | `192.220.4.80/28`, `192.220.4.160/30` |
| Fuyutsuki `192.220.4.134` | `192.220.3.192/27`, `192.220.4.56/29`, `192.220.4.72/29`, `192.220.4.164/30`, `192.220.4.168/30` |

**Router lain:**

| Router | Default route via | Rute ke bawah |
|---|---|---|
| Yui | `192.220.4.109` | `192.220.4.32/28` via Mari `.138`, `192.220.0.0/23` via Rei `.142`, `192.220.4.0/27` via Shinji `.146` |
| Hikari | `192.220.4.113` | `192.220.3.224/27` via Kaworu `.150` |
| Asuka | `192.220.4.117` | `192.220.4.48/29` via Ritsuko `.154`, `192.220.3.128/26` via Kensuke `.158` |
| Shigeru | `192.220.4.129` | `192.220.4.88/29` via Makoto `.162` |
| Fuyutsuki | `192.220.4.133` | `192.220.3.192/27` via Maya `.166`, `192.220.4.72/29` via Toji `.170` |
| Kaji, Misato, Mari, Rei, Shinji, Kaworu, Ritsuko, Kensuke, Makoto, Maya, Toji | Router induk | tidak ada (hanya default route) |

Script routing ada di bagian `# Soal 3` tiap `scripts/<router>.sh`, dan baris `up ip route add` di `routings/<router>.conf`.

### Bukti
**A. Tabel routing (`ip route`) router**
![ip route](assets/misi_soal3_ip_route.png)
<!-- TODO: screenshot ip route Gendou dan router lain -->

**B. Armisael ping ke Lilith, Sachiel, dan Comm-Net**
![Ping Armisael](assets/misi_soal3_ping_armisael.png)
<!-- TODO: screenshot ping Armisael ke 192.220.4.74, 192.220.3.130, 192.220.2.2 -->

---

## Soal 4: Haus kabar dari dunia luar (NAT dan DNS)

**Deskripsi soal:** seluruh jaringan mendapat akses internet lewat Gendou. Konfigurasi tidak boleh perlu diubah saat IP NAT1 berganti, hanya traffic dari prefix internal yang keluar lewat NAT1 yang diterjemahkan alamatnya, dan traffic antar-LAN tetap membawa alamat asli pengirim. Node juga harus bisa me-resolve nama domain. Bukti: ping `8.8.8.8` dan `deb.debian.org` dari Armisael dan Lilith, dan counter rule NAT.

### Langkah pengerjaan
1. **NAT di Gendou** memakai `MASQUERADE`, bukan `SNAT --to-source`, karena `MASQUERADE` otomatis memakai IP interface keluar (`eth0`), sehingga tidak perlu diubah saat IP dari DHCP NAT1 berganti:
   ```bash
   iptables -t nat -A POSTROUTING -s 192.220.0.0/16 -o eth0 -j MASQUERADE
   ```
   - `-s 192.220.0.0/16` membatasi hanya prefix internal yang diterjemahkan.
   - `-o eth0` membatasi hanya traffic yang keluar lewat NAT1. Traffic antar-LAN tidak keluar lewat `eth0`, jadi tidak diterjemahkan dan tetap membawa alamat asli.
2. **DNS** di semua node memakai `nameserver 8.8.8.8` (Seele) di `/etc/resolv.conf`, agar `apt` dan `ping nama-domain` bisa jalan. Gendou memakai DNS dari DHCP NAT1 (dengan cadangan `8.8.8.8`).
3. Rule disimpan di bagian `# Soal 4` pada `scripts/gendou.sh`, dan baris DNS ditambahkan ke script router lain serta node uji. Karena ini penambahan fitur, tidak dibuat script terpisah.
4. Setelah script dijalankan, ping dari Armisael dan Lilith, lalu tampilkan counter:
   ```bash
   iptables -t nat -L POSTROUTING -n -v
   ```

### Bukti
**A. Rule NAT dan counter di Gendou**
![iptables NAT Gendou](assets/misi_soal4_iptables_gendou.png)
<!-- TODO: screenshot iptables -t nat -L POSTROUTING -n -v setelah ping -->

**B. Armisael ping 8.8.8.8 dan deb.debian.org**
![Ping Armisael](assets/misi_soal4_ping_armisael.png)

**C. Lilith ping 8.8.8.8 dan deb.debian.org**
![Ping Lilith](assets/misi_soal4_ping_lilith.png)

---

## Soal 5: Pintu depan dikunci rapat (Firewall di Gendou)

**Deskripsi soal:** mengunci sisi NAT1 di Gendou agar traffic boleh keluar namun koneksi baru dari luar tidak boleh masuk. Policy `INPUT` dan `FORWARD` diubah menjadi `DROP`, lalu diizinkan: (a) balasan koneksi yang sudah ada, (b) traffic dari jaringan internal ke internet, (c) traffic antar-LAN, (d) traffic dari jaringan internal ke Gendou sendiri, serta **Loopback** dan **DHCP dari NAT1**. Konfigurasi soal 2 sampai 5 digabung dalam satu script `gendo.sh` (di repo: `scripts/gendou.sh`). Bukti: `iptables -S` di Gendou dan ping `8.8.8.8` dari Armisael masih berhasil.

### Langkah pengerjaan
1. **Reset chain filter sementara** (`INPUT`, `FORWARD`, `OUTPUT` di-flush dengan policy `ACCEPT` sementara) agar script idempotent dan tidak menimbulkan duplikasi rule saat dijalankan ulang.
2. **Aturan chain `INPUT`** (traffic menuju Gendou sendiri):
   - `iptables -A INPUT -i lo -j ACCEPT` → mengizinkan **loopback**.
   - `iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT` → **(a)** mengizinkan balasan koneksi yang sudah ada (misal balasan DNS/`apt`/ping dari luar).
   - `iptables -A INPUT -i eth0 -p udp --sport 67 --dport 68 -j ACCEPT` → mengizinkan balasan **DHCP dari NAT1** di `eth0`.
   - `iptables -A INPUT ! -i eth0 -s 192.220.0.0/16 -j ACCEPT` → **(d)** mengizinkan traffic dari jaringan internal ke Gendou, sekaligus mencegah spoofing prefix internal dari sisi NAT1 (`! -i eth0`).
3. **Aturan chain `FORWARD`** (traffic yang melewati Gendou):
   - `iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT` → **(a)** mengizinkan balasan koneksi yang sudah ada dari internet maupun antar-LAN.
   - `iptables -A FORWARD ! -i eth0 -o eth0 -s 192.220.0.0/16 -j ACCEPT` → **(b)** mengizinkan traffic dari jaringan internal ke internet lewat NAT1 (`eth0`).
   - `iptables -A FORWARD ! -i eth0 ! -o eth0 -s 192.220.0.0/16 -d 192.220.0.0/16 -j ACCEPT` → **(c)** mengizinkan traffic antar-LAN internal.
4. **Kunci policy default:**
   ```bash
   iptables -P INPUT DROP
   iptables -P FORWARD DROP
   iptables -P OUTPUT ACCEPT
   ```
   Semua koneksi baru yang masuk dari sisi NAT1 (`eth0`) tidak cocok dengan rule mana pun sehingga otomatis di-`DROP`.
5. Karena merupakan penambahan fitur dan diminta soal berada dalam satu script bersama soal 2–4, aturan ditambahkan ke bagian `# Soal 5` pada [`scripts/gendou.sh`](scripts/gendou.sh) dan dijalankan di `/root/gendo.sh` pada node Gendou.

### Bukti
**A. Daftar rule firewall (`iptables -S`) di Gendou**
![iptables -S Gendou](assets/misi_soal5_iptables_gendou.png)
<!-- TODO: screenshot iptables -S di Gendou -->

**B. Armisael masih bisa ping `8.8.8.8`**
![Ping 8.8.8.8 Armisael](assets/misi_soal5_ping_armisael.png)
<!-- TODO: screenshot ping -c 3 8.8.8.8 dari Armisael setelah firewall aktif -->

---

## Soal 6: Alamat para pilot (IP statis permanen semua node non-router)

**Deskripsi soal:** memberi IP statis dan gateway ke semua 25 node non-router sesuai aturan glosarium (gateway adalah IP usable pertama, node pada switch diberi IP usable berikutnya sesuai urutan), lalu menyimpannya agar bertahan setelah restart. Bukti: `ip -br` dan ping ke gateway di `Unit-01`.

### Langkah pengerjaan
1. Menyusun konfigurasi `/etc/network/interfaces` permanen untuk seluruh 25 node non-router di folder [`routings/`](routings) menggunakan generator [`soal6/gen_soal6.py`](soal6/gen_soal6.py).
2. Tiap file `routings/<node>.conf` berisi konfigurasi statis `eth0` (`address`, `netmask`, `gateway`) serta `up echo nameserver 8.8.8.8 > /etc/resolv.conf` agar DNS juga otomatis terpasang saat node hidup kembali.
3. Agar konfigurasi **bertahan setelah restart** di GNS3, konfigurasi dipasang melalui **Edit config** (Network configuration) pada masing-masing node non-router di GNS3 — bukan hanya lewat perintah `ip addr` sementara di console — lalu node di-Stop dan Start ulang.
4. Menguji persistensi dengan me-restart `Unit-01`, lalu memeriksa `ip -br a` dan melakukan ping ke gateway Misato (`192.220.4.65`).

### Tabel IP statis 25 node non-router
| No | Node | Switch | Router | IP/Prefix | Netmask | Gateway | File config |
|---|---|---|---|---|---|---|---|
| 1 | Quarters | Switch-Quarters | Rei | `192.220.0.2/23` | `255.255.254.0` | `192.220.0.1` | `routings/quarters.conf` |
| 2 | Comm-Net | Switch-Comm | Hikari | `192.220.2.2/24` | `255.255.255.0` | `192.220.2.1` | `routings/comm-net.conf` |
| 3 | Hangar-Crew | Switch-Hangar | Yui | `192.220.3.2/25` | `255.255.255.128` | `192.220.3.1` | `routings/hangar-crew.conf` |
| 4 | Sachiel | Switch-Bunker | Kensuke | `192.220.3.130/26` | `255.255.255.192` | `192.220.3.129` | `routings/sachiel.conf` |
| 5 | Pen-Pen | Switch-Medic | Maya | `192.220.3.194/27` | `255.255.255.224` | `192.220.3.193` | `routings/pen-pen.conf` |
| 6 | Medic-Bay | Switch-Medic | Maya | `192.220.3.195/27` | `255.255.255.224` | `192.220.3.193` | `routings/medic-bay.conf` |
| 7 | Relay-Node | Switch-Relay | Kaworu | `192.220.3.226/27` | `255.255.255.224` | `192.220.3.225` | `routings/relay-node.conf` |
| 8 | Garden-Staff | Switch-Garden | Shinji | `192.220.4.2/27` | `255.255.255.224` | `192.220.4.1` | `routings/garden-staff.conf` |
| 9 | Dock-Crew | Switch-Dock | Mari | `192.220.4.34/28` | `255.255.255.240` | `192.220.4.33` | `routings/dock-crew.conf` |
| 10 | Entry-Plug | Switch-Lab | Ritsuko | `192.220.4.50/29` | `255.255.255.248` | `192.220.4.49` | `routings/entry-plug.conf` |
| 11 | Dummy-Plug | Switch-Lab | Ritsuko | `192.220.4.51/29` | `255.255.255.248` | `192.220.4.49` | `routings/dummy-plug.conf` |
| 12 | Magi-Casper | Switch-Terminal | Fuyutsuki | `192.220.4.58/29` | `255.255.255.248` | `192.220.4.57` | `routings/magi-casper.conf` |
| 13 | Magi-Balthasar | Switch-Terminal | Fuyutsuki | `192.220.4.59/29` | `255.255.255.248` | `192.220.4.57` | `routings/magi-balthasar.conf` |
| 14 | Magi-Melchior | Switch-Terminal | Fuyutsuki | `192.220.4.60/29` | `255.255.255.248` | `192.220.4.57` | `routings/magi-melchior.conf` |
| 15 | Unit-01 | Switch-Cage | Misato | `192.220.4.66/29` | `255.255.255.248` | `192.220.4.65` | `routings/unit-01.conf` |
| 16 | Unit-02 | Switch-Cage | Misato | `192.220.4.67/29` | `255.255.255.248` | `192.220.4.65` | `routings/unit-02.conf` |
| 17 | Unit-00 | Switch-Cage | Misato | `192.220.4.68/29` | `255.255.255.248` | `192.220.4.65` | `routings/unit-00.conf` |
| 18 | Lilith | Switch-Dogma | Toji | `192.220.4.74/29` | `255.255.255.248` | `192.220.4.73` | `routings/lilith.conf` |
| 19 | Adam | Switch-Dogma | Toji | `192.220.4.75/29` | `255.255.255.248` | `192.220.4.73` | `routings/adam.conf` |
| 20 | Zeruel | Switch-Monolith | Shigeru | `192.220.4.82/29` | `255.255.255.248` | `192.220.4.81` | `routings/zeruel.conf` |
| 21 | Armisael | Switch-Monolith | Shigeru | `192.220.4.83/29` | `255.255.255.248` | `192.220.4.81` | `routings/armisael.conf` |
| 22 | Radar-Array | Switch-Radar | Makoto | `192.220.4.90/29` | `255.255.255.248` | `192.220.4.89` | `routings/radar-array.conf` |
| 23 | Archive-Vault | Switch-Archive | Asuka | `192.220.4.98/30` | `255.255.255.252` | `192.220.4.97` | `routings/archive-vault.conf` |
| 24 | Spy | Switch-Intel | Kaji | `192.220.4.102/30` | `255.255.255.252` | `192.220.4.101` | `routings/spy.conf` |
| 25 | Tokyo3-Core | Switch-Cmd | Gendou | `192.220.4.106/30` | `255.255.255.252` | `192.220.4.105` | `routings/tokyo3-core.conf` |

### Bukti
**`ip -br` dan ping ke gateway (`192.220.4.65`) di `Unit-01` setelah restart**
![ip -br dan ping gateway Unit-01](assets/misi_soal6_unit01.png)
<!-- TODO: screenshot ip -br a dan ping -c 3 192.220.4.65 di Unit-01 setelah restart -->

---

## Soal 7: Membangunkan MAGI (Instalasi & Listener `nc`)

**Deskripsi soal:** mengaktifkan ketiga node MAGI (`Magi-Casper`, `Magi-Balthasar`, `Magi-Melchior`) di Switch-Terminal dengan memasang `iptables` dan `netcat-traditional` lewat `/root/<nama>.sh`, lalu menyalakan listener TCP sesuai glosarium. Dari `Lilith`, kirim pesan ke ketiganya (port 5000) dan ke port `5001` milik Balthasar, lalu tampilkan pesan yang diterima di tiap node.

### Daftar layanan MAGI
| Node | IP | Port TCP | Script | Log penerima |
|---|---|---|---|---|
| **Magi-Casper** | `192.220.4.58` | `5000` | [`scripts/magi-casper.sh`](scripts/magi-casper.sh) | `/root/nc_5000.log` |
| **Magi-Balthasar** | `192.220.4.59` | `5000`, `5001` | [`scripts/magi-balthasar.sh`](scripts/magi-balthasar.sh) | `/root/nc_5000.log`, `/root/nc_5001.log` |
| **Magi-Melchior** | `192.220.4.60` | `5000` | [`scripts/magi-melchior.sh`](scripts/magi-melchior.sh) | `/root/nc_5000.log` |

### Langkah pengerjaan
1. Di masing-masing node MAGI, menjalankan script `/root/<nama>.sh` (`magi-casper.sh`, `magi-balthasar.sh`, `magi-melchior.sh`) yang:
   - memasang paket `iptables` dan `netcat-traditional`,
   - menjalankan listener `nc.traditional -nlvp <port>` dalam loop background (`nohup`) agar terus siap menerima koneksi berulang,
   - mencatat informasi koneksi dan pesan masuk ke `/root/nc_<port>.log` (flag `-n` dipakai agar tidak tertunda reverse DNS lookup).
2. Dari `Lilith` (`192.220.4.74`), mengirim pesan uji ke keempat endpoint (`5000` di Casper, Balthasar, Melchior, serta `5001` di Balthasar).
3. Menampilkan isi `/root/nc_5000.log` di ketiga node dan `/root/nc_5001.log` di Balthasar sebagai bukti pesan diterima.

### Bukti
**A. Pengiriman pesan dari Lilith**
![Kirim pesan Lilith ke MAGI](assets/misi_soal7_lilith_send.png)
<!-- TODO: screenshot pengiriman nc dari Lilith ke Casper, Balthasar (5000 & 5001), dan Melchior -->

**B. Pesan diterima di Magi-Casper (port 5000)**
![Log Magi-Casper](assets/misi_soal7_casper.png)

**C. Pesan diterima di Magi-Balthasar (port 5000 dan 5001)**
![Log Magi-Balthasar](assets/misi_soal7_balthasar.png)

**D. Pesan diterima di Magi-Melchior (port 5000)**
![Log Magi-Melchior](assets/misi_soal7_melchior.png)

---

## Soal 8: Mengenali kondisi normal (Layanan Pen-Pen dan Tokyo3-Core)

**Deskripsi soal:** mengaktifkan layanan listener di `Pen-Pen` (port 80) dan `Tokyo3-Core` (port 80 dan 8080) sebagai kondisi normal sebelum dilindungi firewall. Port 80 membalas `Welcome to {hostname}`, sedangkan port 8080 di `Tokyo3-Core` membalas `syifa imutz`. Bukti: `nc` dari `Lilith` ke ketiga port tersebut, serta pembuktian bahwa port yang tidak dilayani (misalnya port `22`) langsung gagal (TCP RST) dan bukan menggantung (timeout).

### Daftar layanan
| Node | IP | Port TCP | Balasan | Script |
|---|---|---|---|---|
| **Pen-Pen** | `192.220.3.194` | `80` | `Welcome to Pen-Pen` | [`scripts/pen-pen.sh`](scripts/pen-pen.sh) |
| **Tokyo3-Core** | `192.220.4.106` | `80` | `Welcome to Tokyo3-Core` | [`scripts/tokyo3-core.sh`](scripts/tokyo3-core.sh) |
| **Tokyo3-Core** | `192.220.4.106` | `8080` | `syifa imutz` | [`scripts/tokyo3-core.sh`](scripts/tokyo3-core.sh) |

### Langkah pengerjaan
1. Menjalankan `/root/pen-pen.sh` di `Pen-Pen` dan `/root/tokyo3-core.sh` di `Tokyo3-Core` untuk memasang `iptables` dan `netcat-traditional`, lalu menyalakan listener background dengan `nc.traditional -nlvp <port> -q 0` yang langsung mengirimkan balasan dan menutup koneksi dengan bersih.
2. Dari `Lilith` (`192.220.4.74`), menguji koneksi `nc` ke ketiga port aktif (`Pen-Pen:80`, `Tokyo3-Core:80`, `Tokyo3-Core:8080`).
3. Menguji port yang tidak dilayani (`22`) dengan `time nc -w 3 <ip> 22; echo "exit=$?"` di `Lilith`. Karena belum ada aturan `DROP`, kernel target langsung membalas TCP RST sehingga koneksi gagal seketika (`exit=1`, durasi < 0.1 detik), bukan menggantung sampai timeout 3 detik.

### Bukti
**A. Uji `nc` dari Lilith ke Pen-Pen:80, Tokyo3-Core:80, Tokyo3-Core:8080, dan port 22 (langsung gagal)**
![Uji nc Lilith kondisi normal](assets/misi_soal8_lilith_nc.png)
<!-- TODO: screenshot nc dari Lilith ke 192.220.3.194:80, 192.220.4.106:80, 192.220.4.106:8080, serta time nc port 22 -->

---

# Babak 2: Sabotase dan Hantu MAGI

## Soal 9: Jalur belakang diutak-atik (Sabotase Routing di Shigeru)

**Deskripsi soal:** menjalankan script sabotase `break_routing.sh` di **Shigeru**, mendiagnosis semua penyebab kenapa `Lilith` tidak mendapat jawaban dari `Armisael` padahal `Armisael` masih bisa ping gateway-nya (`192.220.4.81`), menjelaskan penyebab gejala tersebut, memperbaiki seluruh kerusakan, lalu membuktikan `Lilith` kembali bisa ping `Armisael`.

### Hasil diagnosa di Shigeru (4 penyebab)
Setelah `break_routing.sh` dijalankan di Shigeru, pemeriksaan lewat `cat /proc/sys/net/ipv4/ip_forward`, `ip route`, `ip rule show`, dan `ip route show table 100` menemukan **4 penyebab sekaligus**:

| No | Penyebab | Hasil diagnosa | Perintah perbaikan |
|---|---|---|---|
| 1 | **IP forwarding dimatikan** | `cat /proc/sys/net/ipv4/ip_forward` bernilai `0` | `sysctl -w net.ipv4.ip_forward=1` |
| 2 | **Default route dibelokkan ke Makoto (`eth2`)** | `default via 192.220.4.162 dev eth2` (seharusnya via Gendou `192.220.4.129 dev eth0`) | `ip route replace default via 192.220.4.129 dev eth0` |
| 3 | **Rute `blackhole` ke subnet Switch-Dogma** | `blackhole 192.220.4.72/29` di tabel routing `main` | `ip route del blackhole 192.220.4.72/29` |
| 4 | **Policy-Based Routing (PBR) menjebak `eth1` ke `table 100`** | `90: from all iif eth1 lookup 100` dengan isi `table 100`: `unreachable default` | `ip rule del iif eth1 lookup 100 priority 90` dan `ip route flush table 100` |

### Penjelasan kenapa gejalanya begitu
1. **Kenapa Armisael masih bisa ping gateway-nya sendiri (`192.220.4.81`)?**
   - `ip_forward = 0` hanya memblokir paket yang diteruskan (*forwarding*) antar-interface, bukan paket yang ditujukan ke IP lokal Shigeru sendiri (`INPUT`).
   - Pada `ip rule`, aturan bawaan `0: from all lookup local` memiliki prioritas `0` (lebih tinggi dari aturan sabotase `priority 90`), sehingga paket menuju `192.220.4.81` langsung diproses oleh tabel `local` sebelum sempat masuk ke `table 100`.
2. **Kenapa Lilith (`192.220.4.74`) tidak mendapat jawaban dari Armisael (`192.220.4.83`)?**
   - Paket ICMP Echo Request dari Lilith berhenti di Shigeru karena `ip_forward = 0`.
   - Kalaupun forwarding aktif, balasan dari Armisael yang masuk lewat `eth1` langsung terkena `ip rule priority 90 (iif eth1 lookup 100)` yang mengarah ke `unreachable default` di `table 100`, sehingga gagal sebelum membaca tabel `main`.
   - Kalaupun PBR dihapus, balasan menuju `192.220.4.74` (subnet `192.220.4.72/29`) tetap dibuang diam-diam (*silent drop*) oleh rute `blackhole 192.220.4.72/29` karena `/29` menang *longest-prefix match* dibanding `default`.
   - Kalaupun `blackhole` dihapus, `default route` yang mengarah ke Makoto (`192.220.4.162`) menimbulkan *routing loop* Shigeru ↔ Makoto sampai TTL habis, karena Makoto juga memiliki default route balik ke Shigeru.

### Perbaikan
Perbaikan ditulis pada script terpisah [`scripts/shigeru_soal9_fix.sh`](scripts/shigeru_soal9_fix.sh) (tidak mengubah `scripts/shigeru.sh` karena bersifat mengganti/memulihkan konfigurasi). Keempat kerusakan dibersihkan sekaligus, lalu Shigeru diuji kembali dengan ping dari `Lilith` ke `Armisael` (`192.220.4.83`).

### Bukti
**A. Diagnosa kerusakan di Shigeru (sebelum perbaikan)**
![Diagnosa Shigeru](assets/misi_soal9_diagnosa_shigeru.png)
<!-- TODO: screenshot hasil ip_forward, ip route, ip rule, ip route show table 100 di Shigeru + ping gagal dari Lilith & ping gateway berhasil dari Armisael -->

**B. Hasil perbaikan di Shigeru dan ping Lilith ke Armisael kembali berhasil**
![Perbaikan dan ping Lilith ke Armisael](assets/misi_soal9_fix_dan_ping.png)
<!-- TODO: screenshot hasil shigeru_soal9_fix.sh di Shigeru dan ping -c 3 192.220.4.83 dari Lilith -->

---

## Soal 10: Para pilot terkunci di dalam (Sabotase NAT di Misato dan Gendou)

**Deskripsi soal:** menjalankan script sabotase `break_nat.sh` di **Misato** dan **Gendou**, mendiagnosis semua penyebab kenapa `Unit-01`, `Unit-02`, dan `Unit-00` (Switch-Cage) tidak bisa ping `8.8.8.8` padahal `Spy` (Switch-Intel) normal dan ping Cage ke `Lilith` tetap berjalan. Lalu memperbaiki kerusakan, membuktikan `Unit-01` kembali bisa ping `8.8.8.8`, dan menyebutkan di router mana alamat sumber diterjemahkan.

### Hasil diagnosa (2 penyebab di 2 router)
Pemeriksaan `iptables -t nat -S` dan `iptables -t nat -L POSTROUTING -n -v` di **Misato** dan **Gendou** menemukan **2 penyebab**:

| No | Router | Rule sabotase yang ditemukan | Dampak |
|---|---|---|---|
| 1 | **Misato** | `-A POSTROUTING -s 192.220.4.64/29 ! -d 192.220.0.0/16 -o eth0 -j SNAT --to-source 172.31.99.1` | Mengubah IP sumber paket internet dari Cage menjadi `172.31.99.1` (di luar prefix `192.220.0.0/16`), sehingga paket langsung di-`DROP` oleh chain `FORWARD` Gendou (yang hanya mengizinkan `-s 192.220.0.0/16`) dan tidak dikenali oleh rule NAT Gendou. |
| 2 | **Gendou** | `-I POSTROUTING 1 -s 192.220.4.64/29 -o eth0 -j RETURN` | Ditempatkan di baris pertama **sebelum** `MASQUERADE`. Meskipun SNAT di Misato sudah dihapus, paket dari Cage langsung keluar dari chain `POSTROUTING` tanpa melalui `MASQUERADE`, sehingga keluar ke NAT1 memakai IP internal mentah (`192.220.4.66`) dan balasannya tidak pernah kembali. |

### Penjelasan kenapa Cage terdampak, tetapi Intel dan ping Cage → Lilith tidak
1. **Kenapa Switch-Intel (`Spy`, `192.220.4.102`, subnet `192.220.4.100/30`) tidak terdampak?**
   - Jalur `Spy` melewati router **Kaji → Gendou**, tidak melewati **Misato**, sehingga tidak terkena SNAT `172.31.99.1`.
   - Di Gendou, rule sabotase `-j RETURN` hanya mencocokkan `-s 192.220.4.64/29` (Switch-Cage), bukan `192.220.4.100/30` (Switch-Intel). Jadi trafik dari `Spy` tetap masuk ke rule `MASQUERADE` di bawahnya.
2. **Kenapa ping dari Cage ke Lilith (`192.220.4.74`) tetap normal?**
   - Rule SNAT di Misato memakai syarat `! -d 192.220.0.0/16`, sehingga trafik menuju alamat internal (`192.220.4.74`) tidak diterjemahkan.
   - Di Gendou, paket menuju Lilith keluar melalui interface internal `eth7` (bukan `-o eth0`), sehingga tidak terkena rule `-j RETURN` maupun NAT.

### Di router mana alamat sumber diterjemahkan?
- **Saat sabotase:** alamat sumber trafik internet dari Cage diterjemahkan secara keliru di **Misato** (menjadi `172.31.99.1`), dan di **Gendou** justru dilewati (`RETURN`) sehingga tidak di-NAT.
- **Setelah perbaikan (kondisi benar):** alamat sumber (`192.220.4.66`, dan seluruh prefix internal `192.220.0.0/16`) **hanya diterjemahkan di Gendou** melalui rule `POSTROUTING -s 192.220.0.0/16 -o eth0 -j MASQUERADE` saat paket keluar ke `eth0` (NAT1). Misato tidak melakukan NAT sama sekali.

### Perbaikan
Perbaikan dipisah menjadi dua script (tidak mengubah `misato.sh` dan `gendou.sh`):
- [`scripts/misato_soal10_fix.sh`](scripts/misato_soal10_fix.sh): menghapus rule SNAT `172.31.99.1` di Misato.
- [`scripts/gendou_soal10_fix.sh`](scripts/gendou_soal10_fix.sh): menghapus rule `RETURN` untuk `192.220.4.64/29` di Gendou dan memastikan rule `MASQUERADE` tetap aktif.

### Bukti
**A. Diagnosa tabel NAT di Misato dan Gendou (serta gejala di Unit-01 dan Spy)**
![Diagnosa NAT Misato dan Gendou](assets/misi_soal10_diagnosa.png)
<!-- TODO: screenshot iptables -t nat -S di Misato & Gendou, ping gagal Unit-01 -> 8.8.8.8, ping sukses Unit-01 -> Lilith & Spy -> 8.8.8.8 -->

**B. Hasil perbaikan dan Unit-01 kembali bisa ping `8.8.8.8`**
![Perbaikan NAT dan ping Unit-01](assets/misi_soal10_fix_unit01.png)
<!-- TODO: screenshot misato_soal10_fix.sh, gendou_soal10_fix.sh, dan ping -c 3 8.8.8.8 dari Unit-01 -->

---

## Soal 11: Casper harus jadi hantu (Blokir Ping Masuk di Magi-Casper)

**Deskripsi soal:** memblokir semua ping (ICMP `echo-request`) dari perangkat lain menuju `Magi-Casper` (`192.220.4.58`), termasuk dari perangkat yang berada di switch yang sama (`Magi-Balthasar`), sementara `Magi-Casper` sendiri tetap boleh mem-ping siapa saja dan layanan TCP `5000` tetap hidup. Bukti: ping ke Casper dari `Balthasar` dan `Lilith` gagal, sedangkan ping dari `Casper` ke keduanya berhasil.

### Langkah pengerjaan
1. **Penempatan firewall di host `Magi-Casper` sendiri** (bukan di router Fuyutsuki), karena `Magi-Balthasar` (`192.220.4.59`) dan `Magi-Melchior` (`192.220.4.60`) berada satu switch (`Switch-Terminal`) dan satu subnet (`192.220.4.56/29`) dengan Casper. Lalu lintas antar-node satu switch dikirim langsung di Layer 2 tanpa melewati router Fuyutsuki.
2. Menambahkan aturan `iptables` pada chain `INPUT` di [`scripts/magi-casper.sh`](scripts/magi-casper.sh) (penambahan fitur keamanan di atas Soal 7):
   ```bash
   iptables -P INPUT ACCEPT
   iptables -F INPUT
   iptables -A INPUT -i lo -j ACCEPT
   iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
   iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
   ```
   - Ping **masuk** (`echo-request`, ICMP type 8) dari host lain (baik beda subnet seperti Lilith maupun satu switch seperti Balthasar) di-`DROP` diam-diam.
   - Ping **keluar** dari Casper tetap melewati `OUTPUT` (`ACCEPT`), dan balasannya (`echo-reply`, ICMP type 0) masuk lewat `ESTABLISHED,RELATED` sehingga ping dari Casper ke siapa saja tetap berhasil.
   - Layanan **TCP 5000** tidak terkena rule ICMP dan tetap diizinkan oleh policy `INPUT ACCEPT`.
3. Menjalankan ulang `/root/magi-casper.sh` di `Magi-Casper`, lalu menguji ping dua arah antara Casper ↔ Balthasar dan Casper ↔ Lilith serta memastikan TCP `5000` tetap menerima pesan.

### Bukti
**A. Rule `iptables -S INPUT` di Magi-Casper dan ping keluar Casper ke Balthasar & Lilith (berhasil)**
![Firewall dan ping keluar Casper](assets/misi_soal11_casper.png)
<!-- TODO: screenshot iptables -S INPUT + ping ke 192.220.4.59 & 192.220.4.74 di Magi-Casper -->

**B. Ping ke Casper dari Balthasar (`192.220.4.59`) dan Lilith (`192.220.4.74`) gagal, sementara TCP 5000 tetap hidup**
![Ping gagal dari Balthasar dan Lilith](assets/misi_soal11_ping_gagal.png)
<!-- TODO: screenshot ping gagal ke 192.220.4.58 dari Magi-Balthasar dan Lilith (+ tes nc TCP 5000) -->

---

## Soal 12: Teknisi yang kelewat semangat (Sabotase Hardening Firewall di Magi-Casper)

**Deskripsi soal:** menjalankan script sabotase `break_fw.sh` di **Magi-Casper**, mendiagnosis semua penyebab kenapa Casper tidak bisa `ping 8.8.8.8`, tidak bisa `apt-get update`, dan `Unit-00` tidak bisa menyambung ke TCP `5000`, sementara ping ke Casper tetap ditolak. Lalu memperbaiki firewall **tanpa membatalkan tujuan hardening** (`policy INPUT` tetap `DROP` dan lalu lintas masuk yang tidak diizinkan tetap ditolak). Bukti: `nc` dari `Unit-00` ke Casper port `5000` berhasil dan `apt-get update` di Casper berhasil.

### Hasil diagnosa di Magi-Casper (4 penyebab)
Pemeriksaan `iptables -S` di `Magi-Casper` setelah `break_fw.sh` dijalankan menampilkan:
```text
-P INPUT DROP
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p icmp -j DROP
-A OUTPUT -p udp -m udp --dport 53 -j DROP
```

Dari hasil tersebut ditemukan **4 penyebab**:

| No | Penyebab | Dampak |
|---|---|---|
| 1 | **Tidak ada rule `ESTABLISHED,RELATED` di `INPUT`** (sementara policy `INPUT = DROP`) | Balasan koneksi yang dimulai oleh Casper (balasan HTTP/HTTPS `apt-get update`, balasan DNS, dan `echo-reply` ping `8.8.8.8`) langsung di-`DROP` di `INPUT`. |
| 2 | **Rule `-A INPUT -p icmp -j DROP` memblokir seluruh ICMP**, bukan hanya `echo-request` | Paket `echo-reply` (ICMP type 0) saat Casper mem-ping `8.8.8.8` atau host lain ikut di-`DROP`. |
| 3 | **Rule `-A OUTPUT -p udp --dport 53 -j DROP`** di `OUTPUT` | Query DNS keluar dari Casper diblokir sehingga `apt-get update` gagal me-resolve domain repository (`deb.debian.org`). |
| 4 | **Tidak ada rule yang mengizinkan TCP `5000` di `INPUT`** | Koneksi masuk baru dari `Unit-00` (dan node lain) ke layanan MAGI Casper port `5000` langsung ditolak oleh policy `INPUT DROP`. |

### Penjelasan kenapa gejalanya begitu
- **Kenapa ping ke Casper tetap ditolak?** Karena `-A INPUT -p icmp -j DROP` dan policy `INPUT DROP` sama-sama menolak paket `echo-request` masuk.
- **Kenapa Casper gagal `ping 8.8.8.8`?** Paket `echo-request` berhasil keluar (`OUTPUT ACCEPT`), tetapi `echo-reply` yang kembali ke Casper diblokir oleh `-A INPUT -p icmp -j DROP` dan ketiadaan rule `ESTABLISHED,RELATED`.
- **Kenapa `apt-get update` gagal?** Terhalang dua lapis: query DNS UDP port 53 diblokir di `OUTPUT`, dan seandainya DNS lewat pun, balasan TCP dari server repository diblokir di `INPUT` karena tidak ada `ESTABLISHED,RELATED`.
- **Kenapa `Unit-00` gagal `nc` ke TCP 5000?** Tidak ada rule `ACCEPT` untuk `--dport 5000` sehingga paket SYN terkena policy `INPUT DROP`.

### Perbaikan (tetap mempertahankan hardening)
Perbaikan ditulis di script terpisah [`scripts/magi-casper_soal12_fix.sh`](scripts/magi-casper_soal12_fix.sh) (tidak menimpa `magi-casper.sh`):
- Menghapus rule sabotase `-A OUTPUT -p udp --dport 53 -j DROP` dan `-A INPUT -p icmp -j DROP`.
- Mempertahankan policy **`INPUT DROP`** dan hanya mengizinkan 3 hal di `INPUT`:
  1. `-A INPUT -i lo -j ACCEPT` (loopback),
  2. `-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT` (balasan ping keluar, DNS, dan `apt-get update`),
  3. `-A INPUT -p tcp --dport 5000 -j ACCEPT` (layanan TCP 5000).
- Karena policy `INPUT` tetap `DROP`, semua lalu lintas masuk yang tidak diizinkan (termasuk ping `echo-request` dari luar dan port selain 5000) tetap ditolak (Soal 11 dan hardening tetap terjaga).

### Bukti
**A. Diagnosa `iptables -S` dan gejala gagal sebelum perbaikan**
![Diagnosa firewall Casper](assets/misi_soal12_diagnosa.png)
<!-- TODO: screenshot iptables -S, ping 8.8.8.8 gagal, apt-get update gagal di Casper, dan nc gagal dari Unit-00 -->

**B. Hasil perbaikan (`iptables -S` dengan `-P INPUT DROP`), `apt-get update` + `ping 8.8.8.8` berhasil di Casper, dan `nc` port 5000 dari Unit-00 berhasil**
![Perbaikan Casper dan uji Unit-00](assets/misi_soal12_fix.png)
<!-- TODO: screenshot magi-casper_soal12_fix.sh, apt-get update & ping 8.8.8.8 di Casper, serta nc port 5000 dari Unit-00 + log Casper -->

---

## Struktur repo
| Path | Isi |
|---|---|
| `assets/` | Screenshot dan gambar laporan |
| `scripts/` | Script konfigurasi tiap router dan node uji, dijalankan di `/root` |
| `routings/` | Isi `/etc/network/interfaces` permanen (Edit config GNS3) untuk 17 router dan 25 node non-router |
| `soal1/` | Perhitungan VLSM (`vlsm.py`) dan tabelnya |
| `soal2/` | Generator script router & node uji (`gen_soal2.py`) |
| `soal6/` | Generator config statis 25 node non-router (`gen_soal6.py`) dan tabel IP host |
