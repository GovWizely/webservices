module Envirotech
  class ImportWorker
    include Sidekiq::Worker

    def perform
      Envirotech.import_sequentially
    end
  end
end
