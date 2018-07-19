namespace :letsencrypt do
  task :renew_certificate do
    if rails.env.production?
      endpoint = 'https://acme-v01.api.letsencrypt.org/'
      certificate_request_domains = 'joeplatta.com www.joeplatta.com'
      app_dir = "/home/deploy/apps/svn_explorer"
      certificate_dir = "#{app_dir}/shared/config/letsencrypt/certificate"
      private_key_path = "#{app_dir}/shared/config/letsencrypt/private_key.pem"
    else
      endpoint = 'https://acme-staging.api.letsencrypt.org/'
      certificate_request_domains = 'staging.example.com'
      app_dir = "/home/deploy/apps/svn_explorer"
      certificate_dir = "#{app_dir}/shared/config/letsencrypt/certificate"
      private_key_path = "#{app_dir}/shared/config/letsencrypt/private_key.pem"
    end

    cert_privkey_path = "#{certificate_dir}/privkey.pem"
    cert_path = "#{certificate_dir}/cert.pem"
    cert_chain_path = "#{certificate_dir}/chain.pem"
    cert_fullchain_path = "#{certificate_dir}/fullchain.pem"

    if File.exists?(cert_privkey_paths) && File.exists?(cert_path) &&
       File.exists?(cert_chain_path) && File.exists?(cert_fullchain_path)

       private_key = OpenSSL::PKey::RSA.new(File.read(private_key_path))

       require 'acme-client'
       client = Acme::Client.new(private_key: private_key, endpoint: endpoint)

       csr = Acme::Client::CertificateRequest.new(names: certificate_request_domains.split)
       certificate = client.new_certificate(csr)

       File.write(cert_privkey_path, certificate.request.private_key.to_pem)
       File.write(cert_path, certificate.to_pem)
       File.write(cert_chain_path, certificate.chain_to_pem)
       File.write(cert_fullchain_path, certificate.fullchain_to_pem)

       puts "[#{Time.now}] Certificate renewed."
    else
      puts "[#{Time.now}] Current certificate doesn't exist so you cannot renew it."
      puts "Please deploy app to generate a new certificate."
    end
  end
end
