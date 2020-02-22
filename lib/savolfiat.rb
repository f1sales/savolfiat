require "savolfiat/version"

require "f1sales_custom/parser"
require "f1sales_custom/source"
require "f1sales_custom/hooks"
require "f1sales_helpers"
require "json"

module Savolfiat
  class Error < StandardError; end
  class F1SalesCustom::Email::Source 
    def self.all
      [
        {
          email_id: 'website',
          name: 'Website'
        },
      ]
    end
  end

  class F1SalesCustom::Email::Parser
    def parse
      parsed_email = JSON.parse(@email.body.gsub('!@#', '')) rescue nil

      if parsed_email.nil?
        parsed_email = @email.body.colons_to_hash(/(Telefone|Nome|Mensagem|E-mail|CPF).*?:/, false) unless parsed_email

        {
          source: {
            name: F1SalesCustom::Email::Source.all[0][:name],
          },
          customer: {
            name: parsed_email['nome'],
            phone: parsed_email['telefone'],
            email: parsed_email['email'],
          },
          product: @email.subject,
          message: parsed_email['mensagem'],
          description: "",
        }
      else

        {
          source: {
            name: F1SalesCustom::Email::Source.all[0][:name],
          },
          customer: {
            name: parsed_email['Nome'],
            phone: parsed_email['Telefone'].to_s,
            email: parsed_email['E-mail'],
          },
          product: "#{parsed_email['Veículo'].strip} #{parsed_email['Placa']}",
          message: parsed_email['Descricao'],
          description: "Preço #{parsed_email['Preço']}",
        }
      end
    end
  end
end
