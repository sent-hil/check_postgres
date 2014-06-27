class CheckPostgres
  PER_DB_STATS = %w(
    backends
    txn_wraparound
    autovac_freeze
  )

 CHECKS = ["dbstats", "locks"] && PER_DB_STATS
end
