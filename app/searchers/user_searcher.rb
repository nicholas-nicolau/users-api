class UserSearcher
  include HTTParty
  base_uri 'https://run.mocky.io/v3/ce47ee53-6531-4821-a6f6-71a188eaaee0'

  attr_accessor :page_size, :page_number, :sort_by, :sort_direction, :total_of_pages, :total_of_registers, :term

  COLUMNS_TO_SORT = %w[id name email age]
  DIRECTIONS_TO_SORT = %w[asc desc]

  def initialize(options = {})
    @page_size = (options.delete(:page_size) || options.delete('page_size')|| 10).to_i
    @page_number = (options.delete(:page_number) || options.delete('page_number') || 0).to_i

    _sort_by = options.delete(:sort_by) || options.delete('sort_by')
    @sort_by = COLUMNS_TO_SORT.include?(_sort_by) ? _sort_by : 'id'

    _sort_direction = options.delete(:sort_direction) || options.delete('sort_direction')
    @sort_direction =  DIRECTIONS_TO_SORT.include?(_sort_direction) ? _sort_direction : 'asc'

    @term = options.delete(:term) || options.delete('term')

    @request_from_api = (options.delete(:request_from_api) || options.delete('request_from_api') || false).to_s == 'true'
  end

  def search
    order_clause = [@sort_by, @sort_direction].join(' ')
    scope = []
    
    if @request_from_api
      response = self.class.get('')
      
      scope = JSON.parse(response.body)['users'].sort_by{ |e| e[@sort_by] }
      scope = scope.reverse if @sort_direction == 'desc'
      scope = scope.select{ |e| e.values.join.downcase.include?(@term) } if @term.present?
    else
      scope = User.order(order_clause)
      scope = scope.where('id::VARCHAR ILIKE :term OR name ILIKE :term OR email ILIKE :term OR age::VARCHAR ILIKE :term', term: "%#{@term}%") if @term.present?
    end
    
    @total_of_registers = scope.count
    @total_of_pages = (@total_of_registers/@page_size.to_f).ceil

    @page_number = [@total_of_pages - 1, @page_number].select{ |e| e >= 0 }.min
    offset = [@page_size, @page_number].inject(:*)

    scope.slice(offset, @page_size) || []
  end
end