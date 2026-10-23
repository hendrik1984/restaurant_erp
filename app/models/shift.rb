class Shift < ApplicationRecord
  belongs_to :user

  validates :clock_in, presence: true
  validate :clock_out_after_clock_in
  validate :no_overlapping_open_shift, on: :create

  scope :open, -> { where(clock_out: nil) }

  def open?
    clock_out.nil?
  end

  def duration
    return nil if open?
    clock_out - clock_in
  end

  private
  def clock_out_after_clock_in
    return if clock_out.blank? || clock_in.blank?
    errors.add(:clock_out, "must be after clock in") if clock_out <= clock_in
  end

  def no_overlapping_open_shift
    return if user_id.blank?
    if Shift.open.where(user_id: user_id).exists?
      errors.add(:base, "You already have an open shift")
    end
  end
end
