class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.per(per_page)
    per_page ||= 20
    offset = @page * per_page
    return [] if @page != 0 && (self.count / offset) < 1
    return self.all if per_page >= self.count
    self.limit(per_page).offset(offset)
  end

  def self.page(page)
    @page = (page.to_i - 1)
    return self
  end
end
