# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

token = Token.find_or_initialize_by(id: 1)
token.update(access_token: "eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0NTU5NDg1NzUsInNjb3BlcyI6InJwcm8gcmhyIHJzbGUgcnNldCByYWN0Iiwic3ViIjoiMkIyTURSIiwiYXVkIjoiMjI3R0ZEIiwiaXNzIjoiRml0Yml0IiwidHlwIjoiYWNjZXNzX3Rva2VuIiwiaWF0IjoxNDU1OTQ0OTc1fQ.ncUYB2dKcKdApeU9uLfEvIpVgm9Ff78Xij8hQ67CwP0", refresh_token: "0960295b391b54257102e1b016b1437036be1e57d7453e606a698a380924fcb9", expire_time: 1455948575)

steps = Fitbit.find_or_initialize_by(name: "step")
steps.update(name: "step", data: "[]", last_update: Time.at(1))