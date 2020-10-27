# InSpec test for recipe consul_wrapper::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/
port = 8500
url = "http://localhost:#{port}/v1/kv/test-details?raw"

if os.windows?
  script = <<-SCRIPT
  echo (Invoke-WebRequest -UseBasicParsing -Uri #{url}).content
  SCRIPT

  describe powershell(script) do
    its('strip') { should eq '{"test":"data"}' }
  end

else
  describe http(url) do
    its('body') { should cmp '{"test":"data"}' }
  end
end
