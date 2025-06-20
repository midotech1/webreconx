#!/bin/bash
#
# WebReconX - All-in-One OSINT Recon & Pentest Tool
# Features:
#  - Admin Login Page Finder
#  - XSS Payload Injector (basic)
#  - DNS Lookup
#  - WHOIS Info                                                                                                                                        #  - Traceroute
#  - Port Scanner (top common ports)
#  - Pinger (ICMP)
#  - Geo-Pinger (IP Geolocation via ip-api.com)
#  - UPnP Scanner (local network)
#
# Requirements: curl, whois, dig, nmap, traceroute, jq, upnpc
# Automatically checks & installs missing dependencies
#
# Usage: sudo ./webreconx.sh
#
# Author: midotech1
#

set -e
# ==== Configuration ====
# ==== Banner ====
figlet webreconX
echo ""
echo "             OSINT Recon & Pentest Tool"
echo "             Author: midotech1"
# Colors
RED='\033[0;31m'       # Errors
GREEN='\033[0;32m'     # Success
YELLOW='\033[1;33m'    # Warnings / Info
CYAN='\033[0;36m'      # Menu / Highlights
NC='\033[0m'           # No Color

OUTPUT_DIR="./WebReconX_Reports"
mkdir -p "$OUTPUT_DIR"

# Common ports for port scan
COMMON_PORTS=(21 22 23 25 53 80 110 111 135 139 143 443 445 993 995 1723 3306 3389 5900 8080)

# === Check and install dependencies ===
function check_install() {
    local pkgs=("curl" "whois" "dig" "nmap" "traceroute" "jq" "upnpc")
    for pkg in "${pkgs[@]}"; do
        if ! command -v "$pkg" &>/dev/null; then
            echo -e "${YELLOW}[*] Installing missing package: $pkg${NC}"
            sudo apt-get install figlet -y
            sudo apt-get update -qq
            sudo apt-get install -y "$pkg" >/dev/null 2>&1 || {
                echo -e "${RED}[-] Failed to install $pkg. Please install manually.${NC}"
                exit 1
            }
        fi
    done
}


# === Admin Login Page Finder ===
# Checks common admin paths on a target domain or IP
function admin_finder() {
    read -rp "Enter target URL (e.g. https://example.com): " target
    echo -e "${CYAN}[*] Starting admin login page finder for $target${NC}"

    # Common admin paths
    paths=(
        "admin/"
        "administrator/"
        "admin/login.php"
        "admin.php"
        "login/"
        "user/login/"                                                                                                                                          "adminpanel/"
        "cpanel/"
        "wp-admin/"
        "admin1/"
        "admin_area/"
        "cms/"
    )

    for p in "${paths[@]}"; do
        url="${target%/}/$p"
        status=$(curl -o /dev/null -s -w "%{http_code}" "$url")
        if [[ "$status" == "200" ]]; then
            echo -e "${GREEN}[+] Found admin page: $url (Status: $status)${NC}"
        else
            echo -e "${YELLOW}[-] Not found: $url (Status: $status)${NC}"
        fi
    done
}

# === XSS Payload Injector ===
function xss_injector() {
    read -rp "Enter target URL with parameter (e.g. http://example.com/?q=): " url
    read -rp "Enter parameter name (e.g. q): " param

    # Simple XSS payloads
    payloads=(
        "<script>alert(1)</script>"
        "'\"><svg/onload=alert(1)>"
        "'><img src=x onerror=alert(1)>"
        "<body/onload=alert(1)>"
    )

    echo -e "${CYAN}[*] Testing XSS payloads on $url${NC}"

    for pl in "${payloads[@]}"; do
        test_url="${url}${pl}"
        echo -e "${YELLOW}Testing payload:${NC} $pl"
        response=$(curl -s "$test_url")
        if echo "$response" | grep -q "$pl"; then
            echo -e "${GREEN}[!] Possible XSS vulnerability found with payload: $pl${NC}"
        else
            echo -e "[-] Payload did not reflect."
        fi
    done
}

