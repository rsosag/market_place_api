class User < ApplicationRecord
  validates :email, uniqueness: true
  validates_format_of :email, with: /\A[^@\s]+@[^@\s]+\z/
  validates :password_digest, presence: true

  # has_secure_password adds the following validations:
  #  the password must be present when creating.
  #  the password length must be less than or equal to 72 bytes.
  #  the confirmation of the password `password_confirmation` (if sent)
  # In addition, this method will add a `User#password` attribute that will
  # be automatically hashed and saved in the `User#password_digest` attribute.
  has_secure_password

  has_many :products, dependent: :destroy

end
