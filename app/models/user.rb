class User < ApplicationRecord
  has_many :works
  has_many :votes
  has_many :ranked_works, through: :votes, source: :work

  validates :username, uniqueness: true, presence: true

  def self.from_auth_hash(provider, auth_hash)
    # because we are in the User model we can create a new user with this syntax
    user = new
    # populate the new User's attributes with info from the auth_hash:
    user.provider = provider
    user.uid = auth_hash['uid']
    user.name = auth_hash['info']['name']
    user.email = auth_hash['info']['email']
    user.username = auth_hash['info']['nickname']
    # NOTE: to use google_oauth2 have to give another way to set the name attribute since the google has a different key for this info 
    user.username = auth_hash['info']['name']
    # user.oauth_token = auth_hash['credentials']["token"]
    # user.oauth_expires_at = Time.at(auth_hash["credentials"]["expires_at"]
    # return the UNSAVED user to the SessionsController
    # the user will be saved in the save_flash method!
    return user
  end # self.from_auth_hash
end
