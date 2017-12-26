# bot名: 呪われし歴史の紡ぎ手(仮)

class  Dictionary
  # 名詞
  noun = {
    '選定' => 'エクスカリバー',
    '悲劇' => '女神の聖弓',
    '勝機' => 'ロンギヌスの槍',
    '勧誘' => 'ブリューナク',
    '週末' => 'ラグナロク',
    '徹夜' => 'ヴァルプルギスの夜',
    '帰宅' => 'グングニル',
    '寒気' => '村雨の妖気',
    '部下' => '使徒',
    '落し物' => 'オーパーツ'
  }

  # 動詞
  verb = {
    '守る' => 'アイギスの盾',
    'どっちかわからない' => 'シュレディンガーの猫',
    '覗き' => 'マクスウェルの悪魔',
    '理解できない' => 'エニグマ'
  }

  def initialize
    @noun = noun
    @verb = verb
  end

  attr_accessor :noun
  attr_accessor :verb
end
