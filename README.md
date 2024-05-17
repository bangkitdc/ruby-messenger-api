# Simple Messenger Service
This app is intended to be a simple server of a CRUD app built with Ruby on Rails.

## Version
* Rails v6.1.7
* Ruby v2.7.2
* Database postgreSQL
* Bundle v2.1.4

## How to run locally
- create `.env`, you can check `.env.example`
- run `bundle install`
- run `rails db:create rails db:migrate`
- run `rails s`
- for testing purposes, you can go to `application_controller.rb` and make `@current_user = User.find(1)`

## DB Schema
<div align="center">
  <img width="550" alt="Screenshot 2024-05-18 021440" src="https://github.com/bangkitdc/ruby-messenger-api/assets/87227379/431ae384-4c4e-4253-a7da-1b0f6e13aab8">
</div>

## Api Endpoint
### Conversations
|Method| URL | Explanation |
|:--:|:--|:--|
| POST | /conversations | Create conversation with desired title |
| GET | /conversations | Get all conversations that the authenticated user has |
| GET | /conversations/:id | Get conversation by id |
| PUT/PATCH | /conversations/:id | Update conversation by id |
| DELETE | /conversations/:id | Delete conversation by id |

### Messages
|Method| URL | Explanation |
|:--:|:--|:--|
| POST | /messages | Create message to other user |

## Ruby GEM
- gem "faker"
- gem "dotenv-rails"
- gem "fast_jsonapi"
- gem "composite_primary_keys"

## Tasks
The challenge is make sure when you run `bundle exec rspec`, all result is green (without error):) 
<div align="center">
  <img width="550" alt="Screenshot 2024-05-18 021440" src="https://github.com/bangkitdc/ruby-messenger-api/assets/87227379/23fe914d-3683-49bc-9abd-68fcd6b30b3c">
</div>

## Documentations
<div align="center">
  <img width="510" alt="create_conv" src="https://github.com/bangkitdc/ruby-messenger-api/assets/87227379/3548757b-e906-4722-8ddb-fd31112913bd">
  <p align="center"><em>Create conversation</em></p>
  <img width="503" alt="get_all_conv" src="https://github.com/bangkitdc/ruby-messenger-api/assets/87227379/b2b07f96-1055-4c4e-b456-d78f59993405">
  <p align="center"><em>Get conversations</em></p>
  <img width="507" alt="get_conv" src="https://github.com/bangkitdc/ruby-messenger-api/assets/87227379/a1cba435-48c5-4442-b930-2d713018a38e">
  <p align="center"><em>Get conversation by id</em></p>
  <img width="518" alt="update_conv" src="https://github.com/bangkitdc/ruby-messenger-api/assets/87227379/6ab19efe-8af7-47b3-9676-4a1cf3feeb5a">
  <p align="center"><em>Update conversation by id</em></p>
  <img width="505" alt="delete_conv" src="https://github.com/bangkitdc/ruby-messenger-api/assets/87227379/d3ed668a-8885-4d7d-9297-a12c37747274">
  <p align="center"><em>Delete conversation by id</em></p>
  <img width="510" alt="create_message" src="https://github.com/bangkitdc/ruby-messenger-api/assets/87227379/41876931-c98a-4df5-9a08-efca69f3f166">
  <p align="center"><em>Create message</em></p>
</div>

## Copyright
2024 © Muhammad Bangkit. All Rights Reserved.
