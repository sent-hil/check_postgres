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
          result[entry[0]] = entry[1]
        end
      end
    end
  end

  def connections
    backends = _send("backends")
    counts = backends.split("|")[1].split(" ")
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

  private

  def _send(action)
    path = File.dirname(__FILE__)
    `#{path}/bin/check_postgres.pl -H #{host} -dbuser #{user} --action #{action}`
  end
end
