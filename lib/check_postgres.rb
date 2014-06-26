class CheckPostgres
  attr_reader :host, :user

  def initialize(host, user)
    @host = host
    @user = user
  end

  def dbstats
    stats = send("dbstats")
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

  def send(action)
    path = File.dirname(__FILE__)
    `#{path}/bin/check_postgres.pl -H #{host} -dbuser #{user} --action #{action}`
  end
end
