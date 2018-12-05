# require 'elasticsearch/model'
class Book < ApplicationRecord
	#required for searchkick, uncomment when needed/ready
	#searchkick word_start: [:title, :author, :description, :isbn13, :isbn10]

	#for elasticsearch
#	include Elasticsearch::Model
# 	include Elasticsearch::Model::Callbacks

	validates :isbn13, :isbn_format => true , length: { is: 13 }
	# validates :isbn10, :isbn_format => { :with => :isbn10 }
	validates :isbn13, :isbn_format => { :with => :isbn13 }	
	validates :title, presence: true
    validates :author, presence: true
    validates :price, presence: true, numericality: { greater_than: 0}
    validates :condition, presence: true
    validates :description, presence: true
	belongs_to :user

	#added for search kick, uncomment when ready/needed
#	def search_data
#		{
#			title: title, 
#			author: author, 
#			description: description, 
#			isbn13: isbn13, 
#			isbn10: isbn10
#		}
#	end


	#attr_accessor :state_event, :remove_cover_image

	#after_save :trigger_state, if: :state_event
	private def trigger_state
		send(state_event) if send(:"can_#{state_event}?")
	end

	#after_save :purge_cover_image, if: :remove_cover_image
	private def purge_cover_image
		cover_image.purge
	end

	# active_storage for multiple images
	has_one_attached :cover_image
	has_many_attached :condition_images

	#copied from https://code.tutsplus.com/tutorials/rails-image-upload-using-carrierwave-in-a-rails-app--cms-25183
	#allows to upload an image

	mount_uploader :image, ImageUploader

	#needed for regular search, uncomment if needed
	def self.search(search)
		if search
			where('title LIKE ? OR author LIKE ? OR isbn13 LIKE ? OR isbn10 LIKE ? OR description LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
		else
			all
		end
	end
end