# === DNS Lookup ===
function dns_lookup() {
read -rp "Enter domain (e.g. example.com): " domain
    echo -e "${CYAN}[*] DNS Lookup for $domain${NC}"
    echo "A Records:"
    dig +short A "$domain"
    echo "MX Records:"
    dig +short MX "$domain"
    echo "TXT Records:"
    dig +short TXT "$domain"
}

# === WHOIS Info Finder ===
function whois_info() {
    read -rp "Enter domain (e.g. example.com): " domain
    echo -e "${CYAN}[*] Whois Info for $domain${NC}"
    whois "$domain" | head -40
}

# === Traceroute ===
function traceroute_func() {
    read -rp "Enter target IP or domain: " target
    echo -e "${CYAN}[*] Running traceroute to $target${NC}"
    traceroute "$target"
}

# === Port Scanner ===
function port_scanner() {
    read -rp "Enter target IP or domain: " target
    echo -e "${CYAN}[*] Scanning common ports on $target${NC}"
    nmap -p "$(IFS=,; echo "${COMMON_PORTS[*]}")" --open "$target"
}

# === Pinger ===
function pinger() {
    read -rp "Enter target IP or domain: " target
    echo -e "${CYAN}[*] Pinging $target (5 packets)${NC}"
    ping -c 5 "$target"
}
                                                                                                                                                       # === Geo-Pinger (IP Geolocation + Ping) ===
function geo_pinger() {
    read -rp "Enter IP address or domain: " target

    ip=$(dig +short "$target" | head -1)
    if [[ -z "$ip" ]]; then
        echo -e "${RED}[-] Could not resolve IP.${NC}"
        return
    fi
                                                                                                                                                           echo -e "${CYAN}[*] Geolocation for IP: $ip${NC}"
    geo_json=$(curl -s "http://ip-api.com/json/$ip")

    status=$(echo "$geo_json" | jq -r '.status')
    if [[ "$status" != "success" ]]; then
        echo -e "${RED}[-] Geolocation API failed.${NC}"
        return
    fi

    city=$(echo "$geo_json" | jq -r '.city')
    country=$(echo "$geo_json" | jq -r '.country')
    isp=$(echo "$geo_json" | jq -r '.isp')
    echo -e "Location: $city, $country"
    echo -e "ISP: $isp"

    echo -e "${CYAN}[*] Pinging $ip (5 packets)${NC}"
    ping -c 5 "$ip"
}

# === UPnP Scanner ===
function upnp_scanner() {
    echo -e "${CYAN}[*] Scanning local network for UPnP devices...${NC}"
    upnpc -l
}

# === Main menu ===
function main_menu() {
    while true; do
        echo -e "\n${CYAN}=== WebReconX Menu ===${NC}"
        echo "1) Admin Login Page Finder"
        echo "2) XSS Payload Injector"
        echo "3) DNS Lookup"
        echo "4) WHOIS Info Finder"
        echo "5) Traceroute"
        echo "6) Port Scanner"
        echo "7) Pinger"
        echo "8) Geo-Pinger"
        echo "9) UPnP Scanner"
        echo "0) Exit"
        read -rp "Choose an option: " choice

        case "$choice" in
            1) admin_finder ;;
            2) xss_injector ;;
            3) dns_lookup ;;
            4) whois_info ;;
            5) traceroute_func ;;
            6) port_scanner ;;
            7) pinger ;;
            8) geo_pinger ;;
            9) upnp_scanner ;;
            0) echo -e "${GREEN}Goodbye!${NC}"; exit 0 ;;
            *) echo -e "${RED}Invalid option.${NC}" ;;
        esac
    done
}

# ==== Run the script ====

check_install
main_menu
sudo mv webreconx /usr/local/bin/
