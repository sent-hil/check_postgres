class CheckPostgres
  CHECKS = %w(
    dbstats
    connections
    locks
  )
end
