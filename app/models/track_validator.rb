class TrackValidator < ActiveModel::Validator
  def validate(record)
    if record.end && record.start
      if record.end < record.start
        record.errors[:base] << "Project must end after beginning, duh."
      end
    end
  end
end
