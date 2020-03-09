require File.expand_path '../spec_helper.rb', __FILE__
require 'ostruct'
require "f1sales_custom/hooks"

RSpec.describe F1SalesCustom::Hooks::Lead do

  let(:source) do
    source = OpenStruct.new
    source.name = 'Facebook - Savol Kia'
    source
  end

  let(:customer) do
    customer = OpenStruct.new
    customer.name = 'Marcio'
    customer.phone = '1198788899'
    customer.email = 'marcio@f1sales.com.br'

    customer
  end

  let(:product) do
    product = OpenStruct.new
    product.name = 'Some product'

    product
  end

  context 'when is to SCS' do

    let(:lead) do
      lead = OpenStruct.new
      lead.message = 'como_deseja_ser_contatado?: e-mail: escolha_a_unidade_savol_kia: são_caetano'
      lead.source = source
      lead.customer = customer
      lead.product = product

      lead
    end


    let(:call_url){ "https://savolfiatscs.f1sales.org/integrations/leads" }

    let(:lead_payload) do
      {
        lead: {
          message: lead.message,
          customer: {
            name: customer.name,
            email: customer.email,
            phone: customer.phone,
          },
          product: {
            name: product.name
          },
          source: {
            name: source.name
          }
        }
      }
    end

    before do
      stub_request(:post, call_url).
        with(body: lead_payload.to_json).to_return(status: 200, body: "", headers: {})
    end

    it 'returns nil' do
      expect(described_class.switch_source(lead)).to be_nil
    end

    it 'post to sp' do
      described_class.switch_source(lead) rescue nil
      expect(WebMock).to have_requested(:post, call_url).
        with(body: lead_payload)
    end

  end
end

