#!/vendor/bin/sh

setSimpleConfig() {

sleep 10

# Set the default IRQ affinity to the silver cluster. When a
# CPU is isolated/hotplugged, the IRQ affinity is adjusted
# to one of the CPU from the default IRQ affinity mask.
echo f > /proc/irq/default_smp_affinity

# Tweak IO performance after boot complete
echo "bfq" > /sys/block/sda/queue/scheduler
echo 256 > /sys/block/sda/queue/read_ahead_kb
echo 256 > /sys/block/sda/queue/nr_requests
echo 0 > /sys/block/sda/queue/iostats
echo 256 > /sys/block/sdf/queue/read_ahead_kb
echo 256 > /sys/block/sdf/queue/nr_requests
echo 0 > /sys/block/sdf/queue/iostats

#Setup cpu_input_boost parameters
echo 10 > sys/module/cpu_input_boost/parameters/dynamic_stune_boost

# Enable scheduler core_ctl
echo 1 > /sys/devices/system/cpu/cpu0/core_ctl/enable
echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/enable

# Increase how much CPU bandwidth (CPU time) realtime scheduling processes are given
echo "980000" > /proc/sys/kernel/sched_rt_runtime_us

# Network tweaks for slightly reduced battery consumption when being "actively" connected to a network connection;
echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control

# configure governor settings for little cluster
echo "schedutil" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
echo 1209600 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_freq
echo 1 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/pl
echo 500 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us
echo 20000 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us 
echo 0 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/iowait_boost_enable
	
# configure governor settings for big cluster
echo "schedutil" > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor
echo 1574400 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_freq
echo 1 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/pl
echo 500 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us
echo 20000 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us 
echo 0 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/iowait_boost_enable

#Enable suspend to idle mode to reduce latency during suspend/resume
echo "s2idle" > /sys/power/mem_sleep

# Toggle Sched Features
echo "NO_FBT_STRICT_ORDER" > /sys/kernel/debug/sched_features

#Stune
echo 1 > /dev/stune/background/schedtune.prefer_idle
echo 1 > /dev/stune/schedtune.prefer_idle
echo 5 > /dev/stune/foreground/schedtune.sched_boost
echo 5 > /dev/stune/rt/schedtune.sched_boost

#Configure Thermal Profile
echo 10 > /sys/class/thermal/thermal_message/sconfig

}

setSimpleConfig &
