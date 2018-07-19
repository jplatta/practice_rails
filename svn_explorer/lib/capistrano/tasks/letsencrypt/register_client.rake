namespace :letsencrypt do
  task :register_client do
    on roles(:app) do
      contact_email = fetch(:letsencrypt_contact_email) || raise('Missing contact email')
      letsencrypt_dir = fetch(:letsencrypt_dir) || raise('Missing letsencrypt directory')
      private_key_path = fetch(:letsencrypt_private_key_path) || raise('Missing private key path')

      #production endpoint:
      #staging endpoint: 'https://acme-staging.api.letsencrypt.org/'
      endpoint = fetch(:letsencrypt_endpoint) || raise('Missing letsencrypt endpoint')

      #make config directory for letsencrypt
      execute :mkdir, "-p #{letsencrypt_dir}"

      if test("[ -f #{private_key_path} ]")
        info "Private key file already exists at #{private_key_path}"
        info "If you want to generate a new private key then please" <<
             "remove the current private key"
        info "and then run task again."
      else
        #create private key
        require 'openssl'
        private_key = OpenSSL::PKey::RSA.new(4096)
        upload! StringIO.new(private_key.to_pem), private_key_path

        #init client
        require 'acme-client'
        client = Acme::Client.new(private_key: private_key, endpoint: endpoint)

        #If private key is unknown, we need to register for first time
        registration = client.register(contact: "mailto:#{contact_email}")
        registration.agree_terms
      end
    end
  end
end
