# Box: 箱を定義している
class Box

  # initialize(id, weight) 
  # => Box.new(○,×)とした時○を@id, ×を@weightに入れる
  def initialize(id, weight)
    @id = id 
    @weight = weight.to_i
  end

  # ○○.idでその@idを取得する
  def id
    @id
  end
 # ○○.weightでその@weightを取得する
  def weight
    @weight
  end
end

# トラックを定義している

# Truck.new(○)とした時 ○が@nameとなる

class Truck
  def initialize(name)
    @name = name

    # 荷物を配列として入れる準備をしている
    @boxes = []
  end

  # ○○.nameでTruckの名前を取得する
  def name
    @name
  end

  # ○○.boxesでTruckの荷台を取得する
  def boxes
    @boxes
  end

  def add(box)
    #<<: 配列に新しい要素を追加する
    @boxes << box
  end

  def amount
    # @boxesという配列の要素のweightを足す
    @boxes.sum(&:weight)
  end

  def box_ids
    # @boxesという配列の要素の中のidを , で繋いで文字列にする
    @boxes.map(&:id).join(',')
  end
end

# 商品を定義している
class Loading
  def initialize(boxes, trucks, strategy)
    @boxes = boxes 
    @trucks = trucks 
    @strategy = strategy
  end

  def load
    # load: 無条件にファイルを読み込ませる(require: ファイルを1度だけしか読み込めない)
    @strategy.load(@boxes, @trucks)
  end
end

class NormalStrategy
  def load(boxes, trucks)
    boxes.each do |box|
      # min_by { |truck| truck.amount } : 
      # @boxes.sum(&:weight)の最小の要素を返す
      trucks.min_by { |truck| truck.amount }.add(box)
    end
  end
end


############################### main #############################################

############################### 通常の積み方 #######################################

# ARGV: Rubyでプログラムを実行した際に指定された引数を格納した配列

boxes = ARGV.map do |arg|
  #arg => 1:50の時、
  #idが1 , weightが50になるよう:で分割
  id, weight = arg.split(":")

  #raise: 例外処理
  raise unless Integer(id) && Integer(weight)

  # ↑で定義したid , weightを使ってBoxを作成
  Box.new(id, weight)

rescue ArgumentError
  p ArgumentError.new("引数おかしい")
  exit
end

# トラックを作成する
trucks = [Truck.new('truck_1'), Truck.new('truck_2'), Truck.new('truck_3')]

# p boxes
# => [#<Box:0x0000000003bf49a8 @id="1", @weight=50>, #<Box:0x0000000003bf48e0 @id="2", @weight=30>, #<Box:0x0000000003bf4818 @id="3", @weight=40>, #<Box:0x0000000003bf4750 @id="4", @weight=10>]

# p trucks
# => [#<Truck:0x0000000003c10680 @name="truck_1", @boxes=[]>, #<Truck:0x0000000003c10608 @name="truck_2", @boxes=[]>, #<Truck:0x0000000003c10590 @name="truck_3", @boxes=[]>]

loading = Loading.new(boxes, trucks, NormalStrategy.new)
loading.load

# p trucks
# => [#<Truck:0x0000000003c04600 @name="truck_1", @boxes=[#<Box:0x0000000003c048a8 @id="1", @weight=50>]>, #<Truck:0x0000000003c04588 @name="truck_2", @boxes=[#<Box:0x0000000003c047e0 @id="2", @weight=30>, #<Box:0x0000000003c04650 @id="4", @weight=10>]>, #<Truck:0x0000000003c04510 @name="truck_3", @boxes=[#<Box:0x0000000003c04718 @id="3", @weight=40>]>]
# @boxesに要素が追加された

p '通常の積み方'
trucks.each do |truck|
  p "#{truck.name}:#{truck.box_ids}"
end


############################### ランダムに詰む #######################################
# 新しくStrategyクラス作ってそれに差し替えるだけ

class RandomStrategy
  def load(boxes, trucks)
    boxes.each do |box|
      trucks.sample.add(box)
    end
  end
end

trucks = [Truck.new('truck_1'), Truck.new('truck_2'), Truck.new('truck_3')] # 初期化

loading = Loading.new(boxes, trucks, RandomStrategy.new)
loading.load

p 'ランダムに積む'
trucks.each do |truck|
  p "#{truck.name}:#{truck.box_ids}"
end
