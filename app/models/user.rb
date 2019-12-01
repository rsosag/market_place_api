class User < ApplicationRecord
  validates :email, uniqueness: true
  validates_format_of :email, with: /\A[^@\s]+@[^@\s]+\z/
  validates :password_digest, presence: true
end
