---
title: "Generating JWK Thumbprints with Ruby"
description: "How to generate JWK thumbprints with Ruby."
tags:
- blogumentation
- ruby
- jwk
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-06-03T09:00:07+0100
slug: "jwk-thumbprint-ruby"
image: https://media.jvt.me/00fdea0d32.png
---
As mentioned in [_How are Open Banking Key Ids (`kid`) Generated?_](/posts/2020/06/02/open-banking-key-id/), Open Banking use the JWK thumbprints as defined by [RFC7638: JSON Web Key (JWK) Thumbprint](https://tools.ietf.org/html/rfc7638).

But these may be used in other circumstances, so it's worth knowing how to generate them. Instead of hand-rolling the generation process, we can re-use the excellent [json-jwt](https://github.com/nov/json-jwt):

```ruby
#!/usr/bin/env ruby
require 'json/jwt'

def read_key(fname)
  contents = File.read fname

  begin
    return OpenSSL::X509::Certificate.new(contents).public_key
  rescue
    # ignore
  end

  begin
    return OpenSSL::PKey.read contents
  rescue
    # ignore
  end

  raise "#{fname} could not be parsed as a certificate, public or private key"
end

hash = ARGV[1] || 'sha256'

key = read_key(ARGV[0])
key = key.public_key unless key.public?

jwk = JSON::JWK.new(key)
puts jwk.thumbprint(hash)
```

This allows us to run the following:

```sh
ruby thumb.rb path/to/private.pem      # works with private key or public key
ruby thumb.rb path/to/public.cer       # works with certificates
ruby thumb.rb path/to/public.pem       # to use default hash algorithm
ruby thumb.rb path/to/public.pem SHA-1 # to specify our own
```
