# Avanza Zero NAV retriever

This script retrieves the latest NAV of the Avanza Zero fund and appends it to a
`ledger`-compatible price-db file, unless the newly retrieved price already
exists in the file.

## Cron
Add script to crontab for nightly retrieval.

    0 22 * * * $HOME/Documents/scripts/avanza_zero_nav_retriever/avanza_zero_nav_retriever.rb

## Disclaimer
I take no responsibility for this script should it cause any harm.
