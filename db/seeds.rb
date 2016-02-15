# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# oauthのトークンをDBに挿入する
token = Token.find_or_initialize_by(id: 1)
token.update(access_token: "", refresh_token: "", expire_time: 0)