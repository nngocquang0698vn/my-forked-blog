---
title:  Extracting SSL/TLS Certificate Chains Using OpenSSL
description: A quick one-liner to get you the full certificate chain in `.pem` format.
tags:
- blogumentation
- bash
- shell
- oneliner
- openssl
- certificates
date: 2017-04-28T16:53:53+01:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: extract-tls-certificate
---
Have you ever needed to add a certificate to your certificate chain, for instance when trusting a new self-signed certificate?

By running the following command, you'll get the full certificate chain for `jvt.me` at the time of execution.

```bash
$ openssl s_client -showcerts -connect "jvt.me:443" < /dev/null 2>/dev/null |\
	sed -n -e '/BEGIN\ CERTIFICATE/,/END\ CERTIFICATE/ p'
-----BEGIN CERTIFICATE-----
MIIFAjCCA+qgAwIBAgISA+A0GeGJ6cegIn2xi/y9b4/DMA0GCSqGSIb3DQEBCwUA
MEoxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MSMwIQYDVQQD
ExpMZXQncyBFbmNyeXB0IEF1dGhvcml0eSBYMzAeFw0xNzA0MDIxNTM5MDBaFw0x
NzA3MDExNTM5MDBaMBoxGDAWBgNVBAMTD2ludm9pY2VzLmp2dC5tZTCCASIwDQYJ
KoZIhvcNAQEBBQADggEPADCCAQoCggEBAOO6OwNU1N7akkbr/yOXGFCZ03qJdUiV
CIfq3vMo+6SXaHOnfn+51+vtmJ4fI8UGW3ecPWXwi8uRbsIdgf+DYxg62L/z0c2W
HdkQpAW+BNf8ll9uiD3xSimbnYgESyGalQ+g0gZTMwxrpdqSRztqU/8mzGvQZlzf
m7BIONDoquDRECqw73Ll439J23916OfkGM4dxjK+C6bFJsoZeMNNbzMm6Ilwyma1
jZ2JdD2BVsnD3oJUxWJPDKjHAMkuIYDLYANOXHd2NvsZQulSoezlwsk8t6guGDiI
+sYMUflhhtR4N/dnnJA1ayQLIR6yXc2Hef7NrlexpvS5M4XroRIHMvUCAwEAAaOC
AhAwggIMMA4GA1UdDwEB/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYB
BQUHAwIwDAYDVR0TAQH/BAIwADAdBgNVHQ4EFgQUa/OEd/0+5la86PnK2DwDqgej
kvAwHwYDVR0jBBgwFoAUqEpqYwR93brm0Tm3pkVl7/Oo7KEwcAYIKwYBBQUHAQEE
ZDBiMC8GCCsGAQUFBzABhiNodHRwOi8vb2NzcC5pbnQteDMubGV0c2VuY3J5cHQu
b3JnLzAvBggrBgEFBQcwAoYjaHR0cDovL2NlcnQuaW50LXgzLmxldHNlbmNyeXB0
Lm9yZy8wGgYDVR0RBBMwEYIPaW52b2ljZXMuanZ0Lm1lMIH+BgNVHSAEgfYwgfMw
CAYGZ4EMAQIBMIHmBgsrBgEEAYLfEwEBATCB1jAmBggrBgEFBQcCARYaaHR0cDov
L2Nwcy5sZXRzZW5jcnlwdC5vcmcwgasGCCsGAQUFBwICMIGeDIGbVGhpcyBDZXJ0
aWZpY2F0ZSBtYXkgb25seSBiZSByZWxpZWQgdXBvbiBieSBSZWx5aW5nIFBhcnRp
ZXMgYW5kIG9ubHkgaW4gYWNjb3JkYW5jZSB3aXRoIHRoZSBDZXJ0aWZpY2F0ZSBQ
b2xpY3kgZm91bmQgYXQgaHR0cHM6Ly9sZXRzZW5jcnlwdC5vcmcvcmVwb3NpdG9y
eS8wDQYJKoZIhvcNAQELBQADggEBAELD0yoT8J/gLzCbF0F9M1NRacNZ+ohPJgeI
yxRWyN9voZtj7FM1VzctSrtGms2PYG8nOpPASJWoTcb2d9ay1i70fuX01PvxliT+
Hgk8eDab/zXjtpuuWCrorGubdQVl28mde3MOk3pS2LnEI8+dBDODOhTn7OUE3QNb
F/SRwz8wGAU2o3mSq+Oy39/vFEST6N183s9fbIwNO4LvQ1AmqxTtsv5/6r7POFzp
7Ex4W1Gv4aWSaU3RfNpzF6Vr8p9lyiGaxM783FhEwx3uOMsiJdFHwd8yL/fSwyq4
hsIIiJDjGWpqXMTQFnu+sd/mxBIvkYFUHNCvErEd8Ot9f4K63Pw=
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIEkjCCA3qgAwIBAgIQCgFBQgAAAVOFc2oLheynCDANBgkqhkiG9w0BAQsFADA/
MSQwIgYDVQQKExtEaWdpdGFsIFNpZ25hdHVyZSBUcnVzdCBDby4xFzAVBgNVBAMT
DkRTVCBSb290IENBIFgzMB4XDTE2MDMxNzE2NDA0NloXDTIxMDMxNzE2NDA0Nlow
SjELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUxldCdzIEVuY3J5cHQxIzAhBgNVBAMT
GkxldCdzIEVuY3J5cHQgQXV0aG9yaXR5IFgzMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAnNMM8FrlLke3cl03g7NoYzDq1zUmGSXhvb418XCSL7e4S0EF
q6meNQhY7LEqxGiHC6PjdeTm86dicbp5gWAf15Gan/PQeGdxyGkOlZHP/uaZ6WA8
SMx+yk13EiSdRxta67nsHjcAHJyse6cF6s5K671B5TaYucv9bTyWaN8jKkKQDIZ0
Z8h/pZq4UmEUEz9l6YKHy9v6Dlb2honzhT+Xhq+w3Brvaw2VFn3EK6BlspkENnWA
a6xK8xuQSXgvopZPKiAlKQTGdMDQMc2PMTiVFrqoM7hD8bEfwzB/onkxEz0tNvjj
/PIzark5McWvxI0NHWQWM6r6hCm21AvA2H3DkwIDAQABo4IBfTCCAXkwEgYDVR0T
AQH/BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYwfwYIKwYBBQUHAQEEczBxMDIG
CCsGAQUFBzABhiZodHRwOi8vaXNyZy50cnVzdGlkLm9jc3AuaWRlbnRydXN0LmNv
bTA7BggrBgEFBQcwAoYvaHR0cDovL2FwcHMuaWRlbnRydXN0LmNvbS9yb290cy9k
c3Ryb290Y2F4My5wN2MwHwYDVR0jBBgwFoAUxKexpHsscfrb4UuQdf/EFWCFiRAw
VAYDVR0gBE0wSzAIBgZngQwBAgEwPwYLKwYBBAGC3xMBAQEwMDAuBggrBgEFBQcC
ARYiaHR0cDovL2Nwcy5yb290LXgxLmxldHNlbmNyeXB0Lm9yZzA8BgNVHR8ENTAz
MDGgL6AthitodHRwOi8vY3JsLmlkZW50cnVzdC5jb20vRFNUUk9PVENBWDNDUkwu
Y3JsMB0GA1UdDgQWBBSoSmpjBH3duubRObemRWXv86jsoTANBgkqhkiG9w0BAQsF
AAOCAQEA3TPXEfNjWDjdGBX7CVW+dla5cEilaUcne8IkCJLxWh9KEik3JHRRHGJo
uM2VcGfl96S8TihRzZvoroed6ti6WqEBmtzw3Wodatg+VyOeph4EYpr/1wXKtx8/
wApIvJSwtmVi4MFU5aMqrSDE6ea73Mj2tcMyo5jMd6jmeWUHK8so/joWUoHOUgwu
X4Po1QYz+3dszkDqMp4fklxBwXRsW10KXzPMTZ+sOPAveyxindmjkW8lGy+QsRlG
PfZ+G6Z6h7mjem0Y+iWlkYcV4PIWL1iwBi8saCbGS5jN2p8M+X+Q7UNKEkROb3N6
KOqkqm57TH2H3eDJAkSnh6/DNFu0Qg==
-----END CERTIFICATE-----
```

As this is output to `stdout`, it is then simple to pipe it to a new file or create a more complex shell pipeline.
