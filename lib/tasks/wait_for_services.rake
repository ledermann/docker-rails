task wait: :environment do
  wait_for_mysql
  wait_for_elasticsearch
end

def wait_for_elasticsearch
  loop do
    begin
      version = Searchkick.server_version
      puts "Elasticsearch #{version} is up and running"
      break
    rescue Faraday::ConnectionFailed => e
      if e.message =~ /Connection refused/
        puts "#{e}"
        puts 'Waiting for Elasticsearch...'
        STDOUT.flush
        sleep 1
      else
        raise e
      end
    end
  end
end

def wait_for_mysql
  loop do
    begin
      version = ActiveRecord::Base.connection.select_rows('SHOW VARIABLES WHERE Variable_name = "version"')[0][1]
      puts "MySQL #{version} is up and running"
      break
    rescue ActiveRecord::NoDatabaseError
      puts "MySQL is up and running, but database is missing"
      break
    rescue Mysql2::Error => e
      if e.message =~/Can't connect/
        puts "#{e}"
        puts 'Waiting for MySQL...'
        STDOUT.flush
        sleep 1
      else
        raise e
      end
    end
  end
end
