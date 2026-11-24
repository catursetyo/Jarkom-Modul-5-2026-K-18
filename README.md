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
5. Pembuktian memakai [`scripts/soal2_cek.sh`](scripts/soal2_cek.sh), yang menampilkan `ip -br a` lalu ping dua ujung tiap link milik router itu.

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
<!-- TODO: screenshot hasil soal2_cek.sh tiap router (16 link) -->

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

## Struktur repo
| Path | Isi |
|---|---|
| `assets/` | Screenshot dan gambar laporan |
| `scripts/` | Script konfigurasi tiap router dan node uji, dijalankan di `/root` |
| `routings/` | Isi `/etc/network/interfaces` tiap router (alternatif Edit config GNS3) |
| `soal1/` | Perhitungan VLSM (`vlsm.py`) dan tabelnya |
| `soal2/` | Generator script (`gen_soal2.py`) |
