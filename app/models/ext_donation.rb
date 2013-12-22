# == Schema Information
#
# Table name: ext_donations
#
#  id                :integer          not null, primary key
#  project_id        :integer
#  amount            :float
#  note              :text
#  collection_method :string(255)
#  donor             :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  collection_time   :datetime
#  email             :string(255)
#  phone             :string(255)
#  anon              :boolean
#

class ExtDonation < ActiveRecord::Base
  belongs_to :project
  has_one :token
  attr_accessible :donor, :amount, :note, :email, :phone,
    :collection_method, :collection_time, :project_id, :token_id, :anon
  validates :donor, :amount, :collection_time, :project_id, presence: true
  has_defaults anon: false

  after_save :generate_token

  scope :bank_transfer, -> { where(collection_method: "BANK_TRANSFER") }
  scope :cod, -> { where(collection_method: "COD") }

  def generate_token
    self.create_token
  end
end
