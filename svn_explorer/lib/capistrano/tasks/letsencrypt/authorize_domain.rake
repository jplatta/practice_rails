namespace :letsencrypt do
  task :authorize_domain do
    on roles(:app) do
      letsencrypt_dir = fetch(:letsencrypt_dir) || raise('Missing letsencrypt directory')
      letsencrypt_authorize_domains = fetch(:letsencrypt_authorize_domains) || raise('Missing letsencrypt authroize domain')
      private_key_path = fetch(:letsencrypt_private_key_path) || raise('Missing private key path')

      endpoint = fetch(:letsencrypt_endpoint) || raise('Missing letsencrypt endpoint')

      private_key = OpenSSL::PKey::RSA.new(capture(:cat, private_key_path))

      require 'acme-client'
      client = Acme::Client.new(private_key: private_key, endpoint: endpoint)

      letsencrypt_authorize_domains.split.each do |domain|
        info "Domain: #{domain}"

        authorization_uri_file = "#{letsencrypt_dir}/authorization_uri_#{domain}.txt"
        authorization = client.authorize(domain: domain)

        run_verification = false

        #unless test("[ -f #{authorization_uri_file}]")
        unless File.file?("#{authorization_uri_file}")
          info "File does not exist...creating file..."

          challenge = authorization.http01

          info challenge.token

          info challenge.filename

          info challenge.file_content

          info challenge.content_type

          upload! StringIO.new(authorization.uri), authorization_uri_file

          run_verification = true
        end

        authorization_uri = capture :cat, authorization_uri_file

        challenge = client.fetch_authorization(authorization_uri).http01

        info "Release path: #{release_path.inspect}"

        execute :mkdir, "-p #{release_path}/public/#{File.dirname(challenge.filename)}"

        challenge_public_path = "#{release_path}/public/#{challenge.filename}"
        upload! StringIO.new(challenge.file_content), challenge_public_path
        execute :chmod, "+r #{challenge_public_path}"

        if run_verification
          challenge.request_verification
          info "Verify status: #{challenge.verify_status}"

          sleep(20)

          info "Verify status: #{challenge.verify_status}"
        else
          info "Skipped verification of challenge. It's already verified."
          info "If you want to verify different domain please remove file: "
          info "#{authorization_uri_file} and run the task again."
        end
      end
    end
  end
end
