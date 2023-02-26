#!/usr/bin/env python3

import socket
import time
from datetime import datetime
import traceback

services = {
    "drive.google.com": {"ips": {"192.168.0.1"}, "dt": "2023-02-26 18:59:21"},
    "mail.google.com": {"ips": {"192.168.0.1", "142.251.1.83"}, "dt": "2023-02-26 18:59:22"},
    "google.com": {"ips": {"192.168.0.1"}, "dt": "2023-02-26 18:59:23"}
}

while True:
    for service in services:
        saved_service_ips = services[service]["ips"]
        saved_service_dt = services[service]["dt"]
        print(f"Service: {service}\tSaved ips: {saved_service_ips}  \tSaved check time: {saved_service_dt}")

        try:
            now = datetime.now()
            check_time = now.strftime("%Y-%m-%d %H:%M:%S")

            checked_service = socket.gethostbyname_ex(service)
            checked_service_ips = set(checked_service[2])
            for ip in checked_service_ips:
                if ip in saved_service_ips:
                    print(f"[CHECKED] {service} - {ip}\tCheck time: {check_time}")
                else:
                    print(f"[ERROR] {service} IP {ip} mismatch: {saved_service_ips}\tCheck time: {check_time}")

            # Save current result
            services[service]["ips"] = checked_service_ips
            services[service]["dt"] = check_time
        except Exception:
            traceback.print_exc()

    now = datetime.now()
    dt = now.strftime("%Y-%m-%d %H:%M:%S")

    print(f"\t\t===================={dt}=====================")
    time.sleep(2)