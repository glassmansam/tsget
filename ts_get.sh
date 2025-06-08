#!/bin/bash

################################################################################
# Helper Function
# Converts a date string into Unix epoch milliseconds.
#
# @param string $1 - A date string compatible with `date -d`.
# @return void - Echoes the epoch millisecond timestamp.
################################################################################
_ts_ms() {
    # We use `date -d` to parse the string, +%s for seconds, and +%N for nanoseconds.
    # We then take the first 13 digits to get millisecond precision.
    date -d "$1" +%s%N | cut -b1-13
}

################################################################################
# Main Function
# Converts predefined human-readable time ranges into start and end Unix epoch
# millisecond timestamps.
#
# @param string $1 - A predefined time range (e.g., "last hour", "yesterday").
# @return integer - Returns 1 on error.
################################################################################
ts_get() {
    local time_range="$1"
    local start_epoch_millis
    local end_epoch_millis

    # By default, the end time is the current moment. This applies to all
    # "last X" style ranges. This will be overridden for fixed-period ranges.
    end_epoch_millis=$(_ts_ms "now")

    # Process the requested time range
    case "$time_range" in
        # --- Ranges Relative to Now ---
        "last 15 minutes")
            start_epoch_millis=$(_ts_ms "15 minutes ago")
            ;;
        "last hour")
            start_epoch_millis=$(_ts_ms "1 hour ago")
            ;;
        "last 8 hours")
            start_epoch_millis=$(_ts_ms "8 hours ago")
            ;;
        "last 24 hours")
            start_epoch_millis=$(_ts_ms "24 hours ago")
            ;;
        "last 3 days")
            start_epoch_millis=$(_ts_ms "3 days ago")
            ;;
        "last 30 days")
            start_epoch_millis=$(_ts_ms "30 days ago")
            ;;
        "last month")
            start_epoch_millis=$(_ts_ms "1 month ago")
            ;;
        "last year")
            start_epoch_millis=$(_ts_ms "1 year ago")
            ;;

        # --- Fixed Full-Day or Multi-Day Periods ---
        # For these ranges, we override the end_epoch_millis to cover the
        # full period from its beginning (00:00:00) to its end (23:59:59).
        "today")
            start_epoch_millis=$(_ts_ms "today 00:00:00")
            # End time remains "now"
            ;;
        "yesterday")
            start_epoch_millis=$(_ts_ms "yesterday 00:00:00")
            end_epoch_millis=$(_ts_ms "yesterday 23:59:59")
            ;;
        "this week")
            start_epoch_millis=$(_ts_ms "last monday 00:00:00")
            # End time remains "now"
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
        "last week day" | "last Mon-Fri") # Using an alias for the same range
            start_epoch_millis=$(_ts_ms "last Monday 00:00:00")
            end_epoch_millis=$(_ts_ms "last Friday 23:59:59")
            ;;
        *)  # Handle unsupported or unknown time ranges
            echo "Error: Unsupported time range: \"$time_range\"" >&2
            return 1
            ;;
    esac

    # Output the results in a readable format
    echo "Time Range:         \"$time_range\""
    echo "Start Epoch Millis: $start_epoch_millis"
    echo "End Epoch Millis:   $end_epoch_millis"
    echo "" # Add a newline for cleaner separation
}

# --- Example Usage ---
# Uncomment the calls below to test the function.

echo "--- Ranges Relative to Now ---"
ts_get "last hour"
ts_get "today"

echo "--- Fixed Full-Day Periods ---"
ts_get "yesterday"
ts_get "last Fri"

echo "--- Fixed Multi-Day/Week Periods ---"
ts_get "last week"
ts_get "last Mon-Wed"

echo "--- Error Handling ---"
ts_get "some future date"
