class ProcessCsvJob < ActiveJob::Base
    queue_as :default

    def perform(att)
      puts("================")
      puts(att)
      # process...
    end
  end