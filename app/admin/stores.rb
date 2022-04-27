module ActiveAdminTimeout
  def self.add_timeout(dsl)
    dsl.controller do
      around_action :do_timeout

      def do_timeout
        connection = ActiveRecord::Base.connection
        connection.execute("set max_execution_time = 2000")
        yield
      rescue ActiveRecord::StatementInvalid => e
        # query timed out
        raise "some error"
      ensure
        # reset to original max_execution_time
        connection.execute("set max_execution_time = #{ENV.fetch("DEFAULT_TIMEOUT", 30_000).to_i}")
      end
    end
  end
end

ActiveAdmin.register Store do
  ActiveAdminTimeout.add_timeout(self)

  # decorate_with FlowerDecorator
  menu
  # Create sections on the index screen
  scope :all, default: true
  # scope :available
  # scope :drafts

  index do
    column :flowers
    column :boom do |x|
      link_to("wait for it", "/admin/stores/#{x.id}/long_query")
    end
    actions
  end

  member_action :long_query do
    Store.connection.execute("SELECT 1 FROM information_schema.tables WHERE sleep(6);")
  end
end
