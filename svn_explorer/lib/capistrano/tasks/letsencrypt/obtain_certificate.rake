namespace :letsencrypt do
  task :obtain_certificate do
    on roles(:app) do
      certificate_request_domains = fetch(:letsencrypt_certificate_request_domains) || raise('Missing certificate request domains')
      letsencrypt_dir = fetch(:letsencrypt_dir) || raise('Missing letsencrypt directory')
      certificate_dir = "#{letsencrypt_dir}/certificate"
      private_key_path = fetch(:letsencrypt_private_key_path) || raise('Missing private key path')
      endpoint = fetch(:letsencrypt_endpoint) || raise('Missing letsencrypt endpoint')

      cert_privkey_path = "#{certificate_dir}/privkey.pem"
      cert_path = "#{certificate_dir}/cert.pem"
      cert_chain_path = "#{certificate_dir}/chain.pem"
      cert_fullchain_path = "#{certificate_dir}/fullchain.pem"

      execute :mkdir, "-p #{certificate_dir}"

      if true #test("[ -f #{cert_fullchain_path} ]") && test("[ -f #{cert_privkey_path}]")
        info "Certificate already exists."
      else
        info "Missing certificate. Let's create a new certificate request."

        private_key = OpenSSL::PKey::RSA.new(capture(:cat, private_key_path))

        require 'acme-client'
        client = Acme::Client.new(private_key: private_key, endpoint: endpoint)
        csr = Acme::Client::CertificateRequest.new(names: certificate_request_domains.split)

        begin
          retries ||= 0
          certificate = client.new_certificate(csr)
        rescue
          retry if (retries += 1) < 3
          raise "Unable to create new cert"
        end

        upload! StringIO.new(certificate.request.private_key.to_pem), cert_privkey_path
        upload! StringIO.new(certificate.to_pem), cert_path
        upload! StringIO.new(certificate.chain_to_pem), cert_chain_path
        upload! StringIO.new(certificate.fullchain_to_pem), cert_fullchain_path

        info "Certificate created."
      end

      info "Creating symlinks for existing certificates."

      on roles(:app) do
        execute "ln -nfs #{cert_privkey_path} #{shared_path}/ssl_private_key.key"
        execute "ln -nfs #{cert_fullchain_path} #{shared_path}/ssl_cert.crt"
      end
    end
  end
end
