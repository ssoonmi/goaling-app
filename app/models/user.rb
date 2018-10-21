# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  location        :string           not null
#  house           :string           not null
#

class User < ApplicationRecord
  validates :username, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: { minimum: 6 }, allow_nil: true

  after_initialize :ensure_session_token

  attr_reader :password

  HOUSES = {
    'Gryffindor' => 'https://vignette.wikia.nocookie.net/harrypotter/images/8/8e/0.31_Gryffindor_Crest_Transparent.png/revision/latest?cb=20161124074004',
    'Slytherin'=> 'https://vignette.wikia.nocookie.net/harrypotter/images/d/d3/0.61_Slytherin_Crest_Transparent.png/revision/latest?cb=20161020182557',
    'Hufflepuff' => 'https://vignette.wikia.nocookie.net/harrypotter/images/5/50/0.51_Hufflepuff_Crest_Transparent.png/revision/latest?cb=20161020182518',
    'Ravenclaw' => 'https://vignette.wikia.nocookie.net/harrypotter/images/2/29/0.41_Ravenclaw_Crest_Transparent.png/revision/latest?cb=20161020182442&format=original'
  }

  has_many :goals,
    foreign_key: :user_id,
    class_name: :Goal,
    dependent: :destroy

  has_many :comments,
    as: :commentable,
    dependent: :destroy

  has_many :authored_comments,
    foreign_key: :author_id,
    class_name: :Comment,
    dependent: :destroy

  def self.houses
    HOUSES.keys
  end

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64
  end

  def self.find_by_credentials(user_params)
    user = User.find_by(username: user_params[:username])
    return user if user && user.is_password?(user_params[:password])
    nil
  end

  def reset_session_token!
    update!(session_token: self.class.generate_session_token)
    self.session_token
  end

  def is_password?(password)
    bcrypted_pw = BCrypt::Password.new(self.password_digest)
    bcrypted_pw.is_password?(password)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def house_image_url
    HOUSES[self.house]
  end
end
