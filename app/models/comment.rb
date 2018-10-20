# == Schema Information
#
# Table name: comments
#
#  id               :bigint(8)        not null, primary key
#  commentable_type :string           not null
#  commentable_id   :bigint(8)        not null
#  body             :text             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  author_id        :integer          not null
#

class Comment < ApplicationRecord
  validates :body, presence: true

  belongs_to :author,
    foreign_key: :author_id,
    class_name: :User,
    dependent: :destroy

  belongs_to :commentable,
    polymorphic: true
end
