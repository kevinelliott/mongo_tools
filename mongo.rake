require 'mongo_mapper'

namespace :mongo do
  task :backup => :environment do
    mongo_uri = MongoMapper.config[RAILS_ENV]["uri"]
    puts "Backing up #{RAILS_ENV} mongo database at #{mongo_uri}"
    uri = URI.parse(mongo_uri)
    mongo_host = uri.host
    mongo_port = uri.port.to_s
    mongo_username = uri.user
    mongo_password = uri.password
    mongo_database = uri.path.gsub('/',"")
    puts "mongo_host = #{mongo_host}"
    puts "mongo_port = #{mongo_port}"
    puts "mongo_username = #{mongo_username}"
    puts "mongo_password = #{mongo_password}"
    puts "mongo_database = #{mongo_database}"
    backup_to = File.join(Rails.root,"tmp","mongodump")
    if RAILS_ENV != "development"
      system "mongodump --host #{mongo_host} --port #{mongo_port} -d #{mongo_database} -u #{mongo_username} -p #{mongo_password} -o #{backup_to}"
    else
      system "mongodump --host #{uri.host} -o #{backup_to}"
    end
    puts "Complete. Written to #{backup_to}."
  end
end
