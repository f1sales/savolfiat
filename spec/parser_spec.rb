require 'ostruct'
require "f1sales_custom/parser"
require "f1sales_custom/source"

RSpec.describe F1SalesCustom::Email::Parser do

  context 'when is a different template' do
    let(:email){ 
      email = OpenStruct.new
      email.to = [email: 'website@savolkia.f1sales.org'],
      email.subject = 'OKM - Stinger',
      email.body = "Veículo: StingerNome: Marcio KlepaczE-mail: marcioklepacz@gmail.comCPF: 276.386.810-02Telefone: 11981587311Mensagem: Teste lead"

      email
    }

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead website a source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[0][:name])
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Marcio Klepacz')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('marcioklepacz@gmail.com')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('11981587311')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('Teste lead')
    end

    it 'contains product' do
      expect(parsed_email[:product]).to eq('OKM - Stinger')
    end

  end

  context 'when is from website' do
    let(:email){ 
      email = OpenStruct.new
      email.to = [email: 'website@savolfiat.f1sales.org'],
      email.subject = 'Oferta / Estoque - Proposta',
      email.body = "!@\#{\n\"CidadeRevenda\":\"Savol Kia (São Bernardo do Campo)\",\n\"Veículo\":\"Sportage \",\n\"Placa\":\"OLL8751\",\n\"Preço\":\"R$ 69.900,00\",\n\"Nome\": \"Guilherme\",\n\"E-mail\": \"guilima@me.com\",\n\"Telefone\": 11998108688,\n\"Descricao\": \"Olá tenho Kia Cerato 2017 e tenho interesse na troca.\"\n}!@#"

      email
    }

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead website a source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[0][:name])
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Guilherme')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('guilima@me.com')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('11998108688')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('Olá tenho Kia Cerato 2017 e tenho interesse na troca.')
    end

    it 'contains product' do
      expect(parsed_email[:product]).to eq('Sportage OLL8751')
    end

    it 'contains description' do
      expect(parsed_email[:description]).to eq('Preço R$ 69.900,00')
    end

  end
end
