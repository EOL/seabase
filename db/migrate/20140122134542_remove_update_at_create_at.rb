class RemoveUpdateAtCreateAt < ActiveRecord::Migration
  def up
    Taxon.connection.select_values('show tables').each do |t|
      execute("alter table `%s` 
              drop column `updated_at`, 
              drop column `created_at`" % t) rescue next 
    end

  end
  
  def down
  end
end
