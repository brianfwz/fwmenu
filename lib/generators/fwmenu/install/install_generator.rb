require 'rails/generators/migration'
require 'bundler'

module Fwmenu
  module Generators
    class InstallGenerator < ::Rails::Generators::NamedBase
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      desc "add the migrations"

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations
        if ActiveRecord::Base.connection.table_exists? "#{file_name}s"
          migration_template "migration/change_menus.rb", "db/migrate/change_#{file_name}s.rb"
        else
          migration_template "migration/create_menus.rb", "db/migrate/create_#{file_name}s.rb"
        end

        if ActiveRecord::Base.connection.table_exists? "#{file_name}s"
          migration_template "migration/change_menu_items.rb", "db/migrate/change_#{file_name}_items.rb"
        else
          migration_template "migration/create_menu_items.rb", "db/migrate/create_#{file_name}_items.rb"
        end
        
        if ActiveRecord::Base.connection.table_exists? "articles"
          migration_template "migration/change_articles.rb", "db/migrate/change_articles.rb"
        else
          migration_template "migration/create_articles.rb", "db/migrate/create_articles.rb"
        end
        
        if ActiveRecord::Base.connection.table_exists? "categories"
          migration_template "migration/change_categories.rb", "db/migrate/change_categories.rb"
        else
          migration_template "migration/create_categories.rb", "db/migrate/create_categories.rb"
        end
        
        migration_template "migration/add_reference_menu_items_to_menu_item.rb", "db/migrate/add_reference_#{file_name}_items_to_#{file_name}_item.rb"
        migration_template "migration/add_reference_menu_items_to_article.rb", "db/migrate/add_reference_#{file_name}_items_to_article.rb"
        migration_template "migration/add_reference_menu_items_to_category.rb", "db/migrate/add_reference_#{file_name}_items_to_category.rb"
        migration_template "migration/add_reference_articles_to_category.rb", "db/migrate/add_reference_articles_to_category.rb"
      end

      def copy_initializer_file
        active = Bundler.load.specs.map { |spec| spec.name }

        template "models/menu.rb", "app/models/#{file_name}.rb"
        template "models/article.rb", "app/models/article.rb"
        template "models/category.rb", "app/models/category.rb"
        template "helpers/menu_helper.rb", "app/helpers/#{file_name}_helper.rb"
        copy_file "controllers/articles_controller.rb", "app/controllers/articles_controller.rb"
        copy_file "controllers/categories_controller.rb", "app/controllers/categories_controller.rb"
        template "views/_get_menu_for.html.slim", "app/views/_get_#{file_name}_for.html.slim"
        template "views/_menu.html.slim", "app/views/_#{file_name}.html.slim"
        template "views/_get_submenu_for.html.slim", "app/views/_get_sub#{file_name}_for.html.slim"
        copy_file "views/articles/show.html.slim", "app/views/articles/show.html.slim"
        copy_file "views/articles/show/article.html.slim", "app/views/articles/show/article.html.slim"
        copy_file "views/articles/show/latest.html.slim", "app/views/articles/show/latest.html.slim"
        copy_file "views/categories/show.html.slim", "app/views/categories/show.html.slim"
        copy_file "views/categories/show/article.html.slim", "app/views/categories/show/article.html.slim"
        copy_file "views/categories/show/latest.html.slim", "app/views/categories/show/latest.html.slim"

        if active.include? "activeadmin"
          
        else
          template "models/menu_item.rb", "app/models/#{file_name}_item.rb"
        end
      end
    end
  end
end