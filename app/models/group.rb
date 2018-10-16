class Group < ApplicationRecord

	has_one_attached :tracker
	has_one_attached :portrait

	has_many :users
end
