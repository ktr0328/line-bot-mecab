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

  dict = Dictionary.new
  events = client.parse_events_from(body)
  events.each {|event|
    if event['type'] == 'message' then
      if event['message']['type'] == 'text' then
        nm = Natto::MeCab.new
        text = event.message['text']
        conversion_text = ""
        nm.parse(text) do |n|
          word = dict.get_categories.fetch(n.surface)
          if word
            conversion_text += dict.get_conversion[word]
          else
            conversion_text += n.surface
          end
          # if n.surface == '選定'
          #   conversion_text += 'エクスカリバー'
          # elsif n.surface == '週末'
          #   conversion_text += 'ラグナロク'
          # elsif n.surface == '僕' || n.surface == '俺' || n.surface == '私'
          #   conversion_text += '我'
          # elsif n.surface == '理解できない'
          #   conversion_text += 'エニグマ'
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
