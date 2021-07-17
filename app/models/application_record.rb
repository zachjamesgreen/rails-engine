class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.per(per_page)
    per_page ||= 20
    offset = @page * per_page
    return [] if @page != 0 && (count / offset) < 1
    return all if per_page >= count

    limit(per_page).offset(offset)
  end

  def self.page(page)
    @page = (page.to_i - 1)
    self
  end
end
