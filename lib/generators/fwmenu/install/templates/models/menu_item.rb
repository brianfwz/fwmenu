class <%= file_name.camelize %>Item < ActiveRecord::Base
	extend Enumerize

	validates :title, :<%= file_name %>, presence: true

	belongs_to :<%= file_name %>
	belongs_to :<%= file_name %>_item
	has_many 	 :<%= file_name %>_items
	belongs_to :article

	enumerize :page, in: Rails.application.routes.routes.collect {|r| r.path.spec.to_s.gsub("(.:format)", "") }.compact.uniq.delete_if{|i|i.include? "admin" or i.include? "rails" }.sort
	
	before_save :set_level
	before_validation :validation_custom

	def set_level
		self.level = self.<%= file_name %>_item.level + 1 if self.<%= file_name %>_item.present?
	end

	def array_<%= file_name %>_items_by_<%= file_name %>_item(items)
		arr = {}
		if items.present?
			items.each do |i|
				if i.<%= file_name %>_item.present?
					if arr[i.<%= file_name %>_item.id].nil?
						arr[i.<%= file_name %>_item.id] = [i]
					else
						arr[i.<%= file_name %>_item.id] << i
					end
				end
			end
		end
		arr
	end

	def get_child(item, arr)
		items = []
		if arr[item.id].present?
			arr[item.id].each do |i|
				items << i
				items = items + get_child(i, arr) if arr[i.id].present?
			end
		end
		items
	end

	def validation_custom
		arr = array_<%= file_name %>_items_by_<%= file_name %>_item(self.<%= file_name %>.<%= file_name %>_items.includes(:<%= file_name %>_item))

		if internal_link
			errors.add(:page, "Please fill up this field") 		unless page.present?
			errors.add(:article, "Please fill up this field") if page.to_s == "/articles/:id" && article.nil?
			errors.add(:show, "Please fill up this field") 		if page.to_s != "/articles/:id" && show.nil? && page.include?(":id")
		else
			errors.add(:link, "Please fill up this field") unless link.present?
		end

		errors.add(:<%= file_name %>_item, "Please select parent belong to <%= file_name %> group") if <%= file_name %>_item.present? && <%= file_name %>.id != <%= file_name %>_item.<%= file_name %>.id
		errors.add(:<%= file_name %>_item, "Please don't select parent is sub<%= file_name %> of this item or itself") if (<%= file_name %>_item.present? && get_child(self, arr).map(&:id).include?(<%= file_name %>_item_id)) || id == <%= file_name %>_item_id
	end
end