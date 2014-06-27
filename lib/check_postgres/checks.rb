class CheckPostgres
  PER_DB_STATS = %w(
    backends
    txn_wraparound
    autovac_freeze
    commitratio
    hitratio
  )

  POSTGRES_DB_STATS = %w(
    last_analyze
    last_autoanalyze
    last_autovacuum
    last_vacuum
  )

 CHECKS = ["dbstats", "locks"] && PER_DB_STATS && POSTGRES_DB_STATS
end
