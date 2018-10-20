# == Schema Information
#
# Table name: goals
#
#  id          :bigint(8)        not null, primary key
#  user_id     :integer          not null
#  description :text
#  title       :string           not null
#  public      :boolean          default(TRUE), not null
#  complete    :boolean          default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

class Goal < ApplicationRecord
  validates :title, presence: true

  belongs_to :user,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :comments,
    as: :commentable,
    dependent: :destroy

end
