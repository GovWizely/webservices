class ImportWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed, log_duplicate_payload: Rails.env.production?

  def perform(class_name)
    class_name.constantize.new.import
  end
end
