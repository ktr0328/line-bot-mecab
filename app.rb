require 'sinatra'
require 'line/bot'
require 'json'
require 'mecab'
require 'natto'
require './src/dictionary'

def client
  @client ||= Line::Bot::Client.new {|config|
    config.channel_secret = ENV['CHANNEL_SECRET']
    config.channel_token = ENV['CHANNEL_ACCESS_TOKEN']
  }
end

post '/callback' do
  body = request.body.read
  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do
      'Bad Request'
    end
  end

  category = Dictionary::Categorize
  conversion = Dictionary::Conversion

  events = client.parse_events_from(body)
  events.each {|event|
    if event['type'] == 'message' then
      if event['message']['type'] == 'text' then
        nm = Natto::MeCab.new
        text = event.message['text']
        conversion_text = ""
        nm.parse(text) do |n|
          word = category[n.surface]
          if word
            conversion_text += conversion[word]
          else
            feature = n.feature.split(',')[0]
            if feature == '名詞' || feature == '助詞' || feature == '形容詞'
              conversion_text += n.surface
            end
          end
        end

        message = [
            {
                type: 'text',
                text: conversion_text
            }
        ]
        client.reply_message(event['replyToken'], message)
      end
    end
  }
  "OK"

end
