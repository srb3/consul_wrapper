# InSpec test for recipe consul_wrapper::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/
if os.windows?
  script = <<-SCRIPT
  echo (Invoke-WebRequest -UseBasicParsing -Uri http://localhost:8500/v1/kv/test-details?raw).content
  SCRIPT

  describe powershell(script) do
    its('strip') { should eq '{"test":"data"}' }
  end

else
  describe http('http://localhost:8500/v1/kv/test-details?raw') do
    its('body') { should cmp '{"test":"data"}' }
  end
end
