require 'natto'
require 'mecab'
nm = Natto::MeCab.new
tagger = MeCab::Tagger.new
text = "俺は週末忙しい選定なんだよ"
old = ""
nm.parse(text) do |n|
 if n.surface == '選定'
   old += 'エクスカリバー'
 elsif n.surface == '週末'
   old += 'ラグナロク'
 elsif n.surface == '僕' || n.surface == '俺' || n.surface == '私'
   old += '我が'
 else
   old += n.surface
 end
end

# puts tagger.parse(text)
nm.parse("前納先生") do |n|
  puts n.feature
end