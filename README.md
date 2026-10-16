# Network Diagnostic Tool

A Bash script that tests a Linux machine's network step by step and saves a timestamped report with PASS/FAIL results.

It helps find where a network problem is: local network, ISP, DNS, or the website.

## Features

- Shows network interfaces and the default gateway
- Tests connectivity with `ping` (gateway, `8.8.8.8`, hostname)
- Checks DNS resolution with `dig`
- Checks HTTPS response code and time with `curl`
- Traces the route with `traceroute`
- Lists listening ports with `ss`
- Prints a summary: NETWORK HEALTHY or PROBLEMS FOUND
- Saves every run to `~/netdiag_reports/`

## Requirements

- Linux (tested on Ubuntu)
- Bash

```bash
sudo apt install iputils-ping dnsutils curl traceroute
```

## Usage

```bash
git clone https://github.com/<your-username>/netdiag.git
cd netdiag
chmod +x netdiag.sh
./netdiag.sh              # default target: google.com
./netdiag.sh github.com   # custom target
```

## Sample Output

```
===== 2. CONNECTIVITY TESTS =====
[PASS] Ping gateway (192.168.1.1)
[PASS] Ping internet (8.8.8.8)
[PASS] Ping hostname (google.com)

===== SUMMARY =====
Passed: 6
Failed: 0
Result: NETWORK HEALTHY
```



## How to Read the Results

| Result | Likely problem |
|---|---|
| Gateway ping fails | Local network, cable, or Wi-Fi |
| Gateway passes, `8.8.8.8` fails | Router or ISP |
| `8.8.8.8` passes, hostname fails | DNS |
| Hostname passes, HTTP fails | Web server or firewall |

## Run Automatically with Cron

```bash
crontab -e
*/30 * * * * /home/youruser/netdiag/netdiag.sh >/dev/null 2>&1
```

## Commands Used

`ip`, `ping`, `dig`, `curl`, `traceroute`, `ss`, `awk`, `tee`, `cron`

## Future Improvements

- Help option and custom target flag
- Check multiple targets from a file
- Slack alert when a test fails
- Colored output

## License

MIT
