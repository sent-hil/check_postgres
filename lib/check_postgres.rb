require_relative "./check_postgres/checks"

class CheckPostgres
  attr_reader :host, :user

  def initialize(host, user)
    @host = host
    @user = user
  end

  def dbstats
    stats = _send("dbstats")
    stats_by_db = stats.split(/\n/)
    stats_by_db.map do |st|
      {}.tap do |result|
        entries = st.split(" ")
        split_entries = entries.map {|x| x.split(":")}

        split_entries.each do |entry|
          key, value = entry[0], entry[1]
          unless key == "dbname"
            value = value.to_i
          end

          result[key] = value
        end
      end
    end
  end

  def locks
    raw = _send("locks")
    result = parse_count(raw)

    {}.tap do |final|
      result.each do |dbname, count|
        key = dbname.to_s.split(".")[0]
        final[key.to_sym] = count
      end
    end
  end

  PER_DB_STATS.each do |check|
    define_method check do
      raw    = _send(check)
      result = parse_count(raw)
      result.merge!("scope" => "db")

      result
    end
  end

  POSTGRES_DB_STATS.each do |check|
    define_method check do
      raw    = _send(check)
      result = parse_count(raw)
      result.merge!("scope" => "postgres")

      {}.tap do |final|
        result.map do |x, y|
          final[x.to_s.split(".")[2]] = y
        end
      end
    end
  end

  private

  def parse_count(result)
    counts = result.split("|")[1].split(" ")
    counts = counts[1..-1]

    {}.tap do |result|
      counts.map do |count|
        entry = count.split("=")

        key   = entry[0].to_sym
        value = entry[1].split(";")[0]

        result[key] = value.to_i
      end
    end
  end

  def _send(action)
    path = File.dirname(__FILE__)
    `#{path}/bin/check_postgres.pl -H #{host} -dbuser #{user} --action #{action}`
  end
end
