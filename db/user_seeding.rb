def seed_users
  response = HTTParty.get('https://run.mocky.io/v3/ce47ee53-6531-4821-a6f6-71a188eaaee0')

  response['users'].sort_by{ |user| user['id'] }.each do |user|
    current_db_user = User.find_by(id: user['id'])

    if current_db_user
      current_db_user.update! name: user['name'], email: user['email'], age: user['age']
    else
      User.create! name: user['name'], email: user['email'], age: user['age']
    end
  end
end