json.users @users do |user|
  json.partial! 'users/data', user: user
end

json.meta do
  json.page_number @searcher.page_number
  json.page_size @searcher.page_size
  json.sort_by @searcher.sort_by
  json.sort_direction @searcher.sort_direction
  json.total_of_pages @searcher.total_of_pages
  json.total_of_registers @searcher.total_of_registers
  json.term @searcher.term
end
