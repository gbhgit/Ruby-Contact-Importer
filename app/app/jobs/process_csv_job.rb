# frozen_string_literal: true

class ProcessCsvJob < ActiveJob::Base
  queue_as :default

  def perform(att)
    import = Import.find_by(id: att["id"])
    if import
      import.column = att["header"]
      import.proc
    end
  end
end
