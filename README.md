# 🕵️‍♂️ WebreconX - OSINT & Recon Tool

**WebreconX** is a powerful Open Source Intelligence (OSINT) and web reconnaissance tool designed for ethical hackers, security researchers, and penetration testers. It automates the process of gathering valuable information about websites, domains, and IPs — all in one place.

---

## 🚀 Features

- 🌐 Domain & Subdomain Enumeration  
- 🧠 WHOIS Lookup  
- 🌍 DNS Record Analysis  
- 🛰️ IP Geolocation  
- 🏗️ HTTP Headers & Server Banner Detection  
- 🔍 Google Dorking & Search Engine Recon  
- 🔧 Built-in Wordlists for Directory Bruteforcing  
- 📤 Export results to text or JSON

---

## 📦 Installation

```bash
git clone https://github.com/midotech1/webreconx.git
cd webreconx
chmod +x install.sh
./install.sh
```

> Requires Python 3.x and Linux (Kali/Ubuntu recommended)

---

## ⚙️ Usage

```bash
sudo ./webreconx.sh -u https://target.com/
```

### Common Options:
```bash
  -u, --url         Target URL
  -s, --subdomains  Run subdomain enumeration
  -w, --whois       Perform WHOIS lookup
  -d, --dns         DNS record extraction
  -i, --ip          Show IP and geolocation info
  -e, --export      Export results to file
```

---

## 📁 Output

Results are saved in the `/results/` directory:
- `target.com_info.txt`
- `target.com_dns.json`
- `target.com_report.html` (optional)

---

## 🛡️ Legal Disclaimer

> WebreconX is intended **only for educational and authorized security testing**.  
> Unauthorized use of this tool against systems without permission is **strictly prohibited**.

---

## 👨‍💻 Author

- **Name:** Ahmed Bouaoud  
- **GitHub:** [github.com/midotech1](https://github.com/midotech1)  
- **Contact:** ahmedbouaoud05@gmail.com

---



