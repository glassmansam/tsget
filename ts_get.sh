#!/bin/bash

################################################################################
# Style and Color Definitions
# Defines ANSI escape codes for a BRIGHT color palette to make the output
# highly visible and easy to read.
################################################################################
C_RESET='\033[0m'
C_BOLD='\033[1m'

# Bright Color Palette
C_RED='\033[1;31m'
C_GREEN='\033[1;32m'
C_YELLOW='\033[1;33m'
C_BLUE='\033[1;34m'
C_MAGENTA='\033[1;35m'
C_CYAN='\033[1;36m'
C_WHITE='\033[1;37m'


################################################################################
# Helper Function
# Converts a date string into Unix epoch milliseconds.
#
# @param string $1 - A date string compatible with `date -d`.
# @return void - Echoes the epoch millisecond timestamp.
################################################################################
_ts_ms() {
    # Use `date -d` to parse the string, +%s for seconds, and +%N for nanoseconds.
    # Then take the first 13 digits to get millisecond precision.
    date -d "$1" +%s%N | cut -b1-13
}

################################################################################
# Main Function
# Converts predefined time ranges into start/end Unix epoch milliseconds
# and prints them with a vibrant, styled output.
#
# @param string $1 - A predefined time range (e.g., "last hour", "yesterday").
# @return integer - Returns 1 on error.
################################################################################
ts_get() {
    local time_range="$1"
    local start_epoch_millis
    local end_epoch_millis

    # Default the end time to the current moment.
    end_epoch_millis=$(_ts_ms "now")

    # Process the requested time range
    case "$time_range" in
        # --- Ranges Relative to Now ---
        "last 15 minutes") start_epoch_millis=$(_ts_ms "15 minutes ago");;
        "last hour")       start_epoch_millis=$(_ts_ms "1 hour ago");;
        "last 8 hours")    start_epoch_millis=$(_ts_ms "8 hours ago");;
        "last 24 hours")   start_epoch_millis=$(_ts_ms "24 hours ago");;
        "last 3 days")     start_epoch_millis=$(_ts_ms "3 days ago");;
        "last 30 days")    start_epoch_millis=$(_ts_ms "30 days ago");;
        "last month")      start_epoch_millis=$(_ts_ms "1 month ago");;
        "last year")       start_epoch_millis=$(_ts_ms "1 year ago");;

        # --- Fixed Full-Day or Multi-Day Periods ---
        "today")
            start_epoch_millis=$(_ts_ms "today 00:00:00")
            ;;
        "yesterday")
            start_epoch_millis=$(_ts_ms "yesterday 00:00:00")
            end_epoch_millis=$(_ts_ms "yesterday 23:59:59")
            ;;
        "this week")
            start_epoch_millis=$(_ts_ms "last monday 00:00:00")
            ;;
        "last week")
            start_epoch_millis=$(_ts_ms "2 weeks ago monday 00:00:00")
            end_epoch_millis=$(_ts_ms "last sunday 23:59:59")
            ;;
        "last Mon")
            start_epoch_millis=$(_ts_ms "last Monday 00:00:00")
            end_epoch_millis=$(_ts_ms "last Monday 23:59:59")
            ;;
        "last Tue")
            start_epoch_millis=$(_ts_ms "last Tuesday 00:00:00")
            end_epoch_millis=$(_ts_ms "last Tuesday 23:59:59")
            ;;
        "last Wed")
            start_epoch_millis=$(_ts_ms "last Wednesday 00:00:00")
            end_epoch_millis=$(_ts_ms "last Wednesday 23:59:59")
            ;;
        "last Thu")
            start_epoch_millis=$(_ts_ms "last Thursday 00:00:00")
            end_epoch_millis=$(_ts_ms "last Thursday 23:59:59")
            ;;
        "last Fri")
            start_epoch_millis=$(_ts_ms "last Friday 00:00:00")
            end_epoch_millis=$(_ts_ms "last Friday 23:59:59")
            ;;
        "last Sat")
            start_epoch_millis=$(_ts_ms "last Saturday 00:00:00")
            end_epoch_millis=$(_ts_ms "last Saturday 23:59:59")
            ;;
        "last Sun")
            start_epoch_millis=$(_ts_ms "last Sunday 00:00:00")
            end_epoch_millis=$(_ts_ms "last Sunday 23:59:59")
            ;;
        "last Mon-Wed")
            start_epoch_millis=$(_ts_ms "last Monday 00:00:00")
            end_epoch_millis=$(_ts_ms "last Wednesday 23:59:59")
            ;;
        "last week day" | "last Mon-Fri")
            start_epoch_millis=$(_ts_ms "last Monday 00:00:00")
            end_epoch_millis=$(_ts_ms "last Friday 23:59:59")
            ;;
        *)
            echo -e "${C_RED}Error: Unsupported time range: \"$time_range\"${C_RESET}" >&2
            return 1
            ;;
    esac

    # Output the results with the new bright styling
    echo -e "${C_CYAN}Time Range:${C_RESET} ${C_WHITE}\"$time_range\"${C_RESET}"
    echo -e "  ${C_YELLOW}Start:${C_RESET}    ${C_GREEN}$start_epoch_millis${C_RESET}"
    echo -e "  ${C_YELLOW}End:${C_RESET}      ${C_GREEN}$end_epoch_millis${C_RESET}"
    echo ""
}

# --- Example Usage ---
# Clear the screen and show a header for the demo
clear
echo -e "${C_MAGENTA}=======================================${C_RESET}"
echo -e "${C_BOLD}  Timestamp Conversion Script Demo${C_RESET}"
echo -e "${C_MAGENTA}=======================================${C_RESET}\n"


echo -e "${C_BLUE}--- Ranges Relative to Now ---${C_RESET}"
ts_get "last hour"
ts_get "today"

echo -e "${C_BLUE}--- Fixed Full-Day Periods ---${C_RESET}"
ts_get "yesterday"
ts_get "last Fri"

echo -e "${C_BLUE}--- Fixed Multi-Day/Week Periods ---${C_RESET}"
ts_get "last week"
ts_get "last Mon-Wed"

echo -e "${C_BLUE}--- Error Handling ---${C_RESET}"
ts_get "some future date"
