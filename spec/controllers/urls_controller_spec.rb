require 'rails_helper'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

describe UrlsController, type: :controller do
  describe 'POST #create' do
    context 'when given url is valid' do
      let(:site_url) { 'https://google.ru' }

      it 'should create new shortened link ' do
        post :create, params: { url: site_url }
        link = ShortenedLink.last

        expect(link.original_url).to eq(site_url)
        expect(link.shortened_url).to be
      end
    end

    context 'when given url is invalid' do
      let(:site_url) { 'wrong_urllll:-)))' }

      it 'should create new shortened link ' do
        post :create, params: { url: site_url }

        resp = JSON.parse(response.body)

        expect(resp['errors']).to eq('Original url is invalid')
      end
    end
  end

  describe 'GET #show' do
    let(:full_url) { 'https://ya.ru' }
    let(:another_url) { 'https://google.com' }
    let(:third_url) { 'https://mail.ru' }

    let(:link) { ShortenedLink.create!(original_url: full_url,
                                       shortened_url: LinkGenerator.new.call) }

    let(:another_link) { ShortenedLink.create!(original_url: another_url,
                                               shortened_url: LinkGenerator.new.call) }

    let(:third_link) { ShortenedLink.create!(original_url: third_url,
                                             shortened_url: LinkGenerator.new.call) }

    it 'should return original url through short url' do
      get :show, params: { id: link.shortened_url }
      resp = JSON.parse(response.body)
      expect(resp['full_link']).to eq(full_url)
    end

    it 'should save url visits' do
      expect(another_link.transitions).to eq(0)
      get :show, params: { id: another_link.shortened_url }
      expect(another_link.reload.transitions).to eq(1)
    end

    it 'should save visit ips and keep it uniq' do
      expect(third_link.transitions).to eq(0)

      3.times { get(:show, params: { id: third_link.shortened_url }) }

      expect(third_link.reload.link_visits.count).to eq(1)
    end
  end

  describe 'GET #stats' do
    let(:link) { ShortenedLink.create!(original_url: 'https://gmail.com',
                                       shortened_url: LinkGenerator.new.call) }

    it 'should show show link stats' do
      # делаем 1 посещение
      get(:show, params: { id: link.shortened_url })
      # запрашиваем статистику
      get(:stats, params: { id: link.shortened_url })

      resp = JSON.parse(response.body)
      expect(resp['transitions']).to eq(1)
    end
  end
end
