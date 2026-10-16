############################################
###########################################

###### Network-Diagnostic-Tool############
#####################################

# AUTHOR  : MANISH
# DATE    : 16/10/2026
# VERSION : v1
############################################




#!/bin/bash
TARGET="${1:-google.com}"
REPORT_DIR="$HOME/netdiag_reports"
mkdir -p "$REPORT_DIR"
REPORT="$REPORT_DIR/netdiag_$(date +%Y%m%d_%H%M%S).txt"
PASS=0
FAIL=0
################################################
###############   HELPER FUNTION  ##############

log()     { echo "$@" | tee -a "$REPORT"; }
section() { log ""; log "===== $1 ====="; }
run()     { "$@" 2>&1 | tee -a "$REPORT"; }

check() {
    local name="$1"; shift
    if "$@" >/dev/null 2>&1; then
        log "[PASS] $name"; PASS=$((PASS+1))
    else
        log "[FAIL] $name"; FAIL=$((FAIL+1))
    fi
}


###########################################
#########PING TEST########################

echo "PING TEST"

section "2. CONNECTIVITY TESTS"
check "Ping gateway" ping -c 2 -W 2 "$GATEWAY"
check "Ping internet (8.8.8.8)" ping -c 2 -W 2 8.8.8.8
check "Ping hostname ($TARGET)" ping -c 2 -W 2 "$TARGET"



########################33
###DNS TEST#############

echo "DNS TEST"

section "3. DNS LOOKUP"
check "DNS resolves $TARGET" dig +short "$TARGET"
run dig +short "$TARGET"
#######################
#HTTP REQUEST#######

echo "HTTP REQUEST"

section "4. HTTP CHECK"
check "HTTPS reachable" curl -s -o /dev/null --max-time 10 "https://$TARGET"
curl -s -o /dev/null --max-time 10 \
  -w "HTTP code: %{http_code} | Total: %{time_total}s\n" \
  "https://$TARGET" | tee -a "$REPORT"


#############################
##Add route and ports########

echo "Route and ports"

section "5. ROUTE TO TARGET"
run traceroute -m 10 -w 2 "$TARGET"

section "6. LISTENING PORTS"
run ss -tuln

############################
##The Summary#######

echo "The Summary"

section "SUMMARY"
log "Passed: $PASS"
log "Failed: $FAIL"
[ "$FAIL" -eq 0 ] && log "Result: NETWORK HEALTHY" || log "Result: PROBLEMS FOUND"
log "Report saved: $REPORT"
