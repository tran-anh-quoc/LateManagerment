# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

[
  { id: 1, name: 'admin', description: 'Admin' },
  { id: 2, name: 'client', description: 'Client' },
  { id: 3, name: 'system', description: 'System' },
].each do |row|
  Group.where(name: row[:name]).first_or_create(row)
end

[
  { id: 10000001, phone_number: '+84000000000', description: 'Quoc tre 10p', user_id: 1567415833 },
  { id: 10000002, phone_number: '+84000000000', description: 'Quoc nghi nua ngay', user_id: 1567415833 },
].each do |row|
  Message.where(row).first_or_create(row)
end

[
  { id: 1567415833, provider: 'google_oauth2', uid: 116909846747724728847, encrypted_password: '$2a$10$OIgAGgotU4eSmg8IUubIC.8cBIxQdLGm.mYBwEvYSUDxKy7ETwEhO', sign_in_count: 1, current_sign_in_at: '2016-08-04 03:44:08', current_sign_in_ip: '10.0.2.2', name: 'Anh Quoc', nickname: 'Anh Quoc', image: 'https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg', email: 'taiungdung0101@gmail.com', authentication_token: 'b-yCu1sEV3sqLyKUC8Yk45959DdSsPSN', group_id: 2, phone_number: '+84968587261' },
  { id: 1000000001, provider: 'system_user', uid: 1000000000000000001, encrypted_password: '$2a$10$OIgAGgotU4eSmg8IUubIC.8cBIxQdLGm.mYBwEvYSUDxKy7ETwEhO', sign_in_count: 1, current_sign_in_at: '2016-08-04 03:44:08', current_sign_in_ip: '10.0.2.2', name: 'System Report', nickname: 'System Report', image: 'https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg', email: 'systemreport@gmail.com', authentication_token: 'b-yCu1sEV3sqLyKUC8Yk45959DdSsPSN', group_id: 3, phone_number: '+84123456789' },
].each do |row|
  User.where(row).first_or_create(row)
end
