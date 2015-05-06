class ImportWorker
  include Sidekiq::Worker

  def perform(class_name)
    class_name.constantize.new.import
  end
end
