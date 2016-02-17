class TrackValidator < ActiveModel::Validator
  def validate(record)
    if record.end && record.start
      if record.end <= record.start
        record.errors[:base] << "project must end after beginning, duh"
      end
    end
    if record.status == 'uploaded' && !record.label_id
      record.errors[:base] << "label must be assigned"
    end
  end
end
