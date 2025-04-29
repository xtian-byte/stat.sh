#!/bin/bash

echo "-------------------------------------"
echo "📦 SERVER PERFORMANCE STATISTICS"
echo "-------------------------------------"

# OS version
echo -e "\n🖥️  OS Version:"
cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"'

# Uptime
echo -e "\n⏱️  Uptime:"
uptime -p

# Load average
echo -e "\n📈 Load Average (1m, 5m, 15m):"
uptime | awk -F'load average:' '{ print $2 }'

# Logged in users
echo -e "\n👥 Logged In Users:"
who | wc -l

# Failed login attempts (last 24h)
echo -e "\n❌ Failed Login Attempts (last 24h):"
journalctl _COMM=sshd --since "24 hours ago" | grep "Failed password" | wc -l

# CPU usage
echo -e "\n🧠 CPU Usage:"
top -bn1 | grep "Cpu(s)" | \
  awk '{print "User: " $2 "%, System: " $4 "%, Idle: " $8 "%, Total Used: " 100 - $8 "%"}'

# Memory usage
echo -e "\n💾 Memory Usage:"
free -m | awk 'NR==2{
  used=$3; 
  free=$4; 
  total=$2; 
  printf "Used: %s MB, Free: %s MB, Total: %s MB, Usage: %.2f%%\n", used, free, total, used/total * 100
}'

# Disk usage
echo -e "\n🗄️  Disk Usage (root '/'):"
df -h / | awk 'NR==2 {
  printf "Used: %s, Available: %s, Total: %s, Usage: %s\n", $3, $4, $2, $5
}'

# Top 5 processes by CPU usage
echo -e "\n🔥 Top 5 CPU-consuming Processes:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

# Top 5 processes by memory usage
echo -e "\n🧵 Top 5 Memory-consuming Processes:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

echo -e "\n✅ Stats collection complete."
