class LinkGenerator
  EXECUTION_TIME_LIMIT = 300 # seconds

  MIN_LINK_LENGTH = 2

  CHARSET = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a

  attr_accessor :link_length

  def initialize
    self.link_length = calc_link_length
  end

  def self.test
    i = 0
    loop do
      i+= 1
      ShortenedLink.create!(original_url: "https://google.com/?a=#{i}", shortened_url: new.call)
    end
  end
 
  # генерируем новый токен для уникальной ссылки
  def call
    # таймаут на всякий случай, чтобы не улететь в бесконечность ненароком :)
    Timeout::timeout(EXECUTION_TIME_LIMIT) do
      loop do
        url = generate_token
        break url unless ShortenedLink.exists?(shortened_url: url)
      end
    end
  end

  private

  # определяем длину для генерируемой ссылки
  def calc_link_length
    last_link = ShortenedLink.last&.shortened_url
    return MIN_LINK_LENGTH if last_link.blank?

    current_length = last_link.split('/').last.size
    existed_urls = ShortenedLink.where("length(shortened_url) = :count",
                                       count: current_length).count

    # если все возможные варианты данной длины уже есть,
    # то генерируем токен на 1 символ длиннее
    current_length += 1 if existed_urls == tokens_limit(current_length)
    current_length
  end

  # создаем уникальный токен
  def generate_token
    token = ''
    link_length.times { token << CHARSET.sample }
    token
  end

  # кол-во уникальных строк для текущей длины токена
  def tokens_limit current_length
    CHARSET.size ** current_length
  end
end
